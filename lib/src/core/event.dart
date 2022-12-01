// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'core.dart';

mixin ZegoSignalingPluginCoreEvent {
  void initCoreEventHandler() {
    debugPrint("[zim] register event handle.");

    ZIMEventHandler.onConnectionStateChanged =
        ZegoSignalingPluginCore.shared.coreData.onConnectionStateChanged;
    // ZIMEventHandler.onRoomStateChanged =
    //     ZegoSignalingPluginCore.shared.coreData.onRoomStateChanged;

    ZIMEventHandler.onError = ZegoSignalingPluginCore.shared.coreData.onError;
  }

  void uninitCoreEventHandler() {
    debugPrint("[zim] unregister event handle.");

    ZIMEventHandler.onConnectionStateChanged = null;
    ZIMEventHandler.onError = null;
  }
}

mixin ZegoSignalingPluginInvitationEvent {
  void initInvitationEventHandler() {
    debugPrint("[zim] register invitation event handle.");

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
  }

  void uninitInvitationEventHandler() {
    debugPrint("[zim] unregister event handle.");

    ZIMEventHandler.onCallInvitationReceived = null;
    ZIMEventHandler.onCallInvitationCancelled = null;
    ZIMEventHandler.onCallInvitationAccepted = null;
    ZIMEventHandler.onCallInvitationRejected = null;
    ZIMEventHandler.onCallInvitationTimeout = null;
    ZIMEventHandler.onCallInviteesAnsweredTimeout = null;
  }
}

mixin ZegoSignalingPluginAttributeEvent {
  void initAttributeEventHandler() {
    debugPrint("[zim] register event handle.");

    ZIMEventHandler.onRoomAttributesUpdated =
        ZegoSignalingPluginCore.shared.coreData.onRoomAttributesUpdated;
    ZIMEventHandler.onGroupAttributesUpdated =
        ZegoSignalingPluginCore.shared.coreData.onGroupAttributesUpdated;
    ZIMEventHandler.onRoomAttributesBatchUpdated =
        ZegoSignalingPluginCore.shared.coreData.onRoomAttributesBatchUpdated;
    ZIMEventHandler.onRoomMemberAttributesUpdated =
        ZegoSignalingPluginCore.shared.coreData.onRoomMemberAttributesUpdated;
  }

  void uninitAttributeEventHandler() {
    debugPrint("[zim] unregister event handle.");

    ZIMEventHandler.onRoomAttributesUpdated = null;
    ZIMEventHandler.onGroupAttributesUpdated = null;
    ZIMEventHandler.onRoomAttributesBatchUpdated = null;
    ZIMEventHandler.onRoomMemberAttributesUpdated = null;
  }
}
