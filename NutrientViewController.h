//
//  NutrientViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NutrientViewController : UIViewController



@property int row;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *useTextView;
@property (nonatomic, weak) IBOutlet UITextView *symptomsTextView;
@property (nonatomic, weak) IBOutlet UITextView *rateTextView;



@end
