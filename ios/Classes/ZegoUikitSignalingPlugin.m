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
  if ([@"configureAudioSession" isEqualToString:call.method]) {
    [self configureAudioSession];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)configureAudioSession {
    NSLog(@"configureAudioSession");
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"configureAudioSession error: %@", error.localizedDescription);
    }

    error = nil;
    [audioSession setMode:AVAudioSessionModeVoiceChat error:&error];
    if (error) {
        NSLog(@"configureAudioSession error: %@", error.localizedDescription);
    }

    error = nil;
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        NSLog(@"configureAudioSession error: %@", error.localizedDescription);
    }
}

@end
