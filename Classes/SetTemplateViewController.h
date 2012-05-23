//
//  SetTemplateViewController.h
//  Faustus
//
//  Created by Hendrik Heuer on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SetTemplateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *templates;
    
    AppDelegate *delegate;
}

@property (nonatomic, retain) AppDelegate *delegate;

@end
