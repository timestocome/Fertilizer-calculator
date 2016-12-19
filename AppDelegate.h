//
//  AppDelegate.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


// Current update
// Add ability to copy and replace database in iTunes


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Record.h"

NSString* const UIShouldRefresh;



@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

// core data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSDictionary* options;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)reloadStores;


@end
