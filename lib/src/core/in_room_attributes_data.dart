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

mixin ZegoSignalingPluginCoreInRoomAttributesData {
  ZIMRoomInfo? get _roomInfo =>
      ZegoSignalingPluginCore.shared.coreData.roomInfo;

  ZIM? get _zim => ZegoSignalingPluginCore.shared.coreData.zim;

  var streamCtrlRoomAttributes = StreamController<Map>.broadcast();
  var streamCtrlRoomBatchAttributes = StreamController<Map>.broadcast();

  ZegoPluginResult beginRoomAttributesBatchOperation({
    required ZIMRoomAttributesBatchOperationConfig config,
  }) {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] begin in-room attribute batch, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", "");
    }

    _zim!.beginRoomAttributesBatchOperation(_roomInfo!.roomID, config);
    return ZegoPluginResult.empty();
  }

  Future<ZegoPluginResult> setRoomAttributes({
    required Map<String, String> roomAttributes,
    required ZIMRoomAttributesSetConfig config,
  }) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] set in-room attribute, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", <String>[]);
    }

    debugPrint(
        "[zim] set in-room attribute: $roomAttributes, is force:${config.isForce}, is delete after owner left:${config.isDeleteAfterOwnerLeft}, is update owner:${config.isUpdateOwner}");

    late ZIMRoomAttributesOperatedCallResult result;
    try {
      result = await _zim!
          .setRoomAttributes(roomAttributes, _roomInfo!.roomID, config);
    } on PlatformException catch (error) {
      debugPrint(
          '[zim] set in-room attributes $roomAttributes error, ${error.code} ${error.message}');

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    debugPrint(
        '[zim] set in-room attributes $roomAttributes result, room id:${result.roomID}, error user ids:${result.errorKeys}');

    return ZegoPluginResult(
        result.errorKeys.isEmpty ? "" : "-2",
        result.errorKeys.isEmpty
            ? ""
            : "error keys:${result.errorKeys.map((e) => "$e,")}",
        result.errorKeys);
  }

  Future<ZegoPluginResult> deleteRoomAttributes({
    required List<String> keys,
    required ZIMRoomAttributesDeleteConfig config,
  }) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] delete in-room attribute, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", <String>[]);
    }

    debugPrint(
        "[zim] delete in-room attribute, keys:$keys, is force:${config.isForce}");

    late ZIMRoomAttributesOperatedCallResult result;
    try {
      result =
          await _zim!.deleteRoomAttributes(keys, _roomInfo!.roomID, config);
    } on PlatformException catch (error) {
      debugPrint(
          '[zim] delete in-room attributes error, ${error.code} ${error.message}');

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    debugPrint(
        '[zim] delete in-room attributes result, room id:${result.roomID}, '
        'error user ids:${result.errorKeys}');

    return ZegoPluginResult(
        result.errorKeys.isEmpty ? "" : "-2",
        result.errorKeys.isEmpty
            ? ""
            : "error keys:${result.errorKeys.map((e) => "$e,")}",
        result.errorKeys);
  }

  Future<ZegoPluginResult> endRoomAttributesBatchOperation() async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] query in-room attribute, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", "");
    }

    try {
      await _zim!.endRoomAttributesBatchOperation(_roomInfo!.roomID);
    } on PlatformException catch (error) {
      debugPrint(
          '[zim] query in-room attributes error, ${error.code} ${error.message}');

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    return ZegoPluginResult.empty();
  }

  Future<ZegoPluginResult> queryRoomAllAttributes() async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] query in-room attribute, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", <String, String>{});
    }

    debugPrint("[zim] query in-room attribute, room id:${_roomInfo?.roomID}");

    late ZIMRoomAttributesQueriedResult result;
    try {
      result = await _zim!.queryRoomAllAttributes(_roomInfo!.roomID);
    } on PlatformException catch (error) {
      debugPrint(
          '[zim] query in-room attributes error, ${error.code} ${error.message}');

      return ZegoPluginResult(
          error.code, error.message ?? "", <String, String>{});
    }

    return ZegoPluginResult("", "", result.roomAttributes);
  }

  void onRoomAttributesUpdated(
    ZIM zim,
    ZIMRoomAttributesUpdateInfo updateInfo,
    String roomID,
  ) {
    debugPrint(
        '[zim] onRoomAttributesUpdated, action:${updateInfo.action}, roomAttributes:${updateInfo.roomAttributes}, $roomID');

    Map<ZIMRoomAttributesUpdateAction, Map<String, String>> roomAttributes = {};
    roomAttributes[updateInfo.action] = updateInfo.roomAttributes;
    streamCtrlRoomAttributes.add(roomAttributes);
  }

  void onRoomAttributesBatchUpdated(
    ZIM zim,
    List<ZIMRoomAttributesUpdateInfo> updateInfoList,
    String roomID,
  ) {
    debugPrint(
        '[zim] onRoomAttributesBatchUpdated, updateInfo:${updateInfoList.map((updateInfo) {
      return "action:${updateInfo.action}, roomAttributes:${updateInfo.roomAttributes}";
    })}, $roomID');

    Map<ZIMRoomAttributesUpdateAction, List<Map<String, String>>>
        batchRoomAttributes = {};
    for (var updateInfo in updateInfoList) {
      if (batchRoomAttributes.containsKey(updateInfo.action)) {
        batchRoomAttributes[updateInfo.action]!.add(updateInfo.roomAttributes);
      } else {
        batchRoomAttributes[updateInfo.action] = [updateInfo.roomAttributes];
      }
    }
    streamCtrlRoomBatchAttributes.add(batchRoomAttributes);
  }

  void onGroupAttributesUpdated(
    ZIM zim,
    List<ZIMGroupAttributesUpdateInfo> updateInfoList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  ) {
    debugPrint(
        '[zim] onGroupAttributesUpdated, updateInfo:${updateInfoList.map((updateInfo) {
      return "action:${updateInfo.action}, groupAttributes:${updateInfo.groupAttributes}";
    })}, '
        'operatedInfo:$operatedInfo, $groupID');
  }
}
