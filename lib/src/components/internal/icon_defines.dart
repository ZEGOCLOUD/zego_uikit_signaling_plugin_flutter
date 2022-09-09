// Flutter imports:
import 'package:flutter/material.dart';

class SignalPluginImage {
  static Image asset(String name) {
    return Image.asset(name, package: "zego_uikit_signal_plugin");
  }
}

class InvitationStyleIconUrls {
  static const String inviteVoice = 'assets/icons/invite_voice.png';
  static const String inviteVideo = 'assets/icons/invite_video.png';
  static const String inviteReject = 'assets/icons/invite_reject.png';
  static const String inviteBackground = 'assets/icons/invite_background.png';

  static const String toolbarBottomVideo =
      'assets/icons/toolbar_bottom_video.png';
  static const String toolbarBottomVoice =
      'assets/icons/toolbar_bottom_voice.png';
  static const String toolbarBottomDecline =
      'assets/icons/toolbar_bottom_decline.png';
  static const String toolbarBottomCancel =
      'assets/icons/toolbar_bottom_cancel.png';
  static const String toolbarBottomEnd =
      'assets/icons/toolbar_bottom_cancel.png';
  static const String toolbarTopSwitchCamera =
      'assets/icons/toolbar_top_switch_camera.png';
}
