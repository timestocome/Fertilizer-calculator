//
//  DatesViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DateEntryViewController.h"


@interface DatesViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    int units;
}


@property (strong, nonatomic) DateEntryViewController *dateEntryViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) NSUserDefaults *defaults;

- (void)reloadData;


@end
