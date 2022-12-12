// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';
import 'in_room_attributes_plugin_service.dart';
import 'invitation_plugin_service.dart';
import 'message_service.dart';
import 'users_in_room_attributes_plugin_service.dart';

class ZegoPluginSignalingImpl
    with
        ZegoPluginInvitationService,
        ZegoPluginInRoomAttributesService,
        ZegoPluginUsersInRoomAttributesService,
        ZegoPluginMessageService {
  /// single instance
  static final ZegoPluginSignalingImpl shared =
      ZegoPluginSignalingImpl._internal();

  /// single instance
  factory ZegoPluginSignalingImpl() => shared;

  ZegoPluginSignalingImpl._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// init
  Future<void> init({
    required int appID,
    String appSign = '',
  }) async {
    return await ZegoSignalingPluginCore.shared
        .init(appID: appID, appSign: appSign);
  }

  /// uninit
  Future<void> uninit() async {
    return await ZegoSignalingPluginCore.shared.uninit();
  }

  /// login
  Future<void> login({
    required String id,
    required String name,
  }) async {
    return await ZegoSignalingPluginCore.shared.login(id, name);
  }

  /// logout
  Future<void> logout() async {
    return await ZegoSignalingPluginCore.shared.logout();
  }

  /// join room
  Future<ZegoPluginResult> joinRoom({
    required String roomID,
    required String roomName,
  }) async {
    return await ZegoSignalingPluginCore.shared.joinRoom(roomID, roomName);
  }

  /// leave room
  Future<void> leaveRoom() async {
    return await ZegoSignalingPluginCore.shared.leaveRoom();
  }
}
