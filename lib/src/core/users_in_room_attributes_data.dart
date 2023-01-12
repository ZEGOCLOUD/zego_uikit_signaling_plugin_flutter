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

  /// send users in-room attributes
  Future<ZegoPluginResult> setUsersInRoomAttributes({
    required String key,
    required String value,
    required List<String> userIDs,
  }) async {
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "query in-room attribute, room id is empty",
        tag: "signal",
        subTag: "user in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", <String>[]);
    }

    ZegoLoggerService.logInfo(
      "set users in-room attributes, room id:\"${_roomInfo?.roomID}\", user id:$userIDs, key:$key, value:$value",
      tag: "signal",
      subTag: "user in-room properties",
    );

    late ZIMRoomMembersAttributesOperatedResult result;
    try {
      result = await _zim!.setRoomMembersAttributes(
        {key: value},
        userIDs,
        _roomInfo!.roomID,
        ZIMRoomMemberAttributesSetConfig(),
      );
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'set users in-room attributes error, ${error.code} ${error.message}',
        tag: "signal",
        subTag: "user in-room properties",
      );

      return ZegoPluginResult(error.code, error.message ?? "", <String>[]);
    }

    ZegoLoggerService.logInfo(
      "set users in-room attributes result, room id:\"${result.roomID},\" error user ids:${result.errorUserList}",
      tag: "signal",
      subTag: "user in-room properties",
    );

    return ZegoPluginResult(
        result.errorUserList.isEmpty ? "" : "-2",
        result.errorUserList.isEmpty
            ? ""
            : "error users:${result.errorUserList.map((e) => "$e,")}",
        result.errorUserList);
  }

  /// query users in-room attributes
  Future<ZegoPluginResult> queryUsersInRoomAttributes({
    String nextFlag = '',
    int count = 100,
  }) async {
    Map<String, Map<String, String>> infos = {};
    if (_roomInfo?.roomID.isEmpty ?? false) {
      ZegoLoggerService.logInfo(
        "query users in-room attribute, room id is empty",
        tag: "signal",
        subTag: "user in-room properties",
      );
      return ZegoPluginResult("-1", "room id is empty", infos);
    }

    ZegoLoggerService.logInfo(
      "query users in-room attribute, room id:\"${_roomInfo?.roomID}\", "
      "nextFlag: $nextFlag, count:$count",
      tag: "signal",
      subTag: "user in-room properties",
    );

    late ZIMRoomMemberAttributesListQueriedResult result;
    try {
      var config = ZIMRoomMemberAttributesQueryConfig();
      config.nextFlag = nextFlag;
      config.count = count;
      result =
          await _zim!.queryRoomMemberAttributesList(_roomInfo!.roomID, config);
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        'query users in-room attributes error, ${error.code} ${error.message}',
        tag: "signal",
        subTag: "user in-room properties",
      );

      return ZegoPluginResult(error.code, error.message ?? "", infos);
    }

    for (var info in result.infos) {
      infos[info.userID] = info.attributes;
    }
    ZegoLoggerService.logInfo(
      'query users in-room attributes finished, info:$infos',
      tag: "signal",
      subTag: "user in-room properties",
    );

    return ZegoPluginResult("", "", infos);
  }

  ///  on room member attributes updated
  void onRoomMemberAttributesUpdated(
    ZIM zim,
    List<ZIMRoomMemberAttributesUpdateInfo> updateInfoList,
    ZIMRoomOperatedInfo operatedInfo,
    String roomID,
  ) {
    ZegoLoggerService.logInfo(
      "onRoomMemberAttributesUpdated, updateInfo:${updateInfoList.map((updateInfo) {
        return "user id:${updateInfo.attributesInfo.userID}, attributes:${updateInfo.attributesInfo.attributes}";
      })}, editor: ${operatedInfo.userID}, room id: \"$roomID\"",
      tag: "signal",
      subTag: "user in-room properties",
    );

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
