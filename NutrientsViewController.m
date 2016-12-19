//
//  NutrientsViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "NutrientsViewController.h"




@implementation NutrientsViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {}
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		self.tableView.backgroundColor = [UIColor clearColor];	
		self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-iPad.png"]];
        
	}else {
        
		self.tableView.backgroundColor = [UIColor clearColor];
        
        UIImageView *tableBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash2.png"]];
		self.tableView.backgroundView = tableBackground;
	}
    
    
    // load the nutrient list
	NSArray *array = [[NSArray alloc] initWithObjects:@"Nitrogen", @"Phosphorus", @"Potassium", @"Boron", @"Calcium", @"Copper", @"Iron", @"Magnesium", @"Auxin", @"Cytokinin", @"Ethylene", @"Abscisic Acid", @"Gibberellin", nil];
	self.nutrientsArray = array;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}







- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nutrientsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NutrientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = [self.nutrientsArray objectAtIndex:indexPath.row];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.backgroundColor = [UIColor clearColor];
    }

    
    
    return cell;
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    row = (int)self.tableView.indexPathForSelectedRow.row;
    
    if ([[segue identifier] isEqualToString:@"NutrientSegue"]) {
        
        [[segue destinationViewController] setRow:row];
                
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




@end
