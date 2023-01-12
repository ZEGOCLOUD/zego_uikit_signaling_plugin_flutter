// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'defines.dart';
import 'in_room_attributes_data.dart';
import 'invitation_data.dart';
import 'message_data.dart';
import 'notification_data.dart';
import 'users_in_room_attributes_data.dart';

class ZegoSignalingPluginCoreData
    with
        ZegoSignalingPluginCoreInvitationData,
        ZegoSignalingPluginCoreInRoomAttributesData,
        ZegoSignalingPluginCoreUsersInRoomAttributesData,
        ZegoSignalingPluginCoreMessageData,
        ZegoSignalingPluginCoreNotificationData {
  ZIM? zim;
  ZIMUserInfo? loginUser;
  ZIMRoomInfo? roomInfo;

  Completer? connectionStateWaiter;
  var connectionState = ZIMConnectionState.disconnected;

  /// get version
  Future<String> getZIMVersion() async {
    return await ZIM.getVersion();
  }

  /// create engine
  Future<void> create({required int appID, String appSign = ''}) async {
    if (null != zim) {
      ZegoLoggerService.logInfo(
        "has created.",
        tag: "signal",
        subTag: "core data",
      );
      return;
    }

    var appConfig = ZIMAppConfig();
    appConfig.appID = appID;
    appConfig.appSign = appSign;
    zim = ZIM.create(appConfig);

    initNotification();

    ZegoLoggerService.logInfo(
      'create, appID:$appID, instance:$zim',
      tag: "signal",
      subTag: "core data",
    );
  }

  /// destroy engine
  Future<void> destroy() async {
    if (null == zim) {
      ZegoLoggerService.logInfo(
        "is not created.",
        tag: "signal",
        subTag: "core data",
      );
      return;
    }

    ZegoLoggerService.logInfo(
      "destroy.",
      tag: "signal",
      subTag: "core data",
    );

    uninitNotification();

    zim!.destroy();
    zim = null;

    clear();
  }

  /// login
  Future<void> login(String id, String name) async {
    if (null == zim) {
      ZegoLoggerService.logInfo(
        "is not created.",
        tag: "signal",
        subTag: "core data",
      );
      return;
    }

    if (loginUser != null) {
      ZegoLoggerService.logInfo(
        "user has login.",
        tag: "signal",
        subTag: "core data",
      );
      return;
    }

    //  wait state be disconnect if reconnect
    if (null != connectionStateWaiter && !connectionStateWaiter!.isCompleted) {
      connectionStateWaiter?.complete();
    }
    await waitConnectionState(ZIMConnectionState.disconnected);

    ZegoLoggerService.logInfo(
      "login request, user id:$id, user name:$name",
      tag: "signal",
      subTag: "core data",
    );
    loginUser = ZIMUserInfo();
    loginUser?.userID = id;
    loginUser?.userName = name;

    ZegoLoggerService.logInfo(
      "ready to login..",
      tag: "signal",
      subTag: "core data",
    );
    await zim!.login(loginUser!).then((value) {
      ZegoLoggerService.logInfo(
        'login success',
        tag: "signal",
        subTag: "core data",
      );
    }).onError((error, stackTrace) {
      ZegoLoggerService.logInfo(
        'login error, $error',
        tag: "signal",
        subTag: "core data",
      );
    });
  }

  /// logout
  Future<void> logout() async {
    ZegoLoggerService.logInfo(
      "user logout",
      tag: "signal",
      subTag: "core data",
    );

    loginUser = null;

    zim!.logout();

    clear();

    ZegoLoggerService.logInfo(
      "logout.",
      tag: "signal",
      subTag: "core data",
    );
  }

  /// join room
  Future<ZegoPluginResult> joinRoom(String roomID, String roomName) async {
    if (null == zim) {
      ZegoLoggerService.logInfo(
        "is not created.",
        tag: "signal",
        subTag: "core data",
      );
      return ZegoPluginResult("-1", "zim is not created.", "");
    }

    if (roomInfo != null) {
      ZegoLoggerService.logInfo(
        "room has login.",
        tag: "signal",
        subTag: "core data",
      );
      return ZegoPluginResult("-2", "room has login.", "");
    }

    ZegoLoggerService.logInfo(
      "join room, room id:\"$roomID\", room name:$roomName",
      tag: "signal",
      subTag: "core data",
    );

    roomInfo = ZIMRoomInfo();
    roomInfo!.roomID = roomID;
    roomInfo!.roomName = roomName;

    late ZIMRoomEnteredResult result;
    try {
      result = await zim!.enterRoom(roomInfo!, ZIMRoomAdvancedConfig());
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        "exception on join room, ${error.code} ${error.message}",
        tag: "signal",
        subTag: "core data",
      );
      roomInfo = null;

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    if (result.roomInfo.baseInfo.roomID.isEmpty) {
      ZegoLoggerService.logInfo(
        "join room failed",
        tag: "signal",
        subTag: "core data",
      );
      roomInfo = null;

      return ZegoPluginResult("-3", "room login failed.", "");
    }

    ZegoLoggerService.logInfo(
      "join room success",
      tag: "signal",
      subTag: "core data",
    );
    return ZegoPluginResult.empty();
  }

  /// leave room
  Future<void> leaveRoom() async {
    if (null == zim) {
      ZegoLoggerService.logInfo(
        "is not created.",
        tag: "signal",
        subTag: "core data",
      );
      return;
    }

    if (roomInfo == null) {
      ZegoLoggerService.logInfo(
        "room has not login.",
        tag: "signal",
        subTag: "core data",
      );
      return;
    }

    var roomID = roomInfo!.roomID;
    roomInfo = null;

    ZegoLoggerService.logInfo(
      "ready to leave room $roomID",
      tag: "signal",
      subTag: "core data",
    );
    await zim!.leaveRoom(roomID).then((result) {
      ZegoLoggerService.logInfo(
        "leave room result: ${result.roomID}",
        tag: "signal",
        subTag: "core data",
      );
    });
  }

  /// clear
  void clear() {
    ZegoLoggerService.logInfo(
      "clear",
      tag: "signal",
      subTag: "core data",
    );

    clearInvitationData();

    loginUser = null;
    roomInfo = null;

    connectionStateWaiter = null;
    connectionState = ZIMConnectionState.disconnected;
  }

  /// wait connection state
  Future<void> waitConnectionState(ZIMConnectionState state,
      {Duration duration = const Duration(milliseconds: 100)}) async {
    ZegoLoggerService.logInfo(
      "waitConnectionState, target state:$state, current state: $connectionState, duration:$duration",
      tag: "signal",
      subTag: "core data",
    );

    connectionStateWaiter = Completer();
    if (state != connectionState) {
      ZegoLoggerService.logInfo(
        "waitConnectionState wait, target state:$state, current state: $connectionState",
        tag: "signal",
        subTag: "core data",
      );
      await Future.delayed(duration);
      return waitConnectionState(state, duration: duration);
    } else {
      ZegoLoggerService.logInfo(
        "waitConnectionState complete",
        tag: "signal",
        subTag: "core data",
      );
      connectionStateWaiter?.complete();
    }

    return connectionStateWaiter?.future;
  }

  ///  on error
  void onError(ZIM zim, ZIMError errorInfo) {
    ZegoLoggerService.logInfo(
      "zim error, code:${errorInfo.code}, message:${errorInfo.message}",
      tag: "signal",
      subTag: "core data",
    );
  }

  /// on connection state changed
  void onConnectionStateChanged(ZIM zim, ZIMConnectionState state,
      ZIMConnectionEvent event, Map extendedData) {
    ZegoLoggerService.logInfo(
      "connection state changed, state:$state, event:$event, extended data:$extendedData",
      tag: "signal",
      subTag: "core data",
    );

    connectionState = state;

    if (connectionState == ZIMConnectionState.disconnected) {
      ZegoLoggerService.logInfo(
        "disconnected, auto logout",
        tag: "signal",
        subTag: "core data",
      );
      logout();
    }

    streamCtrlConnectionState.add({
      'state': connectionState.index,
    });
  }

  /// on room state changed
  void onRoomStateChanged(ZIM zim, ZIMRoomState state, ZIMRoomEvent event,
      Map extendedData, String roomID) {
    ZegoLoggerService.logInfo(
      "room state changed, state:$state, event:$event, extended data:$extendedData, roomID:$roomID",
      tag: "signal",
      subTag: "core data",
    );

    streamCtrlRoomState.add({
      'state': state.index,
    });

    if (ZIMRoomState.disconnected == state) {
      ZegoLoggerService.logInfo(
        "room has been disconnect.",
        tag: "signal",
        subTag: "core data",
      );
      roomInfo = null;
    }
  }
}
