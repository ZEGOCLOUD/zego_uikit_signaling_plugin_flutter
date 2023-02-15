part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginUserAPIImpl implements ZegoSignalingPluginUserAPI {
  /// login
  @override
  Future<ZegoSignalingPluginConnectUserResult> connectUser({
    required String id,
    String name = '',
    String? token,
  }) async {
    return ZIM
        .getInstance()!
        .login(
            ZIMUserInfo()
              ..userID = id
              ..userName = name.isNotEmpty ? name : id,
            token)
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

    // waitForDisconnect
    const frequence = Duration(milliseconds: 100);
    if (ZegoSignalingPluginEventCenter().connectionState !=
        ZIMConnectionState.disconnected) {
      final completer = Completer<ZegoSignalingPluginDisconnectUserResult>();
      final timer = Timer.periodic(frequence, (timer) {
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
