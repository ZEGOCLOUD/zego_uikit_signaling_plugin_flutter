// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginInvitationService {
  /// send invitation to one or more specified users
  /// [invitees] list of invitees.
  /// [timeout]timeout of the call invitation, the unit is seconds
  /// [type] call type
  /// [data] extended field, through which the inviter can carry information to the invitee.
  Future<ZegoPluginResult> sendInvitation({
    required String inviterName,
    required List<String> invitees,
    required int timeout,
    required int type,
    required String data,
    ZegoNotificationConfig? notificationConfig,
  }) async {
    invitees.removeWhere((item) => ["", null].contains(item));
    if (invitees.isEmpty) {
      ZegoLoggerService.logInfo(
        '[Error] invitees is empty',
        tag: "signal",
        subTag: "invitation service",
      );
      return ZegoPluginResult(
          "", "", {"invitation_id": "", "error_invitees": <String>[]});
    }

    var config = ZIMCallInviteConfig();
    config.timeout = timeout;
    config.extendedData = const JsonEncoder().convert({
      'inviter_name': inviterName,
      'type': type,
      'data': data,
    });

    if (null != notificationConfig &&
        notificationConfig.notifyWhenAppIsInTheBackgroundOrQuit) {
      var pushConfig = ZIMPushConfig();
      pushConfig.title = notificationConfig.title;
      pushConfig.content = notificationConfig.message;
      pushConfig.resourcesID = notificationConfig.resourceID;
      pushConfig.payload = data;
      config.pushConfig = pushConfig;
    }

    ZegoLoggerService.logInfo(
      'send invitation: invitees:$invitees, timeout:$timeout, type:$type, data:$data, notification config:${notificationConfig?.toString()}',
      tag: "signal",
      subTag: "invitation service",
    );

    return await ZegoSignalingPluginCore.shared.coreData
        .invite(invitees, type, config);
  }

  /// cancel invitation to one or more specified users
  /// [inviteeID] invitee's id
  /// [data] extended field
  Future<ZegoPluginResult> cancelInvitation({
    required List<String> invitees,
    required String data,
  }) async {
    invitees.removeWhere((item) => ["", null].contains(item));
    if (invitees.isEmpty) {
      ZegoLoggerService.logInfo(
        '[Error] invitees is empty',
        tag: "signal",
        subTag: "invitation service",
      );
      return ZegoPluginResult("", "", <String>[]);
    }

    var config = ZIMCallCancelConfig();
    config.extendedData = data;

    var callID = ZegoSignalingPluginCore.shared.coreData.queryCallIDByInviterID(
        ZegoSignalingPluginCore.shared.coreData.loginUser!.userID);
    ZegoLoggerService.logInfo(
      'cancel invitation: callID:$callID, invitees:$invitees, data:$data',
      tag: "signal",
      subTag: "invitation service",
    );

    return await ZegoSignalingPluginCore.shared.coreData
        .cancel(invitees, callID, config);
  }

  /// invitee reject the call invitation
  /// [inviterID] inviter id, who send invitation
  /// [data] extended field, you can include your reasons such as Declined
  Future<ZegoPluginResult> refuseInvitation({
    required String inviterID,
    required String data,
  }) async {
    var config = ZIMCallRejectConfig();
    config.extendedData = data;

    String callID = "";
    Map<String, dynamic>? extendedDataMap;
    try {
      extendedDataMap = jsonDecode(data) as Map<String, dynamic>?;
    } catch (e) {
      ZegoLoggerService.logInfo(
        "refuse data is not a json, ${e.toString()}",
        tag: "signal",
        subTag: "invitation service",
      );
    }
    if (extendedDataMap?.containsKey("invitation_id") ?? false) {
      callID = extendedDataMap!["invitation_id"]! as String;
    } else {
      callID = ZegoSignalingPluginCore.shared.coreData
          .queryCallIDByInviterID(inviterID);
    }
    ZegoLoggerService.logInfo(
      'refuse invitation: callID:$callID, inviter id:$inviterID, data:$data',
      tag: "signal",
      subTag: "invitation service",
    );

    if (callID.isEmpty) {
      ZegoLoggerService.logInfo(
        '[Error] call id is empty',
        tag: "signal",
        subTag: "invitation service",
      );
      return ZegoPluginResult.empty();
    }

    return await ZegoSignalingPluginCore.shared.coreData.reject(callID, config);
  }

  /// invitee accept the call invitation
  /// [inviterID] inviter id, who send invitation
  /// [data] extended field
  Future<ZegoPluginResult> acceptInvitation({
    required String inviterID,
    required String data,
  }) async {
    var config = ZIMCallAcceptConfig();
    config.extendedData = data;

    var callID = ZegoSignalingPluginCore.shared.coreData
        .queryCallIDByInviterID(inviterID);
    ZegoLoggerService.logInfo(
      'accept invitation: callID:$callID, inviter id:$inviterID, data:$data',
      tag: "signal",
      subTag: "invitation service",
    );

    if (callID.isEmpty) {
      ZegoLoggerService.logInfo(
        '[Error] call id is empty',
        tag: "signal",
        subTag: "invitation service",
      );
      return ZegoPluginResult.empty();
    }

    return await ZegoSignalingPluginCore.shared.coreData.accept(callID, config);
  }

  /// stream callback, notify connection state
  Stream<Map> getConnectionStateStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlConnectionState.stream;
  }

  /// stream callback, notify room state
  Stream<Map> getRoomStateStream() {
    return ZegoSignalingPluginCore.shared.coreData.streamCtrlRoomState.stream;
  }

  /// stream callback, notify invitee when call invitation received
  Stream<Map> getInvitationReceivedStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInvitationReceived.stream;
  }

  /// stream callback, notify invitee if invitation timeout
  Stream<Map> getInvitationTimeoutStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInvitationTimeout.stream;
  }

  /// stream callback, When the call invitation times out, the invitee does not respond, and the inviter will receive a callback.
  Stream<Map> getInvitationResponseTimeoutStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInvitationResponseTimeout.stream;
  }

  /// stream callback, notify when call invitation accepted by invitee
  Stream<Map> getInvitationAcceptedStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInvitationAccepted.stream;
  }

  /// stream callback, notify when call invitation rejected by invitee
  Stream<Map> getInvitationRefusedStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInvitationRefused.stream;
  }

  /// stream callback, notify when call invitation cancelled by inviter
  Stream<Map> getInvitationCanceledStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInvitationCanceled.stream;
  }
}
