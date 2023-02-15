part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginInvitationAPIImpl
    implements ZegoSignalingPluginInvitationAPI {
  @override
  Future<ZegoSignalingPluginSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required int timeout,
    String extendedData = '',
    ZegoSignalingPluginNotificationConfig? notificationConfig,
  }) async {
    final config = ZIMCallInviteConfig()
      ..extendedData = extendedData
      ..timeout = timeout
      ..pushConfig = (notificationConfig != null)
          ? (ZIMPushConfig()
            ..title = notificationConfig.title
            ..content = notificationConfig.message
            ..resourcesID = notificationConfig.resourceID
            ..payload = notificationConfig.payload)
          : null;

    return ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult zimResult) {
      return ZegoSignalingPluginSendInvitationResult(
        invitationID: zimResult.callID,
        errorInvitees: {
          for (var element in zimResult.info.errorInvitees)
            element.userID:
                ZegoSignalingPluginCallUserState.values[element.state.index]
        },
      );
    }).catchError((error) {
      return ZegoSignalingPluginSendInvitationResult(
        invitationID: '',
        errorInvitees: {},
        error: error,
      );
    });
  }

  @override
  Future<ZegoSignalingPluginCancelInvitationResult> cancelInvitation({
    required String invitationID,
    required List<String> invitees,
    String extendedData = '',
  }) async {
    return ZIM
        .getInstance()!
        .callCancel(invitees, invitationID,
            ZIMCallCancelConfig()..extendedData = extendedData)
        .then((ZIMCallCancelSentResult zimResult) {
      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: zimResult.errorInvitees,
      );
    }).catchError((error) {
      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: invitees,
        error: error,
      );
    });
  }

  @override
  Future<ZegoSignalingPluginResponseInvitationResult> refuseInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    return ZIM
        .getInstance()!
        .callReject(
            invitationID, ZIMCallRejectConfig()..extendedData = extendedData)
        .then((ZIMCallRejectionSentResult zimResult) {
      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      return ZegoSignalingPluginResponseInvitationResult(
        error: error,
      );
    });
  }

  @override
  Future<ZegoSignalingPluginResponseInvitationResult> acceptInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    return ZIM
        .getInstance()!
        .callAccept(
            invitationID, ZIMCallAcceptConfig()..extendedData = extendedData)
        .then((ZIMCallAcceptanceSentResult zimResult) {
      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      return ZegoSignalingPluginResponseInvitationResult(
        error: error,
      );
    });
  }
}

class ZegoSignalingPluginInvitationEventImpl
    implements ZegoSignalingPluginInvitationEvent {
  @override
  Stream<ZegoSignalingPluginIncomingInvitationReceivedEvent>
      getIncomingInvitationReceivedEventStream() {
    return ZegoSignalingPluginEventCenter()
        .incomingInvitationReceivedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginIncomingInvitationCancelledEvent>
      getIncomingInvitationCancelledEventStream() {
    return ZegoSignalingPluginEventCenter()
        .incomingInvitationCancelledEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginOutgoingInvitationAcceptedEvent>
      getOutgoingInvitationAcceptedEventStream() {
    return ZegoSignalingPluginEventCenter()
        .outgoingInvitationAcceptedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginOutgoingInvitationRejectedEvent>
      getOutgoingInvitationRejectedEventStream() {
    return ZegoSignalingPluginEventCenter()
        .outgoingInvitationRejectedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginIncomingInvitationTimeoutEvent>
      getIncomingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginEventCenter()
        .incomingInvitationTimeoutEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginOutgoingInvitationTimeoutEvent>
      getOutgoingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginEventCenter()
        .outgoingInvitationTimeoutEvent
        .stream;
  }
}
