// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginUsersInRoomAttributesService {
  Future<ZegoPluginResult> setUsersInRoomAttributes({
    required String key,
    required String value,
    required List<String> userIDs,
  }) async {
    userIDs.removeWhere((item) => ["", null].contains(item));
    if (userIDs.isEmpty) {
      debugPrint('[Error] users is empty');
      return ZegoPluginResult("", "", <String>[]);
    }

    return await ZegoSignalingPluginCore.shared.coreData
        .setUsersInRoomAttributes(key: key, value: value, userIDs: userIDs);
  }

  Future<ZegoPluginResult> queryUsersInRoomAttributes({
    String nextFlag = '',
    int count = 100,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .queryUsersInRoomAttributes(
      nextFlag: nextFlag,
      count: count,
    );
  }

  Stream<Map> getUsersInRoomAttributesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlUsersInRoomAttributes.stream;
  }
}
