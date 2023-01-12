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

typedef InvitationID = String;

enum InvitationState { error, waiting, accept, refuse, cancel, timeout }

class InvitationUser {
  String userID;
  InvitationState state;

  InvitationUser({required this.userID, required this.state});

  @override
  String toString() {
    return "userid :$userID, state:$state";
  }
}

class InvitationData {
  String id; // invitation ID
  String inviterID;
  List<InvitationUser> invitees;
  int type;

  InvitationData({
    required this.id,
    required this.inviterID,
    required this.invitees,
    required this.type,
  });

  @override
  String toString() {
    return "id:$id, type:$type, inviter id:$inviterID, invitees:${invitees.map((e) => e.toString())}";
  }
}

mixin ZegoSignalingPluginCoreInvitationData {
  ZIMUserInfo? get _loginUser =>
      ZegoSignalingPluginCore.shared.coreData.loginUser;

  Map<InvitationID, InvitationData> invitationMap = {};

  var streamCtrlConnectionState = StreamController<Map>.broadcast();
  var streamCtrlRoomState = StreamController<Map>.broadcast();
  var streamCtrlInvitationReceived = StreamController<Map>.broadcast();
  var streamCtrlInvitationTimeout = StreamController<Map>.broadcast();
  var streamCtrlInvitationResponseTimeout = StreamController<Map>.broadcast();
  var streamCtrlInvitationAccepted = StreamController<Map>.broadcast();
  var streamCtrlInvitationRefused = StreamController<Map>.broadcast();
  var streamCtrlInvitationCanceled = StreamController<Map>.broadcast();

  void addInvitationData(InvitationData invitationData) {
    ZegoLoggerService.logInfo(
      "add invitation data ${invitationData.toString()}",
      tag: "signal",
      subTag: "invitation data",
    );
    invitationMap[invitationData.id] = invitationData;
  }

  InvitationData? removeInvitationData(String callID) {
    ZegoLoggerService.logInfo(
      "remove invitation data, call id: $callID",
      tag: "signal",
      subTag: "invitation data",
    );
    return invitationMap.remove(callID);
  }

  InvitationUser? getInvitee(String callID, String userID) {
    for (var invitee in invitationMap[callID]?.invitees ?? <InvitationUser>[]) {
      if (invitee.userID == userID) {
        return invitee;
      }
    }

    return null;
  }

  String queryCallIDByInviterID(String inviterID) {
    for (var invitationData in invitationMap.values) {
      if (invitationData.inviterID == inviterID) {
        return invitationData.id;
      }
    }

    return "";
  }

  void removeIfAllInviteesDone(String callID) {
    var isDone = true;
    for (var invitee in invitationMap[callID]?.invitees ?? <InvitationUser>[]) {
      if (invitee.state == InvitationState.waiting) {
        isDone = false;
        break;
      }
    }

    if (isDone) {
      removeInvitationData(callID);
    }
  }

  void clearInvitationData() {
    invitationMap = {};
  }

  /// invite
  Future<ZegoPluginResult> invite(
      List<String> invitees, int type, ZIMCallInviteConfig config) async {
    late ZIMCallInvitationSentResult result;
    try {
      result = await ZIM.getInstance()!.callInvite(invitees, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'invite error, code:${error.code}, message:${error.message ?? ""}',
        tag: "signal",
        subTag: "invitation data",
      );

      return ZegoPluginResult(error.code, error.message ?? "",
          {"invitation_id": "", "error_invitees": <String>[]});
    }

    var invitationData = InvitationData(
      id: result.callID,
      inviterID: _loginUser!.userID,
      invitees: invitees
          .map((inviteeID) => InvitationUser(
                userID: inviteeID,
                state: InvitationState.waiting,
              ))
          .toList(),
      type: type,
    );
    addInvitationData(invitationData);

    ZegoLoggerService.logInfo(
      'invite done, call id:${result.callID}',
      tag: "signal",
      subTag: "invitation data",
    );
    if (result.info.errorInvitees.isNotEmpty) {
      for (var invitee in result.info.errorInvitees) {
        ZegoLoggerService.logInfo(
          'error invitee, user id: ${invitee.userID}, state:${invitee.state.toString()}',
          tag: "signal",
          subTag: "invitation data",
        );
      }

      var errorUserIDs =
          result.info.errorInvitees.map((e) => e.userID).toList();
      for (var invitee in invitationData.invitees) {
        if (errorUserIDs.contains(invitee.userID)) {
          invitee.state = InvitationState.error;
        }
      }
      removeIfAllInviteesDone(result.callID);
    }

    return ZegoPluginResult(
      "",
      "",
      {
        "invitation_id": result.callID,
        "error_invitees":
            result.info.errorInvitees.map((e) => e.userID).toList()
      },
    );
  }

  /// cancel
  Future<ZegoPluginResult> cancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    late ZIMCallCancelSentResult result;
    try {
      result = await ZIM.getInstance()!.callCancel(invitees, callID, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'cancel invitation error, code:${error.code}, message:${error.message ?? ""}',
        tag: "signal",
        subTag: "invitation data",
      );

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    for (var invitee in invitationMap[callID]?.invitees ?? <InvitationUser>[]) {
      var isCancelUser = invitees.contains(invitee.userID);
      var isCancelError = result.errorInvitees.contains(invitee.userID);
      if (isCancelUser && !isCancelError) {
        invitee.state = InvitationState.cancel;
      } else {
        invitee.state = InvitationState.error;
      }
    }
    removeIfAllInviteesDone(callID);

    if (result.errorInvitees.isNotEmpty) {
      for (var element in result.errorInvitees) {
        ZegoLoggerService.logInfo(
          'cancel invitation error, call id:${result.callID}, invitee id:${element.toString()}',
          tag: "signal",
          subTag: "invitation data",
        );
      }
    } else {
      ZegoLoggerService.logInfo(
        'cancel invitation done, call id:${result.callID}',
        tag: "signal",
        subTag: "invitation data",
      );
    }

    return ZegoPluginResult("", "", result.errorInvitees);
  }

  /// accept
  Future<ZegoPluginResult> accept(
      String callID, ZIMCallAcceptConfig config) async {
    removeInvitationData(callID);

    late ZIMCallAcceptanceSentResult result;
    try {
      result = await ZIM.getInstance()!.callAccept(callID, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'accept invitation error, code:${error.code}, message:${error.message ?? ""}',
        tag: "signal",
        subTag: "invitation data",
      );

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    ZegoLoggerService.logInfo(
      'accept invitation done, call id:${result.callID}',
      tag: "signal",
      subTag: "invitation data",
    );

    return ZegoPluginResult.empty();
  }

  /// reject
  Future<ZegoPluginResult> reject(
      String callID, ZIMCallRejectConfig config) async {
    removeInvitationData(callID);

    late ZIMCallRejectionSentResult result;
    try {
      result = await ZIM.getInstance()!.callReject(callID, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'reject invitation error, code:${error.code}, message:${error.message ?? ""}',
        tag: "signal",
        subTag: "invitation data",
      );

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    ZegoLoggerService.logInfo(
      'reject invitation done, call id:${result.callID}',
      tag: "signal",
      subTag: "invitation data",
    );

    return ZegoPluginResult.empty();
  }

  // ------- events ------

  /// on call invitation received
  void onCallInvitationReceived(
      ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
    ZegoLoggerService.logInfo(
      'onCallInvitationReceived, timeout:${info.timeout}, inviter:${info.inviter}, extended data:${info.extendedData}, call id:$callID',
      tag: "signal",
      subTag: "invitation data",
    );

    var extendedMap = jsonDecode(info.extendedData) as Map<String, dynamic>;
    var invitationData = InvitationData(
      id: callID,
      inviterID: info.inviter,
      invitees: [
        InvitationUser(
          userID: _loginUser!.userID,
          state: InvitationState.waiting,
        )
      ],
      type: extendedMap['type'] as int,
    );
    if (invitationMap.containsKey(invitationData.id)) {
      ZegoLoggerService.logInfo(
        'call id ${invitationData.id} is exist before',
        tag: "signal",
        subTag: "invitation data",
      );

      return;
    }
    addInvitationData(invitationData);

    streamCtrlInvitationReceived.add({
      'inviter': ZegoUIKitUser(
          id: info.inviter, name: extendedMap['inviter_name'] as String),
      'type': extendedMap['type'] as int,
      'data': extendedMap['data'] as String,
      'invitation_id': callID,
    });
  }

  /// on call invitation cancelled
  void onCallInvitationCancelled(
      ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
    //  inviter extendedData
    ZegoLoggerService.logInfo(
      'onCallInvitationCancelled, inviter:${info.inviter}, extended data:${info.extendedData}, call id: $callID',
      tag: "signal",
      subTag: "invitation data",
    );

    removeInvitationData(callID);

    streamCtrlInvitationCanceled.add({
      'inviter': ZegoUIKitUser(id: info.inviter, name: ''),
      'data': info.extendedData,
    });
  }

  /// on call invitation accepted
  void onCallInvitationAccepted(
      ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
    //  inviter extendedData
    ZegoLoggerService.logInfo(
      'onCallInvitationAccepted, invitee:${info.invitee}, extended data:${info.extendedData}, call id:$callID',
      tag: "signal",
      subTag: "invitation data",
    );

    getInvitee(callID, info.invitee)?.state = InvitationState.accept;
    removeInvitationData(callID);

    streamCtrlInvitationAccepted.add({
      'invitee': ZegoUIKitUser(id: info.invitee, name: ''),
      'data': info.extendedData,
    });
  }

  /// on call invitation rejected
  void onCallInvitationRejected(
      ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
    //  inviter extendedData
    ZegoLoggerService.logInfo(
      'onCallInvitationRejected, invitee:${info.invitee}, extended data:${info.extendedData}, call id:$callID',
      tag: "signal",
      subTag: "invitation data",
    );

    getInvitee(callID, info.invitee)?.state = InvitationState.refuse;
    removeIfAllInviteesDone(callID);

    streamCtrlInvitationRefused.add({
      'invitee': ZegoUIKitUser(id: info.invitee, name: ''),
      'data': info.extendedData,
    });
  }

  /// on call invitation timeout
  void onCallInvitationTimeout(ZIM zim, String callID) {
    ZegoLoggerService.logInfo(
      'onCallInvitationTimeout, call id:$callID',
      tag: "signal",
      subTag: "invitation data",
    );

    var invitationData = removeInvitationData(callID);

    streamCtrlInvitationTimeout.add({
      'inviter': ZegoUIKitUser(id: invitationData?.inviterID ?? "", name: ''),
      'data': '',
    });
  }

  /// on call invitation answered timeout
  void onCallInviteesAnsweredTimeout(
      ZIM zim, List<String> invitees, String callID) {
    ZegoLoggerService.logInfo(
      'onCallInviteesAnsweredTimeout, invitees:$invitees, call id:$callID',
      tag: "signal",
      subTag: "invitation data",
    );

    for (var invitee in invitationMap[callID]?.invitees ?? <InvitationUser>[]) {
      if (invitees.contains(invitee.userID)) {
        invitee.state = InvitationState.timeout;
      }
    }
    removeIfAllInviteesDone(callID);

    streamCtrlInvitationResponseTimeout.add({
      'invitees': invitees
          .map((inviteeID) => ZegoUIKitUser(id: inviteeID, name: ''))
          .toList(),
      'data': '',
    });
  }
}
