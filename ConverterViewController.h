//
//  ConverterViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConverterViewController : UIViewController
{
    double				nitrogenOnHand, phosphorusOnHand, potassiumOnHand;
	double				nitrogenDesired, phosphorusDesired, potassiumDesired;
	double				ratio1, fertilizer1;
	double				ratio2, fertilizer2;
	double				ratio3, fertilizer3;
	double				partsFertilizer;

}



@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, weak) IBOutlet UILabel *fertilizer1Label;
@property (nonatomic, weak) IBOutlet UILabel *fertilizer2Label;
@property (nonatomic, weak) IBOutlet UILabel *fertilizer3Label;
@property (nonatomic, weak) IBOutlet UILabel *ratio1Label;
@property (nonatomic, weak) IBOutlet UILabel *ratio2Label;
@property (nonatomic, weak) IBOutlet UILabel *ratio3Label;
@property (nonatomic, weak) IBOutlet UILabel *result1Label;
@property (nonatomic, weak) IBOutlet UILabel *result2Label;
@property (nonatomic, weak) IBOutlet UILabel *result3Label;
@property (nonatomic, weak) IBOutlet UITextField *nitrogenOnHandTextField;
@property (nonatomic, weak) IBOutlet UITextField *nitrogenDesiredTextField;
@property (nonatomic, weak) IBOutlet UITextField *phosphorusOnHandTextField;
@property (nonatomic, weak) IBOutlet UITextField *phosphorusDesiredTextField;
@property (nonatomic, weak) IBOutlet UITextField *potassiumOnHandTextField;
@property (nonatomic, weak) IBOutlet UITextField *potassiumDesiredTextField;
@property (nonatomic, weak) IBOutlet UITextField *partsFertilizerTextField;


- (IBAction)calculate;
- (void)setup;
- (void)saveState;



@end
