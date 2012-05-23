//
//  templateView.m
//  Faustus
//
//  Created by Hendrik Heuer on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "templateView.h"

@implementation templateView

@synthesize templatesRoles, roleImages;

- (void)awakeFromNib {
    delegate = [[UIApplication sharedApplication] delegate];

    arrow = [UIImage imageNamed:@"arrow.png"];
    wrong = [UIImage imageNamed:@"wrong.png"];
    
    UIImage *image0 = [UIImage imageNamed:@"tonic-tone.png"];
    UIImage *image1 = [UIImage imageNamed:@"supertonic-tone.png"];
    UIImage *image2 = [UIImage imageNamed:@"mediant-tone.png"];
    UIImage *image3 = [UIImage imageNamed:@"subdominant-tone.png"];
    UIImage *image4 = [UIImage imageNamed:@"dominant-tone.png"];
    UIImage *image5 = [UIImage imageNamed:@"submediant-tone.png"];
    UIImage *image6 = [UIImage imageNamed:@"subtonic-tone.png"];

    roleImages = [[NSArray alloc] initWithObjects:image0, image1, image2, image3, image4, image5, image6, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(templateChanged:) 
                                                 name: @"didChangeTemplate" 
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(chordPlayed:) 
                                                 name: @"didPlayNote" 
                                               object: nil];

    
    [self prepareTemplate];
}

-(void) prepareTemplate {
    currentTemplate = delegate.selectedTemplate;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Templates" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
    templatesRoles = [dict objectForKey:[delegate.sharedTemplates objectAtIndex:delegate.selectedTemplate]];
    [templatesRoles retain];
    
    nextChord = [[templatesRoles objectAtIndex:0] intValue];
    currentChordIndex = 0;
}

-(void) templateChanged: (NSNotification*) notification {
    [self prepareTemplate];
    [self setNeedsDisplay];
}

-(void) chordPlayed: (NSNotification*) notification {
    if (delegate.lastPlayedChord == nextChord) {
        currentChordIndex++;
        
        if (currentChordIndex < [templatesRoles count] ) {
            nextChord = [[templatesRoles objectAtIndex:currentChordIndex] intValue]; 
        } else {
            [self prepareTemplate];
            [self setNeedsDisplay];
        }
    }

    delegate.nextChord = nextChord;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"nextChordWasSet" 
                                                        object: nil 
                                                      userInfo: nil];
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {    
    int xoffset = 0;
    int yoffset = 0;
    
    for (int i = 0; i < [templatesRoles count]; i++ ) {
        int n = [[templatesRoles objectAtIndex:i] intValue];
        
        //NSLog(@"%i: %i", i, n);
        
        UIImage *iImage = [roleImages objectAtIndex:n];
        CGRect imageRect = CGRectMake(xoffset, yoffset, 55, 55);
        [iImage drawInRect:imageRect];
        
        if (i < currentChordIndex) {
            //CGRect arrowImageRect = CGRectMake(xoffset+15, yoffset+15, 24, 24);
            CGRect arrowImageRect = CGRectMake(xoffset+37, yoffset+37, 16, 16);
            [arrow drawInRect:arrowImageRect];
        }
        
        xoffset += 55;
        
        if (xoffset >= 275) {
            xoffset = 0;
            yoffset += 55;
        }
    } 
}

@end
