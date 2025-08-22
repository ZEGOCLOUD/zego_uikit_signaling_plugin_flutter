part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginCallKitAPIImpl
    implements ZegoSignalingPluginCallKitAPI {
  /// set incoming push received handler
  @override
  Future<void> setIncomingPushReceivedHandler(
    ZegoSignalingIncomingPushReceivedHandler handler,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'set incoming push received handler',
      tag: 'signaling',
      subTag: 'callkit',
    );

    // Convert handler type for zego_callkit
    CallKitEventHandler.didReceiveIncomingPush = (Map extras, UUID uuid) {
      handler(extras, (uuid as UUIDImpl).uuidString);
    };
  }

  /// set init configuration for callkit
  @override
  Future<void> setInitConfiguration(
    ZegoSignalingPluginProviderConfiguration configuration,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'set init configuration:$configuration',
      tag: 'signaling',
      subTag: 'callkit',
    );

    // Convert to zego_callkit types
    var cxConfiguration = CXProviderConfiguration(
      localizedName: configuration.localizedName,
      iconTemplateImageName: configuration.iconTemplateImageName,
      supportsVideo: configuration.supportsVideo,
      maximumCallGroups: configuration.maximumCallGroups,
      maximumCallsPerCallGroup: configuration.maximumCallsPerCallGroup,
    );
    CallKit.setInitConfiguration(cxConfiguration);
  }

  /// report call end
  @override
  Future<void> reportCallEnded(
    ZegoSignalingPluginCXCallEndedReason endedReason,
    String uuid,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'report call ended, endedReason:$endedReason, uuid:$uuid',
      tag: 'signaling',
      subTag: 'callkit',
    );

    // Convert to zego_callkit types
    final uuidImpl = UUIDImpl(uuidString_: uuid);
    final zegoCallEndedReason = _convertToZegoCallEndedReason(endedReason);
    CallKit.getInstance().reportCallEnded(zegoCallEndedReason, uuidImpl);
  }

  /// Convert ZegoSignalingPluginCXCallEndedReason to CXCallEndedReason
  CXCallEndedReason _convertToZegoCallEndedReason(
      ZegoSignalingPluginCXCallEndedReason reason) {
    switch (reason) {
      case ZegoSignalingPluginCXCallEndedReason.callEndedReasonFailed:
        return CXCallEndedReason.CXCallEndedReasonFailed;
      case ZegoSignalingPluginCXCallEndedReason.callEndedReasonRemoteEnded:
        return CXCallEndedReason.CXCallEndedReasonRemoteEnded;
      case ZegoSignalingPluginCXCallEndedReason.callEndedReasonUnanswered:
        return CXCallEndedReason.CXCallEndedReasonUnanswered;
      case ZegoSignalingPluginCXCallEndedReason.callEndedReasonAnsweredElsewhere:
        return CXCallEndedReason.CXCallEndedReasonAnsweredElsewhere;
      case ZegoSignalingPluginCXCallEndedReason.callEndedReasonDeclinedElsewhere:
        return CXCallEndedReason.CXCallEndedReasonDeclinedElsewhere;
    }
  }
}

/// @nodoc
class ZegoSignalingPluginCallKitEventImpl
    implements ZegoSignalingPluginCallKitEvent {
  /// Called when the provider has been reset. Delegates must respond to this callback by cleaning up all internal call state (disconnecting communication channels, releasing network resources, etc.). This callback can be treated as a request to end all calls without the need to respond to any actions
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitProviderDidResetEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitProviderDidResetEvent
        .stream;
  }

  /// Called when the provider has been fully created and is ready to send actions and receive updates
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitProviderDidBeginEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitProviderDidBeginEvent
        .stream;
  }

  /// Called when the provider's audio session activation state changes.
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitActivateAudioEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitActivateAudioEvent
        .stream;
  }

  /// callkit deactivate audio event stream
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitDeactivateAudioEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitDeactivateAudioEvent
        .stream;
  }

  /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitTimedOutPerformingActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitTimedOutPerformingActionEvent
        .stream;
  }

  /// each perform*CallAction method is called sequentially for each action in the transaction
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformStartCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformStartCallActionEvent
        .stream;
  }

  /// callkit perform answer call action event
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformAnswerCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformAnswerCallActionEvent
        .stream;
  }

  /// callkit perform end call action event
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformEndCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformEndCallActionEvent
        .stream;
  }

  /// callkit perform set held call action event
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetHeldCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformSetHeldCallActionEvent
        .stream;
  }

  /// callkit perform set muted call action event
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetMutedCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformSetMutedCallActionEvent
        .stream;
  }

  /// callkit perform set group call action event
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetGroupCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformSetGroupCallActionEvent
        .stream;
  }

  /// callkit perform play DTMF call action event
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformPlayDTMFCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformPlayDTMFCallActionEvent
        .stream;
  }
}
