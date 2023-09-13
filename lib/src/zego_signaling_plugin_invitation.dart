part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginInvitationAPIImpl
    implements ZegoSignalingPluginInvitationAPI {
  @override
  Future<ZegoSignalingPluginSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required int timeout,
    String extendedData = '',
    ZegoSignalingPluginNotificationConfig? notificationConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'send invitation, invitees:$invitees, '
      'timeout:$timeout, '
      'extendedData:$extendedData, '
      'notification config:${notificationConfig.toString()}',
      tag: 'signaling',
      subTag: 'room',
    );

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
      ZegoSignalingLoggerService.logInfo(
        'send invitation, done, invitation id:${zimResult.callID}, '
        'error invitees:${zimResult.info.errorInvitees.map((e) => '${e.userID}, ')}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginSendInvitationResult(
        invitationID: zimResult.callID,
        errorInvitees: {
          for (var element in zimResult.info.errorInvitees)
            element.userID:
                ZegoSignalingPluginCallUserState.values[element.state.index]
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'send invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

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
    ZegoSignalingPluginIncomingInvitationCancelPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'cancel invitation, invitation id:$invitationID, invitees:$invitees, '
      'extendedData:$extendedData, pushConfig:$pushConfig',
      tag: 'signaling',
      subTag: 'room',
    );

    var config = ZIMCallCancelConfig();
    config.extendedData = extendedData;
    if (null != pushConfig) {
      var zimPushConfig = ZIMPushConfig();
      zimPushConfig.title = pushConfig.title;
      zimPushConfig.content = pushConfig.content;
      zimPushConfig.payload = pushConfig.payload;
      zimPushConfig.resourcesID = pushConfig.resourcesID;

      config.pushConfig = zimPushConfig;
    }
    return ZIM
        .getInstance()!
        .callCancel(
          invitees,
          invitationID,
          config,
        )
        .then((ZIMCallCancelSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'cancel invitation, done, invitation id:${zimResult.callID}, '
        'error invitees:${zimResult.errorInvitees}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: zimResult.errorInvitees,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'cancel invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

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
    ZegoSignalingLoggerService.logInfo(
      'refuse invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .callReject(
            invitationID, ZIMCallRejectConfig()..extendedData = extendedData)
        .then((ZIMCallRejectionSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'refuse invitation, done, invitation id:${zimResult.callID}',
        tag: 'signaling',
        subTag: 'room',
      );

      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'refuse invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

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
    ZegoSignalingLoggerService.logInfo(
      'accept invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .callAccept(
            invitationID, ZIMCallAcceptConfig()..extendedData = extendedData)
        .then((ZIMCallAcceptanceSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'accept invitation, done, invitation id:${zimResult.callID}',
        tag: 'signaling',
        subTag: 'room',
      );

      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'accept invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginResponseInvitationResult(
        error: error,
      );
    });
  }
}

/// @nodoc
class ZegoSignalingPluginInvitationEventImpl
    implements ZegoSignalingPluginInvitationEvent {
  @override
  Stream<ZegoSignalingPluginIncomingInvitationReceivedEvent>
      getIncomingInvitationReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationReceivedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginIncomingInvitationCancelledEvent>
      getIncomingInvitationCancelledEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationCancelledEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginOutgoingInvitationAcceptedEvent>
      getOutgoingInvitationAcceptedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationAcceptedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginOutgoingInvitationRejectedEvent>
      getOutgoingInvitationRejectedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationRejectedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginIncomingInvitationTimeoutEvent>
      getIncomingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationTimeoutEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginOutgoingInvitationTimeoutEvent>
      getOutgoingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationTimeoutEvent
        .stream;
  }
}
