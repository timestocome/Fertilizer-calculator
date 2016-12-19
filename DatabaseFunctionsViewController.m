//
//  DatabaseFunctionsViewController.m
//  SaveAQuote
//
//  Created by Linda Cobb on 3/18/14.
//
//

#import "DatabaseFunctionsViewController.h"


@implementation DatabaseFunctionsViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeTemporaryFiles];
}



// get icloud settings 
- (void)viewWillAppear:(BOOL)animated
{
    iCloudOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"iCloudOn"] intValue];
    self.iCloudSwitch.on = iCloudOn;
}







- (IBAction)iCloudSyncing:(id)sender
{
    iCloudOn = [self.iCloudSwitch isOn];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:iCloudOn] forKey:@"iCloudOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // set up
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];

    
     if ( iCloudOn ){
         // get local store information
         NSPersistentStore* oldStore = [[appDelegate.persistentStoreCoordinator persistentStores] objectAtIndex:0];
         NSURL* oldStoreURL = [oldStore URL];
    
         // load cloud store
         [appDelegate reloadStores];
    
         // get cloud store url
         NSPersistentStoreCoordinator* newPSC = appDelegate.persistentStoreCoordinator;
         NSPersistentStore* newPS = [[newPSC persistentStores] objectAtIndex:0];
         NSURL* newStoreURL = [newPS URL];
    
         // can't reach icloud alert user, reset switch and bail
         if ( [oldStoreURL isEqual:newStoreURL] ){
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to reach iCloud" message:@"Are you online and logged into your iCloud account?" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
             [alertView show];
             iCloudOn = ![self.iCloudSwitch isOn];
             self.iCloudSwitch.on = iCloudOn;
             [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:iCloudOn] forKey:@"iCloudOn"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             return;
         }
    
         NSLog(@"old store %@, new store %@", oldStoreURL, newStoreURL);
         
         // icloud reachable so merge data
         NSError* error = nil;
         [newPSC migratePersistentStore:oldStore toURL:newStoreURL options:nil withType:NSSQLiteStoreType error:&error];
         NSLog(@"\n\nMigration okay? %@\n\n", error.userInfo );

         
    }else{
        [self removeMetadataFromLocalDatabase];
        [appDelegate reloadStores];
    }
    

}





- (void)removeMetadataFromLocalDatabase
{
    
    // local options
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    // path to local files
    NSURL* applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // data description
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // load the local database
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:DATABASE_NAME];
    NSError *error = nil;
    
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSManagedObjectContext* managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    
    // get local store meta data
    NSMutableDictionary *metadata = [[NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                                URL:storeURL error:&error] mutableCopy];
    
    if ( metadata ){
        [metadata removeObjectForKey:@"com.apple.coredata.ubiquity.baseline.timestamp"];
        [metadata removeObjectForKey:@"com.apple.coredata.ubiquity.token"];
        [metadata removeObjectForKey:@"com.apple.coredata.ubiquity.ubiquitized"];
        
        if ([NSPersistentStoreCoordinator setMetadata:metadata forPersistentStoreOfType:NSSQLiteStoreType
                                                   URL:storeURL error:&error]) {
        }
    }
}








- (void)removeTemporaryFiles
{
    //
    // if icloud was off during update we have 3 files in Documents to remove
    //
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSError* error = nil;

    NSURL* tempiCloudDatabase1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", documentsDirectory, ICLOUD_DATABASE_NAME]];
    NSURL* tempiCloudDatabase2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", documentsDirectory, ICLOUD_DATABASE_NAME, @"-shm"]];
    NSURL* tempiCloudDatabase3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", documentsDirectory, ICLOUD_DATABASE_NAME, @"-wal"]];
    
    
    if ( [fileManager fileExistsAtPath:[tempiCloudDatabase1 path]] == YES ){
        [fileManager removeItemAtURL:tempiCloudDatabase1 error:&error];
    }
    
    if ( [fileManager fileExistsAtPath:[tempiCloudDatabase2 path]]){
        [fileManager removeItemAtURL:tempiCloudDatabase2 error:&error];
    }
    
    if ( [fileManager fileExistsAtPath:[tempiCloudDatabase3 path]]){
        [fileManager removeItemAtURL:tempiCloudDatabase3 error:&error];
    }

}





- (IBAction)removeDuplicates:(id)sender
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
    }
    
    
    // find and remove duplicates
    NSArray *findDuplicatesArray = [fetchedResultsController fetchedObjects];
    int numberOfObjects = (int)[findDuplicatesArray count];
    
    
    if ( numberOfObjects > 2 ){
        for (int i=1; i<numberOfObjects; i++){
            
            Record *firstRecord = [findDuplicatesArray objectAtIndex:i-1];
            Record *secondRecord = [findDuplicatesArray objectAtIndex:i];
            
            if ( [firstRecord.date timeIntervalSinceDate:secondRecord.date] < 86000 ){  // same day --- looks like a dup
                if ( [firstRecord.note compare:secondRecord.note] == 0 ){         // same note and same date, it's a dup
                    
                    [managedObjectContext deleteObject:firstRecord];
                }
            }
        }
    }
    
    // cleanup
    findDuplicatesArray = nil;
    [managedObjectContext save:&error];
    
}






- (IBAction)emailDatabase:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
            NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            url =[url URLByAppendingPathComponent:DATABASE_NAME];
            
            NSData* data = [NSData dataWithContentsOfURL:url];
            
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
            
			[picker setSubject:@"Fertilizer SQLite database"];
            [picker setMessageBody:@"Fertilizer database" isHTML:NO];
            [picker addAttachmentData:data mimeType:@"application/x-sqlite3" fileName:DATABASE_NAME];
            
            NSString *dataFileName = [NSString stringWithFormat:@"%@%@", DATABASE_NAME, @"-wal"];
            [picker addAttachmentData:data mimeType:@"applications/xsqlite3" fileName:dataFileName];
            
            NSString *dataFileName2 = [NSString stringWithFormat:@"%@%@", DATABASE_NAME, @"-shm"];
            [picker addAttachmentData:data mimeType:@"applications/xsqlite3" fileName:dataFileName2];
            
            [self presentViewController:picker animated:YES completion:nil];
            
		}else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failed" message:@"Device unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
		}
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failed" message:@"Device unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSLog(@"result %@",error.userInfo   );
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(IBAction)emailData:(id)sender
{
    //  fetch data **************************************************************
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* managedObjectContext = appDelegate.managedObjectContext;
    
    // load stored objects
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) { NSLog (@"mutable array fetch fail");}		// Handle the error.
    
    // format data
    int count = (int)[mutableFetchResults count];
    Record *r = [Record alloc];
    
    
    // loop through data and parse each record into a string
    NSString *note;
    NSDate *date;
    
    NSMutableArray* recordsArray = [[NSMutableArray alloc] initWithCapacity:count];
    NSString *aRecord;
    
    for ( int i=0; i<count; i++){
        
        r = [mutableFetchResults objectAtIndex:i];
        note = [r note];
        date = [r date];
        
        aRecord = [NSString stringWithFormat:@"\n%@, %@", date, note];
        [recordsArray addObject:aRecord];
    }

    // convert all those strings to one long string
    NSString *data = [NSString stringWithFormat:@"\n"];
    count = (int)[recordsArray count];
    
    for ( int i=0; i<count; i++){
        data = [data stringByAppendingString:[recordsArray objectAtIndex:i]];
    }
    
    // email that string
    NSArray *shareItem = @[data];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:shareItem applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
