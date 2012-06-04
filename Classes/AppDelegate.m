#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize note, mode, name, gain, metronomeGain, metronomeBPM, metronomeSound, metronomeVisual;
@synthesize selectedTemplate, sharedTemplates, sharedModeNames, sharedNoteNames, sharedNoteRoots, showName;
@synthesize lastPlayedChord, nextChord, modulateKey;
@synthesize notesSharp, notesFlat, currentNoteAndMode, isSharp;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    note = 0;
    mode = 0;
    name = 0;

    metronomeBPM = 120;
    
    gain = 0.9f;
    metronomeGain = 0.9f;
            
    metronomeSound = false;
    metronomeVisual = false;
    
    selectedTemplate = 0;
    
    showName = true;
         
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Templates" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];    
    sharedTemplates = [[NSArray alloc] initWithArray:[dict allKeys]];    
    
    //NSLog(@"%i", [sharedTemplates count]);
    
    /*
    sharedNoteNames = [[NSArray alloc] 
                 initWithObjects: @"C", @"C#", @"D", @"D#", @"E", 
                 @"F", @"F#", @"G", @"G#", @"A", @"Bb", @"B", nil];
    */
    
    isSharp = true;
     
    notesSharp = [[NSArray alloc] 
                  initWithObjects:@"C", @"C#", @"D", @"D#", @"E", 
                  @"F", @"F#", @"G", @"G#",
                  @"A", @"A#", @"B", nil];
    
    notesFlat = [[NSArray alloc] 
                 initWithObjects:@"C", @"Db", @"D", @"Eb", @"E", 
                 @"F", @"Gb", @"G", @"Ab",
                 @"A", @"Bb", @"B", nil];
    
    sharedNoteNames = [[NSArray alloc] 
                       initWithObjects:@"C", @"C#", @"Db", @"D", @"D#", @"Eb", @"E", 
                       @"F", @"F#", @"Gb", @"G", @"G#",
                       @"Ab", @"A", @"A#", @"Bb", @"B", nil];
    
    sharedNoteRoots = [[NSArray alloc] 
                       initWithObjects:
                       [NSNumber numberWithInt:0], 
                       [NSNumber numberWithInt:1], 
                       [NSNumber numberWithInt:1], 
                       [NSNumber numberWithInt:2], 
                       [NSNumber numberWithInt:3], 
                       [NSNumber numberWithInt:3], 
                       [NSNumber numberWithInt:4], 
                       [NSNumber numberWithInt:5], 
                       [NSNumber numberWithInt:6], 
                       [NSNumber numberWithInt:6], 
                       [NSNumber numberWithInt:7], 
                       [NSNumber numberWithInt:8], 
                       [NSNumber numberWithInt:8], 
                       [NSNumber numberWithInt:9], 
                       [NSNumber numberWithInt:10], 
                       [NSNumber numberWithInt:10], 
                       [NSNumber numberWithInt:11], 
                       nil];
    
    sharedModeNames = [[NSArray alloc] 
             initWithObjects:@"Major", @"Minor", @"Minor harmonic", @"Minor melodic", nil];
    
    currentNoteAndMode = @"C";
    
    lastPlayedChord = -1;
    nextChord -= 1;
    
    return true;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

@end