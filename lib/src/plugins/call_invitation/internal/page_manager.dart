// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'package:zego_uikit_signal_plugin/src/plugins/call_invitation/prebuilt_call_invitation.dart';
import 'package:zego_uikit_signal_plugin/src/plugins/call_invitation/prebuilt_call_invitation_defines.dart';
import 'package:zego_uikit_signal_plugin/src/services/services.dart';
import 'defines.dart';
import 'notification_ring.dart';
import 'pages/calling_machine.dart';
import 'pages/invitation_notify.dart';

typedef ContextQuery = BuildContext Function();

class ZegoInvitationPageManager {
  factory ZegoInvitationPageManager() => instance;
  static final ZegoInvitationPageManager instance =
      ZegoInvitationPageManager._internal();

  ZegoInvitationPageManager._internal();

  String defaultPackagePrefix = 'packages/zego_uikit_signal_plugin/';

  late int appID;
  late String appSign;
  late String userID;
  late String userName;
  late String tokenServerUrl;
  late ConfigQuery configQuery;
  late ContextQuery
      contextQuery; // we need a context object, to push/pop page when receive invitation request

  var callerRingtone = ZegoRingtone();
  var calleeRingtone = ZegoRingtone();

  late ZegoCallingMachine callingMachine;
  bool invitationTopSheetVisibility = false;
  List<StreamSubscription<dynamic>> streamSubscriptions = [];

  ZegoCallInvitationData invitationData = ZegoCallInvitationData.empty();
  List<ZegoUIKitUser> acceptInvitees = [];
  List<ZegoUIKitUser> refuseInvitees = [];
  List<ZegoUIKitUser> timeoutInvitees = [];

  bool get isGroupCall => invitationData.invitees.length > 1;

  Future<void> init({
    required int appID,
    String appSign = '',
    String tokenServerUrl = '',
    required String userID,
    required String userName,
    required ConfigQuery configQuery,
    required ContextQuery contextQuery,
    required ZegoRingtoneConfig ringtoneConfig,
  }) async {
    this.appID = appID;
    this.appSign = appSign;
    this.userID = userID;
    this.userName = userName;
    this.configQuery = configQuery;
    this.tokenServerUrl = tokenServerUrl;
    this.contextQuery = contextQuery;

    listenStream();

    callingMachine = ZegoCallingMachine();
    callingMachine.init();

    initRing(ringtoneConfig);

    debugPrint(
        'init, appID:$appID, appSign:$appSign, tokenServerUrl:$tokenServerUrl, userID:$userID, userName:$userName');
  }

  void uninit() {
    removeStreamListener();
  }

  void initRing(ZegoRingtoneConfig ringtoneConfig) {
    if (ringtoneConfig.callerPath != null) {
      debugPrint("reset caller ring, source path:${ringtoneConfig.callerPath}");
      callerRingtone.init(
        prefix: "",
        sourcePath: ringtoneConfig.callerPath!,
        isVibrate: false,
      );
    } else {
      callerRingtone.init(
        prefix: defaultPackagePrefix,
        sourcePath: "assets/audio/callerRing.mp3",
        isVibrate: false,
      );
    }
    if (ringtoneConfig.calleePath != null) {
      debugPrint("reset callee ring, source path:${ringtoneConfig.calleePath}");
      calleeRingtone.init(
        prefix: "",
        sourcePath: ringtoneConfig.calleePath!,
        isVibrate: true,
      );
    } else {
      calleeRingtone.init(
        prefix: defaultPackagePrefix,
        sourcePath: "assets/audio/calleeRing.wav",
        isVibrate: true,
      );
    }
  }

  void listenStream() {
    streamSubscriptions.add(ZegoSignalPlugin()
        .getInvitationReceivedStream()
        .listen(onInvitationReceived));
    streamSubscriptions.add(ZegoSignalPlugin()
        .getInvitationAcceptedStream()
        .listen(onInvitationAccepted));
    streamSubscriptions.add(ZegoSignalPlugin()
        .getInvitationTimeoutStream()
        .listen(onInvitationTimeout));
    streamSubscriptions.add(ZegoSignalPlugin()
        .getInvitationResponseTimeoutStream()
        .listen(onInvitationResponseTimeout));
    streamSubscriptions.add(ZegoSignalPlugin()
        .getInvitationRefusedStream()
        .listen(onInvitationRefused));
    streamSubscriptions.add(ZegoSignalPlugin()
        .getInvitationCanceledStream()
        .listen(onInvitationCanceled));
  }

  void removeStreamListener() {
    for (var streamSubscription in streamSubscriptions) {
      streamSubscription.cancel();
    }
  }

  void onLocalSendInvitation(
    bool result,
    String callID,
    List<ZegoUIKitUser> invitees,
    ZegoInvitationType invitationType,
  ) {
    invitationData.callID = callID;
    invitationData.inviter = ZegoSignalPlugin().getLocalUser();
    invitationData.invitees = invitees;
    invitationData.type = invitationType;

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    if (result) {
      callerRingtone.startRing();

      if (isGroupCall) {
        /// group call, enter room directly
        callingMachine.stateOnlineAudioVideo.enter();
      } else {
        /// single call
        if (ZegoInvitationType.voiceCall == invitationData.type) {
          callingMachine.stateCallingWithVoice.enter();
        } else {
          if (configQuery(invitationData).turnOnCameraWhenJoining) {
            ZegoUIKit.instance.turnCameraOn(true);
          }

          callingMachine.stateCallingWithVideo.enter();
        }
      }
    } else {
      restoreToIdle();
    }
  }

  void onLocalAcceptInvitation() {
    debugPrint("local accept invitation");

    calleeRingtone.stopRing();

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    callingMachine.stateOnlineAudioVideo.enter();
  }

  void onLocalRefuseInvitation() {
    debugPrint("local refuse invitation");
    restoreToIdle();
  }

  void onLocalCancelInvitation() {
    debugPrint("local cancel invitation");

    restoreToIdle();
  }

  void onInvitationReceived(StreamDataInvitationReceived data) {
    if (CallingState.kIdle != callingMachine.getPageState()) {
      debugPrint("auto refuse this call, because call state is not idle, "
          "current state is ${callingMachine.getPageState()}");

      ZegoSignalPlugin().refuseInvitation(data.inviter.id, '');

      return;
    }

    calleeRingtone.startRing();

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    var invitationInternalData = InvitationInternalData.fromJson(data.data);
    invitationData.callID = invitationInternalData.callID;
    invitationData.invitees = invitationInternalData.invitees;

    invitationData.inviter =
        ZegoUIKitUser(id: data.inviter.id, name: data.inviter.name);

    invitationData.type =
        ZegoInvitationTypeExtension.mapValue[data.type] as ZegoInvitationType;

    showInvitationTopSheet();
  }

  void onInvitationAccepted(StreamDataInvitationAccepted data) {
    callerRingtone.stopRing();

    //  if inputting right now
    FocusManager.instance.primaryFocus?.unfocus();

    callingMachine.stateOnlineAudioVideo.enter();
  }

  void onInvitationTimeout(StreamDataInvitationTimeout data) {
    restoreToIdle();
  }

  void onInvitationResponseTimeout(StreamDataInvitationResponseTimeout data) {
    if (isGroupCall) {
      timeoutInvitees.addAll(data.invitees);
      debugPrint(
          "invitation timeout, invitee:${data.invitees}, now have:$timeoutInvitees");
      if (timeoutInvitees.length >= invitationData.invitees.length) {
        debugPrint("invitation timeout, all timeout");
        restoreToIdle();
      }
    } else {
      restoreToIdle();
    }
  }

  void onInvitationRefused(StreamDataInvitationRefused data) {
    if (isGroupCall) {
      refuseInvitees.add(data.invitee);
      debugPrint(
          "invitation refuse, invitee:${data.invitee}, now have:$refuseInvitees");
      if (refuseInvitees.length >= invitationData.invitees.length) {
        debugPrint("invitation refuse, all refuse");
        restoreToIdle();
      }
    } else {
      restoreToIdle();
    }
  }

  void onInvitationCanceled(StreamDataInvitationCanceled data) {
    restoreToIdle();
  }

  void onHangUp() {
    restoreToIdle();
  }

  void onOnlySelfInRoom() {
    restoreToIdle();
  }

  void restoreToIdle() {
    debugPrint("invitation page service to be idle");

    callerRingtone.stopRing();
    calleeRingtone.stopRing();

    ZegoUIKit.instance.turnCameraOn(false);

    hideInvitationTopSheet();

    if (CallingState.kIdle !=
        (callingMachine.machine.current?.identifier ?? CallingState.kIdle)) {
      debugPrint(
          'restore to idle, current state:${callingMachine.machine.current?.identifier}');

      Navigator.of(contextQuery()).pop();

      callingMachine.stateIdle.enter();
    }

    invitationData = ZegoCallInvitationData.empty();
    acceptInvitees.clear();
    refuseInvitees.clear();
    timeoutInvitees.clear();
  }

  void onInvitationTopSheetEmptyClicked() {
    hideInvitationTopSheet();

    if (ZegoInvitationType.voiceCall == invitationData.type) {
      callingMachine.stateCallingWithVoice.enter();
    } else {
      callingMachine.stateCallingWithVideo.enter();
    }
  }

  void showInvitationTopSheet() {
    if (invitationTopSheetVisibility) {
      return;
    }

    invitationTopSheetVisibility = true;

    showTopModalSheet(
      contextQuery(),
      GestureDetector(
        onTap: () {
          onInvitationTopSheetEmptyClicked();
        },
        child: ZegoCallInvitationDialog(
          invitationData: invitationData,
          avatarBuilder: configQuery(invitationData).avatarBuilder,
        ),
      ),
      barrierDismissible: false,
    );
  }

  void hideInvitationTopSheet() {
    if (invitationTopSheetVisibility) {
      Navigator.of(contextQuery()).pop();

      invitationTopSheetVisibility = false;
    }
  }
}
