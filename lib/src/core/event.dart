// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'core.dart';

mixin ZegoSignalingPluginCoreEvent {
  /// init core event handler
  void initCoreEventHandler() {
    debugPrint("[zim] register core event handle.");

    ZIMEventHandler.onConnectionStateChanged =
        ZegoSignalingPluginCore.shared.coreData.onConnectionStateChanged;
    ZIMEventHandler.onRoomStateChanged =
        ZegoSignalingPluginCore.shared.coreData.onRoomStateChanged;

    ZIMEventHandler.onError = ZegoSignalingPluginCore.shared.coreData.onError;
  }

  /// uninit core event handler
  void uninitCoreEventHandler() {
    debugPrint("[zim] unregister core event handle.");

    ZIMEventHandler.onConnectionStateChanged = null;
    ZIMEventHandler.onError = null;
  }
}

mixin ZegoSignalingPluginInvitationEvent {
  /// init invitation event handler
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

  /// uninit invitation event handler
  void uninitInvitationEventHandler() {
    debugPrint("[zim] unregister invitation event handle.");

    ZIMEventHandler.onCallInvitationReceived = null;
    ZIMEventHandler.onCallInvitationCancelled = null;
    ZIMEventHandler.onCallInvitationAccepted = null;
    ZIMEventHandler.onCallInvitationRejected = null;
    ZIMEventHandler.onCallInvitationTimeout = null;
    ZIMEventHandler.onCallInviteesAnsweredTimeout = null;
  }
}

mixin ZegoSignalingPluginAttributeEvent {
  /// init attribute event handler
  void initAttributeEventHandler() {
    debugPrint("[zim] register attribute event handle.");

    ZIMEventHandler.onRoomAttributesUpdated =
        ZegoSignalingPluginCore.shared.coreData.onRoomAttributesUpdated;
    ZIMEventHandler.onGroupAttributesUpdated =
        ZegoSignalingPluginCore.shared.coreData.onGroupAttributesUpdated;
    ZIMEventHandler.onRoomAttributesBatchUpdated =
        ZegoSignalingPluginCore.shared.coreData.onRoomAttributesBatchUpdated;
    ZIMEventHandler.onRoomMemberAttributesUpdated =
        ZegoSignalingPluginCore.shared.coreData.onRoomMemberAttributesUpdated;
  }

  /// uninit attribute event handler
  void uninitAttributeEventHandler() {
    debugPrint("[zim] unregister attribute event handle.");

    ZIMEventHandler.onRoomAttributesUpdated = null;
    ZIMEventHandler.onGroupAttributesUpdated = null;
    ZIMEventHandler.onRoomAttributesBatchUpdated = null;
    ZIMEventHandler.onRoomMemberAttributesUpdated = null;
  }
}

mixin ZegoSignalingPluginMessageEvent {
  /// init message event handler
  void initMessageEventHandler() {
    debugPrint("[zim] register message event handle.");

    ZIMEventHandler.onReceiveRoomMessage =
        ZegoSignalingPluginCore.shared.coreData.onReceiveRoomMessage;
  }

  /// uninit message event handler
  void uninitMessageEventHandler() {
    debugPrint("[zim] unregister message event handle.");

    ZIMEventHandler.onReceiveRoomMessage = null;
  }
}
