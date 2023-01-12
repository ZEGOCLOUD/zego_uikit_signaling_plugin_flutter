// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'defines.dart';

mixin ZegoSignalingPluginCoreInRoomAttributesData {
  ZIMRoomInfo? get _roomInfo =>
      ZegoSignalingPluginCore.shared.coreData.roomInfo;

  ZIM? get _zim => ZegoSignalingPluginCore.shared.coreData.zim;

  var streamCtrlRoomProperties = StreamController<Map>.broadcast();
  var streamCtrlRoomBatchProperties = StreamController<Map>.broadcast();

  /// begin room properties batch operation
  ZegoPluginResult beginRoomPropertiesBatchOperation({
    required ZIMRoomAttributesBatchOperationConfig config,
  }) {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "begin in-room properties batch, room id is empty",
        tag: "signal",
        subTag: "in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", "");
    }

    _zim!.beginRoomAttributesBatchOperation(_roomInfo!.roomID, config);

    ZegoLoggerService.logInfo(
      'begin in-room properties batch operation',
      tag: "signal",
      subTag: "in-room properties",
    );

    return ZegoPluginResult.empty();
  }

  /// update room properties
  Future<ZegoPluginResult> updateRoomProperties({
    required Map<String, String> roomAttributes,
    required ZIMRoomAttributesSetConfig config,
  }) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "set in-room attribute, room id is empty",
        tag: "signal",
        subTag: "in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", <String>[]);
    }

    ZegoLoggerService.logInfo(
      "set in-room attribute: $roomAttributes, is force:${config.isForce}, is delete after owner left:${config.isDeleteAfterOwnerLeft}, is update owner:${config.isUpdateOwner}",
      tag: "signal",
      subTag: "in-room properties",
    );

    late ZIMRoomAttributesOperatedCallResult result;
    try {
      result = await _zim!
          .setRoomAttributes(roomAttributes, _roomInfo!.roomID, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'set in-room properties $roomAttributes error, ${error.code} ${error.message}',
        tag: "signal",
        subTag: "in-room properties",
      );

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    ZegoLoggerService.logInfo(
      "set in-room properties $roomAttributes result, room id:\"${result.roomID}\", error user ids:${result.errorKeys}",
      tag: "signal",
      subTag: "in-room properties",
    );

    return ZegoPluginResult(
        result.errorKeys.isEmpty ? "" : "-2",
        result.errorKeys.isEmpty
            ? ""
            : "error keys:${result.errorKeys.map((e) => "$e,")}",
        result.errorKeys);
  }

  /// delete room properties
  Future<ZegoPluginResult> deleteRoomProperties({
    required List<String> keys,
    required ZIMRoomAttributesDeleteConfig config,
  }) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "delete in-room attribute, room id is empty",
        tag: "signal",
        subTag: "in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", <String>[]);
    }

    ZegoLoggerService.logInfo(
      "delete in-room attribute, keys:$keys, is force:${config.isForce}",
      tag: "signal",
      subTag: "in-room properties",
    );

    late ZIMRoomAttributesOperatedCallResult result;
    try {
      result =
          await _zim!.deleteRoomAttributes(keys, _roomInfo!.roomID, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'delete in-room properties error, ${error.code} ${error.message}',
        tag: "signal",
        subTag: "in-room properties",
      );

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    ZegoLoggerService.logInfo(
      "delete in-room properties result, room id:\"${result.roomID}\", error user ids:${result.errorKeys}",
      tag: "signal",
      subTag: "in-room properties",
    );

    return ZegoPluginResult(
        result.errorKeys.isEmpty ? "" : "-2",
        result.errorKeys.isEmpty
            ? ""
            : "error keys:${result.errorKeys.map((e) => "$e,")}",
        result.errorKeys);
  }

  /// end room properties batch operation
  Future<ZegoPluginResult> endRoomPropertiesBatchOperation() async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "end room properties batch operation, room id is empty",
        tag: "signal",
        subTag: "in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", "");
    }

    ZegoLoggerService.logInfo(
      'try end in-room properties batch operation..',
      tag: "signal",
      subTag: "in-room properties",
    );
    try {
      await _zim!.endRoomAttributesBatchOperation(_roomInfo!.roomID);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'end in-room properties batch operation error, ${error.code} ${error.message}',
        tag: "signal",
        subTag: "in-room properties",
      );

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    ZegoLoggerService.logInfo(
      'end in-room properties batch operation finished',
      tag: "signal",
      subTag: "in-room properties",
    );

    return ZegoPluginResult.empty();
  }

  /// query room properties
  Future<ZegoPluginResult> queryRoomProperties() async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "query in-room attribute, room id is empty",
        tag: "signal",
        subTag: "in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", <String, String>{});
    }

    ZegoLoggerService.logInfo(
      "query in-room attribute, room id:\"${_roomInfo?.roomID}\"",
      tag: "signal",
      subTag: "in-room properties",
    );

    late ZIMRoomAttributesQueriedResult result;
    try {
      result = await _zim!.queryRoomAllAttributes(_roomInfo!.roomID);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'query in-room properties error, ${error.code} ${error.message}',
        tag: "signal",
        subTag: "in-room properties",
      );

      return ZegoPluginResult(
          error.code, error.message ?? "", <String, String>{});
    }

    ZegoLoggerService.logInfo(
      "query in-room properties result, room id:\"${result.roomID}\", properties:${result.roomAttributes}",
      tag: "signal",
      subTag: "in-room properties",
    );

    return ZegoPluginResult("", "", result.roomAttributes);
  }

  /// on room attributes updated
  void onRoomAttributesUpdated(
    ZIM zim,
    ZIMRoomAttributesUpdateInfo updateInfo,
    String roomID,
  ) {
    ZegoLoggerService.logInfo(
      'onRoomAttributesUpdated, action:${updateInfo.action}, roomAttributes:${updateInfo.roomAttributes}, $roomID',
      tag: "signal",
      subTag: "in-room properties",
    );

    Map<int, Map<String, String>> roomAttributes = {};
    roomAttributes[updateInfo.action.index] = updateInfo.roomAttributes;
    streamCtrlRoomProperties.add(roomAttributes);
  }

  /// on room attributes batch updated
  void onRoomAttributesBatchUpdated(
    ZIM zim,
    List<ZIMRoomAttributesUpdateInfo> updateInfoList,
    String roomID,
  ) {
    ZegoLoggerService.logInfo(
      'onRoomAttributesBatchUpdated, updateInfo:${updateInfoList.map((updateInfo) {
        return "action:${updateInfo.action}, roomAttributes:${updateInfo.roomAttributes}";
      })}, $roomID',
      tag: "signal",
      subTag: "in-room properties",
    );

    Map<int, List<Map<String, String>>> batchRoomAttributes = {};
    for (var updateInfo in updateInfoList) {
      if (batchRoomAttributes.containsKey(updateInfo.action)) {
        batchRoomAttributes[updateInfo.action.index]!
            .add(updateInfo.roomAttributes);
      } else {
        batchRoomAttributes[updateInfo.action.index] = [
          updateInfo.roomAttributes
        ];
      }
    }
    streamCtrlRoomBatchProperties.add(batchRoomAttributes);
  }

  /// on group attributes updated
  void onGroupAttributesUpdated(
    ZIM zim,
    List<ZIMGroupAttributesUpdateInfo> updateInfoList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  ) {
    ZegoLoggerService.logInfo(
      'onGroupAttributesUpdated, updateInfo:${updateInfoList.map((updateInfo) {
        return "action:${updateInfo.action}, groupAttributes:${updateInfo.groupAttributes}";
      })}, operatedInfo:$operatedInfo, $groupID',
      tag: "signal",
      subTag: "in-room properties",
    );
  }
}
