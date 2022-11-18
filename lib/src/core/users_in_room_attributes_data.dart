// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'defines.dart';

mixin ZegoSignalingPluginCoreUsersInRoomAttributesData {
  ZIMRoomInfo? get _roomInfo =>
      ZegoSignalingPluginCore.shared.coreData.roomInfo;

  ZIM? get _zim => ZegoSignalingPluginCore.shared.coreData.zim;

  var streamCtrlUsersInRoomAttributes = StreamController<Map>.broadcast();

  Future<ZegoPluginResult> setUsersInRoomAttributes({
    required Map<String, String> attributes,
    required List<String> userIDs,
  }) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] query in-room attribute, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", "");
    }

    debugPrint(
        '[zim] set users in-room attributes, room id:${_roomInfo?.roomID}, '
        'user id:$userIDs, attributes:$attributes');

    late ZIMRoomMembersAttributesOperatedResult result;
    try {
      result = await _zim!.setRoomMembersAttributes(
        attributes,
        userIDs,
        _roomInfo!.roomID,
        ZIMRoomMemberAttributesSetConfig(),
      );
    } on PlatformException catch (error) {
      debugPrint(
          '[zim] set users in-room attributes error, ${error.code} ${error.message}');

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    debugPrint(
        '[zim] set users in-room attributes result, room id:${result.roomID}, '
        'error user ids:${result.errorUserList}');

    return ZegoPluginResult(
        result.errorUserList.isEmpty ? "" : "-2",
        result.errorUserList.isEmpty
            ? ""
            : "error users:${result.errorUserList.map((e) => "$e,")}",
        result.errorUserList);
  }

  Future<ZegoPluginResult> queryUsersInRoomAttributesList({
    required ZIMRoomMemberAttributesQueryConfig queryConfig,
  }) async {
    Map<String, Map<String, String>> infos = {};
    if (_roomInfo?.roomID.isEmpty ?? false) {
      debugPrint("[zim] query users in-room attribute, room id is empty");
      return ZegoPluginResult("-1", "room id is empty", infos);
    }

    debugPrint(
        "[zim] query users in-room attribute, room id:${_roomInfo?.roomID}, "
        "config: ${queryConfig.nextFlag} ${queryConfig.count}");

    late ZIMRoomMemberAttributesListQueriedResult result;
    try {
      result = await _zim!
          .queryRoomMemberAttributesList(_roomInfo!.roomID, queryConfig);
    } on PlatformException catch (error) {
      debugPrint(
          '[zim] query users in-room attributes error, ${error.code} ${error.message}');

      return ZegoPluginResult(error.code, error.message ?? "", infos);
    }

    for (var info in result.infos) {
      infos[info.userID] = info.attributes;
    }
    return ZegoPluginResult("", "", infos);
  }

  void onRoomMemberAttributesUpdated(
    ZIM zim,
    List<ZIMRoomMemberAttributesUpdateInfo> updateInfoList,
    ZIMRoomOperatedInfo operatedInfo,
    String roomID,
  ) {
    debugPrint(
        '[zim] onRoomMemberAttributesUpdated, updateInfo:${updateInfoList.map((updateInfo) {
      return "user id:${updateInfo.attributesInfo.userID}, attributes:${updateInfo.attributesInfo.attributes}";
    })}, editor: ${operatedInfo.userID}, room id: $roomID');

    Map<String, Map<String, String>> attributesInfoMap = {};
    for (var updateInfo in updateInfoList) {
      attributesInfoMap[updateInfo.attributesInfo.userID] =
          updateInfo.attributesInfo.attributes;
    }
    streamCtrlUsersInRoomAttributes.add({
      'editor': ZegoUIKit().getUser(operatedInfo.userID),
      'infos': attributesInfoMap,
    });
  }
}
