#import "ZegoUikitSignalingPlugin.h"

@implementation ZegoUikitSignalingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_uikit_signaling_plugin"
            binaryMessenger:[registrar messenger]];
  ZegoUikitSignalingPlugin* instance = [[ZegoUikitSignalingPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"activeAudioByCallKit" isEqualToString:call.method]) {
    [self activeAudioByCallKit];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)activeAudioByCallKit {
    NSLog(@"activeAudioByCallKit");
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"activeAudioByCallKit error: %@", error.localizedDescription);
    }

    error = nil;
    [audioSession setMode:AVAudioSessionModeVoiceChat error:&error];
    if (error) {
        NSLog(@"activeAudioByCallKit error: %@", error.localizedDescription);
    }

    error = nil;
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        NSLog(@"activeAudioByCallKit error: %@", error.localizedDescription);
    }
}

@end
