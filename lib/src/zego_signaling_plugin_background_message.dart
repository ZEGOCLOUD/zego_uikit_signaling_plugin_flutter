part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginBackgroundMessageAPIImpl
    implements ZegoSignalingPluginBackgroundMessageAPI {
  /// only for Android
  @override
  Future<ZegoSignalingPluginSetMessageHandlerResult>
      setBackgroundMessageHandler(
    ZegoSignalingPluginZPNsBackgroundMessageHandler handler,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'register background message handler',
      tag: 'signaling',
      subTag: 'background message',
    );

    if ((!kIsWeb) && (!io.Platform.isAndroid)) {
      ZegoSignalingLoggerService.logInfo(
        'Only Support Android Platform.',
        tag: 'signaling',
        subTag: 'background message',
      );

      return ZegoSignalingPluginSetMessageHandlerResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android Platform.',
        ),
      );
    }

    ZPNs.setBackgroundMessageHandler(handler);

    return const ZegoSignalingPluginSetMessageHandlerResult();
  }

  @override
  Future<ZegoSignalingPluginSetMessageHandlerResult> setThroughMessageHandler(
    ZegoSignalingPluginZPNsThroughMessageHandler handler,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'register through message handler',
      tag: 'signaling',
      subTag: 'background message',
    );

    if ((!kIsWeb) && (!io.Platform.isAndroid)) {
      ZegoSignalingLoggerService.logInfo(
        'Only Support Android Platform.',
        tag: 'signaling',
        subTag: 'background message',
      );

      return ZegoSignalingPluginSetMessageHandlerResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android Platform.',
        ),
      );
    }

    ZPNsEventHandler.onThroughMessageReceived = handler;

    return const ZegoSignalingPluginSetMessageHandlerResult();
  }
}

/// @nodoc
class ZegoSignalingPluginBackgroundMessageEventImpl
    implements ZegoSignalingPluginBackgroundMessageEvent {}
