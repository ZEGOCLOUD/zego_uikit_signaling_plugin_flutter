part of '../zego_uikit_signaling_plugin.dart';

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
      return ZegoSignalingPluginInRoomTextMessageResult(
        error: error,
      );
    });
  }
}

class ZegoSignalingPluginMessageEventImpl
    implements ZegoSignalingPluginMessageEvent {
  @override
  Stream<ZegoSignalingPluginInRoomTextMessageReceivedEvent>
      getInRoomTextMessageReceivedEventStream() {
    return ZegoSignalingPluginEventCenter().inRoomTextMessageReceived.stream;
  }
}
