// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zpns/zego_zpns.dart';

part 'zego_signaling_plugin_event_native_style.dart';

class ZegoSignalingPluginEventCenter {
  factory ZegoSignalingPluginEventCenter() => instance;
  ZegoSignalingPluginEventCenter._() {
    _passthroughEvent();
    _baseEvent();
    _invitationEvent();
    _roomEvent();
    _zpnsEvent();
  }

  void _passthroughEvent() {
    // Message (Only passed through to zimkit)
    ZIMEventHandler.onMessageReceiptChanged = (
      ZIM zim,
      List<ZIMMessageReceiptInfo> infos,
    ) {
      passthrougnEvent.onMessageReceiptChanged?.call(zim, infos);
    };
    ZIMEventHandler.onReceivePeerMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromUserID,
    ) {
      passthrougnEvent.onReceivePeerMessage?.call(zim, messageList, fromUserID);
    };

    ZIMEventHandler.onReceiveRoomMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromRoomID,
    ) {
      passthrougnEvent.onReceiveRoomMessage?.call(zim, messageList, fromRoomID);
    };
    ZIMEventHandler.onReceiveGroupMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromGroupID,
    ) {
      passthrougnEvent.onReceiveGroupMessage
          ?.call(zim, messageList, fromGroupID);
    };

    ZIMEventHandler.onConversationMessageReceiptChanged =
        (ZIM zim, List<ZIMMessageReceiptInfo> infos) {
      passthrougnEvent.onConversationMessageReceiptChanged?.call(zim, infos);
    };
    ZIMEventHandler.onMessageRevokeReceived =
        (ZIM zim, List<ZIMRevokeMessage> messageList) {
      passthrougnEvent.onMessageRevokeReceived?.call(zim, messageList);
    };

    // Group (Only passed through to zimkit)
    ZIMEventHandler.onGroupStateChanged = (ZIM zim,
        ZIMGroupState state,
        ZIMGroupEvent event,
        ZIMGroupOperatedInfo operatedInfo,
        ZIMGroupFullInfo groupInfo) {
      passthrougnEvent.onGroupStateChanged?.call(
        zim,
        state,
        event,
        operatedInfo,
        groupInfo,
      );
    };
    ZIMEventHandler.onGroupNameUpdated = (
      ZIM zim,
      String groupName,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      passthrougnEvent.onGroupNameUpdated
          ?.call(zim, groupName, operatedInfo, groupID);
    };

    ZIMEventHandler.onGroupAvatarUrlUpdated = (
      ZIM zim,
      String groupAvatarUrl,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      passthrougnEvent.onGroupAvatarUrlUpdated
          ?.call(zim, groupAvatarUrl, operatedInfo, groupID);
    };

    ZIMEventHandler.onGroupNoticeUpdated = (
      ZIM zim,
      String groupNotice,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      passthrougnEvent.onGroupNoticeUpdated?.call(
        zim,
        groupNotice,
        operatedInfo,
        groupID,
      );
    };
    ZIMEventHandler.onGroupAttributesUpdated = (
      ZIM zim,
      List<ZIMGroupAttributesUpdateInfo> updateInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      passthrougnEvent.onGroupAttributesUpdated?.call(
        zim,
        updateInfo,
        operatedInfo,
        groupID,
      );
    };
    ZIMEventHandler.onGroupMemberStateChanged = (
      ZIM zim,
      ZIMGroupMemberState state,
      ZIMGroupMemberEvent event,
      List<ZIMGroupMemberInfo> userList,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      passthrougnEvent.onGroupMemberStateChanged?.call(
        zim,
        state,
        event,
        userList,
        operatedInfo,
        groupID,
      );
    };
    ZIMEventHandler.onGroupMemberInfoUpdated = (
      ZIM zim,
      List<ZIMGroupMemberInfo> userInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      passthrougnEvent.onGroupMemberInfoUpdated?.call(
        zim,
        userInfo,
        operatedInfo,
        groupID,
      );
    };

    // Conversation (Only passed through to zimkit)
    ZIMEventHandler.onConversationChanged = (
      ZIM zim,
      List<ZIMConversationChangeInfo> conversationChangeInfoList,
    ) {
      passthrougnEvent.onConversationChanged
          ?.call(zim, conversationChangeInfoList);
    };
    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        (ZIM zim, int totalUnreadMessageCount) {
      passthrougnEvent.onConversationTotalUnreadMessageCountUpdated
          ?.call(zim, totalUnreadMessageCount);
    };
  }

  void _invitationEvent() {
    ZIMEventHandler.onCallInvitationReceived = (
      ZIM zim,
      ZIMCallInvitationReceivedInfo info,
      String invitationID,
    ) {
      incomingInvitationReceivedEvent.add(
        ZegoSignalingPluginIncomingInvitationReceivedEvent(
          invitationID: invitationID,
          inviterID: info.inviter,
          timeoutSecond: info.timeout,
          extendedData: info.extendedData,
        ),
      );
      passthrougnEvent.onCallInvitationReceived?.call(
        zim,
        info,
        invitationID,
      );
    };

    ZIMEventHandler.onCallInvitationCancelled = (
      ZIM zim,
      ZIMCallInvitationCancelledInfo info,
      String invitationID,
    ) {
      incomingInvitationCancelledEvent.add(
        ZegoSignalingPluginIncomingInvitationCancelledEvent(
          invitationID: invitationID,
          inviterID: info.inviter,
          extendedData: info.extendedData,
        ),
      );
      passthrougnEvent.onCallInvitationCancelled?.call(
        zim,
        info,
        invitationID,
      );
    };
    ZIMEventHandler.onCallInvitationAccepted = (
      ZIM zim,
      ZIMCallInvitationAcceptedInfo info,
      String invitationID,
    ) {
      outgoingInvitationAcceptedEvent.add(
        ZegoSignalingPluginOutgoingInvitationAcceptedEvent(
          invitationID: invitationID,
          inviteeID: info.invitee,
          extendedData: info.extendedData,
        ),
      );
      passthrougnEvent.onCallInvitationAccepted?.call(
        zim,
        info,
        invitationID,
      );
    };
    ZIMEventHandler.onCallInvitationRejected = (
      ZIM zim,
      ZIMCallInvitationRejectedInfo info,
      String invitationID,
    ) {
      outgoingInvitationRejectedEvent.add(
        ZegoSignalingPluginOutgoingInvitationRejectedEvent(
          invitationID: invitationID,
          inviteeID: info.invitee,
          extendedData: info.extendedData,
        ),
      );
      passthrougnEvent.onCallInvitationRejected?.call(
        zim,
        info,
        invitationID,
      );
    };
    ZIMEventHandler.onCallInvitationTimeout = (
      ZIM zim,
      String invitationID,
    ) {
      incomingInvitationTimeoutEvent.add(
        ZegoSignalingPluginIncomingInvitationTimeoutEvent(
          invitationID: invitationID,
        ),
      );
      passthrougnEvent.onCallInvitationTimeout?.call(
        zim,
        invitationID,
      );
    };
    ZIMEventHandler.onCallInviteesAnsweredTimeout = (
      ZIM zim,
      List<String> invitees,
      String invitationID,
    ) {
      outgoingInvitationTimeoutEvent.add(
        ZegoSignalingPluginOutgoingInvitationTimeoutEvent(
          invitationID: invitationID,
          invitees: invitees,
        ),
      );
      passthrougnEvent.onCallInviteesAnsweredTimeout?.call(
        zim,
        invitees,
        invitationID,
      );
    };
  }

  void _roomEvent() {
    ZIMEventHandler.onRoomMemberJoined = (
      ZIM zim,
      List<ZIMUserInfo> memberList,
      String roomID,
    ) {
      roomMemberJoinedEvent.add(
        ZegoSignalingPluginRoomMemberJoinedEvent(
          roomID: roomID,
          usersID: memberList.map((e) => e.userID).toList(),
          usersName: memberList.map((e) => e.userName).toList(),
        ),
      );
      passthrougnEvent.onRoomMemberJoined?.call(
        zim,
        memberList,
        roomID,
      );
    };
    ZIMEventHandler.onRoomMemberLeft = (
      ZIM zim,
      List<ZIMUserInfo> memberList,
      String roomID,
    ) {
      roomMemberLeftEvent.add(
        ZegoSignalingPluginRoomMemberLeftEvent(
          roomID: roomID,
          usersID: memberList.map((e) => e.userID).toList(),
          usersName: memberList.map((e) => e.userName).toList(),
        ),
      );
      passthrougnEvent.onRoomMemberLeft?.call(
        zim,
        memberList,
        roomID,
      );
    };
    ZIMEventHandler.onRoomStateChanged = (
      ZIM zim,
      ZIMRoomState state,
      ZIMRoomEvent event,
      Map extendedData,
      String roomID,
    ) {
      roomStateChangedEvent.add(
        ZegoSignalingPluginRoomStateChangedEvent(
          roomID: roomID,
          state: ZegoSignalingPluginRoomState.values[state.index],
          action: ZegoSignalingPluginRoomAction.values[event.index],
          extendedData: extendedData,
        ),
      );
      passthrougnEvent.onRoomStateChanged?.call(
        zim,
        state,
        event,
        extendedData,
        roomID,
      );
    };
    ZIMEventHandler.onRoomAttributesUpdated = (
      ZIM zim,
      ZIMRoomAttributesUpdateInfo updateInfo,
      String roomID,
    ) {
      roomPropertiesUpdatedEvent.add(
        ZegoSignalingPluginRoomPropertiesUpdatedEvent(
          roomID: roomID,
          setProperties: ZIMRoomAttributesUpdateAction.set == updateInfo.action
              ? updateInfo.roomAttributes
              : {},
          deleteProperties:
              ZIMRoomAttributesUpdateAction.delete == updateInfo.action
                  ? updateInfo.roomAttributes
                  : {},
        ),
      );
      passthrougnEvent.onRoomAttributesUpdated?.call(
        zim,
        updateInfo,
        roomID,
      );
    };
    ZIMEventHandler.onRoomAttributesBatchUpdated = (
      ZIM zim,
      List<ZIMRoomAttributesUpdateInfo> updateInfo,
      String roomID,
    ) {
      roomPropertiesBatchUpdatedEvent.add(
        ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent(
          roomID: roomID,
          setProperties: updateInfo
              .where((element) =>
                  ZIMRoomAttributesUpdateAction.set == element.action)
              .map((e) => e.roomAttributes)
              .fold({}, (value, element) => value..addAll(element)),
          deleteProperties: updateInfo
              .where((element) =>
                  ZIMRoomAttributesUpdateAction.delete == element.action)
              .map((e) => e.roomAttributes)
              .fold({}, (value, element) => value..addAll(element)),
        ),
      );
      passthrougnEvent.onRoomAttributesBatchUpdated?.call(
        zim,
        updateInfo,
        roomID,
      );
    };
    ZIMEventHandler.onRoomMemberAttributesUpdated = (
      ZIM zim,
      List<ZIMRoomMemberAttributesUpdateInfo> infos,
      ZIMRoomOperatedInfo operatedInfo,
      String roomID,
    ) {
      usersInRoomAttributesUpdatedEvent.add(
        ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent(
          roomID: roomID,
          editorID: operatedInfo.userID,
          attributes: { for (var element in infos) element
                .attributesInfo
                .userID : element
                .attributesInfo
                .attributes },
        ),
      );
      passthrougnEvent.onRoomMemberAttributesUpdated?.call(
        zim,
        infos,
        operatedInfo,
        roomID,
      );
    };
    ZIMEventHandler.onReceiveRoomMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromRoomID,
    ) {
      inRoomTextMessageReceived.add(
        ZegoSignalingPluginInRoomTextMessageReceivedEvent(
          messages: messageList
              .map((e) => ZegoSignalingPluginInRoomTextMessage(
                    orderKey: e.orderKey,
                    senderUserID: e.senderUserID,
                    text: (e as ZIMTextMessage).message,
                    timestamp: e.timestamp,
                  ))
              .toList(),
          roomID: fromRoomID,
        ),
      );
      passthrougnEvent.onReceiveRoomMessage?.call(
        zim,
        messageList,
        fromRoomID,
      );
    };
  }

  void _baseEvent() {
    ZIMEventHandler.onError = (
      ZIM zim,
      ZIMError errorInfo,
    ) {
      errorEvent.add(
        ZegoSignalingPluginErrorEvent(
          code: errorInfo.code,
          message: errorInfo.message,
        ),
      );
      passthrougnEvent.onError?.call(
        zim,
        errorInfo,
      );
    };
    ZIMEventHandler.onConnectionStateChanged = (
      ZIM zim,
      ZIMConnectionState state,
      ZIMConnectionEvent event,
      Map extendedData,
    ) {
      connectionState = state;
      connectionStateChangedEvent.add(
        ZegoSignalingPluginConnectionStateChangedEvent(
          state: ZegoSignalingPluginConnectionState.values[state.index],
          action: ZegoSignalingPluginConnectionAction.values[event.index],
          extendedData: extendedData,
        ),
      );
      passthrougnEvent.onConnectionStateChanged?.call(
        zim,
        state,
        event,
        extendedData,
      );
    };

    ZIMEventHandler.onTokenWillExpire = (
      ZIM zim,
      int second,
    ) {
      tokenWillExpireEvent
          .add(ZegoSignalingPluginTokenWillExpireEvent(second: second));
      passthrougnEvent.onTokenWillExpire?.call(
        zim,
        second,
      );
    };
  }

  void _zpnsEvent() {
    ZPNsEventHandler.onRegistered = (ZPNsRegisterMessage registerMessage) {
      notificationRegisteredEvent.add(
        ZegoSignalingPluginNotificationRegisteredEvent(
          pushID: registerMessage.pushID,
          code: registerMessage.errorCode,
        ),
      );
      passthrougnEvent.onZPNsRegistered?.call(
        registerMessage,
      );
    };

    ZPNsEventHandler.onNotificationArrived = (ZPNsMessage message) {
      notificationArrivedEvent.add(
        ZegoSignalingPluginNotificationArrivedEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
      passthrougnEvent.onZPNsNotificationArrived?.call(
        message,
      );
    };

    ZPNsEventHandler.onNotificationClicked = (ZPNsMessage message) {
      notificationClickedEvent.add(
        ZegoSignalingPluginNotificationClickedEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
      passthrougnEvent.onZPNsNotificationClicked?.call(
        message,
      );
    };
  }

  ZIMConnectionState connectionState = ZIMConnectionState.disconnected;

  // base
  final errorEvent =
      StreamController<ZegoSignalingPluginErrorEvent>.broadcast();
  final connectionStateChangedEvent = StreamController<
      ZegoSignalingPluginConnectionStateChangedEvent>.broadcast();
  final tokenWillExpireEvent =
      StreamController<ZegoSignalingPluginTokenWillExpireEvent>.broadcast();
  // invitation
  final incomingInvitationReceivedEvent = StreamController<
      ZegoSignalingPluginIncomingInvitationReceivedEvent>.broadcast();
  final incomingInvitationCancelledEvent = StreamController<
      ZegoSignalingPluginIncomingInvitationCancelledEvent>.broadcast();
  final outgoingInvitationAcceptedEvent = StreamController<
      ZegoSignalingPluginOutgoingInvitationAcceptedEvent>.broadcast();
  final outgoingInvitationRejectedEvent = StreamController<
      ZegoSignalingPluginOutgoingInvitationRejectedEvent>.broadcast();
  final incomingInvitationTimeoutEvent = StreamController<
      ZegoSignalingPluginIncomingInvitationTimeoutEvent>.broadcast();
  final outgoingInvitationTimeoutEvent = StreamController<
      ZegoSignalingPluginOutgoingInvitationTimeoutEvent>.broadcast();
  // room
  final roomMemberJoinedEvent =
      StreamController<ZegoSignalingPluginRoomMemberJoinedEvent>.broadcast();
  final roomMemberLeftEvent =
      StreamController<ZegoSignalingPluginRoomMemberLeftEvent>.broadcast();
  final roomStateChangedEvent =
      StreamController<ZegoSignalingPluginRoomStateChangedEvent>.broadcast();
  final roomPropertiesUpdatedEvent = StreamController<
      ZegoSignalingPluginRoomPropertiesUpdatedEvent>.broadcast();
  final roomPropertiesBatchUpdatedEvent = StreamController<
      ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent>.broadcast();
  final usersInRoomAttributesUpdatedEvent = StreamController<
      ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent>.broadcast();
  final inRoomTextMessageReceived = StreamController<
      ZegoSignalingPluginInRoomTextMessageReceivedEvent>.broadcast();

  // zpns
  final notificationRegisteredEvent = StreamController<
      ZegoSignalingPluginNotificationRegisteredEvent>.broadcast();
  final notificationArrivedEvent =
      StreamController<ZegoSignalingPluginNotificationArrivedEvent>.broadcast();
  final notificationClickedEvent =
      StreamController<ZegoSignalingPluginNotificationClickedEvent>.broadcast();

  static final instance = ZegoSignalingPluginEventCenter._();
  final ZegoSignalingPluginEventCenterPassthroughEvent passthrougnEvent =
      ZegoSignalingPluginEventCenterPassthroughEvent();
}
