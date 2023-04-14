part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginBackgroundMessageAPIImpl
    implements ZegoSignalingPluginBackgroundMessageAPI {
  /// only for Android
  @override
  Future<ZegoSignalingPluginSetBackgroundMessageHandlerResult>
      setBackgroundMessageHandler(
    ZegoSignalingPluginZPNsBackgroundMessageHandler handler,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'register background message handler',
      tag: 'signaling',
      subTag: 'background message',
    );

    if (!Platform.isAndroid) {
      ZegoSignalingLoggerService.logInfo(
        'Only Support Android Platform.',
        tag: 'signaling',
        subTag: 'background message',
      );

      return ZegoSignalingPluginSetBackgroundMessageHandlerResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android Platform.',
        ),
      );
    }

    ZPNs.setBackgroundMessageHandler(handler);

    return const ZegoSignalingPluginSetBackgroundMessageHandlerResult();
  }
}

class ZegoSignalingPluginBackgroundMessageEventImpl
    implements ZegoSignalingPluginBackgroundMessageEvent {
  @override
  Stream<ZegoSignalingPluginThroughMessageReceivedEvent>
      getBackgroundThroughMessageReceivedEventStream() {
    return ZegoSignalingPluginEventCenter().throughMessageReceivedEvent.stream;
  }
}
