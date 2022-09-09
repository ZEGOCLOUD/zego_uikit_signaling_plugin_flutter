// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/components/components.dart';
import 'package:zego_uikit_signal_plugin/src/components/internal/internal.dart';
import 'package:zego_uikit_signal_plugin/src/services/services.dart';
import 'package:zego_uikit_signal_plugin/src/plugins/call_invitation/internal/defines.dart';
import 'package:zego_uikit_signal_plugin/src/plugins/call_invitation/internal/page_manager.dart';
import 'package:zego_uikit_signal_plugin/src/plugins/call_invitation/prebuilt_call_invitation_defines.dart';

class ZegoSendCallInvitationButton extends StatefulWidget {
  final List<ZegoUIKitUser> invitees;
  final bool isVideoCall;

  final Size? buttonSize;
  final ButtonIcon? icon;
  final Size? iconSize;
  final String? text;
  final TextStyle? textStyle;
  final double? iconTextSpacing;
  final bool verticalLayout;

  final int timeoutSeconds;

  ///  You can do what you want after clicked.
  final void Function(bool)? onPressed;
  final Color? clickableTextColor;
  final Color? unclickableTextColor;
  final Color? clickableBackgroundColor;
  final Color? unclickableBackgroundColor;

  const ZegoSendCallInvitationButton({
    Key? key,
    required this.invitees,
    required this.isVideoCall,
    this.buttonSize,
    this.icon,
    this.iconSize,
    this.text,
    this.textStyle,
    this.iconTextSpacing,
    this.verticalLayout = true,
    this.timeoutSeconds = 60,
    this.onPressed,
    this.clickableTextColor = Colors.black,
    this.unclickableTextColor = Colors.black,
    this.clickableBackgroundColor = Colors.transparent,
    this.unclickableBackgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  State<ZegoSendCallInvitationButton> createState() =>
      _ZegoSendCallInvitationButtonState();
}

class _ZegoSendCallInvitationButtonState
    extends State<ZegoSendCallInvitationButton> {
  String? callID;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var timestamp =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString()}";
    callID = 'call_${ZegoSignalPlugin().getLocalUser().id}_$timestamp';
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ZegoStartInvitationButton(
          invitationType: ZegoInvitationTypeExtension(widget.isVideoCall
                  ? ZegoInvitationType.videoCall
                  : ZegoInvitationType.voiceCall)
              .value,
          invitees: widget.invitees.map((user) {
            return user.id;
          }).toList(),
          data: InvitationInternalData(callID!, widget.invitees).toJson(),
          icon: widget.icon ??
              ButtonIcon(
                icon: widget.isVideoCall
                    ? SignalPluginImage.asset(
                        InvitationStyleIconUrls.inviteVideo)
                    : SignalPluginImage.asset(
                        InvitationStyleIconUrls.inviteVoice),
              ),
          iconSize: widget.iconSize,
          text: widget.text,
          textStyle: widget.textStyle,
          iconTextSpacing: widget.iconTextSpacing,
          verticalLayout: widget.verticalLayout,
          buttonSize: widget.buttonSize,
          timeoutSeconds: widget.timeoutSeconds,
          onPressed: onPressed,
          clickableTextColor: widget.clickableTextColor,
          unclickableTextColor: widget.unclickableTextColor,
          clickableBackgroundColor: widget.clickableBackgroundColor,
          unclickableBackgroundColor: widget.unclickableBackgroundColor,
        );
      },
    );
  }

  void onPressed(bool result) {
    ZegoInvitationPageManager.instance.onLocalSendInvitation(
      result,
      callID!,
      widget.invitees,
      widget.isVideoCall
          ? ZegoInvitationType.videoCall
          : ZegoInvitationType.voiceCall,
    );

    if (widget.onPressed != null) {
      widget.onPressed!(result);
    }
  }
}
