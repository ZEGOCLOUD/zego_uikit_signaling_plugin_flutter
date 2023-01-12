// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'src/core/core.dart';
import 'src/core/defines.dart';
import 'src/service/service.dart';

export 'package:zego_zim/zego_zim.dart';

class ZegoUIKitSignalingPlugin implements IZegoUIKitPlugin {
  /// single instance
  static final ZegoUIKitSignalingPlugin instance =
      ZegoUIKitSignalingPlugin._internal();

  /// single instance
  factory ZegoUIKitSignalingPlugin() => instance;

  /// single instance
  ZegoUIKitSignalingPlugin._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// single instance
  ZegoPluginSignalingImpl impl = ZegoPluginSignalingImpl();

  @override
  ZegoUIKitPluginType getPluginType() {
    return ZegoUIKitPluginType.signaling;
  }

  @override
  Future<String> getVersion() async {
    var zimVersion = await ZegoSignalingPluginCore.shared.getVersion();
    return "version: signal:$zimVersion";
  }

  @override
  Future<Map> invoke(String method, Map params) async {
    ZegoLoggerService.logInfo(
      "invoke, method:$method, params:$params",
      tag: "signal",
      subTag: "invoke",
    );

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
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
        };
      case 'leaveRoom':
        await impl.leaveRoom();
        return {};
      case 'sendInvitation':
        var notificationConfigMap =
            params['notificationConfig'] as Map<String, dynamic>? ?? {};
        ZegoNotificationConfig? notificationConfig;
        if (ZegoSignalingPluginCore
            .shared.coreData.notifyWhenAppIsInTheBackgroundOrQuit) {
          notificationConfig = ZegoNotificationConfig(
            notifyWhenAppIsInTheBackgroundOrQuit: true,
            resourceID: notificationConfigMap['resourceID'] as String? ?? "",
            title: notificationConfigMap['title'] as String? ?? "",
            message: notificationConfigMap['message'] as String? ?? "",
          );
        }
        var pluginResult = await impl.sendInvitation(
          inviterName: params['inviterName']! as String,
          invitees: params['invitees']! as List<String>,
          timeout: params['timeout']! as int,
          type: params['type']! as int,
          data: params['data']! as String,
          notificationConfig: notificationConfig,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          'result': pluginResult.result as Map<String, dynamic>,
        };
      case 'cancelInvitation':
        var pluginResult = await impl.cancelInvitation(
          invitees: params['invitees']! as List<String>,
          data: params['data']! as String,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          'errorInvitees': pluginResult.result as List<String>,
        };
      case 'refuseInvitation':
        var pluginResult = await impl.refuseInvitation(
          inviterID: params['inviterID']! as String,
          data: params['data']! as String,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
        };
      case 'acceptInvitation':
        var pluginResult = await impl.acceptInvitation(
          inviterID: params['inviterID']! as String,
          data: params['data']! as String,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
        };
      case 'setUsersInRoomAttributes':
        var pluginResult = await impl.setUsersInRoomAttributes(
          key: params['key']! as String,
          value: params['value']! as String,
          userIDs: params['userIDs']! as List<String>,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          'errorUserList': pluginResult.result as List<String>,
        };
      case 'queryUsersInRoomAttributes':
        var pluginResult = await impl.queryUsersInRoomAttributes(
          nextFlag: params['nextFlag']! as String,
          count: params['count']! as int,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          'infos': pluginResult.result as Map<String, Map<String, String>>,
        };
      case "beginRoomPropertiesBatchOperation":
        var config = ZIMRoomAttributesBatchOperationConfig();
        config.isForce = params['isForce']! as bool;
        config.isDeleteAfterOwnerLeft =
            params['isDeleteAfterOwnerLeft']! as bool;
        config.isUpdateOwner = params['isUpdateOwner']! as bool;
        var pluginResult =
            impl.beginRoomPropertiesBatchOperation(config: config);
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
        };
      case "endRoomPropertiesBatchOperation":
        var pluginResult = await impl.endRoomPropertiesBatchOperation();
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
        };
      case "updateRoomProperty":
        var config = ZIMRoomAttributesSetConfig();
        config.isForce = params['isForce']! as bool;
        config.isDeleteAfterOwnerLeft =
            params['isDeleteAfterOwnerLeft']! as bool;
        config.isUpdateOwner = params['isUpdateOwner']! as bool;
        var pluginResult = await impl.updateRoomProperties(
          roomAttributes: {
            params['key']! as String: params['value']! as String
          },
          config: config,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          "errorKeys": pluginResult.result as List<String>,
        };
      case "deleteRoomProperties":
        var config = ZIMRoomAttributesDeleteConfig();
        config.isForce = params['isForce']! as bool;
        var pluginResult = await impl.deleteRoomProperties(
          keys: params['keys']! as List<String>,
          config: config,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          "errorKeys": pluginResult.result as List<String>,
        };
      case 'queryRoomProperties':
        var pluginResult = await impl.queryRoomProperties();
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
          'roomAttributes': pluginResult.result as Map<String, String>,
        };
      // case 'sendInRoomTextMessage':
      //   var pluginResult =
      //       await impl.sendInRoomTextMessage(params['text']! as String);
      //   return {
      //     "errorCode": pluginResult.code,
      //     "errorMessage": pluginResult.message,
      //   };
      case 'enableNotifyWhenAppRunningInBackgroundOrQuit':
        var pluginResult =
            await impl.enableNotifyWhenAppRunningInBackgroundOrQuit(
          params['enabled']! as bool,
          params['isIOSSandboxEnvironment']! as bool,
        );
        return {
          "errorCode": pluginResult.code,
          "errorMessage": pluginResult.message,
        };
      default:
        throw UnimplementedError();
    }
  }

  @override
  Stream<Map> getEventStream(String name) {
    switch (name) {
      case 'connectionState':
        return impl.getConnectionStateStream();
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
      case 'roomPropertiesStream':
        return impl.getRoomPropertiesStream();
      case 'roomBatchPropertiesStream':
        return impl.getRoomBatchPropertiesStream();
      case 'inRoomTextMessageStream':
        return impl.getInRoomTextMessageStream();
      default:
        throw UnimplementedError();
    }
  }
}
