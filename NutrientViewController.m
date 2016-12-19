//
//  NutrientViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NutrientViewController.h"



@implementation NutrientViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-iPad.png"]];
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
		
	}else {
		
		UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash2.png"]];
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
	}

    
	if ( self.row == 0 ){
        self.title = @"Nitrogen";
        
		[self.useTextView setText:@"Primary building block for plant protoplasm, the translucent substance found in all plant cells.  "];
		[self.symptomsTextView setText:@"Too little and older leaves turn yellow, growth is stunted. Too much and no fruits grow and the plant becomes cold sensitive."];
		[self.rateTextView setText:@"Application: Usually 1lb/1000 sqft (1kg/205 sqm) 4x/year, less in colder climates, more in warmer climates."];
		
	}else if ( self.row == 1 ){
        self.title = @"Phosphorus";
                
		[self.useTextView setText:@"Needed for energy storage and transfer in the plant. "];
		[self.symptomsTextView setText:@"Too little causes older leaf die back, poor root and flower development, bitter fruits and vegetables. Too much can cause a nitrogen deficiency."];
		[self.rateTextView setText:@"Only occasionally needed for flower and vegetable beds. 0.5lb/1000sqft (0.5kg/205sqm) 1x/year Best applied as liquid sprayed on leaves."];
		
	}else if ( self.row == 2 ){
        self.title = @"Potassium";
        
		[self.useTextView setText:@"Needed to activate enzymes and form sugars and oils, also improves cold weather tolerance. "];
		[self.symptomsTextView setText:@"Too little causes leaves to curl and distort, beginning with oldest.  Stalks may be stunted.  Too much can cause a nitrogen deficiency. "];
		[self.rateTextView setText:@"Only rarely needed. 1lb/1000sqft (1kg/205sqm) 1x/year"];
		
	}else if ( self.row == 3 ){        
        self.title = @"Boron";
        
		[self.useTextView setText:@"Needed for proper cell formation in new growth."];
		[self.symptomsTextView setText:@"Usually only deficient in wet, acidic soils, Newest buds die, stems may split, new leaves distorted, no fruit."];
		[self.rateTextView setText:@"Best applied in liquid spray to foliage. 0.05lb/1000sqft (0.05kg/205sqm ) 1x/yr"];
		
	}else if ( self.row == 4 ){
        
        self.title = @"Calcium";
        
		[self.useTextView setText:@"Builds plant cell walls."];
		[self.symptomsTextView setText:@"Usually only a problem with over watering in warm climates, blossom end rot is a common symptom."];
		[self.rateTextView setText:@"Rarely needed. 1lb/1000sqft (1kg/205sqm) 1x/year"];
		
	}else if (self.row == 5 ){        
        self.title = @"Copper";
        
		[self.useTextView setText:@"Sweetens the taste of fruits, handles free radicals."];
		[self.symptomsTextView setText:@"Dark green leaves, crinkly leaves, stunted growth, new leaves are yellow and curl up."];
		[self.rateTextView setText:@"Best applied in liquid spray to foliage see label for rate, can be toxic if over applied."];
		
	}else if (self.row == 6 ){
        self.title = @"Iron";
        
		[self.useTextView setText:@"Needed for chlorophyl formation."];
		[self.symptomsTextView setText:@"Leaves yellow beginning at stem, veins remain green. More common if soil pH > 8 and in clay soils."];
		[self.rateTextView setText:@"Iron spray may help young plants ~1 oz/gallon (1 gm/liter) of water."];
		
	}else if ( self.row == 7){
        self.title = @"Magnesium";
        
		[self.useTextView setText:@"Needed for photosynthesis and iron uptake."];
		[self.symptomsTextView setText:@"Older leaves yellow, veins remain green."];
		[self.rateTextView setText:@"Use Epsom salt 1 teaspoon/gallon (1.3ml/l) of water 2x/year if deficient."];
		
    }else if ( self.row == 8 ){
        self.title = @"Auxin";
        [self.useTextView setText:@"Plant hormone that stimulates young seedlings to grow."];
        [self.symptomsTextView setText:@"Too much and shoots grow, roots do not. Too little and only roots grow."];
        [self.rateTextView setText:@"IAA (indoleacetic acid) is the synthetic form"];

    }else if ( self.row == 9 ){
        self.title = @"Cytokinin";
        [self.useTextView setText:@"Plant hormone that stimulates cell division and shoot growth, helps immune system."];
        [self.symptomsTextView setText:@"Reduced shoot growth and increased root growth"];
        [self.rateTextView setText:@""];

    }else if ( self.row == 10 ){
        self.title = @"Ethylene";
        [self.useTextView setText:@"Plant hormone that stimulates fruit and flowering."];
        [self.symptomsTextView setText:@"Lack of flowers, plant doesn't come out of dormancy"];
        [self.rateTextView setText:@"Sweet smelling gas given off by fruit rotting"];

    }else if ( self.row == 11 ){
        self.title = @"Abscisic Acid";
        [self.useTextView setText:@"Plant hormone, inhibits bolting, helps encourage dormancy"];
        [self.symptomsTextView setText:@"Plants have trouble handling temperature stress (wilting) and or healing injuries"];
        [self.rateTextView setText:@""];

    }else if ( self.row == 12 ){
        self.title = @"Gibberellin";
        [self.useTextView setText:@"Plant hormone that stimulates shoot growth, bolting and flowering"];
        [self.symptomsTextView setText:@"Too much causes bolting, too little stunted growth"];
        [self.rateTextView setText:@"There are 126 gibberellins known."];

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



- (void)viewDidUnload
{
    [super viewDidUnload];
}


@end
