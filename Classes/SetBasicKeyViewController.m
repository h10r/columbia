//
//  SetBasicKeyViewController.m
//  Faustus
//
//  Created by Hendrik Heuer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SetBasicKeyViewController.h"

@interface SetBasicKeyViewController ()

@end

@implementation SetBasicKeyViewController

@synthesize noteNames, modeNames, keyPickerView, noteOrFunctionToggle, delegate;

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
    
    noteNames = delegate.sharedNoteNames;
    modeNames = delegate.sharedModeNames;
    
    int selectedIndex = 0;
    
    for (int i=0; i < [noteNames count]; i++ ) {
        if ( [delegate.currentNoteAndMode isEqualToString:[noteNames objectAtIndex:i] ] ) {
            selectedIndex = i;
        }
    }
    
    [keyPickerView selectRow:selectedIndex inComponent:0 animated:NO];
    [keyPickerView selectRow:delegate.mode inComponent:1 animated:NO];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        delegate.name = row;
        
        delegate.currentNoteAndMode = [noteNames objectAtIndex:row];
        
        NSInteger rightNote = [[delegate.sharedNoteRoots objectAtIndex:row] integerValue];
        
        delegate.note = rightNote; // NSLog( @"%@", [noteNames objectAtIndex:row] );
    } else {
        delegate.mode = row; // NSLog( @"%@", [modeNames objectAtIndex:row] );
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didChangeKey" 
                                                        object: nil 
                                                      userInfo: nil];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [noteNames count];
    } else {
        return [modeNames count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [noteNames objectAtIndex:row];
    } else {
        return [modeNames objectAtIndex:row];
    }
}    

-(IBAction)changeSeg:(UISegmentedControl*)sender {
	if(sender.selectedSegmentIndex == 0){
		delegate.showName = true;
	}
	if(sender.selectedSegmentIndex == 1){
        delegate.showName = false;
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didChangeCaption" 
                                                        object: nil 
                                                      userInfo: nil];
}


@end
