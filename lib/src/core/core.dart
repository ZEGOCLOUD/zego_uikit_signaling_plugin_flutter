// Dart imports:
import 'dart:async';

// Project imports:
import 'data.dart';
import 'defines.dart';
import 'event.dart';

// Package imports:

class ZegoSignalingPluginCore
    with
        ZegoSignalingPluginCoreEvent,
        ZegoSignalingPluginInvitationEvent,
        ZegoSignalingPluginAttributeEvent {
  static ZegoSignalingPluginCore shared = ZegoSignalingPluginCore._internal();

  ZegoSignalingPluginCore._internal();

  ZegoSignalingPluginCoreData coreData = ZegoSignalingPluginCoreData();

  Future<String> getVersion() async {
    var version = await coreData.getVersion();
    return "zego_zim:$version; zego_uikit_signaling_plugin:1.0.13";
  }

  Future<void> init({required int appID, String appSign = ''}) async {
    initCoreEventHandler();
    initInvitationEventHandler();
    initAttributeEventHandler();

    coreData.create(appID: appID, appSign: appSign);
  }

  Future<void> uninit() async {
    uninitCoreEventHandler();
    uninitInvitationEventHandler();
    uninitAttributeEventHandler();

    return await coreData.destroy();
  }

  Future<void> login(String id, String name) async {
    await coreData.login(id, name);
  }

  Future<void> logout() async {
    await coreData.logout();
  }

  Future<ZegoPluginResult> joinRoom(String roomID, String roomName) async {
    return await coreData.joinRoom(roomID, roomName);
  }

  Future<void> leaveRoom() async {
    await coreData.leaveRoom();
  }
}
