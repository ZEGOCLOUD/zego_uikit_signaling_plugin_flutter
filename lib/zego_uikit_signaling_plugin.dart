// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'src/core/core.dart';
import 'src/service/invitation_plugin_service.dart';

class ZegoUIKitSignalingPlugin implements IZegoUIKitPlugin {
  static final ZegoUIKitSignalingPlugin instance =
      ZegoUIKitSignalingPlugin._internal();

  factory ZegoUIKitSignalingPlugin() => instance;

  ZegoUIKitSignalingPlugin._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  ZegoPluginInvitationService inviteService = ZegoPluginInvitationService();

  @override
  ZegoUIKitPluginType getPluginType() {
    return ZegoUIKitPluginType.signaling;
  }

  @override
  Future<String> getVersion() async {
    var zimVersion = await ZegoSignalingPluginCore.shared.getVersion();
    return "signaling_plugin:1.0.0;zim:$zimVersion";
  }

  @override
  Future<Map> invoke(String method, Map params) async {
    switch (method) {
      case 'init':
        await inviteService.init(
            appID: params['appID']!, appSign: params['appSign']!);
        return {};
      case 'uninit':
        await inviteService.uninit();
        return {};
      case 'login':
        await inviteService.login(
            id: params['userID']!, name: params['userName']!);
        return {};
      case 'logout':
        await inviteService.logout();
        return {};
      case 'sendInvitation':
        var pluginResult = await inviteService.sendInvitation(
          inviterName: params['inviterName']!,
          invitees: params['invitees']!,
          timeout: params['timeout']!,
          type: params['type']!,
          data: params['data']!,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'errorInvitees': pluginResult.result as List<String>,
        };
      case 'cancelInvitation':
        var pluginResult = await inviteService.cancelInvitation(
          invitees: params['invitees']!,
          data: params['data']!,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'errorInvitees': pluginResult.result as List<String>,
        };
      case 'refuseInvitation':
        var pluginResult = await inviteService.refuseInvitation(
          inviterID: params['inviterID']!,
          data: params['data']!,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      case 'acceptInvitation':
        var pluginResult = await inviteService.acceptInvitation(
          inviterID: params['inviterID']!,
          data: params['data']!,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      default:
        throw UnimplementedError();
    }
  }

  @override
  Stream<Map> getEventStream(String name) {
    switch (name) {
      case 'invitationConnectionState':
        return inviteService.getInvitationConnectionStateStream();
      case 'invitationReceived':
        return inviteService.getInvitationReceivedStream();
      case 'invitationTimeout':
        return inviteService.getInvitationTimeoutStream();
      case 'invitationResponseTimeout':
        return inviteService.getInvitationResponseTimeoutStream();
      case 'invitationAccepted':
        return inviteService.getInvitationAcceptedStream();
      case 'invitationRefused':
        return inviteService.getInvitationRefusedStream();
      case 'invitationCanceled':
        return inviteService.getInvitationCanceledStream();
      default:
        throw UnimplementedError();
    }
  }
}
