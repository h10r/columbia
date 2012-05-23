//
//  HelpViewController.m
//  Faustus
//
//  Created by Hendrik Heuer on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

@synthesize closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [closeButton addTarget:self action:@selector(backButtonItemToDismissModal:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [closeButton addTarget:self action:@selector(backButtonItemToDismissModal:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
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

-(void)backButtonItemToDismissModal:(id)sender {
    NSLog(@"this is called!");
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
