// Dart imports:
import 'dart:async';
import 'dart:io'
    if (dart.library.html) 'dart:html'
    if (dart.library.io) 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/services.dart';
// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
// Project imports:
import 'package:zego_uikit_signaling_plugin/src/internal/zego_signaling_plugin_event_center.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zpns/zego_zpns.dart';

export 'package:zego_zim/zego_zim.dart' hide ZIMEventHandler;

part 'src/zego_signaling_plugin_invitation.dart';
part 'src/zego_signaling_plugin_message.dart';
part 'src/zego_signaling_plugin_notification.dart';
part 'src/zego_signaling_plugin_room.dart';
part 'src/zego_signaling_plugin_user.dart';

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
    if ((!kIsWeb) && (Platform.isAndroid || Platform.isIOS)) {
      final zpnsVersion = await ZPNs.getVersion();
      return 'signaling:2.0.0;zim:$zimVersion;zpns:$zpnsVersion;';
    } else {
      return 'signaling:2.0.0;zim:$zimVersion;';
    }
  }

  @override
  Future<void> init({required int appID, String appSign = ''}) async {
    ZIM.create(ZIMAppConfig()
      ..appID = appID
      ..appSign = appSign);
  }

  @override
  Future<void> uninit() async {
    ZIM.getInstance()?.destroy();
  }

  @override
  Stream<ZegoSignalingPluginErrorEvent> getErrorEventStream() {
    return eventCenter.errorEvent.stream;
  }

  final eventCenter = ZegoSignalingPluginEventCenter();
}
