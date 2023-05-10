part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginCallKitAPIImpl
    implements ZegoSignalingPluginCallKitAPI {
  @override
  Future<void> setIncomingPushReceivedHandler(
    ZegoSignalingIncomingPushReceivedHandler handler,
  ) async {
    ZegoSignalingLoggerService.logInfo(
      'set incoming push received handler',
      tag: 'signaling',
      subTag: 'callkit',
    );

    CallKitEventHandler.didReceiveIncomingPush = handler;
  }

  @override
  Future<void> setInitConfiguration(
    ZegoSignalingPluginProviderConfiguration _configuration,
  ) async {
    var configuration = CXProviderConfiguration(
      localizedName: _configuration.localizedName,
      iconTemplateImageName: _configuration.iconTemplateImageName,
      supportsVideo: _configuration.supportsVideo,
      maximumCallGroups: _configuration.maximumCallGroups,
      maximumCallsPerCallGroup: _configuration.maximumCallsPerCallGroup,
    );
    CallKit.setInitConfiguration(configuration);
  }

  @override
  void activeAudioByCallKit() {
    ZegoSignalingLoggerService.logInfo(
      'active audio by callKit',
      tag: 'signaling',
      subTag: 'callkit',
    );

    ZegoSignalingPluginPlatform.instance.activeAudioByCallKit();
  }
}

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

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformAnswerCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformAnswerCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformEndCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformEndCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetHeldCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformSetHeldCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitSetMutedCallActionEvent>
      getCallkitPerformSetMutedCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformSetMutedCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetGroupCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformSetGroupCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformPlayDTMFCallActionEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .callkitPerformPlayDTMFCallActionEvent
        .stream;
  }
}
