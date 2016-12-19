//
//  InfoViewController.m
//  FertilizerCalc
//
//  Created by Linda Cobb on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
#import "Record.h"



@implementation InfoViewController







-(void)viewWillAppear:(BOOL)animated
{
    self.defaults = [NSUserDefaults standardUserDefaults];
    
	NSNumber *u = [self.defaults objectForKey:@"units"];
	units = u.intValue;
	[self.unitsSegmentedControl setSelectedSegmentIndex:units];	
}







- (IBAction)email:(id)sender
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			// send the email
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
			
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                [picker setSubject:[NSString stringWithFormat:@"Fertilizer V 7.6 iPad Request"]];
            }else{
                [picker setSubject:[NSString stringWithFormat:@"Fertilizer V 7.6 iPhone Request"]];
            }
            
			[picker setToRecipients:[NSArray arrayWithObject:@"timestocome@gmail.com"]];
			
            [self presentViewController:picker animated:YES completion:NULL];
			
		}else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failed" message:@"Device unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failed" message:@"Device unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
    
}




// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}





- (IBAction)changeUnits:(id)sender
{
	units = (int)self.unitsSegmentedControl.selectedSegmentIndex;
	NSNumber *u = [NSNumber numberWithInt:(int)[self.unitsSegmentedControl selectedSegmentIndex]];
	[self.defaults setObject:u forKey:@"units"];
	
}




- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView* skView = (SKView *)self.view;
    
    if ( ! skView.scene ){
        
        // Create and configure the scene.
        CGSize tabSize = CGSizeMake(skView.bounds.size.width, skView.bounds.size.height - 70);
        SKScene* scene = [MyScene sceneWithSize:tabSize];
      
        scene.scaleMode = SKSceneScaleModeAspectFill;
        _myScene = (MyScene *)scene;
        self.myScene.viewController = self;
        
        // Present the scene.
        [skView presentScene:self.myScene];
       
    }

    
	self.defaults = [NSUserDefaults standardUserDefaults];
	
	// draw a random quote
	NSArray *a = [[NSArray alloc] initWithObjects:
				  @"Keep your grass 2 to 3 inches tall, removing less than a third of the height each time you mow.",
				  @"Keep your lawnmower blades sharp. If the grass blades are frayed at the top, it's time to sharpen.",
				  @"Overwatering does more harm than under watering on the lawn or in the garden.",
				  @"Too much of one fertilizer nutrient can cause a deficiency in another nutrient.",
				  @"Cut your lawn often enough that you can leave the small cuttings on the lawn to provide nutrients.", 
				  @"It's time to water the lawn when footprints don't vanish or when you can't stick your finger down an inch in the garden soil.",
				  @"It is better to water deeply once a week, than lightly several times a week",
				  @"Remove dead flowers to keep your flowers blooming longer.",
				  @"To kill a section of lawn bury it in newspaper, then dirt, then mulch.",
				  @"Go organic and your lawn and garden will need less care from you.",
				  @"Location, location, location, put the right plant in the right location and the plant will take care of itself.",
				  @"Time release fertilizers release slowly in the cold, and quickly in the heat, adjust accordingly.",
				  @"Rake last years leaves and grass cuttings into the garden before putting down your mulch.",
				  @"Most states will test your soil for nutrients, check with your local extension office for details.",
				  @"Take care of your soil and the plants will take care of themselves.",
				  @"Lay newspaper down under mulch or rocks to prevent weeds.",
				  @"To remove stubborn plants, cut them to ground level and block the light, no light means no food for the plant.",
				  @"Prune shrubs by first removing branches that cross, then weak branches, then shape.",
				  @"Tall, spindly, weak plants usually want more light.",
				  @"Make a shrub bushier by removing top growth frequently.",
				  @"When planting new plants use the same soil that came out of the hole or the roots will grow in circles and strangle.",
				  @"Use the same plant in several places in a garden to tie it all together.",
				  @"Too much of one plant will attract problem insects. Use some variety in your landscape.",
				  @"Plant tall, wide, smelly, or prickly plants away from walkways. Make your walkways wide.",
				  @"Use a rake not a leaf blower, your waistline and the environment will thank you.",
				  @"Prune plants 6 months before or after peak flowering times.",
				  @"Use dish soap in water to kill aphids, ~1 tablespoon soap per quart of water.",
				  @"Grease the bird feeder pole with Vaseline to keep the squirrels away.",
				  @"Don't forget the birds, they use gardens like rest stops along migration routes.",
				  @"Dump and refill water for pets and birds every other day to prevent mosquitoes from breeding.",
				  @"Don't plant under the power lines, sooner or later they'll come down.",
				  @"Water daily the first week after you plant something, every other day the 2nd week, every 3rd day the 3rd week. . .",
				  @"Let the plants in the beds spill over the edge a little, it looks more natural.",
				  @"It doesn't matter how cute it is, if it's an invasive you're going to spend a lot of time, some time ripping it out.",
				  @"Pine needles make a great mulch.",
				  @"Want to attract bees and butterflies? Bring home the plants at the nursery that attract bees there.",
				  @"If you must cover plants on a cold winter night put a sheet between the plant and the plastic.",
				  @"Proper watering in the winter helps protect plants from the cold. Don't forget to water when needed.",
				  @"Bubble wrap makes a great winter protection for delicate plants.",
				  @"Lay the cuttings from the roses around the beds to help keep unwanted critters away.",
				  @"If the soil pH is too high ( 8+ ) plants can't take up nutrients, first fix the pH.",
				  nil];
	self.quotes = a;
	
	srand(time(NULL));
	long r = rand()%[self.quotes count];
	[self.quote setText:[self.quotes objectAtIndex:r]];
	
}
















-(IBAction)gift:(id)sender
{
    NSString *GiftAppURL = [NSString stringWithFormat:@"itms-appss://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%d&productType=C&pricingParameter=STDQ&mt=8&ign-mscache=1",391102214];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GiftAppURL]];
}


-(IBAction)share:(id)sender
{
    NSString *messageString = @"Fertilizer Calculator Link: itms-apps://itunes.apple.com/us/app/fit-test/id391102214?mt=8";
    NSArray *shareItem = @[messageString];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:shareItem applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
    
}


-(IBAction)rate:(id)sender
{
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id391102214"]];
    
}


-(IBAction)shareTip:(id)sender
{
    NSString *messageString = self.quote.text;
    NSArray *shareItem = @[messageString];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:shareItem applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
 
}




@end
