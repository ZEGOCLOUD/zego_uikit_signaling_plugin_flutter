// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'signaling_core.dart';

mixin ZegoSignalingPluginCoreEvent {
  void initEventHandler() {
    debugPrint("[zim] register event handle.");

    ZIMEventHandler.onCallInvitationReceived =
        ZegoSignalingPluginCore.shared.coreData.onCallInvitationReceived;
    ZIMEventHandler.onCallInvitationCancelled =
        ZegoSignalingPluginCore.shared.coreData.onCallInvitationCancelled;
    ZIMEventHandler.onCallInvitationAccepted =
        ZegoSignalingPluginCore.shared.coreData.onCallInvitationAccepted;
    ZIMEventHandler.onCallInvitationRejected =
        ZegoSignalingPluginCore.shared.coreData.onCallInvitationRejected;
    ZIMEventHandler.onCallInvitationTimeout =
        ZegoSignalingPluginCore.shared.coreData.onCallInvitationTimeout;
    ZIMEventHandler.onCallInviteesAnsweredTimeout =
        ZegoSignalingPluginCore.shared.coreData.onCallInviteesAnsweredTimeout;
    ZIMEventHandler.onConnectionStateChanged =
        ZegoSignalingPluginCore.shared.coreData.onConnectionStateChanged;
    ZIMEventHandler.onError = ZegoSignalingPluginCore.shared.coreData.onError;
  }

  void uninitEventHandler() {
    debugPrint("[zim] unregister event handle.");

    ZIMEventHandler.onCallInvitationReceived = null;
    ZIMEventHandler.onCallInvitationCancelled = null;
    ZIMEventHandler.onCallInvitationAccepted = null;
    ZIMEventHandler.onCallInvitationRejected = null;
    ZIMEventHandler.onCallInvitationTimeout = null;
    ZIMEventHandler.onCallInviteesAnsweredTimeout = null;
    ZIMEventHandler.onConnectionStateChanged = null;
    ZIMEventHandler.onError = null;
  }
}
