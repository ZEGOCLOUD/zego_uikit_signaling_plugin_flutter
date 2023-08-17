// Dart imports:
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/channel/zego_signaling_plugin_platform_interface.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/zego_signaling_plugin_core.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/zego_signaling_plugin_event_center.dart';
import 'package:zego_uikit_signaling_plugin/src/log/logger_service.dart';

export 'package:zego_zim/zego_zim.dart' hide ZIMEventHandler;

part 'src/zego_signaling_plugin_invitation.dart';

part 'src/zego_signaling_plugin_message.dart';

part 'src/zego_signaling_plugin_notification.dart';

part 'src/zego_signaling_plugin_room.dart';

part 'src/zego_signaling_plugin_user.dart';

part 'src/zego_signaling_plugin_background_message.dart';

part 'src/zego_signaling_plugin_callkit.dart';

/// @nodoc
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
  ZegoSignalingPluginEventCenter get eventCenter =>
      ZegoSignalingPluginCore().eventCenter;

  factory ZegoUIKitSignalingPlugin() => instance;

  ZegoUIKitSignalingPlugin._();

  static final ZegoUIKitSignalingPlugin instance = ZegoUIKitSignalingPlugin._();

  @override
  ZegoUIKitPluginType getPluginType() => ZegoUIKitPluginType.signaling;

  @override
  Future<String> getVersion() async {
    final zimVersion = await ZIM.getVersion();
    const signalingVersion = 'zego_uikit_signaling_plugin: 2.3.2;';
    if (!kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS)) {
      final zpnsVersion = await ZPNs.getVersion();
      return '$signalingVersion zim:$zimVersion; zpns:$zpnsVersion;';
    } else {
      return '$signalingVersion zim:$zimVersion;';
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

    if (null != ZIM.getInstance()) {
      ZegoSignalingLoggerService.logInfo(
        'ZIM is create before',
        tag: 'signaling',
        subTag: 'init',
      );

      return;
    }

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
    return ZegoSignalingPluginCore().eventCenter.errorEvent.stream;
  }
}
