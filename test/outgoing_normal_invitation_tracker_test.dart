import 'package:flutter_test/flutter_test.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/outgoing_normal_invitation_tracker.dart';

void main() {
  group('OutgoingNormalInvitationTracker', () {
    test('tracks registered recipients only once', () {
      final tracker = OutgoingNormalInvitationTracker();
      tracker.register('call-1', [
        'user-1',
        'user-2',
      ], timeout: const Duration(seconds: 10));

      expect(tracker.processState('call-1', _state('user-1')), isTrue);
      expect(tracker.processState('call-1', _state('user-1')), isFalse);
      expect(tracker.processState('call-1', _state('untracked')), isFalse);
      tracker.clear();
    });

    test('replays early states for successful recipients only', () {
      final tracker = OutgoingNormalInvitationTracker();
      expect(tracker.processState('call-1', _state('user-1')), isFalse);
      expect(
        tracker.processState(
          'call-1',
          _state('failed-user', NormalInvitationTerminalState.rejected),
        ),
        isFalse,
      );

      final earlyStates = tracker.register('call-1', [
        'user-1',
        'user-2',
      ], timeout: const Duration(seconds: 10));

      expect(earlyStates, hasLength(1));
      expect(earlyStates.single.userID, 'user-1');
      expect(earlyStates.single.state, NormalInvitationTerminalState.accepted);
      expect(tracker.processState('call-1', _state('user-1')), isFalse);
      expect(tracker.processState('call-1', _state('user-2')), isTrue);
      tracker.clear();
    });

    test('successful cancellation removes recipients from tracking', () {
      final tracker = OutgoingNormalInvitationTracker();
      tracker.register('call-1', [
        'user-1',
        'user-2',
      ], timeout: const Duration(seconds: 10));
      tracker.cancelRecipients('call-1', ['user-1']);

      expect(tracker.processState('call-1', _state('user-1')), isFalse);
      expect(tracker.processState('call-1', _state('user-2')), isTrue);
      tracker.clear();
    });

    test('expires pending and active invitations', () async {
      final tracker = OutgoingNormalInvitationTracker(
        pendingStateRetention: const Duration(milliseconds: 10),
        expirationGrace: Duration.zero,
      );
      tracker.processState('early-call', _state('user-1'));
      tracker.register('call-1', ['user-1'], timeout: Duration.zero);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(tracker.processState('call-1', _state('user-1')), isFalse);
      expect(
        tracker.register('early-call', [
          'user-1',
        ], timeout: const Duration(seconds: 1)),
        isEmpty,
      );
      tracker.clear();
    });
  });
}

NormalInvitationUserState _state(
  String userID, [
  NormalInvitationTerminalState state = NormalInvitationTerminalState.accepted,
]) {
  return NormalInvitationUserState(
    userID: userID,
    state: state,
    extendedData: '',
  );
}
