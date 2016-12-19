//
//  CalculatorViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"



@implementation CalculatorViewController





- (void)viewDidLoad
{
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


- (void)viewWillAppear:(BOOL)animated
{	
	[self setup];
}


- (void)applicationWillEnterForeground:(NSNotificationCenter *)notification
{
	[self setup];
}



-(void)setup
{
    self.defaults = [NSUserDefaults standardUserDefaults];

	NSNumber *u = [self.defaults objectForKey:@"units"];
	units = u.intValue;
    
	if ( units == 0 ){ [self.poundsKilogramsLabel setText:@"lbs"]; }
	else { [self.poundsKilogramsLabel setText:@"Kgs"]; }
    
	self.defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *r = [self.defaults objectForKey:@"rate"];
	rate = r.intValue;
	if ( rate <= 0 ) { rate = 1.0; }
    
	nitrogen = 1;
	potassium = 1;
	phosphorus = 1;
	pounds = 1;
    
	NSArray *n = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                  @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", 
                  @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", 
                  @"30", @"31", @"32", @"43", @"34", @"35", @"36", @"37", @"38", @"39",
                  @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49",
                  @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59",
                  @"60", @"61", @"62", @"63", @"64", @"65", @"66", @"67", @"68", @"69",
                  @"70", @"71", @"72", @"73", @"74", @"75", @"76", @"77", @"78", @"79",
                  @"80", @"81", @"82", @"83", @"84", @"85", @"86", @"87", @"88", @"89",
                  @"90", @"91", @"92", @"93", @"94", @"95", @"96", @"97", @"98", @"99",
                  @"100", nil];
	self.nitrogenArray = n;
    
	NSArray *n1 = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                   @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", 
                   @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", 
                   @"30", @"31", @"32", @"43", @"34", @"35", @"36", @"37", @"38", @"39",
                   @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49",
                   @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59",
                   @"60", @"61", @"62", @"63", @"74", @"65", @"66", @"67", @"68", @"69",
                   @"70", @"71", @"72", @"73", @"64", @"75", @"76", @"77", @"78", @"79",
                   @"80", @"81", @"82", @"83", @"84", @"85", @"86", @"87", @"88", @"89",
                   @"90", @"91", @"92", @"93", @"94", @"95", @"96", @"97", @"98", @"99",
                   @"100", nil];
	self.potassiumArray = n1;
    
	NSArray *n2 = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                   @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", 
                   @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", 
                   @"30", @"31", @"32", @"43", @"34", @"35", @"36", @"37", @"38", @"39",
                   @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49",
                   @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59",
                   @"60", @"61", @"62", @"63", @"64", @"65", @"66", @"67", @"68", @"69",
                   @"70", @"71", @"72", @"73", @"74", @"75", @"76", @"77", @"78", @"79",
                   @"80", @"81", @"82", @"83", @"84", @"85", @"86", @"87", @"88", @"89",
                   @"90", @"91", @"92", @"93", @"94", @"95", @"96", @"97", @"98", @"99",
                   @"100", nil];
	self.phosphorusArray = n2;
    
	NSArray *n3 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                   @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", 
                   @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", 
                   @"30", @"31", @"32", @"43", @"34", @"35", @"36", @"37", @"38", @"39",
                   @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49",
                   @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59",
                   @"60", @"61", @"62", @"63", @"64", @"65", @"66", @"67", @"68", @"69",
                   @"70", @"71", @"72", @"73", @"74", @"75", @"76", @"77", @"78", @"79",
                   @"80", @"81", @"82", @"83", @"84", @"85", @"86", @"87", @"88", @"89",
                   @"90", @"91", @"92", @"93", @"94", @"95", @"96", @"97", @"98", @"99",
                   @"100", nil];
	self.poundsArray = n3;
	
	[self.pickerView selectRow:[[self.defaults objectForKey:@"n_position"]intValue] inComponent:0 animated:YES];
	[self.pickerView selectRow:[[self.defaults objectForKey:@"p_position"]intValue] inComponent:1 animated:YES];
	[self.pickerView selectRow:[[self.defaults objectForKey:@"k_position"]intValue] inComponent:2 animated:YES];
	[self.pickerView selectRow:[[self.defaults objectForKey:@"pounds_position"]intValue] inComponent:3 animated:YES];
    
    nitrogen = [self.pickerView selectedRowInComponent:0];
	phosphorus = [self.pickerView selectedRowInComponent:1];
	potassium = [self.pickerView selectedRowInComponent:2];
	pounds = 1 + [self.pickerView selectedRowInComponent:3];
    
	[self calculate];
}



- (NSInteger)selectedRowInComponent:(NSInteger)componet
{	
	return [self.pickerView selectedRowInComponent:componet];
	
}



- (void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	nitrogen = [picker selectedRowInComponent:0];
	phosphorus = [picker selectedRowInComponent:1];
	potassium = [picker selectedRowInComponent:2];
	pounds = 1 + [picker selectedRowInComponent:3];
	
	if ( component == 0 ){
		NSNumber *n = [NSNumber numberWithInt:(int)row];
		[self.defaults setObject:n forKey:@"n_position"];
	}else if ( component == 1 ){
		NSNumber *p = [NSNumber numberWithInt:(int)row];
		[self.defaults setObject:p forKey:@"p_position"];
	}else if ( component == 2 ){
		NSNumber *k = [NSNumber numberWithInt:(int)row];
		[self.defaults setObject:k forKey:@"k_position"];
	}else if ( component == 3 ){
		NSNumber *l = [NSNumber numberWithInt:(int)row];
		[self.defaults setObject:l forKey:@"pounds_position"];
	}
	[self.defaults synchronize];
    
    
	[self calculate];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{	
	return 4;
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if ( component == 0 ){
		return [self.nitrogenArray count];
	}else if ( component == 1 ){
		return [self.phosphorusArray count];
	}else if ( component == 2 ){
		return [self.potassiumArray count];
	}else if ( component == 3 ){
		return [self.poundsArray count];
	}else { return 1; }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	if ( component == 0 ){
		return [self.nitrogenArray objectAtIndex:row];
	}else if ( component == 1 ){
		return [self.phosphorusArray objectAtIndex:row];
	}else if ( component == 2 ){
		return [self.potassiumArray objectAtIndex:row];
	}else if ( component == 3 ){
		return [self.poundsArray objectAtIndex:row];
	}else { return @""; }
    
}


- (void)calculate
{
	double lbsNitrogen = pounds * nitrogen / 100;
	double lbsPotassium = pounds * potassium * .83 / 100;
	double lbsPhosphorus = pounds * phosphorus * .44 / 100;
    
	if ( units == 0 ){
		double nitrogenSqft = ((pounds * ( nitrogen/100 ))/rate) * 1000;
		
		[self.nitrogenLabel setText:[NSString stringWithFormat:@"%.2lf lbs Nitrogen", lbsNitrogen]];
		[self.potassiumLabel setText:[NSString stringWithFormat:@"%.2lf lbs Potassium", lbsPotassium]];
		[self.phosphorusLabel setText:[NSString stringWithFormat:@"%.2lf lbs Phosphorus", lbsPhosphorus]];
		[self.sqftLabel setText:[NSString stringWithFormat:@"Coverage ~ %.0lf sqft", nitrogenSqft]];  
	}else {
		double nitrogenSqm = ((pounds * 2.20462262 * (nitrogen/100))/rate ) * 1000  * .09290304;
		[self.nitrogenLabel setText:[NSString stringWithFormat:@"%.2lf kgs Nitrogen", lbsNitrogen]];
		[self.potassiumLabel setText:[NSString stringWithFormat:@"%.2lf kgs Potassium", lbsPotassium]];
		[self.phosphorusLabel setText:[NSString stringWithFormat:@"%.2lf kgs Phosphorus", lbsPhosphorus]];
		[self.sqftLabel setText:[NSString stringWithFormat:@"Coverage ~ %.0lf sq meters", nitrogenSqm]];  
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







- (void)viewDidUnload {}




@end
