// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'core.dart';

mixin ZegoSignalingPluginCoreEvent {
  /// init core event handler
  void initCoreEventHandler() {
    ZegoLoggerService.logInfo(
      "register core event handle.",
      tag: "signal",
      subTag: "core event",
    );

    ZIMEventHandler.onConnectionStateChanged =
        ZegoSignalingPluginCore.shared.coreData.onConnectionStateChanged;
    ZIMEventHandler.onRoomStateChanged =
        ZegoSignalingPluginCore.shared.coreData.onRoomStateChanged;

    ZIMEventHandler.onError = ZegoSignalingPluginCore.shared.coreData.onError;
  }

  /// uninit core event handler
  void uninitCoreEventHandler() {
    ZegoLoggerService.logInfo(
      "unregister core event handle.",
      tag: "signal",
      subTag: "core event",
    );

    ZIMEventHandler.onConnectionStateChanged = null;
    ZIMEventHandler.onError = null;
  }
}

mixin ZegoSignalingPluginInvitationEvent {
  /// init invitation event handler
  void initInvitationEventHandler() {
    ZegoLoggerService.logInfo(
      "register invitation event handle.",
      tag: "signal",
      subTag: "core event",
    );

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
    ZegoLoggerService.logInfo(
      "unregister invitation event handle.",
      tag: "signal",
      subTag: "core event",
    );

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
    ZegoLoggerService.logInfo(
      "register attribute event handle.",
      tag: "signal",
      subTag: "core event",
    );

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
    ZegoLoggerService.logInfo(
      "unregister attribute event handle.",
      tag: "signal",
      subTag: "core event",
    );

    ZIMEventHandler.onRoomAttributesUpdated = null;
    ZIMEventHandler.onGroupAttributesUpdated = null;
    ZIMEventHandler.onRoomAttributesBatchUpdated = null;
    ZIMEventHandler.onRoomMemberAttributesUpdated = null;
  }
}

mixin ZegoSignalingPluginMessageEvent {
  /// init message event handler
  void initMessageEventHandler() {
    ZegoLoggerService.logInfo(
      "register message event handle.",
      tag: "signal",
      subTag: "core event",
    );

    ZIMEventHandler.onReceiveRoomMessage =
        ZegoSignalingPluginCore.shared.coreData.onReceiveRoomMessage;
  }

  /// uninit message event handler
  void uninitMessageEventHandler() {
    ZegoLoggerService.logInfo(
      "unregister message event handle.",
      tag: "signal",
      subTag: "core event",
    );

    ZIMEventHandler.onReceiveRoomMessage = null;
  }
}
