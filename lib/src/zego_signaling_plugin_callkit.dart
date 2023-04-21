part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginCallKitAPIImpl
    implements ZegoSignalingPluginCallKitAPI {
  @override
  Future<void> setIncomingPushReceivedHandler(
    ZegoSignalingIncomingPushReceivedHandler handler,
  ) async {
    CallKitEventHandler.didReceiveIncomingPush = handler;
  }
}

class ZegoSignalingPluginCallKitEventImpl
    implements ZegoSignalingPluginCallKitEvent {
  /// Called when the provider has been reset. Delegates must respond to this callback by cleaning up all internal call state (disconnecting communication channels, releasing network resources, etc.). This callback can be treated as a request to end all calls without the need to respond to any actions
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitProviderDidResetEventStream() {
    return ZegoSignalingPluginEventCenter().callkitProviderDidResetEvent.stream;
  }

  /// Called when the provider has been fully created and is ready to send actions and receive updates
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitProviderDidBeginEventStream() {
    return ZegoSignalingPluginEventCenter().callkitProviderDidBeginEvent.stream;
  }

  /// Called when the provider's audio session activation state changes.
  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitActivateAudioEventStream() {
    return ZegoSignalingPluginEventCenter().callkitActivateAudioEvent.stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitDeactivateAudioEventStream() {
    return ZegoSignalingPluginEventCenter().callkitDeactivateAudioEvent.stream;
  }

  /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitTimedOutPerformingActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitTimedOutPerformingActionEvent
        .stream;
  }

  /// each perform*CallAction method is called sequentially for each action in the transaction
  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformStartCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformStartCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformAnswerCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformAnswerCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformEndCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformEndCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetHeldCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformSetHeldCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitSetMutedCallActionEvent>
      getCallkitPerformSetMutedCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformSetMutedCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetGroupCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformSetGroupCallActionEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformPlayDTMFCallActionEventStream() {
    return ZegoSignalingPluginEventCenter()
        .callkitPerformPlayDTMFCallActionEvent
        .stream;
  }
}
