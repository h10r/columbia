//
//  SetBasicKeyViewController.h
//  Faustus
//
//  Created by Hendrik Heuer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SetBasicKeyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *noteNames, *modeNames;
    
    IBOutlet UIPickerView *keyPickerView;
    IBOutlet UISegmentedControl *noteOrFunctionToggle;
    
    AppDelegate *delegate;    
}

@property (nonatomic, retain) NSArray *noteNames,*modeNames;
@property (nonatomic, retain) UIPickerView *keyPickerView;
@property (nonatomic, retain) UISegmentedControl *noteOrFunctionToggle;
@property (nonatomic, retain) AppDelegate *delegate;

@end
