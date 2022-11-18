// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginInRoomAttributesService {
  ZegoPluginResult beginRoomAttributesBatchOperation({
    required ZIMRoomAttributesBatchOperationConfig config,
  }) {
    return ZegoSignalingPluginCore.shared.coreData
        .beginRoomAttributesBatchOperation(config: config);
  }

  Future<ZegoPluginResult> setRoomAttributes({
    required Map<String, String> roomAttributes,
    required ZIMRoomAttributesSetConfig config,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .setRoomAttributes(roomAttributes: roomAttributes, config: config);
  }

  Future<ZegoPluginResult> deleteRoomAttributes({
    required List<String> keys,
    required ZIMRoomAttributesDeleteConfig config,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .deleteRoomAttributes(keys: keys, config: config);
  }

  Future<ZegoPluginResult> endRoomAttributesBatchOperation() async {
    return await ZegoSignalingPluginCore.shared.coreData
        .endRoomAttributesBatchOperation();
  }

  Future<ZegoPluginResult> queryRoomAllAttributes() async {
    return await ZegoSignalingPluginCore.shared.coreData
        .queryRoomAllAttributes();
  }

  Stream<Map> getRoomAttributesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlRoomAttributes.stream;
  }

  Stream<Map> getRoomBatchAttributesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlRoomBatchAttributes.stream;
  }
}
