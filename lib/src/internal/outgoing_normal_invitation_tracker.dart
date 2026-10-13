import 'dart:async';

/// A terminal user state that backs the legacy normal-invitation events.
enum NormalInvitationTerminalState { accepted, rejected, timeout }

/// A user state received before the corresponding send call returns.
class NormalInvitationUserState {
  const NormalInvitationUserState({
    required this.userID,
    required this.state,
    required this.extendedData,
  });

  final String userID;
  final NormalInvitationTerminalState state;
  final String extendedData;
}

/// Tracks recipients for locally sent normal invitations.
class OutgoingNormalInvitationTracker {
  OutgoingNormalInvitationTracker({
    this.pendingStateRetention = const Duration(seconds: 30),
    this.expirationGrace = const Duration(seconds: 30),
    this.maxTrackedInvitations = 128,
  });

  final Duration pendingStateRetention;
  final Duration expirationGrace;
  final int maxTrackedInvitations;
  final Map<String, _TrackedInvitation> _trackedInvitations = {};
  final Map<String, _BufferedInvitation> _bufferedInvitations = {};

  /// Starts tracking successful recipients and returns any early terminal
  /// states for those recipients.
  List<NormalInvitationUserState> register(
    String invitationID,
    Iterable<String> invitees, {
    required Duration timeout,
  }) {
    _removeTracked(invitationID);
    final inviteeIDs = invitees.toSet();
    final bufferedInvitation = _removeBuffered(invitationID);
    if (invitationID.isEmpty || inviteeIDs.isEmpty) return const [];

    final earlyStates = <NormalInvitationUserState>[];
    final pendingStates = bufferedInvitation?.states.values;
    if (pendingStates != null) {
      for (final state in pendingStates) {
        if (inviteeIDs.remove(state.userID)) {
          earlyStates.add(state);
        }
      }
    }

    final lifetime =
        (timeout.isNegative ? Duration.zero : timeout) + expirationGrace;
    _trackedInvitations[invitationID] = _TrackedInvitation(
      inviteeIDs: inviteeIDs,
      timer: Timer(lifetime, () => _removeTracked(invitationID)),
    );
    _trimTrackedInvitations();
    return earlyStates;
  }

  /// Handles a terminal state. Returns true when it belongs to a tracked
  /// normal invitation recipient.
  bool processState(String invitationID, NormalInvitationUserState state) {
    final trackedInvitation = _trackedInvitations[invitationID];
    if (trackedInvitation != null) {
      return trackedInvitation.inviteeIDs.remove(state.userID);
    }

    _bufferState(invitationID, state);
    return false;
  }

  /// Removes recipients whose invitations were successfully cancelled.
  void cancelRecipients(String invitationID, Iterable<String> invitees) {
    _trackedInvitations[invitationID]?.inviteeIDs.removeAll(invitees);
  }

  /// Clears tracked and buffered states, such as when the user logs out.
  void clear() {
    for (final invitation in _trackedInvitations.values) {
      invitation.timer.cancel();
    }
    for (final invitation in _bufferedInvitations.values) {
      invitation.timer.cancel();
    }
    _trackedInvitations.clear();
    _bufferedInvitations.clear();
  }

  void _bufferState(String invitationID, NormalInvitationUserState state) {
    if (invitationID.isEmpty || pendingStateRetention <= Duration.zero) return;

    var bufferedInvitation = _bufferedInvitations[invitationID];
    if (bufferedInvitation == null) {
      bufferedInvitation = _BufferedInvitation(
        states: {},
        timer: Timer(
          pendingStateRetention,
          () => _removeBuffered(invitationID),
        ),
      );
      _bufferedInvitations[invitationID] = bufferedInvitation;
      _trimBufferedInvitations();
    }
    bufferedInvitation.states.putIfAbsent(state.userID, () => state);
  }

  _BufferedInvitation? _removeBuffered(String invitationID) {
    final bufferedInvitation = _bufferedInvitations.remove(invitationID);
    bufferedInvitation?.timer.cancel();
    return bufferedInvitation;
  }

  void _removeTracked(String invitationID) {
    _trackedInvitations.remove(invitationID)?.timer.cancel();
  }

  void _trimTrackedInvitations() {
    final limit = maxTrackedInvitations < 1 ? 1 : maxTrackedInvitations;
    while (_trackedInvitations.length > limit) {
      _removeTracked(_trackedInvitations.keys.first);
    }
  }

  void _trimBufferedInvitations() {
    final limit = maxTrackedInvitations < 1 ? 1 : maxTrackedInvitations;
    while (_bufferedInvitations.length > limit) {
      _removeBuffered(_bufferedInvitations.keys.first);
    }
  }
}

class _TrackedInvitation {
  _TrackedInvitation({required this.inviteeIDs, required this.timer});

  final Set<String> inviteeIDs;
  final Timer timer;
}

class _BufferedInvitation {
  _BufferedInvitation({required this.states, required this.timer});

  final Map<String, NormalInvitationUserState> states;
  final Timer timer;
}
