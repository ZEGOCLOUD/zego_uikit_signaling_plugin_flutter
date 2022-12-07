// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'defines.dart';

mixin ZegoSignalingPluginCoreInvitationData {
  ZIMUserInfo? get _loginUser =>
      ZegoSignalingPluginCore.shared.coreData.loginUser;

  Map<String, String> _userCallIDs = {}; //  <user id, zim call id>

  var streamCtrlConnectionState = StreamController<Map>.broadcast();
  var streamCtrlRoomState = StreamController<Map>.broadcast();
  var streamCtrlInvitationReceived = StreamController<Map>.broadcast();
  var streamCtrlInvitationTimeout = StreamController<Map>.broadcast();
  var streamCtrlInvitationResponseTimeout = StreamController<Map>.broadcast();
  var streamCtrlInvitationAccepted = StreamController<Map>.broadcast();
  var streamCtrlInvitationRefused = StreamController<Map>.broadcast();
  var streamCtrlInvitationCanceled = StreamController<Map>.broadcast();

  String queryCallID(String userID) {
    return _userCallIDs[userID] ?? "";
  }

  Future<ZegoPluginResult> invite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    late ZIMCallInvitationSentResult result;
    try {
      result = await ZIM.getInstance()!.callInvite(invitees, config);
    } on PlatformException catch (error) {
      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    String errorMessage = "";
    _userCallIDs[_loginUser!.userID] = result.callID;
    if (result.info.errorInvitees.isNotEmpty) {
      for (var invitee in result.info.errorInvitees) {
        errorMessage += invitee.state.toString() + ";";
        debugPrint(
            '[zim] invite error, invitee state: ${invitee.state.toString()}');
      }
    } else {
      debugPrint('[zim] invite done, call id:${result.callID}');
    }

    return ZegoPluginResult(
        errorMessage.isEmpty ? "" : "-1",
        errorMessage,
        List<String>.generate(result.info.errorInvitees.length,
            (index) => result.info.errorInvitees[index].userID));
  }

  Future<ZegoPluginResult> cancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    late ZIMCallCancelSentResult result;
    try {
      result = await ZIM.getInstance()!.callCancel(invitees, callID, config);
    } on PlatformException catch (error) {
      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    _userCallIDs.remove(_loginUser!.userID);

    if (result.errorInvitees.isNotEmpty) {
      for (var element in result.errorInvitees) {
        debugPrint(
            '[zim] cancel invitation error, call id:${result.callID}, invitee id:${element.toString()}');
      }
    } else {
      debugPrint('[zim] cancel invitation done, call id:${result.callID}');
    }

    return ZegoPluginResult("", "", result.errorInvitees);
  }

  Future<ZegoPluginResult> accept(
      String callID, ZIMCallAcceptConfig config) async {
    late ZIMCallAcceptanceSentResult result;
    try {
      result = await ZIM.getInstance()!.callAccept(callID, config);
    } on PlatformException catch (error) {
      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    debugPrint('[zim] accept invitation done, call id:${result.callID}');

    return ZegoPluginResult.empty();
  }

  Future<ZegoPluginResult> reject(
      String callID, ZIMCallRejectConfig config) async {
    String inviteUserID = getInviteUserIDByCallID(callID);
    _userCallIDs.remove(inviteUserID);

    late ZIMCallRejectionSentResult result;
    try {
      result = await ZIM.getInstance()!.callReject(callID, config);
    } on PlatformException catch (error) {
      return ZegoPluginResult(error.code, error.message ?? "", "");
    }
    debugPrint('[zim] reject invitation done, call id:${result.callID}');

    return ZegoPluginResult.empty();
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

  void clearInvitationData() {
    _userCallIDs = {};
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
}
