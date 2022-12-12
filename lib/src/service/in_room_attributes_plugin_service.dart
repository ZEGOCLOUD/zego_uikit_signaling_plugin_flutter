// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginInRoomAttributesService {
  /// begin room properties batch operation
  ZegoPluginResult beginRoomPropertiesBatchOperation({
    required ZIMRoomAttributesBatchOperationConfig config,
  }) {
    return ZegoSignalingPluginCore.shared.coreData
        .beginRoomPropertiesBatchOperation(config: config);
  }

  /// update room properties
  Future<ZegoPluginResult> updateRoomProperties({
    required Map<String, String> roomAttributes,
    required ZIMRoomAttributesSetConfig config,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .updateRoomProperties(roomAttributes: roomAttributes, config: config);
  }

  /// delete room properties
  Future<ZegoPluginResult> deleteRoomProperties({
    required List<String> keys,
    required ZIMRoomAttributesDeleteConfig config,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .deleteRoomProperties(keys: keys, config: config);
  }

  /// end room properties batch operation
  Future<ZegoPluginResult> endRoomPropertiesBatchOperation() async {
    return await ZegoSignalingPluginCore.shared.coreData
        .endRoomPropertiesBatchOperation();
  }

  /// query room properties
  Future<ZegoPluginResult> queryRoomProperties() async {
    return await ZegoSignalingPluginCore.shared.coreData.queryRoomProperties();
  }

  /// Map<int(ZIMRoomAttributesUpdateAction), Map<String, String>>
  Stream<Map> getRoomPropertiesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlRoomProperties.stream;
  }

  /// Map<int(ZIMRoomAttributesUpdateAction), List<Map<String, String>>>
  Stream<Map> getRoomBatchPropertiesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlRoomBatchProperties.stream;
  }
}
