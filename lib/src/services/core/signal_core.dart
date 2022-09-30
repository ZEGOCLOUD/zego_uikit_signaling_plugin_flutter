// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'zim/signal_core_zim.dart';

class ZegoSignalCore {
  static final ZegoSignalCore shared = ZegoSignalCore._internal();

  bool isInit = false;
  bool isNeedDisableWakelock = false;

  ZegoSignalCoreZimPlugin? zimPlugin;

  ZegoSignalCore._internal();

  Future<String> getSignalPluginVersion() async {
    var version = await zimPlugin?.getVersion();
    return "zego_zim:$version";
  }

  Future<void> loadZim({required int appID, String appSign = ''}) async {
    if (zimPlugin != null) {
      return;
    }

    zimPlugin = ZegoSignalCoreZimPlugin();
    zimPlugin?.create(appID: appID, appSign: appSign);
  }

  Future<void> unloadZim() async {
    return await zimPlugin?.destroy();
  }

  Future<void> login(String id, String name) async {
    await zimPlugin?.login(id, name);
  }

  ZegoUIKitUser getLocalUser() {
    return ZegoUIKitUser(
      id: zimPlugin?.loginUser?.userID ?? "",
      name: zimPlugin?.loginUser?.userName ?? "",
    );
  }

  Future<void> logout() async {
    await zimPlugin?.logout();
  }
}
