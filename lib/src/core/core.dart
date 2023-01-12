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
        ZegoSignalingPluginAttributeEvent,
        ZegoSignalingPluginMessageEvent {
  /// single instance
  static ZegoSignalingPluginCore shared = ZegoSignalingPluginCore._internal();

  /// single instance
  ZegoSignalingPluginCore._internal();

  /// single instance
  ZegoSignalingPluginCoreData coreData = ZegoSignalingPluginCoreData();

  /// get version
  Future<String> getVersion() async {
    var zimVersion = await coreData.getZIMVersion();
    var zpnsVersion = await coreData.getZpnsVersion();
    return "zego_zim:$zimVersion; zego_zpns:$zpnsVersion; zego_uikit_signaling_plugin:1.4.0";
  }

  /// init
  Future<void> init({required int appID, String appSign = ''}) async {
    initCoreEventHandler();
    initInvitationEventHandler();
    initAttributeEventHandler();
    initMessageEventHandler();

    await coreData.create(appID: appID, appSign: appSign);
  }

  /// uninit
  Future<void> uninit() async {
    uninitCoreEventHandler();
    uninitInvitationEventHandler();
    uninitAttributeEventHandler();
    uninitMessageEventHandler();

    return await coreData.destroy();
  }

  /// login
  Future<void> login(String id, String name) async {
    await coreData.login(id, name);
  }

  /// logout
  Future<void> logout() async {
    await coreData.logout();
  }

  /// join room
  Future<ZegoPluginResult> joinRoom(String roomID, String roomName) async {
    return await coreData.joinRoom(roomID, roomName);
  }

  /// leave room
  Future<void> leaveRoom() async {
    await coreData.leaveRoom();
  }
}
