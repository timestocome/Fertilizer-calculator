//
//  DatesViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatesViewController.h"
#import "Record.h"
#import "AppDelegate.h"



@implementation DatesViewController





- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {}
    
    return self;
}




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIBarButtonItem *addRecordItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addRecord:)];
    
    self.navigationItem.rightBarButtonItem = addRecordItem;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		UIImageView *tableBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-iPad.png"]];
		self.tableView.backgroundView = tableBackground;
		
	}else {
		UIImageView *tableBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash2.png"]];
		self.tableView.backgroundView = tableBackground;		
	}
    
    
    // listen for iCloud changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFetchedResults:) name:@"com.timestocome.RefreshAllViews" object:[[UIApplication sharedApplication] delegate]];
}



- (void)viewWillAppear:(BOOL)animated
{    
    // get units --- 0 is imperial 1 is metric
    units = [[self.defaults objectForKey:@"englishOrMetric"] intValue];
    
    // check for changes and reload data
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.fetchedResultsController = nil;
    
    [self reloadData];
}



- (void)reloadData
{    
    NSError *error = nil;
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;
    
    if ( ![[self fetchedResultsController] performFetch:&error]){
        NSLog(@"Core Data Error: %@ %@", error, [error userInfo]);
    }else{
        NSLog(@"reloading data %lu",(unsigned long)self.fetchedResultsController.fetchedObjects.count);
    }
    [self.tableView reloadData];
}





- (void)addRecord:(id)sender
{ 
    // move to edit screen
    if ( self.dateEntryViewController == NULL ){
        DateEntryViewController *devc = [[DateEntryViewController alloc] init];
        
        self.dateEntryViewController = devc;
    }
    
    [self performSegueWithIdentifier:@"DateSegue" sender:self];
}



- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil){ return _fetchedResultsController; }
    
    if ( !self.managedObjectContext ){
        // check for changes and reload data
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
    }
    
    
    return _fetchedResultsController;
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController fetchedObjects]count];

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell"];
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    cell.backgroundColor = [UIColor clearColor];

    
	// A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}

    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:101];
    dateLabel.text =[dateFormatter stringFromDate:[managedObject valueForKey:@"date"]];
        
    UILabel *noteLabel = (UILabel *)[cell viewWithTag:102];
    noteLabel.text = [managedObject valueForKey:@"note"];
    

    
    return cell;
}







//// editing of table view
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // delete from table and database
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // save database changes
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
        
        
    }
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller { [self.tableView endUpdates]; }

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller { [self.tableView beginUpdates]; }


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
    }
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
    }
}



//// change to detail view for editing record
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.dateEntryViewController.record = (Record *)object;
    }    
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DateSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        [[segue destinationViewController] setRecord:(Record *)object];
    }
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){	
		return YES;
	}else {	
		if ( interfaceOrientation == UIDeviceOrientationPortrait ){
			return YES;
		}else {
			return NO;	
		}
	}
}



- (void)reloadFetchedResults:(NSNotification*)note
{
    self.fetchedResultsController = nil;
    _fetchedResultsController = [self fetchedResultsController];
    [self reloadData];
}





//// clean up
-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}



@end
