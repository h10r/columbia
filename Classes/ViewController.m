//
//  ViewController.m
//  Thesis
//
//  Created by Hendrik Heuer on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CABase.h>
#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize delegate, notes, notesFlat, notesSharp; 
@synthesize modes, chordsInRelationToBasicKey, modesInRelationToBasicKey, backgroundLines;
@synthesize btnTonic, btnTonic0, btnTonic3, btnTonic5, btnTonic6, btnTonic7;
@synthesize btnSupertonic, btnSupertonic0, btnSupertonic3, btnSupertonic5, btnSupertonic6, btnSupertonic7;
@synthesize btnMediant, btnMediant0, btnMediant3, btnMediant5, btnMediant6, btnMediant7;
@synthesize btnSubdominant, btnSubdominant0, btnSubdominant3, btnSubdominant5, btnSubdominant6, btnSubdominant7;
@synthesize btnDominant, btnDominant0, btnDominant3, btnDominant5, btnDominant6, btnDominant7;
@synthesize btnSubmediant, btnSubmediant0, btnSubmediant3, btnSubmediant5, btnSubmediant6, btnSubmediant7;
@synthesize btnSubtonic,btnSubtonic0, btnSubtonic3, btnSubtonic5, btnSubtonic6, btnSubtonic7;
@synthesize btnTonic8, btnTonic80, btnTonic83, btnTonic85, btnTonic86, btnTonic87;
@synthesize metronomeButton, select, selectHighlight, metronomeSoundID, singleSoundPlayer;
@synthesize buttonPositions;
@synthesize octaveLabel, octaveStepper;

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super initWithCoder:decoder]))
	{
		playingArpeggio = NO;
        
		// Create the player and tell it which sound bank to use.
		player = [[SoundBankPlayer alloc] init];
		[player setSoundBank:@"Piano"];
        
		// We use a timer to play arpeggios.
		[self startTimer];
                
        arpeggio = false;
                        
        notesSharp = [[NSArray alloc] 
                      initWithObjects:@"C", @"C#", @"D", @"D#", @"E", 
                      @"F", @"F#", @"G", @"G#",
                      @"A", @"A#", @"B", nil];
        
        notesFlat = [[NSArray alloc] 
                     initWithObjects:@"C", @"Db", @"D", @"Eb", @"E", 
                     @"F", @"Gb", @"G", @"Ab",
                     @"A", @"Bb", @"B", nil];

        notes = notesSharp;
        
        octave = 4;
        
        octaveStepper.minimumValue = 2;
        octaveStepper.maximumValue = 7;
        octaveStepper.value = octave;
        octaveStepper.stepValue = 1;
        
        modes = [[NSArray alloc] initWithObjects:@"Major", @"Minor", @"Harmonic minor", @"Melodic minor", nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(didChangeKeySoUpdate:) 
                                                     name: @"didChangeKey" 
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(didUpdateGain:) 
                                                     name: @"didUpdateGain" 
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(didUpdateMetronome:) 
                                                     name: @"didUpdateMetronome" 
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didChangeCaption:) 
                                                     name:@"didChangeCaption" 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(moveNextChordIndicator:) 
                                                     name: @"nextChordWasSet" 
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(modulateToKey:) 
                                                     name: @"modulateKey" 
                                                   object: nil];

        NSString* path = [[NSBundle mainBundle] pathForResource:@"metronome" ofType:@"caf"];
        NSURL *afUrl = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)afUrl,&metronomeSoundID);
        
        NSString *soundFilePath =
        [[NSBundle mainBundle] pathForResource: @"metronome"
                                        ofType: @"caf"];
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        
        AVAudioPlayer *newPlayer =
        [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                               error: nil];
        [fileURL release];
        
        self.singleSoundPlayer = newPlayer;
        [newPlayer release];
        
        [singleSoundPlayer prepareToPlay];
        
        selectorAt = -1;
	}
	return self;
}

- (void) playMetronome:(NSTimer*)timer {
    if (delegate.metronomeSound) {
        [singleSoundPlayer play];
    }
    
    if (delegate.metronomeVisual) {
        metronomeButton.highlighted = !metronomeButton.highlighted;
    }
}

-(void) modulateToKey:(NSNotification*) notification {
    
    delegate.currentNoteAndMode = delegate.modulateKey;
    
    //NSLog(@"%@", delegate.modulateKey);
    
    int i;
    int rightIndex = -1;
    for (i = 0; i < [notesFlat count]; i++) {
        NSString *s = [notesFlat objectAtIndex:i];        
        if ([delegate.modulateKey isEqualToString:s]) {
            rightIndex = i;
        }
    }
    for (i = 0; i < [notesSharp count]; i++) {
        NSString *s = [notesSharp objectAtIndex:i];        
        if ([delegate.modulateKey isEqualToString:s]) {
            rightIndex = i;
        }
    }
    
    if (rightIndex >= 0) {
        NSLog(@"%i", rightIndex);
        delegate.note = rightIndex;
        [self decideIfSharpOrFlat];
        [self updateKey];
    }
}

- (void) moveNextChordIndicator: (NSNotification*) notification {    
    if (selectorAt == delegate.nextChord) {
        return;
    }
    
    UIButton *lastButton = [buttonPositions objectAtIndex:delegate.lastPlayedChord];
    UIButton *nextButton = [buttonPositions objectAtIndex:delegate.nextChord];
         
    /*
     CABasicAnimation *animOpacity;
     animOpacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
     animOpacity.duration=3.0;
     animOpacity.repeatCount=2;
     animOpacity.autoreverses=YES;
     animOpacity.fromValue=[NSNumber numberWithFloat:1.0];
     animOpacity.toValue=[NSNumber numberWithFloat:0.0];
     
     [select.layer addAnimation:animOpacity forKey:nil];
     [selectHighlight.layer addAnimation:animOpacity forKey:nil];
     */
    
    CABasicAnimation *moveAnim  = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnim.beginTime = 0.0f;
	moveAnim.duration = 0.3f;
	moveAnim.fromValue =[NSValue valueWithCGPoint:lastButton.center];
	moveAnim.toValue =[NSValue valueWithCGPoint:nextButton.center];
    [select.layer addAnimation:moveAnim forKey:nil];
    [selectHighlight.layer addAnimation:moveAnim forKey:nil];
    
    CABasicAnimation *pulsateAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    pulsateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulsateAnim.beginTime = 0.3f;
    pulsateAnim.duration = 10;
    pulsateAnim.repeatCount = 30;
    pulsateAnim.autoreverses = YES;
    pulsateAnim.removedOnCompletion = YES;
    pulsateAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    [select.layer addAnimation:pulsateAnim forKey:nil];
    [selectHighlight.layer addAnimation:pulsateAnim forKey:nil];
        
    select.center = nextButton.center;
    selectHighlight.center = nextButton.center;
    
    selectorAt = delegate.nextChord;
}

- (void) didChangeKeySoUpdate: (NSNotification*) notification {
    //NSLog(@"%@", delegate.currentNoteAndMode);
    //delegate.currentNoteAndMode = [[delegate.currentNoteAndMode autorelease] stringByAppendingString:@"m"];
        
    [self decideIfSharpOrFlat];    
    [self updateKey];
}

-(void) didUpdateGain: (NSNotification*) notification {
    gain = delegate.gain;
}

-(void) didUpdateMetronome: (NSNotification*) notification {
    metronomeGain = delegate.metronomeGain;
    
    singleSoundPlayer.volume = metronomeGain;
        
    float BPMinSeconds = ((60000.0f / delegate.metronomeBPM) / 1000.0f);
    
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval: BPMinSeconds
                                             target: self
                                           selector: @selector(playMetronome:)
                                           userInfo: nil
                                            repeats: YES];
}

-(void) didChangeCaption: (NSNotification*) notification {
    if (delegate.showName) {
        [self setButtonsAsNames];
    } else {
        [self setButtonsAsFunctions];
    }
}

-(void) decideIfSharpOrFlat {
    NSString *currentNoteAndMode = delegate.currentNoteAndMode;
    
    // NSLog(@"%@", currentNoteAndMode);
    
    if (currentMode == 0) { // major
        NSArray *signMajorSharp = [[NSArray alloc] 
                                   initWithObjects:@"C", @"G", @"D", @"A", @"E", 
                                   @"B", @"F#", nil];
        
        notes = notesFlat;
                
        for (NSString *s in signMajorSharp) {
            
            if ( [currentNoteAndMode isEqualToString:s] ) {
                notes = notesSharp;
            }
        }
    } else {
        NSArray *signMinorSharp = [[NSArray alloc] 
                                   initWithObjects:@"A", @"E", @"B", @"F#", @"C#", 
                                   @"G#", @"D#", nil];
        notes = notesFlat;
        for (NSString *s in signMinorSharp) {
            if ( [currentNoteAndMode isEqualToString:s] ) {
                notes = notesSharp;
            }
        }
    }
    
    if ( [currentNoteAndMode rangeOfString:@"#"].length > 0) {
        notes = notesSharp;
    }
    
    if ( [currentNoteAndMode rangeOfString:@"b"].length > 0) {
        notes = notesFlat;
    }
    
    if (delegate.showName) {
        [self setButtonsAsNames];
    }
}

- (NSString*) currentKeyAsString {
    return [self stringChordByModeAndNumber:0];
}

- (void) updateKey {
    // 0 major, 1 minor, 2 flat, 3 sharp
        
    root = delegate.note;
    
    int newMode = delegate.mode; // 0 major, 1 minor
    gain = delegate.gain;
    
    // set up major key
    if (newMode == 0) {
        modesInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithInt:0 ],
                 [NSNumber numberWithInt:1 ],
                 [NSNumber numberWithInt:1 ],
                 [NSNumber numberWithInt:0 ],
                 [NSNumber numberWithInt:0 ],
                 [NSNumber numberWithInt:1 ],
                 [NSNumber numberWithInt:2 ],
                 [NSNumber numberWithInt:0 ],
                 nil];
        chordsInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithInt:0   ],
                 [NSNumber numberWithInt:2 ],
                 [NSNumber numberWithInt:4 ],
                 [NSNumber numberWithInt:5 ],
                 [NSNumber numberWithInt:7 ],
                 [NSNumber numberWithInt:9 ],
                 [NSNumber numberWithInt:11 ],
                 [NSNumber numberWithInt:12 ],
                 nil];
        
    // set up minor key    
    } else if (newMode == 1) { // minor
        modesInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithInt:1   ],
                 [NSNumber numberWithInt:2 ],
                 [NSNumber numberWithInt:0 ],
                 [NSNumber numberWithInt:1 ],
                 [NSNumber numberWithInt:1 ],
                 [NSNumber numberWithInt:0 ],
                 [NSNumber numberWithInt:0 ],
                 [NSNumber numberWithInt:1 ],
                 nil];
        
        chordsInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithInt:0   ],
                 [NSNumber numberWithInt:2 ],
                 [NSNumber numberWithInt:3 ],
                 [NSNumber numberWithInt:5 ],
                 [NSNumber numberWithInt:7 ],
                 [NSNumber numberWithInt:8 ],
                 [NSNumber numberWithInt:10 ],
                 [NSNumber numberWithInt:12 ],
                 nil];
    } else if (newMode == 2) { // minor harmonic
        modesInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                                     [NSNumber numberWithInt:1 ],
                                     [NSNumber numberWithInt:2 ],
                                     [NSNumber numberWithInt:3 ],
                                     [NSNumber numberWithInt:1 ],
                                     [NSNumber numberWithInt:0 ],
                                     [NSNumber numberWithInt:0 ],
                                     [NSNumber numberWithInt:2 ],
                                     [NSNumber numberWithInt:1 ],
                                     nil];
        
        chordsInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                                      [NSNumber numberWithInt:0   ],
                                      [NSNumber numberWithInt:2 ],
                                      [NSNumber numberWithInt:3 ],
                                      [NSNumber numberWithInt:5 ],
                                      [NSNumber numberWithInt:7 ],
                                      [NSNumber numberWithInt:8 ],
                                      [NSNumber numberWithInt:10 ],
                                      [NSNumber numberWithInt:12 ],
                                      nil];
    } else if (newMode == 3) { // minor melodic
        modesInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                                     [NSNumber numberWithInt:1   ],
                                     [NSNumber numberWithInt:1 ],
                                     [NSNumber numberWithInt:3 ],
                                     [NSNumber numberWithInt:0 ],
                                     [NSNumber numberWithInt:0 ],
                                     [NSNumber numberWithInt:2 ],
                                     [NSNumber numberWithInt:2 ],
                                     [NSNumber numberWithInt:1 ],
                                     nil];
        
        chordsInRelationToBasicKey = [[NSArray alloc] initWithObjects:
                                      [NSNumber numberWithInt:0   ],
                                      [NSNumber numberWithInt:2 ],
                                      [NSNumber numberWithInt:3 ],
                                      [NSNumber numberWithInt:5 ],
                                      [NSNumber numberWithInt:7 ],
                                      [NSNumber numberWithInt:8 ],
                                      [NSNumber numberWithInt:10 ],
                                      [NSNumber numberWithInt:12 ],
                                      nil];
    }
    
    // [btnTonic setText:[NSMutableString stringWithString:[notes objectAtIndex:( () % 12) ]] ];
    
    if (delegate.showName) {
        [self setButtonsAsNames];
    }
}

-(void) setButtonsAsFunctions {
    [btnTonic setTitle:@"T" forState:UIControlStateNormal];
    [btnTonic0 setTitle:@"0" forState:UIControlStateNormal];
    [btnTonic3 setTitle:@"3" forState:UIControlStateNormal];
    [btnTonic5 setTitle:@"5" forState:UIControlStateNormal];
    [btnTonic6 setTitle:@"6" forState:UIControlStateNormal];
    [btnTonic7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnSupertonic setTitle:@"Sp" forState:UIControlStateNormal];
    [btnSupertonic0 setTitle:@"0" forState:UIControlStateNormal];
    [btnSupertonic3 setTitle:@"3" forState:UIControlStateNormal];
    [btnSupertonic5 setTitle:@"5" forState:UIControlStateNormal];
    [btnSupertonic6 setTitle:@"6" forState:UIControlStateNormal];
    [btnSupertonic7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnMediant setTitle:@"Dp" forState:UIControlStateNormal];
    [btnMediant0 setTitle:@"0" forState:UIControlStateNormal];
    [btnMediant3 setTitle:@"3" forState:UIControlStateNormal];
    [btnMediant5 setTitle:@"5" forState:UIControlStateNormal];
    [btnMediant6 setTitle:@"6" forState:UIControlStateNormal];
    [btnMediant7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnSubdominant setTitle:@"S" forState:UIControlStateNormal];
    [btnSubdominant0 setTitle:@"0" forState:UIControlStateNormal];
    [btnSubdominant3 setTitle:@"3" forState:UIControlStateNormal];
    [btnSubdominant5 setTitle:@"5" forState:UIControlStateNormal];
    [btnSubdominant6 setTitle:@"6" forState:UIControlStateNormal];
    [btnSubdominant7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnDominant setTitle:@"D" forState:UIControlStateNormal];
    [btnDominant0 setTitle:@"0" forState:UIControlStateNormal];
    [btnDominant3 setTitle:@"3" forState:UIControlStateNormal];
    [btnDominant5 setTitle:@"5" forState:UIControlStateNormal];
    [btnDominant6 setTitle:@"6" forState:UIControlStateNormal];
    [btnDominant7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnSubmediant setTitle:@"Tp" forState:UIControlStateNormal];
    [btnSubmediant0 setTitle:@"0" forState:UIControlStateNormal];
    [btnSubmediant3 setTitle:@"3" forState:UIControlStateNormal];
    [btnSubmediant5 setTitle:@"5" forState:UIControlStateNormal];
    [btnSubmediant6 setTitle:@"6" forState:UIControlStateNormal];
    [btnSubmediant7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnSubtonic setTitle:@"D7" forState:UIControlStateNormal];
    [btnSubtonic0 setTitle:@"0" forState:UIControlStateNormal];
    [btnSubtonic3 setTitle:@"3" forState:UIControlStateNormal];
    [btnSubtonic5 setTitle:@"5" forState:UIControlStateNormal];
    [btnSubtonic6 setTitle:@"6" forState:UIControlStateNormal];
    [btnSubtonic7 setTitle:@"7" forState:UIControlStateNormal];
    
    [btnTonic8 setTitle:@"T" forState:UIControlStateNormal];
    [btnTonic80 setTitle:@"0" forState:UIControlStateNormal];
    [btnTonic83 setTitle:@"3" forState:UIControlStateNormal];
    [btnTonic85 setTitle:@"5" forState:UIControlStateNormal];
    [btnTonic86 setTitle:@"6" forState:UIControlStateNormal];
    [btnTonic87 setTitle:@"7" forState:UIControlStateNormal];
}

-(void) setButtonsAsNames {
    [btnTonic setTitle:[self stringChordByModeAndNumber:0] forState:UIControlStateNormal];
    [btnTonic0 setTitle:[self stringNoteByModeAndNumber:0 only:0] forState:UIControlStateNormal];
    [btnTonic3 setTitle:[self stringNoteByModeAndNumber:0 only:3] forState:UIControlStateNormal];
    [btnTonic5 setTitle:[self stringNoteByModeAndNumber:0 only:5] forState:UIControlStateNormal];
    [btnTonic6 setTitle:[self stringNoteByModeAndNumber:0 only:6] forState:UIControlStateNormal];
    [btnTonic7 setTitle:[self stringNoteByModeAndNumber:0 only:7] forState:UIControlStateNormal];
    
    [btnSupertonic setTitle:[self stringChordByModeAndNumber:1] forState:UIControlStateNormal];
    [btnSupertonic0 setTitle:[self stringNoteByModeAndNumber:1 only:0] forState:UIControlStateNormal];
    [btnSupertonic3 setTitle:[self stringNoteByModeAndNumber:1 only:3] forState:UIControlStateNormal];
    [btnSupertonic5 setTitle:[self stringNoteByModeAndNumber:1 only:5] forState:UIControlStateNormal];
    [btnSupertonic6 setTitle:[self stringNoteByModeAndNumber:1 only:6] forState:UIControlStateNormal];
    [btnSupertonic7 setTitle:[self stringNoteByModeAndNumber:1 only:7] forState:UIControlStateNormal];
    
    [btnMediant setTitle:[self stringChordByModeAndNumber:2] forState:UIControlStateNormal];
    [btnMediant0 setTitle:[self stringNoteByModeAndNumber:2 only:0] forState:UIControlStateNormal];
    [btnMediant3 setTitle:[self stringNoteByModeAndNumber:2 only:3] forState:UIControlStateNormal];
    [btnMediant5 setTitle:[self stringNoteByModeAndNumber:2 only:5] forState:UIControlStateNormal];
    [btnMediant6 setTitle:[self stringNoteByModeAndNumber:2 only:6] forState:UIControlStateNormal];
    [btnMediant7 setTitle:[self stringNoteByModeAndNumber:2 only:7] forState:UIControlStateNormal];
    
    [btnSubdominant setTitle:[self stringChordByModeAndNumber:3] forState:UIControlStateNormal];
    [btnSubdominant0 setTitle:[self stringNoteByModeAndNumber:3 only:0] forState:UIControlStateNormal];
    [btnSubdominant3 setTitle:[self stringNoteByModeAndNumber:3 only:3] forState:UIControlStateNormal];
    [btnSubdominant5 setTitle:[self stringNoteByModeAndNumber:3 only:5] forState:UIControlStateNormal];
    [btnSubdominant6 setTitle:[self stringNoteByModeAndNumber:3 only:6] forState:UIControlStateNormal];
    [btnSubdominant7 setTitle:[self stringNoteByModeAndNumber:3 only:7] forState:UIControlStateNormal];
    
    [btnDominant setTitle:[self stringChordByModeAndNumber:4] forState:UIControlStateNormal];
    [btnDominant0 setTitle:[self stringNoteByModeAndNumber:4 only:0] forState:UIControlStateNormal];
    [btnDominant3 setTitle:[self stringNoteByModeAndNumber:4 only:3] forState:UIControlStateNormal];
    [btnDominant5 setTitle:[self stringNoteByModeAndNumber:4 only:5] forState:UIControlStateNormal];
    [btnDominant6 setTitle:[self stringNoteByModeAndNumber:4 only:6] forState:UIControlStateNormal];
    [btnDominant7 setTitle:[self stringNoteByModeAndNumber:4 only:7] forState:UIControlStateNormal];
    
    [btnSubmediant setTitle:[self stringChordByModeAndNumber:5] forState:UIControlStateNormal];
    [btnSubmediant0 setTitle:[self stringNoteByModeAndNumber:5 only:0] forState:UIControlStateNormal];
    [btnSubmediant3 setTitle:[self stringNoteByModeAndNumber:5 only:3] forState:UIControlStateNormal];
    [btnSubmediant5 setTitle:[self stringNoteByModeAndNumber:5 only:5] forState:UIControlStateNormal];
    [btnSubmediant6 setTitle:[self stringNoteByModeAndNumber:5 only:6] forState:UIControlStateNormal];
    [btnSubmediant7 setTitle:[self stringNoteByModeAndNumber:5 only:7] forState:UIControlStateNormal];
    
    [btnSubtonic setTitle:[self stringChordByModeAndNumber:6] forState:UIControlStateNormal];
    [btnSubtonic0 setTitle:[self stringNoteByModeAndNumber:6 only:0] forState:UIControlStateNormal];
    [btnSubtonic3 setTitle:[self stringNoteByModeAndNumber:6 only:3] forState:UIControlStateNormal];
    [btnSubtonic5 setTitle:[self stringNoteByModeAndNumber:6 only:5] forState:UIControlStateNormal];
    [btnSubtonic6 setTitle:[self stringNoteByModeAndNumber:6 only:6] forState:UIControlStateNormal];
    [btnSubtonic7 setTitle:[self stringNoteByModeAndNumber:6 only:7] forState:UIControlStateNormal];
    
    [btnTonic8 setTitle:[self stringChordByModeAndNumber:7] forState:UIControlStateNormal];
    [btnTonic80 setTitle:[self stringNoteByModeAndNumber:7 only:0] forState:UIControlStateNormal];
    [btnTonic83 setTitle:[self stringNoteByModeAndNumber:7 only:3] forState:UIControlStateNormal];
    [btnTonic85 setTitle:[self stringNoteByModeAndNumber:7 only:5] forState:UIControlStateNormal];
    [btnTonic86 setTitle:[self stringNoteByModeAndNumber:7 only:6] forState:UIControlStateNormal];
    [btnTonic87 setTitle:[self stringNoteByModeAndNumber:7 only:7] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    [btnTonic addTarget:self action:@selector(btnTonicPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic0 addTarget:self action:@selector(btnTonic0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic3 addTarget:self action:@selector(btnTonic3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic5 addTarget:self action:@selector(btnTonic5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic6 addTarget:self action:@selector(btnTonic6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic7 addTarget:self action:@selector(btnTonic7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnSupertonic addTarget:self action:@selector(btnSupertonicPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSupertonic0 addTarget:self action:@selector(btnSupertonic0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSupertonic3 addTarget:self action:@selector(btnSupertonic3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSupertonic5 addTarget:self action:@selector(btnSupertonic5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSupertonic6 addTarget:self action:@selector(btnSupertonic6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSupertonic7 addTarget:self action:@selector(btnSupertonic7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnMediant addTarget:self action:@selector(btnMediantPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnMediant0 addTarget:self action:@selector(btnMediant0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnMediant3 addTarget:self action:@selector(btnMediant3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnMediant5 addTarget:self action:@selector(btnMediant5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnMediant6 addTarget:self action:@selector(btnMediant6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnMediant7 addTarget:self action:@selector(btnMediant7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnSubdominant addTarget:self action:@selector(btnSubdominantPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubdominant0 addTarget:self action:@selector(btnSubdominant0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubdominant3 addTarget:self action:@selector(btnSubdominant3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubdominant5 addTarget:self action:@selector(btnSubdominant5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubdominant6 addTarget:self action:@selector(btnSubdominant6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubdominant7 addTarget:self action:@selector(btnSubdominant7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnDominant addTarget:self action:@selector(btnDominantPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnDominant0 addTarget:self action:@selector(btnDominant0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnDominant3 addTarget:self action:@selector(btnDominant3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnDominant5 addTarget:self action:@selector(btnDominant5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnDominant6 addTarget:self action:@selector(btnDominant6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnDominant7 addTarget:self action:@selector(btnDominant7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnSubmediant addTarget:self action:@selector(btnSubmediantPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubmediant0 addTarget:self action:@selector(btnSubmediant0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubmediant3 addTarget:self action:@selector(btnSubmediant3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubmediant5 addTarget:self action:@selector(btnSubmediant5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubmediant6 addTarget:self action:@selector(btnSubmediant6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubmediant7 addTarget:self action:@selector(btnSubmediant7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnSubtonic addTarget:self action:@selector(btnSubtonicPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubtonic0 addTarget:self action:@selector(btnSubtonic0Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubtonic3 addTarget:self action:@selector(btnSubtonic3Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubtonic5 addTarget:self action:@selector(btnSubtonic5Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubtonic6 addTarget:self action:@selector(btnSubtonic6Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnSubtonic7 addTarget:self action:@selector(btnSubtonic7Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [btnTonic8 addTarget:self action:@selector(btnTonic8Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic80 addTarget:self action:@selector(btnTonic80Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic83 addTarget:self action:@selector(btnTonic83Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic85 addTarget:self action:@selector(btnTonic85Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic86 addTarget:self action:@selector(btnTonic86Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [btnTonic87 addTarget:self action:@selector(btnTonic87Pressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [self decideIfSharpOrFlat];
    [self updateKey];
    
    buttonPositions = [[NSArray alloc] initWithObjects:btnTonic, btnSupertonic, btnMediant, btnSubdominant, btnDominant, btnSubmediant, btnSubtonic, nil];
}

-(void)viewWillAppear:(BOOL)animated {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.5f;
    anim.repeatCount = 1e100f;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [select.layer addAnimation:anim forKey:nil];
    [selectHighlight.layer addAnimation:anim forKey:nil];
}

- (void)animateButton:(UIButton*)thisButton {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.19;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)];
    [thisButton.layer addAnimation:anim forKey:nil];
}

- (IBAction)btnTonicPressed:(id)sender { [self playChordByModeAndNumber:0]; [self animateButton:btnTonic]; }
- (IBAction)btnTonic0Pressed:(id)sender { [self playNoteByModeAndNumber:0 only:0]; [self animateButton:btnTonic0]; }
- (IBAction)btnTonic3Pressed:(id)sender { [self playNoteByModeAndNumber:0 only:3]; [self animateButton:btnTonic3]; }
- (IBAction)btnTonic5Pressed:(id)sender { [self playNoteByModeAndNumber:0 only:5]; [self animateButton:btnTonic5]; }
- (IBAction)btnTonic6Pressed:(id)sender { [self playNoteByModeAndNumber:0 only:6]; [self animateButton:btnTonic6]; }
- (IBAction)btnTonic7Pressed:(id)sender { [self playNoteByModeAndNumber:0 only:7]; [self animateButton:btnTonic7]; }

- (IBAction)btnSupertonicPressed:(id)sender { [self playChordByModeAndNumber:1]; [self animateButton:btnSupertonic]; }
- (IBAction)btnSupertonic0Pressed:(id)sender { [self playNoteByModeAndNumber:1 only:0]; [self animateButton:btnSupertonic0]; }
- (IBAction)btnSupertonic3Pressed:(id)sender { [self playNoteByModeAndNumber:1 only:3]; [self animateButton:btnSupertonic3]; }
- (IBAction)btnSupertonic5Pressed:(id)sender { [self playNoteByModeAndNumber:1 only:5]; [self animateButton:btnSupertonic5]; }
- (IBAction)btnSupertonic6Pressed:(id)sender { [self playNoteByModeAndNumber:1 only:6]; [self animateButton:btnSupertonic6]; }
- (IBAction)btnSupertonic7Pressed:(id)sender { [self playNoteByModeAndNumber:1 only:7]; [self animateButton:btnSupertonic7]; }

- (IBAction)btnMediantPressed:(id)sender { [self playChordByModeAndNumber:2]; [self animateButton:btnMediant]; }
- (IBAction)btnMediant0Pressed:(id)sender { [self playNoteByModeAndNumber:2 only:0]; [self animateButton:btnMediant0]; }
- (IBAction)btnMediant3Pressed:(id)sender { [self playNoteByModeAndNumber:2 only:3]; [self animateButton:btnMediant3]; }
- (IBAction)btnMediant5Pressed:(id)sender { [self playNoteByModeAndNumber:2 only:5]; [self animateButton:btnMediant5]; }
- (IBAction)btnMediant6Pressed:(id)sender { [self playNoteByModeAndNumber:2 only:6]; [self animateButton:btnMediant6]; }
- (IBAction)btnMediant7Pressed:(id)sender { [self playNoteByModeAndNumber:2 only:7]; [self animateButton:btnMediant7]; }

- (IBAction)btnSubdominantPressed:(id)sender { [self playChordByModeAndNumber:3]; [self animateButton:btnSubdominant]; }
- (IBAction)btnSubdominant0Pressed:(id)sender { [self playNoteByModeAndNumber:3 only:0]; [self animateButton:btnSubdominant0]; }
- (IBAction)btnSubdominant3Pressed:(id)sender { [self playNoteByModeAndNumber:3 only:3]; [self animateButton:btnSubdominant3]; }
- (IBAction)btnSubdominant5Pressed:(id)sender { [self playNoteByModeAndNumber:3 only:5]; [self animateButton:btnSubdominant5]; }
- (IBAction)btnSubdominant6Pressed:(id)sender { [self playNoteByModeAndNumber:3 only:6]; [self animateButton:btnSubdominant6]; }
- (IBAction)btnSubdominant7Pressed:(id)sender { [self playNoteByModeAndNumber:3 only:7]; [self animateButton:btnSubdominant7]; }

- (IBAction)btnDominantPressed:(id)sender { [self playChordByModeAndNumber:4]; [self animateButton:btnDominant]; }
- (IBAction)btnDominant0Pressed:(id)sender { [self playNoteByModeAndNumber:4 only:0]; [self animateButton:btnDominant0]; }
- (IBAction)btnDominant3Pressed:(id)sender { [self playNoteByModeAndNumber:4 only:3]; [self animateButton:btnDominant3]; }
- (IBAction)btnDominant5Pressed:(id)sender { [self playNoteByModeAndNumber:4 only:5]; [self animateButton:btnDominant5]; }
- (IBAction)btnDominant6Pressed:(id)sender { [self playNoteByModeAndNumber:4 only:6]; [self animateButton:btnDominant6]; }
- (IBAction)btnDominant7Pressed:(id)sender { [self playNoteByModeAndNumber:4 only:7]; [self animateButton:btnDominant7]; }

- (IBAction)btnSubmediantPressed:(id)sender { [self playChordByModeAndNumber:5]; [self animateButton:btnSubmediant]; }
- (IBAction)btnSubmediant0Pressed:(id)sender { [self playNoteByModeAndNumber:5 only:0]; [self animateButton:btnSubmediant0]; }
- (IBAction)btnSubmediant3Pressed:(id)sender { [self playNoteByModeAndNumber:5 only:3]; [self animateButton:btnSubmediant3]; }
- (IBAction)btnSubmediant5Pressed:(id)sender { [self playNoteByModeAndNumber:5 only:5]; [self animateButton:btnSubmediant5]; }
- (IBAction)btnSubmediant6Pressed:(id)sender { [self playNoteByModeAndNumber:5 only:6]; [self animateButton:btnSubmediant6]; }
- (IBAction)btnSubmediant7Pressed:(id)sender { [self playNoteByModeAndNumber:5 only:7]; [self animateButton:btnSubmediant7]; }

- (IBAction)btnSubtonicPressed:(id)sender  { [self playChordByModeAndNumber:6]; [self animateButton:btnSubtonic]; }
- (IBAction)btnSubtonic0Pressed:(id)sender { [self playNoteByModeAndNumber:6 only:0]; [self animateButton:btnSubtonic0]; }
- (IBAction)btnSubtonic3Pressed:(id)sender { [self playNoteByModeAndNumber:6 only:3]; [self animateButton:btnSubtonic3]; }
- (IBAction)btnSubtonic5Pressed:(id)sender { [self playNoteByModeAndNumber:6 only:5]; [self animateButton:btnSubtonic5]; }
- (IBAction)btnSubtonic6Pressed:(id)sender { [self playNoteByModeAndNumber:6 only:6]; [self animateButton:btnSubtonic6]; }
- (IBAction)btnSubtonic7Pressed:(id)sender { [self playNoteByModeAndNumber:6 only:7]; [self animateButton:btnSubtonic7]; }

- (IBAction)btnTonic8Pressed:(id)sender { [self playChordByModeAndNumber:7]; [self animateButton:btnTonic8]; }
- (IBAction)btnTonic80Pressed:(id)sender { [self playNoteByModeAndNumber:7 only:0]; [self animateButton:btnTonic80]; }
- (IBAction)btnTonic83Pressed:(id)sender { [self playNoteByModeAndNumber:7 only:3]; [self animateButton:btnTonic83]; }
- (IBAction)btnTonic85Pressed:(id)sender { [self playNoteByModeAndNumber:7 only:5]; [self animateButton:btnTonic85]; }
- (IBAction)btnTonic86Pressed:(id)sender { [self playNoteByModeAndNumber:7 only:6]; [self animateButton:btnTonic86]; }
- (IBAction)btnTonic87Pressed:(id)sender { [self playNoteByModeAndNumber:7 only:7]; [self animateButton:btnTonic87]; }

- (NSMutableString*)stringChordByModeAndNumber:(int)number {
    int thisMode = [[modesInRelationToBasicKey objectAtIndex:number] intValue];
    int thisNodeOffset = [[chordsInRelationToBasicKey objectAtIndex:number] intValue];
    
    NSMutableString *chordName = [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset) % 12) ]];
    
    if ( thisMode == 0 ) { // major
            // nothing to add here
    } else if ( thisMode == 1 ) { // minor
        [chordName appendString:@"m"];
    } else if ( thisMode == 2 ) { // diminished
        [chordName appendString:@"o"];
    } else if ( thisMode == 3 ) { // augmented
        [chordName appendString:@"+"];
    }
    
    return chordName;
}


- (NSMutableString*)stringNoteByModeAndNumber:(int)number only:(int)onlyNote {
    int thisMode = [[modesInRelationToBasicKey objectAtIndex:number] intValue];
    int thisNodeOffset = [[chordsInRelationToBasicKey objectAtIndex:number] intValue];
    
    if (onlyNote == 0) {
        return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset) % 12) ]];
    }
    
    if (onlyNote == 6) {
        return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+9) % 12) ]];
    } 
    
    if (onlyNote == 7) {
        if (thisMode == 1) { // minor
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+10) % 12) ]];
        } else { // major and others
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+11) % 12) ]];
        }
    }
    
    if ( onlyNote == 3 ) {
        if ( thisMode == 0 ) { // major
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+4) % 12) ]];
        } else if ( thisMode == 1 ) { // minor
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+3) % 12) ]];
        } else if ( thisMode == 2 ) {
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+3) % 12) ]];
        } else if ( thisMode == 3 ) {
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+4) % 12) ]];
        }
    }
    
    if ( onlyNote == 5 ) {
        if ( thisMode == 0 ) {
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+7) % 12) ]];
        } else if ( thisMode == 1 ) {
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+7) % 12) ]];
        } else if ( thisMode == 2 ) {
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+6) % 12) ]];
        } else if ( thisMode == 3 ) {
            return [NSMutableString stringWithString:[notes objectAtIndex:( (root+thisNodeOffset+8) % 12) ]];
        }
    }
    
    return [NSMutableString stringWithString:@""];
}

- (void)playChordByModeAndNumber:(int)number {
    int thisMode = [[modesInRelationToBasicKey objectAtIndex:number] intValue];
    int thisNodeOffset = [[chordsInRelationToBasicKey objectAtIndex:number] intValue];
    
    delegate.lastPlayedChord = number;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didPlayNote" 
                                                        object: nil 
                                                      userInfo: nil];
    
    int rootWithOctave = root + (12*octave);
    
    if ( thisMode == 0 ) {
        [self playMajorChord:rootWithOctave+thisNodeOffset];
    } else if ( thisMode == 1 ) {
        [self playMinorChord:rootWithOctave+thisNodeOffset];
    } else if ( thisMode == 2 ) {
        [self playDiminishedChord:rootWithOctave+thisNodeOffset];
    } else if ( thisMode == 3 ) {
        [self playAugmentedChord:rootWithOctave+thisNodeOffset];
    }
}

- (void)playNoteByModeAndNumber:(int)number only:(int)onlyNote {
    int thisMode = [[modesInRelationToBasicKey objectAtIndex:number] intValue];
    int thisNodeOffset = [[chordsInRelationToBasicKey objectAtIndex:number] intValue];

    delegate.lastPlayedChord = number;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didPlayNote" 
                                                        object: nil 
                                                      userInfo: nil];
    
    int rootWithOctave = root + (12*octave);
    
    if (onlyNote == 0) {
        [self playSingleNote:rootWithOctave+thisNodeOffset];
    }
        
    if (onlyNote == 6) {
        [self playSingleNote:rootWithOctave+thisNodeOffset+9];
    } 
    
    if (onlyNote == 7) {
        if (thisMode == 1) { // minor
            [self playSingleNote:rootWithOctave+thisNodeOffset+10];
        } else { // major and others
            [self playSingleNote:rootWithOctave+thisNodeOffset+11];
        }
    }
    
    if ( onlyNote == 3 ) {
        if ( thisMode == 0 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+4];
        } else if ( thisMode == 1 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+3];
        } else if ( thisMode == 2 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+3];
        } else if ( thisMode == 3 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+4];
        }
    }
    
    if ( onlyNote == 5 ) {
        if ( thisMode == 0 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+7];
        } else if ( thisMode == 1 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+7];
        } else if ( thisMode == 2 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+6];
        } else if ( thisMode == 3 ) {
            [self playSingleNote:rootWithOctave+thisNodeOffset+8];
        }
    }
}

- (void) playSingleNote:(int)thisNote {
    [player queueNote:thisNote gain:gain]; 
    [player playQueuedNotes];
}

- (IBAction)playMajorChord:(int)keynote {
    if (arpeggio) {
        NSMutableArray* notesToBePlayed = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:keynote   ],
                          [NSNumber numberWithInt:keynote+4 ],
                          [NSNumber numberWithInt:keynote+7],
                          nil];
        
        [self playArpeggioWithNotes:notesToBePlayed delay:0.05];
    } else {
        [player queueNote:keynote   gain:gain];
        [player queueNote:keynote+4 gain:gain];
        [player queueNote:keynote+7 gain:gain];
        
        [player playQueuedNotes];
    }
}

- (IBAction)playMinorChord:(int)keynote {
    if (arpeggio) {
        NSMutableArray* notesToBePlayed = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:keynote   ],
                          [NSNumber numberWithInt:keynote+3 ],
                          [NSNumber numberWithInt:keynote+7],
                          nil];
        
        [self playArpeggioWithNotes:notesToBePlayed delay:0.05];
    } else {
        [player queueNote:keynote    gain:gain];
        [player queueNote:keynote+3  gain:gain];
        [player queueNote:keynote+7 gain:gain];
        
        [player playQueuedNotes];
    }
}

- (IBAction)playDiminishedChord:(int)keynote {
    if (arpeggio) {
        NSMutableArray* notesToBePlayed = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:keynote   ],
                          [NSNumber numberWithInt:keynote+3 ],
                          [NSNumber numberWithInt:keynote+6],
                          nil];
        
        [self playArpeggioWithNotes:notesToBePlayed delay:0.05];
    } else {
        [player queueNote:keynote    gain:gain];
        [player queueNote:keynote+3  gain:gain];
        [player queueNote:keynote+6 gain:gain];
        
        [player playQueuedNotes];
    }
}

- (IBAction)playAugmentedChord:(int)keynote {
    if (arpeggio) {
        NSMutableArray* notesToBePlayed = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:keynote   ],
                          [NSNumber numberWithInt:keynote+4 ],
                          [NSNumber numberWithInt:keynote+8],
                          nil];
        
        [self playArpeggioWithNotes:notesToBePlayed delay:0.05];
    } else {
        [player queueNote:keynote    gain:gain];
        [player queueNote:keynote+4  gain:gain];
        [player queueNote:keynote+8 gain:gain];
        
        [player playQueuedNotes];
    }
}


- (void)playArpeggioWithNotes:(NSArray*)notesToBePlayed delay:(double)delay
{
	if (!playingArpeggio)
	{
		playingArpeggio = YES;
		arpeggioNotes = [notesToBePlayed retain];
		arpeggioIndex = 0;
		arpeggioDelay = delay;
		arpeggioStartTime = CACurrentMediaTime();
	}
}

- (void)startTimer
{
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.05  // 50 ms
											 target: self
										   selector: @selector(handleTimer:)
										   userInfo: nil
											repeats: YES];
}

- (void)stopTimer
{
	if (timer != nil && [timer isValid])
	{
		[timer invalidate];
		timer = nil;
	}
}

- (void)handleTimer:(NSTimer*)timer
{
	if (playingArpeggio)
	{
		// Play each note of the arpeggio after "arpeggioDelay" seconds.
		double now = CACurrentMediaTime();
		if (now - arpeggioStartTime >= arpeggioDelay)
		{
			NSNumber* number = (NSNumber*)[arpeggioNotes objectAtIndex:arpeggioIndex];
			[player noteOn:[number intValue] gain:gain];
            
			++arpeggioIndex;
			if (arpeggioIndex == [arpeggioNotes count])
			{
				playingArpeggio = NO;
				[arpeggioNotes release];
				arpeggioNotes = nil;
			}
			else  // schedule next note
			{
				arpeggioStartTime = now;
			}
		}
	}
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

- (IBAction)octaveChanged:(UIStepper *)sender {
    octave = ((int)[sender value]);
    
    NSLog(@"%i", octave);
    
    [octaveLabel setText:[NSString stringWithFormat:@"Octave: %i", octave-4] ];
}


@end
