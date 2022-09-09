// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/services/defines/defines.dart';
import 'core/core.dart';
import 'defines/defines.dart';

part 'call_invitation_service.dart';

class ZegoSignalPlugin with ZegoInvitationService {
  ZegoSignalPlugin._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  factory ZegoSignalPlugin() => instance;
  static final ZegoSignalPlugin instance = ZegoSignalPlugin._internal();

  Future<String> getSignalPluginVersion() async {
    return await ZegoSignalCore.shared.getSignalPluginVersion();
  }

  Future<void> loadZim({required int appID, String appSign = ''}) async {
    return await ZegoSignalCore.shared.loadZim(appID: appID, appSign: appSign);
  }

  Future<void> unloadZim() async {
    return await ZegoSignalCore.shared.unloadZim();
  }

  Future<void> login(String id, String name) async {
    return await ZegoSignalCore.shared.login(id, name);
  }

  Future<void> logout() async {
    return await ZegoSignalCore.shared.logout();
  }

  ZegoUIKitUser getLocalUser() {
    return ZegoSignalCore.shared.getLocalUser();
  }
}
