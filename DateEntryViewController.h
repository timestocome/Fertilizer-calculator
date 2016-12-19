//
//  DateEntryViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Record.h"


@interface DateEntryViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) Record *record;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UITextField *noteTextField;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


- (void)saveData;


@end
