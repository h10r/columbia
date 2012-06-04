//
//  DetailViewController.m
//  Faustus
//
//  Created by Hendrik Heuer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "SplitViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;
@synthesize detailItem=_detailItem;
@synthesize detailDescriptionLabel=_detailDescriptionLabel;
@synthesize popoverController=_myPopoverController;

@synthesize templateView, lblCurrentKey, lblCurrentTemplate, lblCurrentTempo, volumeSlider; 
@synthesize circleOfFifthPicker, circleOfFifths, delegate, modeNames, noteNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(didChangeKeySoUpdate:) 
                                                     name: @"didChangeKey" 
                                                   object: nil];

    }
    return self;
}

-(void) didChangeKeySoUpdate:(NSNotification*) notification {
    [self setCircleOfFifthsAccordingToMode];
}

- (void) setCircleOfFifthsAccordingToMode {
    NSLog(@"changed note names!");
    
    if (delegate.mode == 1) {
        circleOfFifths = [[NSArray alloc] 
                          initWithObjects: @"A", @"E", @"B", @"F#", @"C#", 
                          @"G#", @"Eb", @"Bb", @"F", @"C", @"G", @"D", nil];
    } else {
        circleOfFifths = [[NSArray alloc] 
                          initWithObjects: @"C", @"G", @"D", @"A", @"E", 
                          @"B", @"Gb", @"Db", @"Ab", @"Eb", @"Bb", @"F", nil];
    }
    
    circleOfFifthsCount = [circleOfFifths count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = [[UIApplication sharedApplication] delegate];
        
    [self setCircleOfFifthsAccordingToMode];
    	
    circleOfFifthPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0.7f*275, 100)];
    [circleOfFifthPicker setDelegate:self];
    
    [circleOfFifthPicker setShowsSelectionIndicator:NO];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [circleOfFifthPicker setTransform:rotate];
    //[circleOfFifthPicker setCenter:CGPointMake(158, 196+10)];
    [circleOfFifthPicker setCenter:CGPointMake(130, 196+10)];
    
    
    [circleOfFifthPicker setShowsSelectionIndicator:YES];
    [self.view addSubview:circleOfFifthPicker];

}

-(void) viewWillAppear:(BOOL)animated {    
    [self setCircleOfFifthsAccordingToMode];
    
    [lblCurrentKey setText:[NSString stringWithFormat: @"%@ %@", 
                delegate.currentNoteAndMode,
                [delegate.sharedModeNames objectAtIndex:delegate.mode]]
     ];

    
    if (delegate.selectedTemplate >= 0) {
        [lblCurrentTemplate setText:[delegate.sharedTemplates objectAtIndex:delegate.selectedTemplate] ];
    }
    
    NSMutableString *strCurrentTempo = [NSMutableString stringWithFormat:@"%i BPM", delegate.metronomeBPM];
    if (delegate.metronomeSound) {
        [strCurrentTempo appendFormat:@", Sound on"];
    }
    if (delegate.metronomeVisual) {
        [strCurrentTempo appendFormat:@", Visual on"];
    }
    [lblCurrentTempo setText:strCurrentTempo ];
    
    NSLog(@"%@", delegate.currentNoteAndMode);
    
    int i;
    int rightIndex = -1;
    for (i = 0; i < [circleOfFifths count]; i++) {
        NSString *s = [circleOfFifths objectAtIndex:i];        
        if ([delegate.currentNoteAndMode isEqualToString:s]) {
            rightIndex = i;
        }
    }
    
    NSLog(@"%i", rightIndex);
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

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

- (void)configureView {
    // Update the user interface for the detail item.
    _detailDescriptionLabel.text = @"Test";   
}

- (IBAction) volumeSliderValueChanged:(UISlider*)sender {
    delegate.gain = [sender value];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didUpdateGain" 
                                                        object: nil 
                                                      userInfo: nil];
}

#pragma mark -
#pragma mark Picker View Methods

-(void)pickerViewLoaded: (id)blah {
	NSUInteger max = 16384;
	NSUInteger base10 = (max/2)-(max/2)%10;
	[circleOfFifthPicker selectRow:[circleOfFifthPicker selectedRowInComponent:0]%12+base10 inComponent:0 animated:false];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *newKey = (NSString *)[circleOfFifths objectAtIndex:(row%12)];
    
    delegate.modulateKey = newKey;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"modulateKey" 
                                                        object: nil 
                                                      userInfo: nil];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 16384;
    // return [circleOfFifths count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [circleOfFifths objectAtIndex:row];
}    

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *viewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
     CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
     rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    
    CGRect rectDate = CGRectMake(0, 0, 60, 40);
    UILabel *lblFifth = [[UILabel alloc]initWithFrame:rectDate];
    [lblFifth setTransform:rotate];
    [lblFifth setText:[circleOfFifths objectAtIndex:(row%(circleOfFifthsCount))]];
    [lblFifth setFont:[UIFont boldSystemFontOfSize:32]];
    [lblFifth setShadowColor:[UIColor whiteColor]];
    [lblFifth setShadowOffset:CGSizeMake(0, -1)];
    [lblFifth setTextAlignment:UITextAlignmentCenter];
    [lblFifth setBackgroundColor:[UIColor clearColor]];
    [lblFifth setClipsToBounds:YES];
    [viewRow addSubview:lblFifth];
    
    return viewRow;
}


@end
