//
//  CalculatorViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> 
{
    double					nitrogen, phosphorus, potassium, sqft, pounds;
	double					rate;
	
	int						units;
}





@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *nitrogenArray;
@property (nonatomic, strong) NSArray *potassiumArray;
@property (nonatomic, strong) NSArray *phosphorusArray;
@property (nonatomic, strong) NSArray *poundsArray;
@property (nonatomic, strong) NSArray *sqftArray;
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, weak) IBOutlet UILabel *poundsKilogramsLabel;
@property (nonatomic, weak) IBOutlet UILabel *nitrogenLabel;
@property (nonatomic, weak) IBOutlet UILabel *phosphorusLabel;
@property (nonatomic, weak) IBOutlet UILabel *potassiumLabel;
@property (nonatomic, weak) IBOutlet UILabel *sqftLabel;


- (void)calculate;
- (void)setup;



@end
