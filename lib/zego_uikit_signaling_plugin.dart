// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'src/core/core.dart';
import 'src/service/invitation_plugin_service.dart';

export 'package:zego_uikit/zego_uikit.dart';

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
        var errorInvitees = await inviteService.sendInvitation(
          inviterName: params['inviterName']!,
          invitees: params['invitees']!,
          timeout: params['timeout']!,
          type: params['type']!,
          data: params['data']!,
        );
        return {'errorInvitees': errorInvitees};
      case 'cancelInvitation':
        var errorInvitees = await inviteService.cancelInvitation(
          invitees: params['invitees']!,
          data: params['data']!,
        );
        return {'errorInvitees': errorInvitees};
      case 'refuseInvitation':
        await inviteService.refuseInvitation(
          inviterID: params['inviterID']!,
          data: params['data']!,
        );
        return {};
      case 'acceptInvitation':
        await inviteService.acceptInvitation(
          inviterID: params['inviterID']!,
          data: params['data']!,
        );
        return {};
      default:
        throw UnimplementedError();
    }
  }

  @override
  Stream<Map> getEventStream(String name) {
    switch (name) {
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
