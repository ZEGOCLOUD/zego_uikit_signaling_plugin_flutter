// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

class StreamDataInvitationReceived {
  final ZegoUIKitUser inviter;
  final int type; // call type
  final String data; // extended field

  StreamDataInvitationReceived(this.inviter, this.type, this.data);
}

class StreamDataInvitationTimeout {
  final ZegoUIKitUser inviter;
  final String data; // extended field

  StreamDataInvitationTimeout(this.inviter, this.data);
}

class StreamDataInvitationResponseTimeout {
  final List<ZegoUIKitUser> invitees;
  final String data; // extended field

  StreamDataInvitationResponseTimeout(this.invitees, this.data);
}

class StreamDataInvitationAccepted {
  final ZegoUIKitUser invitee;
  final String data; // extended field

  StreamDataInvitationAccepted(this.invitee, this.data);
}

class StreamDataInvitationRefused {
  final ZegoUIKitUser invitee;
  final String data; // extended field

  StreamDataInvitationRefused(this.invitee, this.data);
}

class StreamDataInvitationCanceled {
  final ZegoUIKitUser inviter;
  final String data; // extended field

  StreamDataInvitationCanceled(this.inviter, this.data);
}
