part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginBackgroundMessageAPIImpl
    implements ZegoSignalingPluginBackgroundMessageAPI {
  bool defaultBackgroundHandlerInit = false;

  /// Convert ZPNsMessage to ZegoSignalingPluginMessage
  ZegoSignalingPluginMessage _convertZPNsMessageToZegoMessage(
      ZPNsMessage zpnsMessage) {
    return ZegoSignalingPluginMessage(
      pushSourceType: _convertPushSourceType(zpnsMessage.pushSourceType),
    )
      ..title = zpnsMessage.title
      ..content = zpnsMessage.content
      ..payload = zpnsMessage.payload
      ..extras = zpnsMessage.extras;
  }

  /// Convert ZPNsPushSourceType to ZegoSignalingPluginPushSourceType
  ZegoSignalingPluginPushSourceType _convertPushSourceType(
      ZPNsPushSourceType zpnsType) {
    switch (zpnsType) {
      case ZPNsPushSourceType.APNs:
        return ZegoSignalingPluginPushSourceType.apns;
      case ZPNsPushSourceType.ZEGO:
        return ZegoSignalingPluginPushSourceType.zego;
      case ZPNsPushSourceType.FCM:
        return ZegoSignalingPluginPushSourceType.fcm;
      case ZPNsPushSourceType.HuaWei:
        return ZegoSignalingPluginPushSourceType.huaWei;
      case ZPNsPushSourceType.XiaoMi:
        return ZegoSignalingPluginPushSourceType.xiaoMi;
      case ZPNsPushSourceType.Oppo:
        return ZegoSignalingPluginPushSourceType.oppo;
      case ZPNsPushSourceType.Vivo:
        return ZegoSignalingPluginPushSourceType.vivo;
    }
  }

  void _initBackgroundMessageHandler() {
    if (defaultBackgroundHandlerInit) {
      ZegoSignalingLoggerService.logInfo(
        'had init',
        tag: 'signaling',
        subTag: 'background message, init default handler',
      );

      return;
    }

    defaultBackgroundHandlerInit = true;

    ZegoSignalingLoggerService.logInfo(
      'init',
      tag: 'signaling',
      subTag: 'background message, init default handler',
    );
    ZPNs.setBackgroundMessageHandler(onSignalingBackgroundMessageReceived);
  }

  @override
  Future<void> removeBackgroundMessageHandler({String key = ''}) async {
    ZegoSignalingLoggerService.logInfo(
      'remove handler, key:$key',
      tag: 'signaling',
      subTag: 'background message handler',
    );
    await clearAndroidHandler(key: key);
  }

  /// register background message handler
  /// only for Android
  ///
  ///
  /// ```dart
  /// @pragma('vm:entry-point')
  /// Future<void> handler1(ZPNsMessage message) async {
  ///     String title,
  ///     String content,
  ///     Map<String, Object?> extras,
  ///     ZegoUIKitCallPushSourceType pushSourceType,
  ///     ) {
  ///   debugPrint(
  ///       'handler 1 recv, title:$title, content:$content, extras:$extras, push type :$pushSourceType');
  /// }
  ///
  /// await setBackgroundMessageHandler(
  /// handler1,
  /// key: 'handler1',
  /// );
  /// ```
  @override
  Future<ZegoSignalingPluginSetMessageHandlerResult>
      setBackgroundMessageHandler(
    ZegoSignalingPluginZPNsBackgroundMessageHandler handler, {
    String key = 'default',
  }) async {
    _initBackgroundMessageHandler();

    ZegoSignalingLoggerService.logInfo(
      'register background message handler, '
      'key:$key',
      tag: 'signaling',
      subTag: 'background message',
    );

    if ((!kIsWeb) && (!io.Platform.isAndroid)) {
      ZegoSignalingLoggerService.logInfo(
        'Only Support Android Platform, ignore',
        tag: 'signaling',
        subTag: 'background message',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.platformNotSupport,
              message: 'only support android platform.',
              method: 'setBackgroundMessageHandler',
            ),
          );

      return ZegoSignalingPluginSetMessageHandlerResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android Platform.',
        ),
      );
    }

    await registerBackgroundMessageHandler(
      ZegoSignalingPluginBackgroundMessageHandler(
        key: key,
        callback: handler,
      ),
    );

    return const ZegoSignalingPluginSetMessageHandlerResult();
  }

  /// set through message handler
  @override
  Future<ZegoSignalingPluginSetMessageHandlerResult> setThroughMessageHandler(
    ZegoSignalingPluginZPNsThroughMessageHandler? handler,
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

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.platformNotSupport,
              message: 'only support android platform.',
              method: 'setThroughMessageHandler',
            ),
          );

      return ZegoSignalingPluginSetMessageHandlerResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android Platform.',
        ),
      );
    }

    // Convert our handler type to the expected ZPNsEventHandler type
    ZPNsEventHandler.onThroughMessageReceived = handler != null
        ? (ZPNsMessage message) =>
            handler(_convertZPNsMessageToZegoMessage(message))
        : null;

    return const ZegoSignalingPluginSetMessageHandlerResult();
  }
}

/// @nodoc
class ZegoSignalingPluginBackgroundMessageEventImpl
    implements ZegoSignalingPluginBackgroundMessageEvent {}
