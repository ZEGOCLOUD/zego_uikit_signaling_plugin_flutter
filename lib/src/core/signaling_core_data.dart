// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:

class ZegoSignalingPluginCoreData {
  bool isCreated = false;
  ZIMUserInfo? loginUser;
  Map<String, String> _userCallIDs = {}; //  <user id, zim call id>

  Completer? connectionStateWaiter;
  var connectionState = ZIMConnectionState.disconnected;

  var streamCtrlInvitationConnectionState = StreamController<Map>.broadcast();
  var streamCtrlInvitationReceived = StreamController<Map>.broadcast();
  var streamCtrlInvitationTimeout = StreamController<Map>.broadcast();
  var streamCtrlInvitationResponseTimeout = StreamController<Map>.broadcast();
  var streamCtrlInvitationAccepted = StreamController<Map>.broadcast();
  var streamCtrlInvitationRefused = StreamController<Map>.broadcast();
  var streamCtrlInvitationCanceled = StreamController<Map>.broadcast();

  Future<String> getVersion() async {
    return await ZIM.getVersion();
  }

  Future<void> create({required int appID, String appSign = ''}) async {
    if (isCreated) {
      debugPrint("[zim] has created.");
      return;
    }

    debugPrint('[zim] create, appID:$appID');

    isCreated = true;

    var appConfig = ZIMAppConfig();
    appConfig.appID = appID;
    appConfig.appSign = appSign;
    ZIM.create(appConfig);
  }

  Future<void> destroy() async {
    if (!isCreated) {
      debugPrint("[zim] is not created.");
      return;
    }

    debugPrint("[zim] destroy.");

    ZIM.getInstance()?.destroy();

    clear();
  }

  Future<void> login(String id, String name) async {
    if (!isCreated) {
      debugPrint("[zim] is not created.");
      return;
    }

    if (loginUser != null) {
      debugPrint("[zim] has login.");
      return;
    }

    //  wait state be disconnect if relogin
    if (null != connectionStateWaiter && !connectionStateWaiter!.isCompleted) {
      connectionStateWaiter?.complete();
    }
    await waitConnectionState(ZIMConnectionState.disconnected);

    debugPrint("[zim] login request, user id:$id, user name:$name");
    loginUser = ZIMUserInfo();
    loginUser?.userID = id;
    loginUser?.userName = name;

    debugPrint("[zim] ready to login..");
    ZIM.getInstance()!.login(loginUser!).then((value) {
      debugPrint('[zim] login success');
    }).onError((error, stackTrace) {
      debugPrint('[zim] login error, $error');
    });
  }

  Future<void> logout() async {
    loginUser = null;

    ZIM.getInstance()!.logout();

    clear();

    debugPrint("[zim] logout.");
  }

  String queryCallID(String userID) {
    return _userCallIDs[userID] ?? "";
  }

  Future<List<String>> invite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    return await ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult result) async {
      _userCallIDs[loginUser!.userID] = result.callID;
      if (result.info.errorInvitees.isNotEmpty) {
        for (var invitee in result.info.errorInvitees) {
          debugPrint(
              '[zim] invite error, invitee state: ${invitee.state.toString()}');
        }
      } else {
        debugPrint('[zim] invite done, call id:${result.callID}');
      }
      return List<String>.generate(result.info.errorInvitees.length,
          (index) => result.info.errorInvitees[index].userID);
    });
  }

  Future<List<String>> cancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    return await ZIM
        .getInstance()!
        .callCancel(invitees, callID, config)
        .then((ZIMCallCancelSentResult result) {
      _userCallIDs.remove(loginUser!.userID);

      if (result.errorInvitees.isNotEmpty) {
        for (var element in result.errorInvitees) {
          debugPrint(
              '[zim] cancel invitation error, call id:${result.callID}, invitee id:${element.toString()}');
        }
      } else {
        debugPrint('[zim] cancel invitation done, call id:${result.callID}');
      }

      return result.errorInvitees;
    });
  }

  Future<void> accept(String callID, ZIMCallAcceptConfig config) async {
    return await ZIM
        .getInstance()!
        .callAccept(callID, config)
        .then((ZIMCallAcceptanceSentResult result) {
      debugPrint('[zim] accept invitation done, call id:${result.callID}');
    });
  }

  Future<void> reject(String callID, ZIMCallRejectConfig config) async {
    String inviteUserID = getInviteUserIDByCallID(callID);
    _userCallIDs.remove(inviteUserID);

    return await ZIM
        .getInstance()!
        .callReject(callID, config)
        .then((ZIMCallRejectionSentResult result) {
      debugPrint('[zim] reject invitation done, call id:${result.callID}');
    });
  }

  String getInviteUserIDByCallID(String callID) {
    String inviteUserID = "";
    _userCallIDs.forEach((userID, userCallID) {
      if (callID == userCallID) {
        inviteUserID = userID;
      }
    });
    return inviteUserID;
  }

  void clear() {
    _userCallIDs = {};
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

  // ------- events ------

  void onCallInvitationReceived(
      ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
    debugPrint(
        '[zim] onCallInvitationReceived, timeout:${info.timeout}, inviter:${info.inviter}, extended data:${info.extendedData}, callID:$callID');
    _userCallIDs[info.inviter] = callID;

    var extendedMap = jsonDecode(info.extendedData) as Map<String, dynamic>;
    streamCtrlInvitationReceived.add({
      'inviter': ZegoUIKitUser(
          id: info.inviter, name: extendedMap['inviter_name'] as String),
      'type': extendedMap['type'] as int,
      'data': extendedMap['data'] as String,
    });
  }

  void onCallInvitationCancelled(
      ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationCancelled, inviter:${info.inviter}, extended data:${info.extendedData}, call id: $callID');

    streamCtrlInvitationCanceled.add({
      'inviter': ZegoUIKitUser(id: info.inviter, name: ''),
      'data': info.extendedData,
    });
  }

  void onCallInvitationAccepted(
      ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationAccepted, invitee:${info.invitee}, extended data:${info.extendedData}, $callID');

    streamCtrlInvitationAccepted.add({
      'invitee': ZegoUIKitUser(id: info.invitee, name: ''),
      'data': info.extendedData,
    });
  }

  void onCallInvitationRejected(
      ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationRejected, invitee:${info.invitee}, extended data:${info.extendedData}, $callID');

    streamCtrlInvitationRefused.add({
      'invitee': ZegoUIKitUser(id: info.invitee, name: ''),
      'data': info.extendedData,
    });
  }

  void onCallInvitationTimeout(ZIM zim, String callID) {
    debugPrint('[zim] onCallInvitationTimeout $callID');

    String inviteUserID = getInviteUserIDByCallID(callID);

    streamCtrlInvitationTimeout.add({
      'inviter': ZegoUIKitUser(id: inviteUserID, name: ''),
      'data': '',
    });
  }

  void onCallInviteesAnsweredTimeout(
      ZIM zim, List<String> invitees, String callID) {
    debugPrint(
        '[zim] onCallInviteesAnsweredTimeout, invitees:$invitees, call id:$callID');

    streamCtrlInvitationResponseTimeout.add({
      'invitees': invitees
          .map((inviteeID) => ZegoUIKitUser(id: inviteeID, name: ''))
          .toList(),
      'data': '',
    });
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
