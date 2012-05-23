//
//  MetronomeViewController.m
//  Faustus
//
//  Created by Hendrik Heuer on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MetronomeViewController.h"

@interface MetronomeViewController ()

@end

@implementation MetronomeViewController

@synthesize bpmLabel, bpmStepper, soundSwitch, visualSwitch, metronomeVolumeSlider, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    bpmStepper.minimumValue = 0;
    bpmStepper.maximumValue = 240;
    
    bpmStepper.value = delegate.metronomeBPM;
    
    bpmStepper.stepValue = 5;
    
    [bpmLabel setText:[NSString stringWithFormat: @"%i BPM", delegate.metronomeBPM ]];
}

- (void) viewWillAppear:(BOOL)animated {
    bpmStepper.value = delegate.metronomeBPM;
    
    soundSwitch.on = delegate.metronomeSound;
    visualSwitch.on = delegate.metronomeVisual;
    
    metronomeVolumeSlider.value = delegate.metronomeGain;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(IBAction) metronomeSoundSwitchChanged:(UISwitch*)sender {
    if (sender.on) {
        delegate.metronomeSound = true;
    } else {
        delegate.metronomeSound = false;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didUpdateMetronome" 
                                                        object: nil 
                                                      userInfo: nil];
}


-(IBAction) metronomeVisualSwitchChanged:(UISwitch*)sender {
    if (sender.on) {
        delegate.metronomeVisual = true;
    } else {
        delegate.metronomeVisual = false;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didUpdateMetronome" 
                                                        object: nil 
                                                      userInfo: nil];
}

- (IBAction)metronomeBPMChanged:(UIStepper *)sender {
    delegate.metronomeBPM = (int)[sender value];
    
    [bpmLabel setText:[NSString stringWithFormat:@"%i BPM", delegate.metronomeBPM ] ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didUpdateMetronome" 
                                                        object: nil 
                                                      userInfo: nil];
}

-(IBAction) metronomeVolumeSliderValueChanged:(UISlider*)sender {
    delegate.metronomeGain = [sender value];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didUpdateMetronome" 
                                                        object: nil 
                                                      userInfo: nil];
}


@end
