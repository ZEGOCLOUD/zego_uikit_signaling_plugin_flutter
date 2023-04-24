import 'package:zego_uikit_signaling_plugin/src/internal/zego_signaling_plugin_event_center.dart';
import 'package:zego_zim/zego_zim.dart';

class ZegoSignalingPluginCore {
  factory ZegoSignalingPluginCore() => _instance;

  ZegoSignalingPluginCore._() {
    eventCenter.init();
  }

  bool get isLogin => currentUser != null;

  ZIMUserInfo? currentUser;
  final eventCenter = ZegoSignalingPluginEventCenter();

  static final _instance = ZegoSignalingPluginCore._();
}
