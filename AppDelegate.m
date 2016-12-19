//
//  AppDelegate.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


NSString* const UIShouldRefresh;





@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self reloadStores];
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {[self saveContext]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [self saveContext]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { }


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self reloadStores];
}












- (void)reloadStores
{

    [self saveContext];
    
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;
    
    _options = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                nil];

    
    int iCloudOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"iCloudOn"] intValue];
    
    if (  iCloudOn ){
    
        NSURL* transactionLogsURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        if ( transactionLogsURL ){  // icloud is available
        
            NSString* coreDataCloudContent = [[transactionLogsURL path] stringByAppendingPathComponent:ICLOUD_DATA];
            transactionLogsURL = [NSURL fileURLWithPath:coreDataCloudContent];
            NSLog(@"transaction logs url %@", transactionLogsURL);
        
        
            // convert old database to be compatible with new version of software
            _options = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                    [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                    @"Store", NSPersistentStoreUbiquitousContentNameKey,
                    transactionLogsURL, NSPersistentStoreUbiquitousContentURLKey,
                    nil];
        }        
        
    }
    _persistentStoreCoordinator = [self persistentStoreCoordinator];
    _managedObjectContext = [self managedObjectContext];
    
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}





- (void)storeDidChange:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // dunno why it changed so don't mess with it
    if ( !reasonForChange ){ return; }
    
    // init setup on a new device or server change, then save it to local defaults
    reason = [reasonForChange integerValue];
    if ( reason == NSUbiquitousKeyValueStoreServerChange || reason == NSUbiquitousKeyValueStoreInitialSyncChange ){
        
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* kvStore = [NSUbiquitousKeyValueStore defaultStore];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [changedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL* stop){
            id value = [kvStore objectForKey:key];
            [defaults setObject:value forKey:key];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UIShouldRefresh object:nil];
    }
}




- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"App delegate save error: %@, %@", error, [error userInfo]);
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoreDidImportContent:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoresWillChange:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:coordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoresDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:coordinator];
    
    return _managedObjectContext;
}



- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    if ( _managedObjectModel == NULL ){ NSLog(@"Cannot create ManagedObjectModel for %@", MODEL_NAME); }

    return _managedObjectModel;
}




- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DATABASE_NAME];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:self.options error:&error]) {
        NSLog(@"\n\nUnresolved error %@, %@\n\n", error, [error userInfo]);
   
    // all went well leave url for database view
    }else{
        
        if ( [[[NSUserDefaults standardUserDefaults]  objectForKey:@"iCloudOn"] intValue] ){
            NSURL *iCloudURL = [[[self.persistentStoreCoordinator persistentStores] objectAtIndex:0] URL];
            [[NSUserDefaults standardUserDefaults] setObject:[iCloudURL absoluteString] forKey:@"newiCloudStoreURL"];
        }else{
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
    }
    
    return _persistentStoreCoordinator;
}



- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



- (void)persistentStoresWillChange:(NSNotification *)notification
{
    if ( [_managedObjectContext hasChanges]){
        NSError* error = nil;
        if (![_managedObjectContext save:&error]){
            NSLog(@"Error while trying to save data before store change  %@", error.localizedDescription );
        }
    }
    [_managedObjectContext reset];
}



- (void)persistentStoresDidChange:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PERSISTENT_STORE_CHANGED" object:nil];
}



- (void)persistentStoreDidImportContent:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PERSISTENT_STORE_UPDATED" object:nil];
}





@end

