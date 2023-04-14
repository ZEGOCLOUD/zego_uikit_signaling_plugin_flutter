// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/internal/log/logger_service.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/zego_signaling_plugin_event_center.dart';

import 'dart:io'
    if (dart.library.html) 'dart:html'
    if (dart.library.io) 'dart:io';

export 'package:zego_zim/zego_zim.dart' hide ZIMEventHandler;

part 'src/zego_signaling_plugin_invitation.dart';

part 'src/zego_signaling_plugin_message.dart';

part 'src/zego_signaling_plugin_notification.dart';

part 'src/zego_signaling_plugin_room.dart';

part 'src/zego_signaling_plugin_user.dart';

part 'src/zego_signaling_plugin_background_message.dart';

part 'src/zego_signaling_plugin_callkit.dart';

class ZegoUIKitSignalingPlugin
    with
        ZegoSignalingPluginRoomAPIImpl,
        ZegoSignalingPluginRoomEventImpl,
        ZegoSignalingPluginInvitationAPIImpl,
        ZegoSignalingPluginInvitationEventImpl,
        ZegoSignalingPluginUserAPIImpl,
        ZegoSignalingPluginUserEventImpl,
        ZegoSignalingPluginNotificationAPIImpl,
        ZegoSignalingPluginNotificationEventImpl,
        ZegoSignalingPluginMessageAPIImpl,
        ZegoSignalingPluginMessageEventImpl,
        ZegoSignalingPluginBackgroundMessageAPIImpl,
        ZegoSignalingPluginBackgroundMessageEventImpl,
        ZegoSignalingPluginCallKitAPIImpl,
        ZegoSignalingPluginCallKitEventImpl,
        IZegoUIKitPlugin
    implements ZegoSignalingPluginInterface {
  factory ZegoUIKitSignalingPlugin() => instance;

  ZegoUIKitSignalingPlugin._();

  static final ZegoUIKitSignalingPlugin instance = ZegoUIKitSignalingPlugin._();

  @override
  ZegoUIKitPluginType getPluginType() => ZegoUIKitPluginType.signaling;

  @override
  Future<String> getVersion() async {
    final zimVersion = await ZIM.getVersion();
    if (Platform.isAndroid || Platform.isIOS) {
      final zpnsVersion = await ZPNs.getVersion();
      return 'zego_uikit_signaling_plugin: 2.1.0; zim:$zimVersion; zpns:$zpnsVersion;';
    } else {
      return 'zego_uikit_signaling_plugin: 2.1.0; zim:$zimVersion;';
    }
  }

  @override
  Future<void> init({required int appID, String appSign = ''}) async {
    await ZegoSignalingLoggerService().initLog();

    ZegoSignalingLoggerService.logInfo(
      'create ZIM',
      tag: 'signaling',
      subTag: 'init',
    );

    ZIM.create(ZIMAppConfig()
      ..appID = appID
      ..appSign = appSign);
  }

  @override
  Future<void> uninit() async {
    ZegoSignalingLoggerService.logInfo(
      'destroy ZIM',
      tag: 'signaling',
      subTag: 'init',
    );

    ZIM.getInstance()?.destroy();
  }

  @override
  Stream<ZegoSignalingPluginErrorEvent> getErrorEventStream() {
    return eventCenter.errorEvent.stream;
  }

  final eventCenter = ZegoSignalingPluginEventCenter();
}
