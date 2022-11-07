// Dart imports:
import 'dart:async';

// Project imports:
import 'signaling_core_data.dart';
import 'signaling_core_event.dart';

// Package imports:

class ZegoSignalingPluginCore with ZegoSignalingPluginCoreEvent {
  static ZegoSignalingPluginCore shared = ZegoSignalingPluginCore._internal();

  ZegoSignalingPluginCore._internal();

  ZegoSignalingPluginCoreData coreData = ZegoSignalingPluginCoreData();

  Future<String> getVersion() async {
    var version = await coreData.getVersion();
    return "zego_zim:$version; zego_uikit_signaling_plugin:1.0.12";
  }

  Future<void> init({required int appID, String appSign = ''}) async {
    initEventHandler();
    coreData.create(appID: appID, appSign: appSign);
  }

  Future<void> uninit() async {
    uninitEventHandler();
    return await coreData.destroy();
  }

  Future<void> login(String id, String name) async {
    await coreData.login(id, name);
  }

  Future<void> logout() async {
    await coreData.logout();
  }
}
