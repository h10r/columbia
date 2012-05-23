//
//  DetailViewController.h
//  Faustus
//
//  Created by Hendrik Heuer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, 
                                                    UISplitViewControllerDelegate, 
                                                    UIPickerViewDelegate, 
                                                    UIPickerViewDataSource> {
    AppDelegate *delegate;    
    NSArray *noteNames, *modeNames, *circleOfFifths;
    
    int circleOfFifthsCount;
                                                        
    IBOutlet UILabel *lblCurrentKey;
    IBOutlet UILabel *lblCurrentTemplate;
    IBOutlet UILabel *lblCurrentTempo;
    
    IBOutlet UISlider *volumeSlider; 
    
    IBOutlet UIView *templateView;
    
    IBOutlet UIPickerView *circleOfFifthPicker;
                                                        
    NSMutableArray *itemArray;
}

@property (nonatomic, retain) AppDelegate *delegate;
@property (nonatomic, retain) NSArray *noteNames,*modeNames, *circleOfFifths;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UILabel *lblCurrentKey;
@property (nonatomic, retain) IBOutlet UILabel *lblCurrentTemplate;
@property (nonatomic, retain) IBOutlet UILabel *lblCurrentTempo;

@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;  

@property (nonatomic, retain) IBOutlet UIView *templateView;

@property (nonatomic, retain) UIPickerView *circleOfFifthPicker;

- (IBAction) volumeSliderValueChanged:(UISlider*)sender;

@end
