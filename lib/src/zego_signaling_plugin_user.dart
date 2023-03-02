part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginUserAPIImpl implements ZegoSignalingPluginUserAPI {
  /// login
  @override
  Future<ZegoSignalingPluginConnectUserResult> connectUser({
    required String id,
    String name = '',
  }) async {
    return ZIM
        .getInstance()!
        .login(ZIMUserInfo()
          ..userID = id
          ..userName = name.isNotEmpty ? name : id)
        .then((value) {
      return const ZegoSignalingPluginConnectUserResult();
    }).catchError((error) {
      return ZegoSignalingPluginConnectUserResult(
        error: error,
      );
    });
  }

  /// logout
  @override
  Future<ZegoSignalingPluginDisconnectUserResult> disconnectUser(
      [Duration timeout = const Duration(seconds: 2)]) async {
    ZIM.getInstance()!.logout();

    if (ZegoSignalingPluginEventCenter().connectionState ==
        ZIMConnectionState.reconnecting) {
      /// if current state is network break(reconnecting),
      /// sdk will not call onConnectionStateChanged callback,
      /// that mean the following Completer code will wait forever,
      /// so here return result directly
      return Future.value(
          const ZegoSignalingPluginDisconnectUserResult(timeout: false));
    }

    /// wait for disconnect, make sure state is disconnected before next connect
    debugPrint('waitForDisconnect...');
    if (ZegoSignalingPluginEventCenter().connectionState !=
        ZIMConnectionState.disconnected) {
      final completer = Completer<ZegoSignalingPluginDisconnectUserResult>();
      final timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (ZegoSignalingPluginEventCenter().connectionState ==
            ZIMConnectionState.disconnected) {
          if (timer.isActive) timer.cancel();
          if (!completer.isCompleted) {
            completer.complete(
                const ZegoSignalingPluginDisconnectUserResult(timeout: false));
          }
          debugPrint('waitForDisconnect success');
        }
      });

      /// if not complete in timeout seconds, not wait the disconnect anymore
      Future.delayed(timeout, () {
        if (timer.isActive) timer.cancel();
        if (!completer.isCompleted) {
          completer.complete(
              const ZegoSignalingPluginDisconnectUserResult(timeout: true));
        }
        debugPrint('waitForDisconnect timeout');
      });
      return completer.future;
    } else {
      return Future.value(
          const ZegoSignalingPluginDisconnectUserResult(timeout: false));
    }
  }

  @override
  Future<ZegoSignalingPluginRenewTokenResult> renewToken(String token) async {
    return ZIM
        .getInstance()!
        .renewToken(token)
        .then((value) => const ZegoSignalingPluginRenewTokenResult())
        .catchError((error) {
      return ZegoSignalingPluginRenewTokenResult(
        error: error,
      );
    });
  }
}

class ZegoSignalingPluginUserEventImpl implements ZegoSignalingPluginUserEvent {
  @override
  Stream<ZegoSignalingPluginConnectionStateChangedEvent>
      getConnectionStateChangedEventStream() {
    return ZegoSignalingPluginEventCenter().connectionStateChangedEvent.stream;
  }

  @override
  Stream<ZegoSignalingPluginTokenWillExpireEvent>
      getTokenWillExpireEventStream() {
    return ZegoSignalingPluginEventCenter().tokenWillExpireEvent.stream;
  }
}
