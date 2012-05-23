#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    int note, mode, name, metronomeBPM;
    float gain, metronomeGain;
    bool metronomeSound, metronomeVisual, showName, isSharp;
    
    NSArray *notesSharp, *notesFlat;
    NSArray *sharedNoteNames, *sharedNoteRoots, *sharedModeNames, *sharedTemplates;    
    int selectedTemplate;
    
    int lastPlayedChord, nextChord;
    
    NSString *modulateKey, *currentNoteAndMode;
}

@property (strong, nonatomic) UIWindow *window;

@property (readwrite,assign) int note, mode, name, metronomeBPM, selectedTemplate;
@property (readwrite,assign) float gain, metronomeGain;
@property (readwrite,assign) bool metronomeSound, metronomeVisual, showName, isSharp;

@property (readwrite, assign) NSString *modulateKey, *currentNoteAndMode;

@property (retain, nonatomic) NSArray *sharedNoteNames, *sharedNoteRoots, *sharedModeNames, *sharedTemplates;
@property (retain, nonatomic) NSArray *notesSharp, *notesFlat;

@property (readwrite,assign) int lastPlayedChord, nextChord;

@end