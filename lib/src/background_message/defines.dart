// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

String handlerCacheKey = 'zego_uikit_callkit_android_handler';

class ZegoSignalingPluginBackgroundMessageHandler {
  String key;
  ZegoSignalingPluginZPNsBackgroundMessageHandler callback;

  ZegoSignalingPluginBackgroundMessageHandler({
    required this.key,
    required this.callback,
  });
}
