//
//  DateEntryViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateEntryViewController.h"
#import "AppDelegate.h"




@implementation DateEntryViewController




- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // update managedObject in case we've switched between iclould and local
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

	
    // adding a new record
    if ( self.record == NULL ){
        Record *r = (Record *)[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
        self.record = r;
        [self.record setDate:[NSDate date]];
        [self.record setNote:@""];
    }
	self.note = [self.record note];
	self.date = [self.record date];
    
	
	[self.noteTextField setText:self.note];
	[self.datePicker setDate:self.date];
	
	self.noteTextField.delegate = self;
    
   
	
	    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-iPad.png"]];
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
		
	}else{
		
		UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash2.png"]];
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
	}
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.noteTextField resignFirstResponder];
    
	return YES;
}







- (void)viewDidUnload 
{
    [super viewDidUnload];
}



- (void)viewWillDisappear:(BOOL)animated
{
	self.note = [self.noteTextField text];
	self.date = [self.datePicker date];
	
	[self saveData];
}




-(void)saveData
{		
    self.note = [self.noteTextField text];
	self.date = [self.datePicker date];
    
    [self.record setNote:self.note];
    [self.record setDate:self.date];
        
    // save new record
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){	
		return YES;
	}else{	
		if ( interfaceOrientation == UIDeviceOrientationPortrait ){
			return YES;
		}else{
			return NO;	
		}
	}
}



@end
