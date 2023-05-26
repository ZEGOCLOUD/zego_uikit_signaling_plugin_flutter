// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/internal/zego_signaling_plugin_core.dart';
import 'package:zego_uikit_signaling_plugin/src/log/logger_service.dart';

part 'zego_signaling_plugin_event_native_style.dart';

/// @nodoc
class ZegoSignalingPluginEventCenter {
  void init() {
    _passthroughEvent();
    _baseEvent();
    _invitationEvent();
    _roomEvent();
    _zpnsEvent();
    _zpnsCallKitEvent();
  }

  void _passthroughEvent() {
    // Message (Only passed through to zimkit)
    ZIMEventHandler.onMessageReceiptChanged = (
      ZIM zim,
      List<ZIMMessageReceiptInfo> infos,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onMessageReceiptChanged, infos:$infos',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onMessageReceiptChanged?.call(zim, infos);
    };
    ZIMEventHandler.onReceivePeerMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromUserID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onReceivePeerMessage, messageList:$messageList, fromUserID:$fromUserID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onReceivePeerMessage?.call(zim, messageList, fromUserID);
    };

    ZIMEventHandler.onReceiveRoomMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromRoomID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onReceiveRoomMessage, messageList:$messageList, fromRoomID:$fromRoomID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onReceiveRoomMessage?.call(zim, messageList, fromRoomID);
    };
    ZIMEventHandler.onReceiveGroupMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromGroupID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onReceiveGroupMessage, messageList:$messageList, fromGroupID:$fromGroupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onReceiveGroupMessage
          ?.call(zim, messageList, fromGroupID);
    };

    ZIMEventHandler.onConversationMessageReceiptChanged =
        (ZIM zim, List<ZIMMessageReceiptInfo> infos) {
      ZegoSignalingLoggerService.logInfo(
        'onConversationMessageReceiptChanged, infos:$infos',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onConversationMessageReceiptChanged?.call(zim, infos);
    };
    ZIMEventHandler.onMessageRevokeReceived =
        (ZIM zim, List<ZIMRevokeMessage> messageList) {
      ZegoSignalingLoggerService.logInfo(
        'onMessageRevokeReceived, messageList:$messageList',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onMessageRevokeReceived?.call(zim, messageList);
    };

    // Group (Only passed through to zimkit)
    ZIMEventHandler.onGroupStateChanged = (ZIM zim,
        ZIMGroupState state,
        ZIMGroupEvent event,
        ZIMGroupOperatedInfo operatedInfo,
        ZIMGroupFullInfo groupInfo) {
      ZegoSignalingLoggerService.logInfo(
        'onGroupStateChanged, state:$state, event:$event, operatedInfo:$operatedInfo, groupInfo:$groupInfo',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupStateChanged?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onGroupNameUpdated, groupName:$groupName, operatedInfo:$operatedInfo, groupID:$groupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupNameUpdated
          ?.call(zim, groupName, operatedInfo, groupID);
    };

    ZIMEventHandler.onGroupAvatarUrlUpdated = (
      ZIM zim,
      String groupAvatarUrl,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onGroupAvatarUrlUpdated, groupAvatarUrl:$groupAvatarUrl, operatedInfo:$operatedInfo, groupID:$groupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupAvatarUrlUpdated
          ?.call(zim, groupAvatarUrl, operatedInfo, groupID);
    };

    ZIMEventHandler.onGroupNoticeUpdated = (
      ZIM zim,
      String groupNotice,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onGroupNoticeUpdated, groupNotice:$groupNotice, operatedInfo:$operatedInfo, groupID:$groupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupNoticeUpdated?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onGroupAttributesUpdated, updateInfo:$updateInfo, operatedInfo:$operatedInfo, groupID:$groupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupAttributesUpdated?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onGroupMemberStateChanged, state:$state, event:$event, userList:$userList, operatedInfo:$operatedInfo, groupID:$groupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupMemberStateChanged?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onGroupMemberInfoUpdated, userInfo:$userInfo, operatedInfo:$operatedInfo, groupID:$groupID',
        tag: 'signaling',
        subTag: 'event center',
      );

      passThroughEvent.onGroupMemberInfoUpdated?.call(
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
      passThroughEvent.onConversationChanged
          ?.call(zim, conversationChangeInfoList);
    };
    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        (ZIM zim, int totalUnreadMessageCount) {
      passThroughEvent.onConversationTotalUnreadMessageCountUpdated
          ?.call(zim, totalUnreadMessageCount);
    };
  }

  void _invitationEvent() {
    ZIMEventHandler.onCallInvitationReceived = (
      ZIM zim,
      ZIMCallInvitationReceivedInfo info,
      String invitationID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onCallInvitationReceived, info:$info, invitationID:$invitationID',
        tag: 'signaling',
        subTag: 'event center',
      );

      incomingInvitationReceivedEvent.add(
        ZegoSignalingPluginIncomingInvitationReceivedEvent(
          invitationID: invitationID,
          inviterID: info.inviter,
          timeoutSecond: info.timeout,
          extendedData: info.extendedData,
        ),
      );
      passThroughEvent.onCallInvitationReceived?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onCallInvitationCancelled, info:$info, invitationID:$invitationID',
        tag: 'signaling',
        subTag: 'event center',
      );

      incomingInvitationCancelledEvent.add(
        ZegoSignalingPluginIncomingInvitationCancelledEvent(
          invitationID: invitationID,
          inviterID: info.inviter,
          extendedData: info.extendedData,
        ),
      );
      passThroughEvent.onCallInvitationCancelled?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onCallInvitationAccepted, info:$info, invitationID:$invitationID',
        tag: 'signaling',
        subTag: 'event center',
      );

      outgoingInvitationAcceptedEvent.add(
        ZegoSignalingPluginOutgoingInvitationAcceptedEvent(
          invitationID: invitationID,
          inviteeID: info.invitee,
          extendedData: info.extendedData,
        ),
      );
      passThroughEvent.onCallInvitationAccepted?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onCallInvitationRejected, info:$info, invitationID:$invitationID',
        tag: 'signaling',
        subTag: 'event center',
      );

      outgoingInvitationRejectedEvent.add(
        ZegoSignalingPluginOutgoingInvitationRejectedEvent(
          invitationID: invitationID,
          inviteeID: info.invitee,
          extendedData: info.extendedData,
        ),
      );
      passThroughEvent.onCallInvitationRejected?.call(
        zim,
        info,
        invitationID,
      );
    };
    ZIMEventHandler.onCallInvitationTimeout = (
      ZIM zim,
      String invitationID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onCallInvitationTimeout, invitationID:$invitationID',
        tag: 'signaling',
        subTag: 'event center',
      );

      incomingInvitationTimeoutEvent.add(
        ZegoSignalingPluginIncomingInvitationTimeoutEvent(
          invitationID: invitationID,
        ),
      );
      passThroughEvent.onCallInvitationTimeout?.call(
        zim,
        invitationID,
      );
    };
    ZIMEventHandler.onCallInviteesAnsweredTimeout = (
      ZIM zim,
      List<String> invitees,
      String invitationID,
    ) {
      ZegoSignalingLoggerService.logInfo(
        'onRoomMemberJoined, invitees:$invitees, invitationID:$invitationID',
        tag: 'signaling',
        subTag: 'event center',
      );

      outgoingInvitationTimeoutEvent.add(
        ZegoSignalingPluginOutgoingInvitationTimeoutEvent(
          invitationID: invitationID,
          invitees: invitees,
        ),
      );
      passThroughEvent.onCallInviteesAnsweredTimeout?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onRoomMemberJoined, memberList:$memberList, roomID:$roomID',
        tag: 'signaling',
        subTag: 'event center',
      );

      roomMemberJoinedEvent.add(
        ZegoSignalingPluginRoomMemberJoinedEvent(
          roomID: roomID,
          usersID: memberList.map((e) => e.userID).toList(),
          usersName: memberList.map((e) => e.userName).toList(),
        ),
      );
      passThroughEvent.onRoomMemberJoined?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onRoomMemberLeft, memberList:$memberList, roomID:$roomID',
        tag: 'signaling',
        subTag: 'event center',
      );

      roomMemberLeftEvent.add(
        ZegoSignalingPluginRoomMemberLeftEvent(
          roomID: roomID,
          usersID: memberList.map((e) => e.userID).toList(),
          usersName: memberList.map((e) => e.userName).toList(),
        ),
      );
      passThroughEvent.onRoomMemberLeft?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onRoomStateChanged, state:$state, event:$event, extendedData:$extendedData, roomID:$roomID',
        tag: 'signaling',
        subTag: 'event center',
      );

      roomState = state;
      roomStateChangedEvent.add(
        ZegoSignalingPluginRoomStateChangedEvent(
          roomID: roomID,
          state: ZegoSignalingPluginRoomState.values[state.index],
          action: ZegoSignalingPluginRoomAction.values[event.index],
          extendedData: extendedData,
        ),
      );
      passThroughEvent.onRoomStateChanged?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onRoomAttributesUpdated, updateInfo:$updateInfo, roomID:$roomID',
        tag: 'signaling',
        subTag: 'event center',
      );

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
      passThroughEvent.onRoomAttributesUpdated?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onRoomAttributesBatchUpdated, updateInfo:$updateInfo, roomID:$roomID',
        tag: 'signaling',
        subTag: 'event center',
      );

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
      passThroughEvent.onRoomAttributesBatchUpdated?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onRoomMemberAttributesUpdated, infos:$infos, operatedInfo:$operatedInfo, roomID:$roomID',
        tag: 'signaling',
        subTag: 'event center',
      );

      usersInRoomAttributesUpdatedEvent.add(
        ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent(
          roomID: roomID,
          editorID: operatedInfo.userID,
          attributes: {
            for (var element in infos)
              element.attributesInfo.userID: element.attributesInfo.attributes
          },
        ),
      );
      passThroughEvent.onRoomMemberAttributesUpdated?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onReceiveRoomMessage, messageList:$messageList, fromRoomID:$fromRoomID',
        tag: 'signaling',
        subTag: 'event center',
      );

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
      passThroughEvent.onReceiveRoomMessage?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onError, errorInfo:$errorInfo',
        tag: 'signaling',
        subTag: 'event center',
      );

      errorEvent.add(
        ZegoSignalingPluginErrorEvent(
          code: errorInfo.code,
          message: errorInfo.message,
        ),
      );
      passThroughEvent.onError?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onConnectionStateChanged, state:$state, event:$event, extendedData:$extendedData',
        tag: 'signaling',
        subTag: 'event center',
      );

      if (state == ZIMConnectionState.disconnected) {
        ZegoSignalingLoggerService.logInfo(
          'onConnectionStateChanged, disconnected, clear current user',
          tag: 'signaling',
          subTag: 'event center',
        );

        ZegoSignalingPluginCore().currentUser = null;
      }

      connectionState = state;
      connectionStateChangedEvent.add(
        ZegoSignalingPluginConnectionStateChangedEvent(
          state: ZegoSignalingPluginConnectionState.values[state.index],
          action: ZegoSignalingPluginConnectionAction.values[event.index],
          extendedData: extendedData,
        ),
      );
      passThroughEvent.onConnectionStateChanged?.call(
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
      ZegoSignalingLoggerService.logInfo(
        'onTokenWillExpire, second:$second',
        tag: 'signaling',
        subTag: 'event center',
      );

      tokenWillExpireEvent
          .add(ZegoSignalingPluginTokenWillExpireEvent(second: second));
      passThroughEvent.onTokenWillExpire?.call(
        zim,
        second,
      );
    };
  }

  void _zpnsEvent() {
    ZPNsEventHandler.onRegistered = (ZPNsRegisterMessage registerMessage) {
      ZegoSignalingLoggerService.logInfo(
        'onRegistered, registerMessage: { '
        'pushID:${registerMessage.pushID}, '
        'errorCode:${registerMessage.errorCode}, '
        'pushSourceType:${registerMessage.pushSourceType}, '
        'errorMessage:${registerMessage.errorMessage}, '
        'commandResult:${registerMessage.commandResult} }',
        tag: 'signaling',
        subTag: 'event center',
      );

      notificationRegisteredEvent.add(
        ZegoSignalingPluginNotificationRegisteredEvent(
          pushID: registerMessage.pushID,
          code: registerMessage.errorCode,
        ),
      );
      passThroughEvent.onZPNsRegistered?.call(
        registerMessage,
      );
    };

    ZPNsEventHandler.onNotificationArrived = (ZPNsMessage message) {
      ZegoSignalingLoggerService.logInfo(
        'onNotificationArrived, message:{ '
        'title: ${message.title}'
        'content: ${message.content}'
        'extras: ${message.extras}'
        'pushSourceType: ${message.pushSourceType} }',
        tag: 'signaling',
        subTag: 'event center',
      );

      notificationArrivedEvent.add(
        ZegoSignalingPluginNotificationArrivedEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
      passThroughEvent.onZPNsNotificationArrived?.call(
        message,
      );
    };

    ZPNsEventHandler.onNotificationClicked = (ZPNsMessage message) {
      ZegoSignalingLoggerService.logInfo(
        'onNotificationClicked, message:{ '
        'title: ${message.title}'
        'content: ${message.content}'
        'extras: ${message.extras}'
        'pushSourceType: ${message.pushSourceType} }',
        tag: 'signaling',
        subTag: 'event center',
      );

      notificationClickedEvent.add(
        ZegoSignalingPluginNotificationClickedEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
      passThroughEvent.onZPNsNotificationClicked?.call(
        message,
      );
    };

    ZPNsEventHandler.onThroughMessageReceived =
        (ZPNsMessage message, Function? iOSOnThroughMessageReceivedCompletion) {
      ZegoSignalingLoggerService.logInfo(
        'onThroughMessageReceived, message:{ '
        'title: ${message.title}'
        'content: ${message.content}'
        'extras: ${message.extras}'
        'pushSourceType: ${message.pushSourceType} }',
        tag: 'signaling',
        subTag: 'event center',
      );

      /// Handling online silent push notifications.
      throughMessageReceivedEvent.add(
        ZegoSignalingPluginThroughMessageReceivedEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );

      passThroughEvent.onZPNsThroughMessageReceived?.call(
        message,
      );
    };
  }

  void _zpnsCallKitEvent() {
    CallKitEventHandler.providerDidReset = () {
      ZegoSignalingLoggerService.logInfo(
        'providerDidReset',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitProviderDidResetEvent.add(ZegoSignalingPluginCallKitVoidEvent());
    };
    CallKitEventHandler.providerDidBegin = () {
      ZegoSignalingLoggerService.logInfo(
        'providerDidBegin',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitProviderDidBeginEvent.add(ZegoSignalingPluginCallKitVoidEvent());
    };
    CallKitEventHandler.didActivateAudioSession = () {
      ZegoSignalingLoggerService.logInfo(
        'didActivateAudioSession',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitActivateAudioEvent.add(ZegoSignalingPluginCallKitVoidEvent());
    };
    CallKitEventHandler.didDeactivateAudioSession = () {
      ZegoSignalingLoggerService.logInfo(
        'didDeactivateAudioSession',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitDeactivateAudioEvent.add(ZegoSignalingPluginCallKitVoidEvent());
    };
    CallKitEventHandler.timedOutPerformingAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'timedOutPerformingAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitTimedOutPerformingActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performStartCallAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performStartCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformStartCallActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performAnswerCallAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performAnswerCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformAnswerCallActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performEndCallAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performEndCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformEndCallActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performSetHeldCallAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performSetHeldCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformSetHeldCallActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performSetMutedCallAction =
        (CXSetMutedCallAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performSetMutedCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformSetMutedCallActionEvent.add(
          ZegoSignalingPluginCallKitSetMutedCallActionEvent(action: action));
    };
    CallKitEventHandler.performSetGroupCallAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performSetGroupCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformSetGroupCallActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performPlayDTMFCallAction = (CXAction action) {
      ZegoSignalingLoggerService.logInfo(
        'performPlayDTMFCallAction',
        tag: 'signaling',
        subTag: 'event center',
      );

      callkitPerformPlayDTMFCallActionEvent
          .add(ZegoSignalingPluginCallKitActionEvent(action: action));
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
  ZIMRoomState roomState = ZIMRoomState.disconnected;
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

  /// zpns notification
  final notificationRegisteredEvent = StreamController<
      ZegoSignalingPluginNotificationRegisteredEvent>.broadcast();
  final notificationArrivedEvent =
      StreamController<ZegoSignalingPluginNotificationArrivedEvent>.broadcast();
  final notificationClickedEvent =
      StreamController<ZegoSignalingPluginNotificationClickedEvent>.broadcast();

  ///  zpns background message  ----------------------------------begin
  final throughMessageReceivedEvent = StreamController<
      ZegoSignalingPluginThroughMessageReceivedEvent>.broadcast();

  /// Called when the provider has been reset. Delegates must respond to this callback by cleaning up all internal call state (disconnecting communication channels, releasing network resources, etc.). This callback can be treated as a request to end all calls without the need to respond to any actions
  final callkitProviderDidResetEvent =
      StreamController<ZegoSignalingPluginCallKitVoidEvent>.broadcast();

  /// Called when the provider has been fully created and is ready to send actions and receive updates
  final callkitProviderDidBeginEvent =
      StreamController<ZegoSignalingPluginCallKitVoidEvent>.broadcast();

  /// Called when the provider's audio session activation state changes.
  final callkitActivateAudioEvent =
      StreamController<ZegoSignalingPluginCallKitVoidEvent>.broadcast();
  final callkitDeactivateAudioEvent =
      StreamController<ZegoSignalingPluginCallKitVoidEvent>.broadcast();

  /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
  final callkitTimedOutPerformingActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();

  /// each perform*CallAction method is called sequentially for each action in the transaction
  final callkitPerformStartCallActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();
  final callkitPerformAnswerCallActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();
  final callkitPerformEndCallActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();
  final callkitPerformSetHeldCallActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();
  final callkitPerformSetMutedCallActionEvent = StreamController<
      ZegoSignalingPluginCallKitSetMutedCallActionEvent>.broadcast();
  final callkitPerformSetGroupCallActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();
  final callkitPerformPlayDTMFCallActionEvent =
      StreamController<ZegoSignalingPluginCallKitActionEvent>.broadcast();

  ///  zpns background message  ----------------------------------end

  final ZegoSignalingPluginEventCenterPassthroughEvent passThroughEvent =
      ZegoSignalingPluginEventCenterPassthroughEvent();
}
