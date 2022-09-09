// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/services/services.dart';

class ZegoAcceptInvitationButton extends StatefulWidget {
  final String inviterID;

  final String? text;
  final ButtonIcon? icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? iconTextSpacing;

  ///  You can do what you want after clicked.
  final VoidCallback? onPressed;

  const ZegoAcceptInvitationButton({
    Key? key,
    required this.inviterID,
    this.text,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.iconTextSpacing,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoAcceptInvitationButton> createState() =>
      _ZegoAcceptInvitationButtonState();
}

class _ZegoAcceptInvitationButtonState
    extends State<ZegoAcceptInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: onPressed,
      text: widget.text,
      icon: widget.icon,
      iconTextSpacing: widget.iconTextSpacing,
      iconSize: widget.iconSize,
      buttonSize: widget.buttonSize,
    );
  }

  void onPressed() {
    ZegoSignalPlugin().acceptInvitation(widget.inviterID, '');

    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
}
