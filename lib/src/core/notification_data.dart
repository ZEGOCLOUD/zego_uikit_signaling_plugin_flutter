// Dart imports:
import 'dart:async';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'defines.dart';

mixin ZegoSignalingPluginCoreNotificationData {
  bool isNotificationInit = false;
  bool notifyWhenAppIsInTheBackgroundOrQuit = false;

  /// get version
  Future<String> getZpnsVersion() async {
    return await ZPNs.getVersion();
  }

  void initNotification() {
    if (isNotificationInit) {
      ZegoLoggerService.logInfo(
        "had init",
        tag: "signal",
        subTag: "notification",
      );
      return;
    }

    isNotificationInit = true;
    ZPNsEventHandler.onRegistered = (ZPNsRegisterMessage registerMessage) {
      ZegoLoggerService.logInfo(
        "onRegistered, push id:${registerMessage.pushID}, error code;${registerMessage.errorCode}",
        tag: "signal",
        subTag: "notification",
      );
    };

    ZPNsEventHandler.onNotificationArrived = (ZPNsMessage message) {
      ZegoLoggerService.logInfo(
        "onNotificationArrived, title:${message.title}, content:${message.content}, extendData:${message.extras}",
        tag: "signal",
        subTag: "notification",
      );
    };

    ZPNsEventHandler.onNotificationClicked = (ZPNsMessage message) {
      ZegoLoggerService.logInfo(
        "onNotificationClicked, title:${message.title}, content:${message.content}, extendData:${message.extras}",
        tag: "signal",
        subTag: "notification",
      );
    };
  }

  void uninitNotification() {
    isNotificationInit = false;

    ZPNsEventHandler.onRegistered = null;
    ZPNsEventHandler.onNotificationArrived = null;
    ZPNsEventHandler.onNotificationClicked = null;
  }

  /// enable notification
  Future<ZegoPluginResult> enableNotifyWhenAppRunningInBackgroundOrQuit(
    bool enabled,
    bool isIOSSandboxEnvironment,
  ) async {
    ZegoLoggerService.logInfo(
      "enable notify when app is in the background or quit: $enabled, is iOS development environment:$isIOSSandboxEnvironment",
      tag: "signal",
      subTag: "notification",
    );
    notifyWhenAppIsInTheBackgroundOrQuit = enabled;

    if (Platform.isAndroid) {
      ZPNsConfig zpnsConfig = ZPNsConfig();
      zpnsConfig.enableFCMPush = true;
      ZPNs.setPushConfig(zpnsConfig);

      // ZPNs.enableDebug();
    } else if (Platform.isIOS) {
      ZegoLoggerService.logInfo(
        "apply notification permission",
        tag: "signal",
        subTag: "notification",
      );

      await ZPNs.getInstance().applyNotificationPermission();
    }

    try {
      ZegoLoggerService.logInfo(
        "try register push",
        tag: "signal",
        subTag: "notification",
      );

      await ZPNs.getInstance()
          .registerPush(
              iOSEnvironment: isIOSSandboxEnvironment
                  ? ZPNsIOSEnvironment.Development
                  : ZPNsIOSEnvironment.Production)
          .then((value) {
        ZegoLoggerService.logInfo(
          "register push finished",
          tag: "signal",
          subTag: "notification",
        );
      });
    } on PlatformException catch (error) {
      ZegoLoggerService.logInfo(
        "register push error:${error.code}, ${error.message}",
        tag: "signal",
        subTag: "notification",
      );

      return ZegoPluginResult(error.code, error.message ?? "", "");
    }

    return ZegoPluginResult.empty();
  }
}
