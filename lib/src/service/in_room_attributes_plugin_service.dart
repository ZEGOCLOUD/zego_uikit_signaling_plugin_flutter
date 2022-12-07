// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginInRoomAttributesService {
  ZegoPluginResult beginRoomPropertiesBatchOperation({
    required ZIMRoomAttributesBatchOperationConfig config,
  }) {
    return ZegoSignalingPluginCore.shared.coreData
        .beginRoomPropertiesBatchOperation(config: config);
  }

  Future<ZegoPluginResult> updateRoomProperties({
    required Map<String, String> roomAttributes,
    required ZIMRoomAttributesSetConfig config,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .updateRoomProperties(roomAttributes: roomAttributes, config: config);
  }

  Future<ZegoPluginResult> deleteRoomProperties({
    required List<String> keys,
    required ZIMRoomAttributesDeleteConfig config,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .deleteRoomProperties(keys: keys, config: config);
  }

  Future<ZegoPluginResult> endRoomPropertiesBatchOperation() async {
    return await ZegoSignalingPluginCore.shared.coreData
        .endRoomPropertiesBatchOperation();
  }

  Future<ZegoPluginResult> queryRoomProperties() async {
    return await ZegoSignalingPluginCore.shared.coreData.queryRoomProperties();
  }

  Stream<Map> getRoomPropertiesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlRoomProperties.stream;
  }

  Stream<Map> getRoomBatchPropertiesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlRoomBatchProperties.stream;
  }
}
