//
//  NutrientsViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NutrientViewController.h"


@interface NutrientsViewController : UITableViewController
{
    int row;
}


@property (nonatomic, strong) NSArray *nutrientsArray;
@property (nonatomic, strong) NutrientViewController *nutrientViewController;

@end
