part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginInvitationAPIImpl
    implements ZegoSignalingPluginInvitationAPI {
  /// send invitation
  @override
  Future<ZegoSignalingPluginSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required int timeout,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'send invitation, invitees:$invitees, '
      'timeout:$timeout, '
      'extendedData:$extendedData, '
      'push config:${pushConfig.toString()}',
      tag: 'signaling',
      subTag: 'invitation',
    );

    final config = ZIMCallInviteConfig()
      ..extendedData = extendedData
      ..timeout = timeout
      ..pushConfig = (pushConfig != null)
          ? (ZIMPushConfig()
            ..title = pushConfig.title
            ..content = pushConfig.message
            ..resourcesID = pushConfig.resourceID
            ..payload = pushConfig.payload)
          : null;
    if (null != pushConfig?.voipConfig) {
      config.pushConfig?.voIPConfig = ZIMVoIPConfig();
      config.pushConfig?.voIPConfig?.iOSVoIPHasVideo =
          pushConfig?.voipConfig?.iOSVoIPHasVideo ?? false;
    }

    return ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'send invitation, done, invitation id:${zimResult.callID}, '
        'error invitees:${zimResult.info.errorInvitees.map((e) => '${e.userID}, ')}',
        tag: 'signaling',
        subTag: 'invitation',
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
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationSendError,
              message:
                  'invitees:$invitees, timeout:$timeout, extended data:$extendedData, notification config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'sendInvitation',
            ),
          );

      return ZegoSignalingPluginSendInvitationResult(
        invitationID: '',
        errorInvitees: {},
        error: error,
      );
    });
  }

  /// cancel invitation
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
      subTag: 'invitation',
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
        subTag: 'invitation',
      );

      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: zimResult.errorInvitees,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'cancel invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationCancelError,
              message:
                  'invitation id:$invitationID, invitees:$invitees, extended data:$extendedData, push config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'cancelInvitation',
            ),
          );

      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: invitees,
        error: error,
      );
    });
  }

  /// refuse invitation
  @override
  Future<ZegoSignalingPluginResponseInvitationResult> refuseInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    ZegoSignalingLoggerService.logInfo(
      'refuse invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'signaling',
      subTag: 'invitation',
    );

    return ZIM
        .getInstance()!
        .callReject(
            invitationID, ZIMCallRejectConfig()..extendedData = extendedData)
        .then((ZIMCallRejectionSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'refuse invitation, done, invitation id:${zimResult.callID}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'refuse invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationRefuseError,
              message:
                  'invitation id:$invitationID, extended data:$extendedData, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'refuseInvitation',
            ),
          );

      return ZegoSignalingPluginResponseInvitationResult(
        error: error,
      );
    });
  }

  /// accept invitation
  @override
  Future<ZegoSignalingPluginResponseInvitationResult> acceptInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    ZegoSignalingLoggerService.logInfo(
      'accept invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'signaling',
      subTag: 'invitation',
    );

    return ZIM
        .getInstance()!
        .callAccept(
            invitationID, ZIMCallAcceptConfig()..extendedData = extendedData)
        .then((ZIMCallAcceptanceSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'accept invitation, done, invitation id:${zimResult.callID}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'accept invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationAcceptError,
              message:
                  'invitation id:$invitationID, extended data:$extendedData, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'acceptInvitation',
            ),
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
  /// user state changed event
  @override
  Stream<ZegoSignalingPluginInvitationUserStateChangedEvent>
      getInvitationUserStateChangedEventStream() {
    return ZegoSignalingPluginCore().eventCenter.userStateChangedEvent.stream;
  }

  /// incoming invitation received event
  @override
  Stream<ZegoSignalingPluginIncomingInvitationReceivedEvent>
      getIncomingInvitationReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationReceivedEvent
        .stream;
  }

  /// incoming invitation cancelled event
  @override
  Stream<ZegoSignalingPluginIncomingInvitationCancelledEvent>
      getIncomingInvitationCancelledEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationCancelledEvent
        .stream;
  }

  /// outgoing invitation accepted event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationAcceptedEvent>
      getOutgoingInvitationAcceptedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationAcceptedEvent
        .stream;
  }

  /// outgoing invitation rejected event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationRejectedEvent>
      getOutgoingInvitationRejectedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationRejectedEvent
        .stream;
  }

  /// incoming invitation timeout event
  @override
  Stream<ZegoSignalingPluginIncomingInvitationTimeoutEvent>
      getIncomingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationTimeoutEvent
        .stream;
  }

  /// outgoing invitation timeout event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationTimeoutEvent>
      getOutgoingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationTimeoutEvent
        .stream;
  }
}
