//
//  ConverterViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConverterViewController.h"



@implementation ConverterViewController



- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.defaults = [NSUserDefaults standardUserDefaults];
	
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
    
	// restore last state	
	nitrogenOnHand = [[self.defaults objectForKey:@"nitrogenOnHand"]doubleValue];
	phosphorusOnHand = [[self.defaults objectForKey:@"phosphorusOnHand"]doubleValue];
	potassiumOnHand = [[self.defaults objectForKey:@"potassiumOnHand"]doubleValue];
	nitrogenDesired = [[self.defaults objectForKey:@"nitrogenDesired"]doubleValue];
	phosphorusDesired = [[self.defaults objectForKey:@"phosphorusDesired"]doubleValue];
	potassiumDesired = [[self.defaults objectForKey:@"potassiumDesired"]doubleValue];
	partsFertilizer = [[self.defaults objectForKey:@"partsFertilizer"]doubleValue];
	
	[self.nitrogenOnHandTextField setText:[NSString stringWithFormat:@"%.2lf", nitrogenOnHand]];
	[self.phosphorusOnHandTextField setText:[NSString stringWithFormat:@"%.2lf", phosphorusOnHand]];
	[self.potassiumOnHandTextField setText:[NSString stringWithFormat:@"%.2lf", potassiumOnHand]];
	[self.nitrogenDesiredTextField setText:[NSString stringWithFormat:@"%.2lf", nitrogenDesired]];
	[self.phosphorusDesiredTextField setText:[NSString stringWithFormat:@"%.2lf", phosphorusDesired]];
	[self.potassiumDesiredTextField setText:[NSString stringWithFormat:@"%.2lf", potassiumDesired]];
	[self.partsFertilizerTextField setText:[NSString stringWithFormat:@"%.2lf", partsFertilizer]];
	
	[self calculate];
}


-(void)saveState
{
	[self.defaults setObject:[NSNumber numberWithDouble:nitrogenOnHand] forKey:@"nitrogenOnHand"];
	[self.defaults setObject:[NSNumber numberWithDouble:phosphorusOnHand] forKey:@"phosphorusOnHand"];
	[self.defaults setObject:[NSNumber numberWithDouble:potassiumOnHand] forKey:@"potassiumOnHand"];
	[self.defaults setObject:[NSNumber numberWithDouble:nitrogenDesired] forKey:@"nitrogenDesired"];
	[self.defaults setObject:[NSNumber numberWithDouble:phosphorusDesired] forKey:@"phosphorusDesired"];
	[self.defaults setObject:[NSNumber numberWithDouble:potassiumDesired] forKey:@"potassiumDesired"];
	[self.defaults setObject:[NSNumber numberWithDouble:partsFertilizer] forKey:@"partsFertilizer"];
}


- (IBAction)calculate
{
	[self.nitrogenOnHandTextField resignFirstResponder];
	[self.nitrogenDesiredTextField resignFirstResponder];
	[self.phosphorusOnHandTextField resignFirstResponder];
	[self.phosphorusDesiredTextField resignFirstResponder];
	[self.potassiumOnHandTextField resignFirstResponder];
	[self.potassiumDesiredTextField resignFirstResponder];
	[self.partsFertilizerTextField resignFirstResponder];
	
	nitrogenOnHand = [[self.nitrogenOnHandTextField text]doubleValue];
	potassiumOnHand = [[self.potassiumOnHandTextField text] doubleValue];
	phosphorusOnHand = [[self.phosphorusOnHandTextField text] doubleValue];
	
	nitrogenDesired = [[self.nitrogenDesiredTextField text] doubleValue];
	potassiumDesired = [[self.potassiumDesiredTextField text] doubleValue];
	phosphorusDesired = [[self.phosphorusDesiredTextField text] doubleValue];
	
	partsFertilizer = [[self.partsFertilizerTextField text] doubleValue];
	
	// match Nitrogen
	ratio1 = nitrogenDesired/nitrogenOnHand;
	fertilizer1 = partsFertilizer * ratio1;
	
	if ( ratio1 > 0 ){
		[self.fertilizer1Label setText:[NSString stringWithFormat:@"%.2lf", ratio1*partsFertilizer]];
		[self.ratio1Label setText:[NSString stringWithFormat:@"%.2lf", ratio1]];
		
		int n1 = (int)nitrogenDesired;
		int k1 = (int)(potassiumOnHand * ratio1);
		int p1 = (int)(phosphorusOnHand * ratio1);
		[self.result1Label setText:[NSString stringWithFormat:@"%d-%d-%d", n1, p1, k1]];
		
	}else {
		[self.fertilizer1Label setText:@"?"];
		[self.ratio1Label setText:@"?"];
		[self.result1Label setText:@"?"];
	}
    
    
	
	// match Phosphorus
	ratio2 = phosphorusDesired/phosphorusOnHand;
	fertilizer2 = partsFertilizer * ratio2;
	
	if ( ratio2 > 0 ){
        
		[self.fertilizer2Label setText:[NSString stringWithFormat:@"%.2lf", ratio2*partsFertilizer]];
		[self.ratio2Label setText:[NSString stringWithFormat:@"%.2lf", ratio2]];
        
		int n2 = (int)(nitrogenOnHand * ratio2);
		int k2 = (int)(potassiumOnHand * ratio2);
		int p2 = (int)phosphorusDesired;
		[self.result2Label setText:[NSString stringWithFormat:@"%d-%d-%d", n2, p2, k2]];
        
	}else {
		[self.fertilizer2Label setText:@"?"];
		[self.ratio2Label setText:@"?"];
		[self.result2Label setText:@"?"];
	}
    
	
	// match Potassium
	ratio3 = potassiumDesired/potassiumOnHand;
	fertilizer3 = partsFertilizer * ratio3;
	
	if ( ratio3 > 0 ){
		[self.fertilizer3Label setText:[NSString stringWithFormat:@"%.2lf", ratio3*partsFertilizer]];
		[self.ratio3Label setText:[NSString stringWithFormat:@"%.2lf", ratio3]];
        
		int n3 = (int)(nitrogenOnHand * ratio3);
		int k3 = (int)potassiumDesired;
		int p3 = (int)(phosphorusOnHand * ratio3);
		[self.result3Label setText:[NSString stringWithFormat:@"%d-%d-%d", n3, p3, k3]];
		
	}else {
		[self.fertilizer3Label setText:@"?"];
		[self.ratio3Label setText:@"?"];
		[self.result3Label setText:@"?"];
	}
    
	
	[self saveState];
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





- (void)viewDidUnload 
{
    [super viewDidUnload];
}


@end
