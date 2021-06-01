#import "Tweak.h"


@implementation BluetoothNoClicks

+ (instancetype)sharedManager {
    static BluetoothNoClicks *sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.audioSession = [%c(AVAudioSession) primarySession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayKeyboardSound) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

- (void)changePlayKeyboardSound {
    AVAudioSessionRouteDescription *routeDescription = [self.audioSession currentRoute];
    if (routeDescription) {
        NSArray *outputs = [routeDescription outputs];
        if ([outputs count] > 0) {
            AVAudioSessionPortDescription *port = (AVAudioSessionPortDescription *)outputs[0];
            if ([[port UID] isEqualToString:@"Speaker"]) {
                [self changePlayKeyboardSound:1];
            } else {
                [self changePlayKeyboardSound:0];
            }
        }
    }
}

- (void)changePlayKeyboardSound:(int)integer {
    SHSSoundsPrefController *controller = [[%c(SHSSoundsPrefController) alloc] init];
    if (controller) {
        for (PSSpecifier *specifier in [controller specifiers]) {
            if ([specifier.identifier isEqualToString:@"KEYBOARD_SOUND_SWITCH"]) {
                [controller setPlayKeyboardSound:@(integer) specifier:specifier];
                break;
            }
        }
    }
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.apple.preferences.sounds.changed"), NULL, NULL, YES);
}
@end

%ctor {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Settings/SoundsAndHapticsSettings.framework"];
    if (!bundle.loaded) [bundle load];
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)checkOutput, CFSTR("AXSpringBoardUserChangedAudioRouteNotification"), NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    %init;
    [BluetoothNoClicks sharedManager];
}


// AXSpringBoardUserChangedAudioRouteNotification
// com.apple.coreaudio.AudioComponentLocalRegistrationsChanged
// PickableRoutesDidChange
// currentRouteChanged
// routeConfigUpdated
// Discoverer_AvailableRoutesChanged
// SBSpringBoardDidLaunchNotification




// BluetoothDeviceConnectSuccessNotification
// BluetoothConnectionStatusChangedNotification
// AVSystemController_PreferredExternalRouteDidChangeNotification
// MPAVRoutingDataSourceRoutesDidChangeNotification


// AVOutputDeviceDiscoverySessionAvailableOutputDevicesDidChangeNotification
