//
//  templateView.h
//  Faustus
//
//  Created by Hendrik Heuer on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface templateView : UIView {
    AppDelegate *delegate; 
    
    NSArray *templatesRoles, *roleImages;
    
    UIImage *arrow, *wrong;
    
    int currentTemplate, nextChord, currentChordIndex;
}

@property (nonatomic, retain) NSArray *templatesRoles, *roleImages;

@end
