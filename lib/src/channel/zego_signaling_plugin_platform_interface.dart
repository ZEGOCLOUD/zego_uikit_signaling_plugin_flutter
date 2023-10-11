import 'package:flutter/foundation.dart';

// Package imports:
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

// Project imports:
import 'zego_signaling_plugin_method_channel.dart';

/// @nodoc
abstract class ZegoSignalingPluginPlatform extends PlatformInterface {
  /// Constructs a ZegoSignalingPluginPlatform.
  ZegoSignalingPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZegoSignalingPluginPlatform _instance =
      MethodChannelZegoSignalingPlugin();

  /// The default instance of [ZegoSignalingPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelUntitled].
  static ZegoSignalingPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZegoSignalingPluginPlatform] when
  /// they register themselves.
  static set instance(ZegoSignalingPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> activeAudioByCallKit() {
    throw UnimplementedError('activeAudioByCallKit has not been implemented.');
  }

  Future<bool> checkAppRunning() {
    throw UnimplementedError('checkAppRunning has not been implemented.');
  }

  Future<void> addLocalNotification(
    ZegoSignalingPluginOutgoingNotificationConfig config,
  ) {
    throw UnimplementedError('addLocalNotification has not been implemented.');
  }

  Future<void> createNotificationChannel(
    ZegoSignalingPluginOutgoingNotificationChannelConfig config,
  ) {
    throw UnimplementedError(
        'createNotificationChannel has not been implemented.');
  }

  Future<void> dismissAllNotifications() {
    throw UnimplementedError(
        'dismissAllNotifications has not been implemented.');
  }

  Future<void> activeAppToForeground() {
    throw UnimplementedError('activeAppToForeground has not been implemented.');
  }

  Future<void> requestDismissKeyguard() {
    throw UnimplementedError(
        'requestDismissKeyguard has not been implemented.');
  }
}
