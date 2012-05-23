//
//  MetronomeViewController.h
//  Faustus
//
//  Created by Hendrik Heuer on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MetronomeViewController : UIViewController {
    IBOutlet UILabel *bpmLabel;
    IBOutlet UIStepper *bpmStepper;
    IBOutlet UISwitch *soundSwitch, *visualSwitch;
    IBOutlet UISlider *metronomeVolumeSlider;  
    
    AppDelegate *delegate;
}


@property (nonatomic, retain) AppDelegate *delegate;

@property (nonatomic, retain) IBOutlet UILabel *bpmLabel;  
@property (nonatomic, retain) IBOutlet UIStepper *bpmStepper;  
@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch, *visualSwitch;  
@property (nonatomic, retain) IBOutlet UISlider *metronomeVolumeSlider;  

-(IBAction) metronomeVolumeSliderValueChanged:(UISlider*)sender;

@end
