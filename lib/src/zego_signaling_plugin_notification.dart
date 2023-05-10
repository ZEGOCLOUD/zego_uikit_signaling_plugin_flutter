part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginNotificationAPIImpl
    implements ZegoSignalingPluginNotificationAPI {
  @override
  Future<ZegoSignalingPluginEnableNotifyResult>
      enableNotifyWhenAppRunningInBackgroundOrQuit({
    bool isIOSSandboxEnvironment = false,
    bool enableIOSVoIP = true,
    String appName = '',
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'enable Notify When App Running In Background Or Quit, '
      'is iOS Sandbox Environment:$isIOSSandboxEnvironment, '
      'enable iOS VoIP:$enableIOSVoIP, '
      'appName: $appName',
      tag: 'signaling',
      subTag: 'notification',
    );

    if ((!Platform.isAndroid) && (!Platform.isIOS)) {
      ZegoSignalingLoggerService.logInfo(
        'Only Support Android And iOS Platform.',
        tag: 'signaling',
        subTag: 'notification',
      );

      return ZegoSignalingPluginEnableNotifyResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android And iOS Platform.',
        ),
      );
    }

    try {
      if (Platform.isAndroid) {
        await ZPNs.setPushConfig(ZPNsConfig()..enableFCMPush = true);
      } else if (Platform.isIOS) {
        await ZPNs.getInstance().applyNotificationPermission();
      }

      await ZPNs.getInstance().registerPush(
        iOSEnvironment: isIOSSandboxEnvironment
            ? ZPNsIOSEnvironment.Development
            : ZPNsIOSEnvironment.Production,
        enableIOSVoIP: enableIOSVoIP,
      );
      ZegoSignalingLoggerService.logInfo(
        'register push done',
        tag: 'signaling',
        subTag: 'notification',
      );
      return const ZegoSignalingPluginEnableNotifyResult();
    } catch (e) {
      ZegoSignalingLoggerService.logInfo(
        'register push, error:${e.toString()}',
        tag: 'signaling',
        subTag: 'notification',
      );

      if (e is PlatformException) {
        return ZegoSignalingPluginEnableNotifyResult(
          error: PlatformException(
            code: e.code,
            message: e.message,
          ),
        );
      } else {
        return ZegoSignalingPluginEnableNotifyResult(
          error: PlatformException(
            code: '-2',
            message: e.toString(),
          ),
        );
      }
    }
  }
}

class ZegoSignalingPluginNotificationEventImpl
    implements ZegoSignalingPluginNotificationEvent {
  @override
  Stream<ZegoSignalingPluginNotificationArrivedEvent>
      getNotificationArrivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .notificationArrivedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginNotificationClickedEvent>
      getNotificationClickedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .notificationClickedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginNotificationRegisteredEvent>
      getNotificationRegisteredEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .notificationRegisteredEvent
        .stream;
  }
}
