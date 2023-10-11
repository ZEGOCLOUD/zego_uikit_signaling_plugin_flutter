// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/log/logger_service.dart';
import 'zego_signaling_plugin_platform_interface.dart';

/// @nodoc
/// An implementation of [ZegoSignalingPluginPlatform] that uses method channels.
class MethodChannelZegoSignalingPlugin extends ZegoSignalingPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final _methodChannel = const MethodChannel('zego_uikit_signaling_plugin');

  @override
  Future<void> activeAudioByCallKit() async {
    if (Platform.isAndroid) {
      ZegoSignalingLoggerService.logInfo(
        'activeAudioByCallKit, not support in Android',
        tag: 'signaling',
        subTag: 'channel',
      );

      return;
    }

    ZegoSignalingLoggerService.logInfo(
      'activeAudioByCallKit',
      tag: 'signaling',
      subTag: 'channel',
    );

    await _methodChannel.invokeMethod<String>('activeAudioByCallKit');
  }

  @override
  Future<bool> checkAppRunning() async {
    if (Platform.isIOS) {
      ZegoSignalingLoggerService.logInfo(
        'checkAppRunning, not support in iOS',
        tag: 'signaling',
        subTag: 'channel',
      );

      return false;
    }

    ZegoSignalingLoggerService.logInfo(
      'checkAppRunning',
      tag: 'signaling',
      subTag: 'channel',
    );

    return await _methodChannel.invokeMethod<bool?>('checkAppRunning') ?? false;
  }

  @override
  Future<void> addLocalNotification(
    ZegoSignalingPluginOutgoingNotificationConfig config,
  ) async {
    if (Platform.isIOS) {
      ZegoSignalingLoggerService.logInfo(
        'addLocalNotification, not support in iOS',
        tag: 'signaling',
        subTag: 'channel',
      );
      return;
    }

    try {
      await _methodChannel.invokeMethod('addLocalNotification', {
        'id': config.id.toString(),
        'sound_source': config.soundSource ?? '',
        'icon_source': config.iconSource ?? '',
        'channel_id': config.channelID,
        'title': config.title,
        'content': config.content,
        'accept_text': config.acceptButtonText,
        'reject_text': config.rejectButtonText,
      });

      // 设置按钮回调
      _methodChannel.setMethodCallHandler((call) async {
        ZegoSignalingLoggerService.logInfo(
          'MethodCallHandler, method:${call.method}, arguments:${call.arguments}.',
          tag: 'signaling',
          subTag: 'channel',
        );

        switch (call.method) {
          case 'onNotificationAccepted':
            config.acceptCallback?.call();
            break;
          case 'onNotificationRejected':
            config.rejectCallback?.call();
            break;
          case 'onNotificationCancelled':
            config.cancelCallback?.call();
            break;
          case 'onNotificationClicked':
            config.clickCallback?.call();
        }
      });
    } on PlatformException catch (e) {
      ZegoSignalingLoggerService.logError(
        'Failed to add local notification: ${e.message}.',
        tag: 'signaling',
        subTag: 'channel',
      );
    }
  }

  @override
  Future<void> createNotificationChannel(
    ZegoSignalingPluginOutgoingNotificationChannelConfig config,
  ) async {
    if (Platform.isIOS) {
      ZegoSignalingLoggerService.logInfo(
        'createNotificationChannel, not support in iOS',
        tag: 'signaling',
        subTag: 'channel',
      );
      return;
    }

    try {
      await _methodChannel.invokeMethod('createNotificationChannel', {
        'channel_id': config.channelID,
        'channel_name': config.channelName,
        'sound_source': config.soundSource ?? '',
      });
    } on PlatformException catch (e) {
      ZegoSignalingLoggerService.logError(
        'Failed to create notification channel: ${e.message}.',
        tag: 'signaling',
        subTag: 'channel',
      );
    }
  }

  @override
  Future<void> dismissAllNotifications() async {
    if (Platform.isIOS) {
      ZegoSignalingLoggerService.logInfo(
        'dismissAllNotifications, not support in iOS',
        tag: 'signaling',
        subTag: 'channel',
      );
      return;
    }

    try {
      await _methodChannel.invokeMethod('dismissAllNotifications', {});
    } on PlatformException catch (e) {
      ZegoSignalingLoggerService.logError(
        'Failed to dismiss all notifications: ${e.message}.',
        tag: 'signaling',
        subTag: 'channel',
      );
    }
  }

  @override
  Future<void> activeAppToForeground() async {
    if (Platform.isIOS) {
      ZegoSignalingLoggerService.logInfo(
        'activeAppToForeground, not support in iOS',
        tag: 'signaling',
        subTag: 'channel',
      );
      return;
    }

    try {
      await _methodChannel.invokeMethod('activeAppToForeground', {});
    } on PlatformException catch (e) {
      ZegoSignalingLoggerService.logError(
        'Failed to active app to foreground: ${e.message}.',
        tag: 'signaling',
        subTag: 'channel',
      );
    }
  }

  @override
  Future<void> requestDismissKeyguard() async {
    if (Platform.isIOS) {
      ZegoSignalingLoggerService.logInfo(
        'requestDismissKeyguard, not support in iOS',
        tag: 'signaling',
        subTag: 'channel',
      );
      return;
    }

    try {
      await _methodChannel.invokeMethod('requestDismissKeyguard', {});
    } on PlatformException catch (e) {
      ZegoSignalingLoggerService.logError(
        'Failed to request dismiss keyguard: ${e.message}.',
        tag: 'signaling',
        subTag: 'channel',
      );
    }
  }
}
