#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <Preferences/PSSpecifier.h>
#import <AVFoundation/AVFoundation.h>


#pragma mark - Declarations
@interface AVAudioSession (BluetoothNoClicks)
+ (id)primarySession;
@end


@interface SHSSoundsPrefController
- (NSArray *)specifiers;
- (void)setPlayKeyboardSound:(id)arg1 specifier:(id)arg2;
@end


@interface BluetoothNoClicks : NSObject
@property AVAudioSession *audioSession;
+ (instancetype)sharedManager;
- (void)changePlayKeyboardSound;
- (void)changePlayKeyboardSound:(int)integer;
@end

