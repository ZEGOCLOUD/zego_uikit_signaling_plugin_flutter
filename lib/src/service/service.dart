// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';
import 'in_room_attributes_plugin_service.dart';
import 'invitation_plugin_service.dart';

class ZegoUIKitSignalingPluginImpl
    with ZegoPluginInvitationService, ZegoPluginInRoomAttributesService {
  static final ZegoUIKitSignalingPluginImpl shared =
      ZegoUIKitSignalingPluginImpl._internal();

  factory ZegoUIKitSignalingPluginImpl() => shared;

  ZegoUIKitSignalingPluginImpl._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> init({
    required int appID,
    String appSign = '',
  }) async {
    return await ZegoSignalingPluginCore.shared
        .init(appID: appID, appSign: appSign);
  }

  Future<void> uninit() async {
    return await ZegoSignalingPluginCore.shared.uninit();
  }

  Future<void> login({
    required String id,
    required String name,
  }) async {
    return await ZegoSignalingPluginCore.shared.login(id, name);
  }

  Future<void> logout() async {
    return await ZegoSignalingPluginCore.shared.logout();
  }

  Future<ZegoPluginResult> joinRoom({
    required String roomID,
    required String roomName,
  }) async {
    return await ZegoSignalingPluginCore.shared.joinRoom(roomID, roomName);
  }

  Future<void> leaveRoom() async {
    return await ZegoSignalingPluginCore.shared.leaveRoom();
  }
}
