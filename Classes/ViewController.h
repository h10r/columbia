//
//  ViewController.h
//  Thesis
//
//  Created by Hendrik Heuer on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundBankPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController  {
    AppDelegate *delegate;
    
    SystemSoundID metronomeSoundID;
    
    IBOutlet UIView *backgroundLines;
    
    IBOutlet UIImageView *select;
    IBOutlet UIImageView *selectHighlight;
    
    IBOutlet UIButton *metronomeButton;
    
    IBOutlet UILabel *octaveLabel;
    IBOutlet UIStepper *octaveStepper;
    
    IBOutlet UIButton *btnTonic;
    IBOutlet UIButton *btnTonic0;
    IBOutlet UIButton *btnTonic3;
    IBOutlet UIButton *btnTonic5;
    IBOutlet UIButton *btnTonic6;
    IBOutlet UIButton *btnTonic7;
    
    IBOutlet UIButton *btnSupertonic;
    IBOutlet UIButton *btnSupertonic0;
    IBOutlet UIButton *btnSupertonic3;
    IBOutlet UIButton *btnSupertonic5;
    IBOutlet UIButton *btnSupertonic6;
    IBOutlet UIButton *btnSupertonic7;
    
    IBOutlet UIButton *btnMediant;
    IBOutlet UIButton *btnMediant0;
    IBOutlet UIButton *btnMediant3;
    IBOutlet UIButton *btnMediant5;
    IBOutlet UIButton *btnMediant6;
    IBOutlet UIButton *btnMediant7;
    
    IBOutlet UIButton *btnSubdominant;
    IBOutlet UIButton *btnSubdominant0;
    IBOutlet UIButton *btnSubdominant3;
    IBOutlet UIButton *btnSubdominant5;
    IBOutlet UIButton *btnSubdominant6;
    IBOutlet UIButton *btnSubdominant7;
    
    IBOutlet UIButton *btnDominant;
    IBOutlet UIButton *btnDominant0;
    IBOutlet UIButton *btnDominant3;
    IBOutlet UIButton *btnDominant5;
    IBOutlet UIButton *btnDominant6;
    IBOutlet UIButton *btnDominant7;
    
    IBOutlet UIButton *btnSubmediant;
    IBOutlet UIButton *btnSubmediant0;
    IBOutlet UIButton *btnSubmediant3;
    IBOutlet UIButton *btnSubmediant5;
    IBOutlet UIButton *btnSubmediant6;
    IBOutlet UIButton *btnSubmediant7;
    
    IBOutlet UIButton *btnSubtonic;
    IBOutlet UIButton *btnSubtonic0;
    IBOutlet UIButton *btnSubtonic3;
    IBOutlet UIButton *btnSubtonic5;
    IBOutlet UIButton *btnSubtonic6;
    IBOutlet UIButton *btnSubtonic7;
    
    IBOutlet UIButton *btnTonic8;
    IBOutlet UIButton *btnTonic80;
    IBOutlet UIButton *btnTonic83;
    IBOutlet UIButton *btnTonic85;
    IBOutlet UIButton *btnTonic86;
    IBOutlet UIButton *btnTonic87;
    
    SoundBankPlayer* player;
    
    AVAudioPlayer *singleSoundPlayer;
    
	NSTimer *timer, *metronom;
    
    NSArray *notes;
    NSArray *notesSharp, *notesFlat;

    NSArray *modes, *modesInRelationToBasicKey, *chordsInRelationToBasicKey, *buttonPositions;
    
	BOOL playingArpeggio;
	NSArray *arpeggioNotes;
	int arpeggioIndex;
	double arpeggioStartTime;
	double arpeggioDelay;
    
    int currentMode;
    int root, octave;
    
    float gain, metronomeGain;
    
    bool arpeggio;
    
    int selectorAt;
}


@property (nonatomic, retain) AppDelegate *delegate;

@property (nonatomic, retain) NSArray *notes;
@property (retain, nonatomic) NSArray *notesSharp, *notesFlat;

@property (retain, nonatomic) NSArray *modes, *modesInRelationToBasicKey, *chordsInRelationToBasicKey, *buttonPositions;

@property (readwrite,assign) SystemSoundID metronomeSoundID;

@property (nonatomic, retain) AVAudioPlayer *singleSoundPlayer;

@property (nonatomic, retain) UIView *backgroundLines;

@property (nonatomic, retain) UIImageView *select;
@property (nonatomic, retain) UIImageView *selectHighlight;

@property (nonatomic, retain) UILabel *octaveLabel;
@property (nonatomic, retain) UIStepper *octaveStepper;

@property (nonatomic, retain) UIButton *metronomeButton;

@property (nonatomic, retain) UIButton *btnTonic;
@property (nonatomic, retain) UIButton *btnTonic0;
@property (nonatomic, retain) UIButton *btnTonic3;
@property (nonatomic, retain) UIButton *btnTonic5;
@property (nonatomic, retain) UIButton *btnTonic6;
@property (nonatomic, retain) UIButton *btnTonic7;

@property (nonatomic, retain) UIButton *btnSupertonic;
@property (nonatomic, retain) UIButton *btnSupertonic0;
@property (nonatomic, retain) UIButton *btnSupertonic3;
@property (nonatomic, retain) UIButton *btnSupertonic5;
@property (nonatomic, retain) UIButton *btnSupertonic6;
@property (nonatomic, retain) UIButton *btnSupertonic7;

@property (nonatomic, retain) UIButton *btnMediant;
@property (nonatomic, retain) UIButton *btnMediant0;
@property (nonatomic, retain) UIButton *btnMediant3;
@property (nonatomic, retain) UIButton *btnMediant5;
@property (nonatomic, retain) UIButton *btnMediant6;
@property (nonatomic, retain) UIButton *btnMediant7;

@property (nonatomic, retain) UIButton *btnSubdominant;
@property (nonatomic, retain) UIButton *btnSubdominant0;
@property (nonatomic, retain) UIButton *btnSubdominant3;
@property (nonatomic, retain) UIButton *btnSubdominant5;
@property (nonatomic, retain) UIButton *btnSubdominant6;
@property (nonatomic, retain) UIButton *btnSubdominant7;

@property (nonatomic, retain) UIButton *btnDominant;
@property (nonatomic, retain) UIButton *btnDominant0;
@property (nonatomic, retain) UIButton *btnDominant3;
@property (nonatomic, retain) UIButton *btnDominant5;
@property (nonatomic, retain) UIButton *btnDominant6;
@property (nonatomic, retain) UIButton *btnDominant7;

@property (nonatomic, retain) UIButton *btnSubmediant;
@property (nonatomic, retain) UIButton *btnSubmediant0;
@property (nonatomic, retain) UIButton *btnSubmediant3;
@property (nonatomic, retain) UIButton *btnSubmediant5;
@property (nonatomic, retain) UIButton *btnSubmediant6;
@property (nonatomic, retain) UIButton *btnSubmediant7;

@property (nonatomic, retain) UIButton *btnSubtonic;
@property (nonatomic, retain) UIButton *btnSubtonic0;
@property (nonatomic, retain) UIButton *btnSubtonic3;
@property (nonatomic, retain) UIButton *btnSubtonic5;
@property (nonatomic, retain) UIButton *btnSubtonic6;
@property (nonatomic, retain) UIButton *btnSubtonic7;

@property (nonatomic, retain) UIButton *btnTonic8;
@property (nonatomic, retain) UIButton *btnTonic80;
@property (nonatomic, retain) UIButton *btnTonic83;
@property (nonatomic, retain) UIButton *btnTonic85;
@property (nonatomic, retain) UIButton *btnTonic86;
@property (nonatomic, retain) UIButton *btnTonic87;

/*********************** Buttons for making sounds ********************************/

- (void)updateKey;

- (void)playChordByModeAndNumber:(int)number;
- (void)playNoteByModeAndNumber:(int)number only:(int)onlyNote;

- (NSMutableString*)stringChordByModeAndNumber:(int)number;
- (NSMutableString*)stringNoteByModeAndNumber:(int)number only:(int)onlyNote;

- (IBAction)playMajorChord:(int)keynote;
- (IBAction)playMinorChord:(int)keynote;
- (IBAction)playDiminishedChord:(int)keynote;
- (IBAction)playAugmentedChord:(int)keynote;

- (void)playArpeggioWithNotes:(NSArray*)notesToBePlayed delay:(double)delay;
- (void)startTimer;
- (void)stopTimer;

- (void)playMetronome:(NSTimer*)timer;

- (NSString*) currentKeyAsString;

/********************* Buttons for chords and notes ******************************/

- (IBAction)btnTonicPressed:(id)sender;
- (IBAction)btnTonic0Pressed:(id)sender;
- (IBAction)btnTonic3Pressed:(id)sender;
- (IBAction)btnTonic5Pressed:(id)sender;
- (IBAction)btnTonic6Pressed:(id)sender;
- (IBAction)btnTonic7Pressed:(id)sender;

- (IBAction)btnSupertonicPressed:(id)sender;
- (IBAction)btnSupertonic0Pressed:(id)sender;
- (IBAction)btnSupertonic3Pressed:(id)sender;
- (IBAction)btnSupertonic5Pressed:(id)sender;
- (IBAction)btnSupertonic6Pressed:(id)sender;
- (IBAction)btnSupertonic7Pressed:(id)sender;

- (IBAction)btnMediantPressed:(id)sender;
- (IBAction)btnMediant0Pressed:(id)sender;
- (IBAction)btnMediant3Pressed:(id)sender;
- (IBAction)btnMediant5Pressed:(id)sender;
- (IBAction)btnMediant6Pressed:(id)sender;
- (IBAction)btnMediant7Pressed:(id)sender;

- (IBAction)btnSubdominantPressed:(id)sender;
- (IBAction)btnSubdominant0Pressed:(id)sender;
- (IBAction)btnSubdominant3Pressed:(id)sender;
- (IBAction)btnSubdominant5Pressed:(id)sender;
- (IBAction)btnSubdominant6Pressed:(id)sender;
- (IBAction)btnSubdominant7Pressed:(id)sender;

- (IBAction)btnDominantPressed:(id)sender;
- (IBAction)btnDominant0Pressed:(id)sender;
- (IBAction)btnDominant3Pressed:(id)sender;
- (IBAction)btnDominant5Pressed:(id)sender;
- (IBAction)btnDominant6Pressed:(id)sender;
- (IBAction)btnDominant7Pressed:(id)sender;

- (IBAction)btnSubmediantPressed:(id)sender;
- (IBAction)btnSubmediant0Pressed:(id)sender;
- (IBAction)btnSubmediant3Pressed:(id)sender;
- (IBAction)btnSubmediant5Pressed:(id)sender;
- (IBAction)btnSubmediant6Pressed:(id)sender;
- (IBAction)btnSubmediant7Pressed:(id)sender;

- (IBAction)btnSubtonicPressed:(id)sender;
- (IBAction)btnSubtonic0Pressed:(id)sender;
- (IBAction)btnSubtonic3Pressed:(id)sender;
- (IBAction)btnSubtonic5Pressed:(id)sender;
- (IBAction)btnSubtonic6Pressed:(id)sender;
- (IBAction)btnSubtonic7Pressed:(id)sender;

- (IBAction)btnTonic8Pressed:(id)sender;
- (IBAction)btnTonic80Pressed:(id)sender;
- (IBAction)btnTonic83Pressed:(id)sender;
- (IBAction)btnTonic85Pressed:(id)sender;
- (IBAction)btnTonic86Pressed:(id)sender;
- (IBAction)btnTonic87Pressed:(id)sender;
 

@end
