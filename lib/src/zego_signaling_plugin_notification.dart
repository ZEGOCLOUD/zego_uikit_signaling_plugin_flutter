part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginNotificationAPIImpl
    implements ZegoSignalingPluginNotificationAPI {
  @override
  Future<ZegoSignalingPluginEnableNotifyResult>
      enableNotifyWhenAppRunningInBackgroundOrQuit({
    bool isIOSSandboxEnvironment = false,
  }) async {
    if (kIsWeb || ((!Platform.isAndroid) && (!Platform.isIOS))) {
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
              : ZPNsIOSEnvironment.Production);
      debugPrint('register push done');
      return const ZegoSignalingPluginEnableNotifyResult();
    } catch (e) {
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
    return ZegoSignalingPluginEventCenter().notificationArrivedEvent.stream;
  }

  @override
  Stream<ZegoSignalingPluginNotificationClickedEvent>
      getNotificationClickedEventStream() {
    return ZegoSignalingPluginEventCenter().notificationClickedEvent.stream;
  }

  @override
  Stream<ZegoSignalingPluginNotificationRegisteredEvent>
      getNotificationRegisteredEventStream() {
    return ZegoSignalingPluginEventCenter().notificationRegisteredEvent.stream;
  }
}
