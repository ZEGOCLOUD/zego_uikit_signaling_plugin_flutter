part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginMessageAPIImpl
    implements ZegoSignalingPluginMessageAPI {
  @override
  Future<ZegoSignalingPluginInRoomTextMessageResult> sendInRoomTextMessage(
      {required String roomID, required String message}) {
    return ZIM
        .getInstance()!
        .sendMessage(
          ZIMTextMessage(message: message),
          roomID,
          ZIMConversationType.room,
          ZIMMessageSendConfig(),
        )
        .then((ZIMMessageSentResult zimResult) {
      return const ZegoSignalingPluginInRoomTextMessageResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'send in-room text message, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginInRoomTextMessageResult(
        error: error,
      );
    });
  }
}

/// @nodoc
class ZegoSignalingPluginMessageEventImpl
    implements ZegoSignalingPluginMessageEvent {
  @override
  Stream<ZegoSignalingPluginInRoomTextMessageReceivedEvent>
      getInRoomTextMessageReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .inRoomTextMessageReceived
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      getInRoomCommandMessageReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .inRoomCommandMessageReceived
        .stream;
  }
}
