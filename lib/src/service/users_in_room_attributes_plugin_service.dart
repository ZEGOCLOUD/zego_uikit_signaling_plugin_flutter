// Flutter imports:

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginUsersInRoomAttributesService {
  /// set users in-room attributes
  Future<ZegoPluginResult> setUsersInRoomAttributes({
    required String key,
    required String value,
    required List<String> userIDs,
  }) async {
    userIDs.removeWhere((item) => ["", null].contains(item));
    if (userIDs.isEmpty) {
      ZegoLoggerService.logInfo(
        '[Error] users is empty',
        tag: "signal",
        subTag: "user in-room property service",
      );
      return ZegoPluginResult("", "", <String>[]);
    }

    return await ZegoSignalingPluginCore.shared.coreData
        .setUsersInRoomAttributes(key: key, value: value, userIDs: userIDs);
  }

  /// query users in-room attributes
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

  /// protocol:
  /// {
  /// 'editor': ZegoUIKitUser?
  /// 'infos': Map<String, Map<String, String>>,
  /// }
  Stream<Map> getUsersInRoomAttributesStream() {
    return ZegoSignalingPluginCore
        .shared.coreData.streamCtrlUsersInRoomAttributes.stream;
  }
}
