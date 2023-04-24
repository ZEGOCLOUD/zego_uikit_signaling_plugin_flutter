part of '../zego_uikit_signaling_plugin.dart';

class ZegoSignalingPluginRoomAPIImpl implements ZegoSignalingPluginRoomAPI {
  /// join room
  @override
  Future<ZegoSignalingPluginJoinRoomResult> joinRoom({
    required String roomID,
    required String roomName,
    Map<String, String> roomAttributes = const {},
    int roomDestroyDelayTime = 0,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'join room, room id:$roomID, room name:$roomName',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .enterRoom(
          ZIMRoomInfo()
            ..roomID = roomID
            ..roomName = roomName,
          ZIMRoomAdvancedConfig()
            ..roomAttributes = roomAttributes
            ..roomDestroyDelayTime = roomDestroyDelayTime,
        )
        .then((zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'join room finish',
        tag: 'signaling',
        subTag: 'room',
      );

      assert(zimResult.roomInfo.baseInfo.roomID.isNotEmpty,
          'zimResult.roomInfo.baseInfo.roomID.isNotEmpty');

      return const ZegoSignalingPluginJoinRoomResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'join room, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginJoinRoomResult(
        error: error,
      );
    });
  }

  /// leave room
  @override
  Future<ZegoSignalingPluginLeaveRoomResult> leaveRoom({
    required String roomID,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'leave room, room id:$roomID',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .leaveRoom(roomID)
        .then((value) => const ZegoSignalingPluginLeaveRoomResult())
        .catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'leave room, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginLeaveRoomResult(
        error: error,
      );
    });
  }

  /// update room properties
  @override
  Future<ZegoSignalingPluginRoomPropertiesOperationResult>
      updateRoomProperties({
    required String roomID,
    required Map<String, String> roomProperties,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) async {
    return ZIM
        .getInstance()!
        .setRoomAttributes(
          roomProperties,
          roomID,
          ZIMRoomAttributesSetConfig()
            ..isForce = isForce
            ..isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft
            ..isUpdateOwner = isUpdateOwner,
        )
        .then((zimResult) {
      return ZegoSignalingPluginRoomPropertiesOperationResult(
        errorKeys: zimResult.errorKeys,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'update room properties, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginRoomPropertiesOperationResult(
        error: error,
        errorKeys: roomProperties.keys.toList(),
      );
    });
  }

  /// delete room properties
  @override
  Future<ZegoSignalingPluginRoomPropertiesOperationResult>
      deleteRoomProperties({
    required String roomID,
    required List<String> keys,
    required bool isForce,
  }) async {
    return ZIM
        .getInstance()!
        .deleteRoomAttributes(
          keys,
          roomID,
          ZIMRoomAttributesDeleteConfig()..isForce = isForce,
        )
        .then((zimResult) {
      return ZegoSignalingPluginRoomPropertiesOperationResult(
        errorKeys: zimResult.errorKeys,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'delete room properties, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginRoomPropertiesOperationResult(
        error: error,
        errorKeys: keys.toList(),
      );
    });
  }

  /// begin room properties batch operation
  @override
  void beginRoomPropertiesBatchOperation({
    required String roomID,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) {
    ZIM.getInstance()!.beginRoomAttributesBatchOperation(
          roomID,
          ZIMRoomAttributesBatchOperationConfig()
            ..isForce = isForce
            ..isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft
            ..isUpdateOwner = isUpdateOwner,
        );
  }

  /// end room properties batch operation
  @override
  Future<ZegoSignalingPluginEndRoomBatchOperationResult>
      endRoomPropertiesBatchOperation({
    required String roomID,
  }) async {
    return ZIM
        .getInstance()!
        .endRoomAttributesBatchOperation(roomID)
        .then((value) => const ZegoSignalingPluginEndRoomBatchOperationResult())
        .catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'end room properties batch operation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginEndRoomBatchOperationResult(
        error: error,
      );
    });
  }

  /// query room properties
  @override
  Future<ZegoSignalingPluginQueryRoomPropertiesResult> queryRoomProperties({
    required String roomID,
  }) {
    return ZIM
        .getInstance()!
        .queryRoomAllAttributes(roomID)
        .then((zimResult) => ZegoSignalingPluginQueryRoomPropertiesResult(
              properties: zimResult.roomAttributes,
            ))
        .catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'query room properties, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginQueryRoomPropertiesResult(
        error: error,
        properties: const {},
      );
    });
  }

  /// query users in room attributes
  @override
  Future<ZegoSignalingPluginQueryUsersInRoomAttributesResult>
      queryUsersInRoomAttributes({
    required String roomID,
    int count = 100,
    String nextFlag = '',
  }) {
    return ZIM
        .getInstance()!
        .queryRoomMemberAttributesList(
          roomID,
          ZIMRoomMemberAttributesQueryConfig()
            ..count = count
            ..nextFlag = nextFlag,
        )
        .then((zimResult) {
      return ZegoSignalingPluginQueryUsersInRoomAttributesResult(
        nextFlag: zimResult.nextFlag,
        attributes: {
          for (var element in zimResult.infos)
            element.userID: element.attributes
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'query user in-room attributes, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginQueryUsersInRoomAttributesResult(
        error: error,
        nextFlag: '',
        attributes: const {},
      );
    });
  }

  /// set users in room attributes
  @override
  Future<ZegoSignalingPluginSetUsersInRoomAttributesResult>
      setUsersInRoomAttributes({
    required String roomID,
    required List<String> userIDs,
    required Map<String, String> setAttributes,
    bool isDeleteAfterOwnerLeft = true,
  }) {
    return ZIM
        .getInstance()!
        .setRoomMembersAttributes(
            setAttributes,
            userIDs,
            roomID,
            ZIMRoomMemberAttributesSetConfig()
              ..isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft)
        .then((ZIMRoomMembersAttributesOperatedResult zimResult) {
      return ZegoSignalingPluginSetUsersInRoomAttributesResult(
        errorUserList: zimResult.errorUserList,
        errorKeys: {
          for (var element in zimResult.infos)
            element.attributesInfo.userID: element.errorKeys
        },
        attributes: {
          for (var element in zimResult.infos)
            element.attributesInfo.userID: element.attributesInfo.attributes
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logInfo(
        'set user in-room attributes, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      return ZegoSignalingPluginSetUsersInRoomAttributesResult(
        error: error,
        errorUserList: userIDs,
        attributes: {},
        errorKeys: {},
      );
    });
  }
}

class ZegoSignalingPluginRoomEventImpl implements ZegoSignalingPluginRoomEvent {
  @override
  Stream<ZegoSignalingPluginRoomPropertiesUpdatedEvent>
      getRoomPropertiesUpdatedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .roomPropertiesUpdatedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent>
      getRoomPropertiesBatchUpdatedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .roomPropertiesBatchUpdatedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginRoomStateChangedEvent>
      getRoomStateChangedEventStream() {
    return ZegoSignalingPluginCore().eventCenter.roomStateChangedEvent.stream;
  }

  @override
  Stream<ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent>
      getUsersInRoomAttributesUpdatedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .usersInRoomAttributesUpdatedEvent
        .stream;
  }

  @override
  Stream<ZegoSignalingPluginRoomMemberJoinedEvent>
      getRoomMemberJoinedEventStream() {
    return ZegoSignalingPluginCore().eventCenter.roomMemberJoinedEvent.stream;
  }

  @override
  Stream<ZegoSignalingPluginRoomMemberLeftEvent>
      getRoomMemberLeftEventStream() {
    return ZegoSignalingPluginCore().eventCenter.roomMemberLeftEvent.stream;
  }
}
