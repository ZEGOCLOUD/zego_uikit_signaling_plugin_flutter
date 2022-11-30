// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'src/core/core.dart';
import 'src/service/service.dart';

export 'package:zego_zim/zego_zim.dart';

class ZegoUIKitSignalingPlugin implements IZegoUIKitPlugin {
  static final ZegoUIKitSignalingPlugin instance =
      ZegoUIKitSignalingPlugin._internal();

  factory ZegoUIKitSignalingPlugin() => instance;

  ZegoUIKitSignalingPlugin._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  ZegoPluginSignalingImpl impl = ZegoPluginSignalingImpl();

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
        await impl.init(
          appID: params['appID']! as int,
          appSign: params['appSign']! as String,
        );
        return {};
      case 'uninit':
        await impl.uninit();
        return {};
      case 'login':
        await impl.login(
          id: params['userID']! as String,
          name: params['userName']! as String,
        );
        return {};
      case 'logout':
        await impl.logout();
        return {};
      case 'joinRoom':
        var pluginResult = await impl.joinRoom(
          roomID: params['roomID']! as String,
          roomName: params['roomName']! as String,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      case 'leaveRoom':
        await impl.leaveRoom();
        return {};
      case 'sendInvitation':
        var pluginResult = await impl.sendInvitation(
          inviterName: params['inviterName']! as String,
          invitees: params['invitees']! as List<String>,
          timeout: params['timeout']! as int,
          type: params['type']! as int,
          data: params['data']! as String,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'errorInvitees': pluginResult.result as List<String>,
        };
      case 'cancelInvitation':
        var pluginResult = await impl.cancelInvitation(
          invitees: params['invitees']! as List<String>,
          data: params['data']! as String,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'errorInvitees': pluginResult.result as List<String>,
        };
      case 'refuseInvitation':
        var pluginResult = await impl.refuseInvitation(
          inviterID: params['inviterID']! as String,
          data: params['data']! as String,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      case 'acceptInvitation':
        var pluginResult = await impl.acceptInvitation(
          inviterID: params['inviterID']! as String,
          data: params['data']! as String,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      case 'setUsersInRoomAttributes':
        var pluginResult = await impl.setUsersInRoomAttributes(
          attributes: params['attributes']! as Map<String, String>,
          userIDs: params['userIDs']! as List<String>,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'errorUserList': pluginResult.result as List<String>,
        };
      case 'queryUsersInRoomAttributesList':
        var queryConfig = ZIMRoomMemberAttributesQueryConfig();
        queryConfig.nextFlag = params['nextFlag']! as String;
        queryConfig.count = params['count']! as int;
        var pluginResult = await impl.queryUsersInRoomAttributesList(
          queryConfig: queryConfig,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'infos': pluginResult.result as Map<String, Map<String, String>>,
        };
      case "beginRoomAttributesBatchOperation":
        var config = ZIMRoomAttributesBatchOperationConfig();
        config.isForce = params['isForce']! as bool;
        config.isDeleteAfterOwnerLeft =
            params['isDeleteAfterOwnerLeft']! as bool;
        config.isUpdateOwner = params['isUpdateOwner']! as bool;
        var pluginResult =
            impl.beginRoomAttributesBatchOperation(config: config);
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      case "endRoomAttributesBatchOperation":
        var pluginResult = await impl.endRoomAttributesBatchOperation();
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
        };
      case "setRoomAttributes":
        var config = ZIMRoomAttributesSetConfig();
        config.isForce = params['isForce']! as bool;
        config.isDeleteAfterOwnerLeft =
            params['isDeleteAfterOwnerLeft']! as bool;
        config.isUpdateOwner = params['isUpdateOwner']! as bool;
        var pluginResult = await impl.setRoomAttributes(
          roomAttributes: params['roomAttributes']! as Map<String, String>,
          config: config,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          "errorKeys": pluginResult.result as List<String>,
        };
      case "deleteRoomAttributes":
        var config = ZIMRoomAttributesDeleteConfig();
        config.isForce = params['isForce']! as bool;
        var pluginResult = await impl.deleteRoomAttributes(
          keys: params['keys']! as List<String>,
          config: config,
        );
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          "errorKeys": pluginResult.result as List<String>,
        };
      case 'queryRoomAllAttributes':
        var pluginResult = await impl.queryRoomAllAttributes();
        return {
          'code': pluginResult.code,
          "message": pluginResult.message,
          'roomAttributes': pluginResult.result as Map<String, String>,
        };
      default:
        throw UnimplementedError();
    }
  }

  @override
  Stream<Map> getEventStream(String name) {
    switch (name) {
      case 'invitationConnectionState':
        return impl.getInvitationConnectionStateStream();
      case 'roomState':
        return impl.getRoomStateStream();
      case 'invitationReceived':
        return impl.getInvitationReceivedStream();
      case 'invitationTimeout':
        return impl.getInvitationTimeoutStream();
      case 'invitationResponseTimeout':
        return impl.getInvitationResponseTimeoutStream();
      case 'invitationAccepted':
        return impl.getInvitationAcceptedStream();
      case 'invitationRefused':
        return impl.getInvitationRefusedStream();
      case 'invitationCanceled':
        return impl.getInvitationCanceledStream();
      case 'usersInRoomAttributes':
        return impl.getUsersInRoomAttributesStream();
      case 'roomAttributesStream':
        return impl.getRoomAttributesStream();
      case 'roomBatchAttributesStream':
        return impl.getRoomBatchAttributesStream();
      default:
        throw UnimplementedError();
    }
  }
}
