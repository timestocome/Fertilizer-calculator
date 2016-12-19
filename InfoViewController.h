//
//  InfoViewController.h
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"


@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    int units;
    int iCloudOn;
}


@property (nonatomic, weak) IBOutlet UISegmentedControl *unitsSegmentedControl;
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, weak) IBOutlet UITextView *quote;
@property (nonatomic, strong) NSArray *quotes;

@property (nonatomic, retain) MyScene* myScene;

- (IBAction)changeUnits:(id)sender;


-(IBAction)gift:(id)sender;
-(IBAction)share:(id)sender;
-(IBAction)rate:(id)sender;
-(IBAction)shareTip:(id)sender;

@end
