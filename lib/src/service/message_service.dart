// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginMessageService {
  /// send in-room text message
  Future<ZegoPluginResult> sendInRoomTextMessage(String text) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .sendInRoomTextMessage(text);
  }

  /// get in-room text message notifier
  Stream<Map> getInRoomTextMessageStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlInRoomTextMessage.stream;
  }
}
