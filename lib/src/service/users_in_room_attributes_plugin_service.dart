// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginUsersInRoomAttributesService {
  Future<ZegoPluginResult> setUsersInRoomAttributes({
    required Map<String, String> attributes,
    required List<String> userIDs,
  }) async {
    userIDs.removeWhere((item) => ["", null].contains(item));
    if (userIDs.isEmpty) {
      debugPrint('[Error] users is empty');
      return ZegoPluginResult("", "", <String>[]);
    }

    return await ZegoSignalingPluginCore.shared.coreData
        .setUsersInRoomAttributes(attributes: attributes, userIDs: userIDs);
  }

  Future<ZegoPluginResult> queryUsersInRoomAttributesList({
    required ZIMRoomMemberAttributesQueryConfig queryConfig,
  }) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .queryUsersInRoomAttributesList(queryConfig: queryConfig);
  }

  Stream<Map> getUsersInRoomAttributesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlUsersInRoomAttributes.stream;
  }
}
