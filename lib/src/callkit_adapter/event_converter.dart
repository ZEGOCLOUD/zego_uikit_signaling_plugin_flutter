// Dart imports:
import 'dart:math';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

// Project imports:
import '../log/logger_service.dart';
import 'action_manager.dart';
import 'action_types.dart';

/// CallKit 事件转换器
/// 负责将 zego_callkit 的 Action 转换为 zego_plugin_adapter 的事件
class ZegoSignalingPluginCallKitEventConverter {
  static final _actionManager = ZegoSignalingPluginCallKitActionManager();

  /// 转换开始通话 Action
  /// [action] zego_callkit 的开始通话 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertStartCallAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert start call action: $actionId',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.start.name,
      actionData: ZegoSignalingPluginCallKitStartActionData(
        callUUID: action.callUUID.uuidString,
        handle: action.handle.value,
        contactIdentifier: action.contactIdentifier,
        video: action.video,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 转换接听通话 Action
  /// [action] zego_callkit 的接听通话 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertAnswerCallAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert answer call action: $actionId',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.answer.name,
      actionData: ZegoSignalingPluginCallKitAnswerActionData(
        callUUID: action.callUUID.uuidString,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 转换结束通话 Action
  /// [action] zego_callkit 的结束通话 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertEndCallAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert end call action: $actionId',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.end.name,
      actionData: ZegoSignalingPluginCallKitEndActionData(
        callUUID: action.callUUID.uuidString,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 转换设置通话保持状态 Action
  /// [action] zego_callkit 的设置通话保持状态 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertSetHeldAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert set held action: $actionId, onHold: ${action.onHold}',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.setHeld.name,
      actionData: ZegoSignalingPluginCallKitSetHeldActionData(
        callUUID: action.callUUID.uuidString,
        onHold: action.onHold,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 转换设置静音状态 Action
  /// [action] zego_callkit 的设置静音状态 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertSetMutedAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert set muted action: $actionId, muted: ${action.muted}',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.setMuted.name,
      actionData: ZegoSignalingPluginCallKitSetMutedActionData(
        callUUID: action.callUUID.uuidString,
        muted: action.muted,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 转换设置群组通话 Action
  /// [action] zego_callkit 的设置群组通话 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertSetGroupAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert set group action: $actionId',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.setGroup.name,
      actionData: ZegoSignalingPluginCallKitSetGroupActionData(
        callUUID: action.callUUID.uuidString,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 转换播放 DTMF 音调 Action
  /// [action] zego_callkit 的播放 DTMF 音调 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertPlayDTMFAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert play DTMF action: $actionId, digits: ${action.digits}, type: ${action.type}',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.playDTMF.name,
      actionData: ZegoSignalingPluginCallKitPlayDTMFActionData(
        callUUID: action.callUUID.uuidString,
        digits: action.digits,
        type: action.type.toString(),
      ),
    );
  }

  /// 转换超时执行 Action
  /// [action] zego_callkit 的超时执行 Action
  /// 返回转换后的事件
  static ZegoSignalingPluginCallKitActionEvent convertTimedOutAction(
      dynamic action) {
    final actionId = _generateActionId();
    _actionManager.registerAction(actionId, action);

    ZegoSignalingLoggerService.logInfo(
      'Convert timed out action: $actionId',
      tag: 'signaling',
      subTag: 'callkit event converter',
    );

    return ZegoSignalingPluginCallKitActionEvent(
      actionId: actionId,
      actionType: ZegoSignalingPluginCallKitActionType.timedOut.name,
      actionData: ZegoSignalingPluginCallKitTimedOutActionData(
        callUUID: action.callUUID.uuidString,
      ),
      fulfill: () => _actionManager.fulfillAction(actionId),
      fail: () => _actionManager.failAction(actionId),
    );
  }

  /// 生成唯一的 Action ID
  /// 返回格式化的唯一标识符
  static String _generateActionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return '${timestamp}_$random';
  }

  /// 获取 Action 管理器实例
  /// 返回 Action 管理器单例
  static ZegoSignalingPluginCallKitActionManager get actionManager =>
      _actionManager;
}
