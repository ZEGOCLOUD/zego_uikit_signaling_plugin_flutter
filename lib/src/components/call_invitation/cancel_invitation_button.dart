// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/services/services.dart';

class ZegoCancelInvitationButton extends StatefulWidget {
  final List<String> invitees;

  final String? text;
  final ButtonIcon? icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? iconTextSpacing;

  ///  You can do what you want after clicked.
  final VoidCallback? onPressed;

  const ZegoCancelInvitationButton({
    Key? key,
    required this.invitees,
    this.text,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.iconTextSpacing,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoCancelInvitationButton> createState() =>
      _ZegoCancelInvitationButtonState();
}

class _ZegoCancelInvitationButtonState
    extends State<ZegoCancelInvitationButton> {
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
    ZegoSignalPlugin().cancelInvitation(widget.invitees, '');

    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
}
