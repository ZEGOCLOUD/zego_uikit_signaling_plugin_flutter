// Project imports:
import 'package:zego_uikit_signaling_plugin/src/core/core.dart';
import 'package:zego_uikit_signaling_plugin/src/core/defines.dart';

mixin ZegoPluginNotificationService {
  /// enable notification
  Future<ZegoPluginResult> enableNotifyWhenAppRunningInBackgroundOrQuit(
    bool enabled,
    bool isIOSSandboxEnvironment,
  ) async {
    return await ZegoSignalingPluginCore.shared.coreData
        .enableNotifyWhenAppRunningInBackgroundOrQuit(
      enabled,
      isIOSSandboxEnvironment,
    );
  }
}
