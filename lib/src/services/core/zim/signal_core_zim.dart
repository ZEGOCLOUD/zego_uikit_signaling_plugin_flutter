// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/services/core/call_invitation/call_invitation.dart';
import 'package:zego_uikit_signal_plugin/src/services/core/signal_core.dart';
import 'package:zego_uikit_signal_plugin/src/services/defines/defines.dart';

class ZegoSignalCoreZimPlugin with ZegoCallInvitationStream {
  ZegoSignalCoreZimPlugin();

  bool isCreated = false;
  int appID = 0;
  String appSign = '';
  ZIMUserInfo? loginUser;

  Completer? connectionStateWaiter;
  var connectionState = ZIMConnectionState.disconnected;

  Map<String, String> _userCallIDs = {}; //  <user id, zim call id>

  String get _localUserID => ZegoSignalCore.shared.getLocalUser().id;

  Future<void> create({required int appID, String appSign = ''}) async {
    if (isCreated) {
      debugPrint("[zim] has created.");
      return;
    }

    debugPrint('[zim] create, appID:$appID, appSign:$appSign');

    this.appID = appID;
    this.appSign = appSign;

    isCreated = true;

    var appConfig = ZIMAppConfig();
    appConfig.appID = this.appID;
    appConfig.appSign = this.appSign;
    ZIM.create(appConfig);

    initEventHandler();
  }

  Future<void> destroy() async {
    if (!isCreated) {
      debugPrint("[zim] is not created.");
      return;
    }

    debugPrint("[zim] destroy.");

    uninitEventHandler();

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
    ZIM.getInstance()?.login(loginUser!).then((value) {
      debugPrint('[zim] login success');
    }).onError((error, stackTrace) {
      debugPrint('[zim] login error, $error');
    });
  }

  Future<void> logout() async {
    loginUser = null;

    ZIM.getInstance()?.logout();

    clear();

    debugPrint("[zim] logout.");
  }

  String queryCallID(String userID) {
    return _userCallIDs[userID] ?? "";
  }

  Future<bool?> invite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    return await ZIM
        .getInstance()
        ?.callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult result) async {
      _userCallIDs[_localUserID] = result.callID;
      if (result.info.errorInvitees.isNotEmpty) {
        for (var invitee in result.info.errorInvitees) {
          debugPrint(
              '[zim] invite error, invitee state: ${invitee.state.toString()}');
        }
      } else {
        debugPrint('[zim] invite done, call id:${result.callID}');
      }
      return result.info.errorInvitees.isEmpty;
    });
  }

  Future<bool?> cancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    return await ZIM
        .getInstance()
        ?.callCancel(invitees, callID, config)
        .then((ZIMCallCancelSentResult result) {
      _userCallIDs.remove(_localUserID);

      if (result.errorInvitees.isNotEmpty) {
        for (var element in result.errorInvitees) {
          debugPrint(
              '[zim] cancel invitation error, call id:${result.callID}, invitee id:${element.toString()}');
        }
      } else {
        debugPrint('[zim] cancel invitation done, call id:${result.callID}');
      }

      return result.errorInvitees.isNotEmpty;
    });
  }

  Future<void> accept(String callID, ZIMCallAcceptConfig config) async {
    return await ZIM
        .getInstance()
        ?.callAccept(callID, config)
        .then((ZIMCallAcceptanceSentResult result) {
      debugPrint('[zim] accept invitation done, call id:${result.callID}');
    });
  }

  Future<void> reject(String callID, ZIMCallRejectConfig config) async {
    String inviteUserID = getInviteUserIDByCallID(callID);
    _userCallIDs.remove(inviteUserID);

    return await ZIM
        .getInstance()
        ?.callReject(callID, config)
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

  void initEventHandler() {
    debugPrint("[zim] register event handle.");

    ZIMEventHandler.onCallInvitationReceived = onCallInvitationReceived;
    ZIMEventHandler.onCallInvitationCancelled = onCallInvitationCancelled;
    ZIMEventHandler.onCallInvitationAccepted = onCallInvitationAccepted;
    ZIMEventHandler.onCallInvitationRejected = onCallInvitationRejected;
    ZIMEventHandler.onCallInvitationTimeout = onCallInvitationTimeout;
    ZIMEventHandler.onCallInviteesAnsweredTimeout =
        onCallInviteesAnsweredTimeout;

    ZIMEventHandler.onError = onError;
    ZIMEventHandler.onConnectionStateChanged = onConnectionStateChanged;
  }

  void uninitEventHandler() {
    debugPrint("[zim] unregister event handle.");

    ZIMEventHandler.onCallInvitationReceived = null;
    ZIMEventHandler.onCallInvitationCancelled = null;
    ZIMEventHandler.onCallInvitationAccepted = null;
    ZIMEventHandler.onCallInvitationRejected = null;
    ZIMEventHandler.onCallInvitationTimeout = null;
    ZIMEventHandler.onCallInviteesAnsweredTimeout = null;
  }

  void clear() {
    _userCallIDs = {};
  }

  void onCallInvitationReceived(
      ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
    debugPrint(
        '[zim] onCallInvitationReceived, timeout:${info.timeout}, inviter:${info.inviter}, extended data:${info.extendedData}, callID:$callID');
    _userCallIDs[info.inviter] = callID;

    var invitationExtendedData =
        ZegoCallInvitationExtendedData.fromJson(info.extendedData);
    var event = StreamDataInvitationReceived(
      ZegoUIKitUser(id: info.inviter, name: invitationExtendedData.inviterName),
      invitationExtendedData.type,
      invitationExtendedData.data,
    );
    streamCtrlInvitationReceived.add(event);
  }

  void onCallInvitationCancelled(
      ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationCancelled, inviter:${info.inviter}, extended data:${info.extendedData}, call id: $callID');

    var event = StreamDataInvitationCanceled(
      ZegoUIKitUser(id: info.inviter, name: ''),
      info.extendedData,
    );
    streamCtrlInvitationCanceled.add(event);
  }

  void onCallInvitationAccepted(
      ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationAccepted, invitee:${info.invitee}, extended data:${info.extendedData}, $callID');

    var event = StreamDataInvitationAccepted(
      ZegoUIKitUser(id: info.invitee, name: ''),
      info.extendedData,
    );
    streamCtrlInvitationAccepted.add(event);
  }

  void onCallInvitationRejected(
      ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
    //  inviter extendedData
    debugPrint(
        '[zim] onCallInvitationRejected, invitee:${info.invitee}, extended data:${info.extendedData}, $callID');

    var event = StreamDataInvitationRefused(
      ZegoUIKitUser(id: info.invitee, name: ''),
      info.extendedData,
    );
    streamCtrlInvitationRefused.add(event);
  }

  void onCallInvitationTimeout(ZIM zim, String callID) {
    debugPrint('[zim] onCallInvitationTimeout $callID');

    String inviteUserID = getInviteUserIDByCallID(callID);

    var event = StreamDataInvitationTimeout(
      ZegoUIKitUser(id: inviteUserID, name: ''),
      '',
    );
    streamCtrlInvitationTimeout.add(event);
  }

  void onCallInviteesAnsweredTimeout(
      ZIM zim, List<String> invitees, String callID) {
    debugPrint(
        '[zim] onCallInviteesAnsweredTimeout, invitees:$invitees, call id:$callID');

    var event = StreamDataInvitationResponseTimeout(
      invitees
          .map((inviteeID) => ZegoUIKitUser(id: inviteeID, name: ''))
          .toList(),
      '',
    );
    streamCtrlInvitationResponseTimeout.add(event);
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
}
