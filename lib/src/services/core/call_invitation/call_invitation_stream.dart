// Dart imports:
import 'dart:async';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/services/defines/defines.dart';

mixin ZegoCallInvitationStream {
  var streamCtrlInvitationReceived =
      StreamController<StreamDataInvitationReceived>.broadcast();

  var streamCtrlInvitationTimeout =
      StreamController<StreamDataInvitationTimeout>.broadcast();

  var streamCtrlInvitationResponseTimeout =
      StreamController<StreamDataInvitationResponseTimeout>.broadcast();

  var streamCtrlInvitationAccepted =
      StreamController<StreamDataInvitationAccepted>.broadcast();

  var streamCtrlInvitationRefused =
      StreamController<StreamDataInvitationRefused>.broadcast();

  var streamCtrlInvitationCanceled =
      StreamController<StreamDataInvitationCanceled>.broadcast();
}
