// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'defines.dart';

mixin ZegoSignalingPluginCoreMessageData {
  ZIMRoomInfo? get _roomInfo =>
      ZegoSignalingPluginCore.shared.coreData.roomInfo;

  ZIM? get _zim => ZegoSignalingPluginCore.shared.coreData.zim;

  var streamCtrlInRoomTextMessage = StreamController<Map>.broadcast();

  /// send in-room text message
  Future<ZegoPluginResult> sendInRoomTextMessage(String text) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] send in-room text message, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", "");
    }

    // late ZIMMessageSentResult result;
    try {
      var message = ZIMTextMessage(message: text);
      message.type = ZIMMessageType.text;
      var config = ZIMMessageSendConfig();
      // result =
      await _zim!.sendRoomMessage(message, _roomInfo!.roomID, config);
    } on PlatformException catch (error) {
      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    return ZegoPluginResult.empty();
  }

  /// protocol:
  /// {
  /// "messageList":
  ///   [
  ///     {
  ///     "messageID": $value(int),
  ///     "timestamp": $value(int),
  ///     "orderKey": $value(int),
  ///     "senderUserID": $value(String),
  ///     "text": $value(String),
  ///     }
  ///   ]
  /// }
  void onReceiveRoomMessage(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromRoomID,
  ) {
    debugPrint(
        '[zim] onReceiveRoomMessage, messageList:${messageList.map((message) {
      return "type:${message.type}, "
          "messageID:${message.messageID}, "
          "localMessageID:${message.localMessageID}, "
          "senderUserID:${message.senderUserID}, "
          "conversationID:${message.conversationID}, "
          "direction:${message.direction}, "
          "sentStatus:${message.sentStatus}, "
          "conversationType:${message.conversationType}, "
          "timestamp:${message.timestamp}, "
          "conversationSeq:${message.conversationSeq}, "
          "orderKey:${message.orderKey}, "
          "isUserInserted:${message.isUserInserted}, "
          "receiptStatus:${message.receiptStatus}, ";
    })}, room id: $fromRoomID');

    messageList.removeWhere((message) => ZIMMessageType.text != message.type);
    List<Map<String, dynamic>> attributesInfoMap = [];
    for (var message in messageList) {
      var textMessage = message as ZIMTextMessage;
      attributesInfoMap.add({
        "messageID": textMessage.messageID,
        "timestamp": textMessage.timestamp,
        "orderKey": textMessage.orderKey,
        "senderUserID": textMessage.senderUserID,
        "text": textMessage.message,
      });
    }

    streamCtrlInRoomTextMessage.add({
      "messageList": attributesInfoMap,
    });
  }
}
