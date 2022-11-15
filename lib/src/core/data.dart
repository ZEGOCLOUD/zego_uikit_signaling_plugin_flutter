// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'defines.dart';
import 'in_room_attributes_data.dart';
import 'invitation_data.dart';

class ZegoSignalingPluginCoreData
    with
        ZegoSignalingPluginCoreInvitationData,
        ZegoSignalingPluginCoreInRoomAttributesData {
  ZIM? zim;
  ZIMUserInfo? loginUser;
  ZIMRoomInfo? roomInfo;

  Completer? connectionStateWaiter;
  var connectionState = ZIMConnectionState.disconnected;

  Future<String> getVersion() async {
    return await ZIM.getVersion();
  }

  Future<void> create({required int appID, String appSign = ''}) async {
    if (null != zim) {
      debugPrint("[zim] has created.");
      return;
    }

    var appConfig = ZIMAppConfig();
    appConfig.appID = appID;
    appConfig.appSign = appSign;
    zim = ZIM.create(appConfig);

    debugPrint('[zim] create, appID:$appID, instance:$zim');
  }

  Future<void> destroy() async {
    if (null == zim) {
      debugPrint("[zim] is not created.");
      return;
    }

    debugPrint("[zim] destroy.");

    zim!.destroy();
    zim = null;

    clear();
  }

  Future<void> login(String id, String name) async {
    if (null == zim) {
      debugPrint("[zim] is not created.");
      return;
    }

    if (loginUser != null) {
      debugPrint("[zim] user has login.");
      return;
    }

    //  wait state be disconnect if reconnect
    if (null != connectionStateWaiter && !connectionStateWaiter!.isCompleted) {
      connectionStateWaiter?.complete();
    }
    await waitConnectionState(ZIMConnectionState.disconnected);

    debugPrint("[zim] login request, user id:$id, user name:$name");
    loginUser = ZIMUserInfo();
    loginUser?.userID = id;
    loginUser?.userName = name;

    debugPrint("[zim] ready to login..");
    await zim!.login(loginUser!).then((value) {
      debugPrint('[zim] login success');
    }).onError((error, stackTrace) {
      debugPrint('[zim] login error, $error');
    });
  }

  Future<void> logout() async {
    debugPrint("user logout");

    loginUser = null;

    zim!.logout();

    clear();

    debugPrint("[zim] logout.");
  }

  Future<ZegoPluginResult> joinRoom(String roomID, String roomName) async {
    if (null == zim) {
      debugPrint("[zim] is not created.");
      return ZegoPluginResult("-1", "zim is not created.", "");
    }

    if (roomInfo != null) {
      debugPrint("[zim] room has login.");
      return ZegoPluginResult("-2", "room has login.", "");
    }

    debugPrint("[zim] join room, room id:$roomID, room name:$roomName");

    roomInfo = ZIMRoomInfo();
    roomInfo!.roomID = roomID;
    roomInfo!.roomName = roomName;

    late ZIMRoomEnteredResult result;
    try {
      result = await zim!.enterRoom(roomInfo!, ZIMRoomAdvancedConfig());
    } on PlatformException catch (error) {
      debugPrint(
          "[zim] exception on join room, ${error.code} ${error.message}");
      roomInfo = null;

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    if (result.roomInfo.baseInfo.roomID.isEmpty) {
      debugPrint("[zim] join room failed");
      roomInfo = null;

      return ZegoPluginResult("-3", "room login failed.", "");
    }

    debugPrint("[zim] join room success");
    return ZegoPluginResult.empty();
  }

  Future<void> leaveRoom() async {
    if (null == zim) {
      debugPrint("[zim] is not created.");
      return;
    }

    if (roomInfo == null) {
      debugPrint("[zim] room has not login.");
      return;
    }

    var roomID = roomInfo!.roomID;
    roomInfo = null;

    debugPrint("[zim] ready to leave room $roomID");
    await zim!.leaveRoom(roomID).then((result) {
      debugPrint("[zim] leave room result: ${result.roomID}");
    });
  }

  void clear() {
    debugPrint("[zim] clear");

    clearInvitationData();

    loginUser = null;
    roomInfo = null;

    connectionStateWaiter = null;
    connectionState = ZIMConnectionState.disconnected;
  }

  Future<void> waitConnectionState(ZIMConnectionState state,
      {Duration duration = const Duration(milliseconds: 100)}) async {
    debugPrint(
        "[zim] waitConnectionState, target state:$state, current state: $connectionState, duration:$duration");

    connectionStateWaiter = Completer();
    if (state != connectionState) {
      debugPrint(
          "[zim] waitConnectionState wait, target state:$state, current state: $connectionState");
      await Future.delayed(duration);
      return waitConnectionState(state, duration: duration);
    } else {
      debugPrint("[zim] waitConnectionState complete");
      connectionStateWaiter?.complete();
    }

    return connectionStateWaiter?.future;
  }

  void onError(ZIM zim, ZIMError errorInfo) {
    debugPrint(
        "[zim] zim error, code:${errorInfo.code}, message:${errorInfo.message}");
  }

  void onConnectionStateChanged(ZIM zim, ZIMConnectionState state,
      ZIMConnectionEvent event, Map extendedData) {
    debugPrint(
        "[zim] connection state changed, state:$state, event:$event, extended data:$extendedData");

    connectionState = state;

    if (connectionState == ZIMConnectionState.disconnected) {
      debugPrint("[zim] disconnected, auto logout");
      logout();
    }

    streamCtrlInvitationConnectionState.add({
      'state': connectionState.index,
    });
  }
}
