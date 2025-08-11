// Dart imports:
import 'dart:async';
import 'dart:math';

// Project imports:
import '../log/logger_service.dart';

/// CallKit Action 管理器
/// 负责管理 zego_callkit Action 实例的生命周期
/// 提供 fulfill 和 fail 方法的执行
class ZegoSignalingPluginCallKitActionManager {
  static final ZegoSignalingPluginCallKitActionManager _instance =
      ZegoSignalingPluginCallKitActionManager._internal();

  factory ZegoSignalingPluginCallKitActionManager() => _instance;

  ZegoSignalingPluginCallKitActionManager._internal();

  /// Action 实例映射表
  /// key: actionId, value: zego_callkit 的 Action 实例
  final Map<String, dynamic> _actionMap = {};

  /// 超时定时器映射表
  /// key: actionId, value: 超时定时器
  final Map<String, Timer> _timeoutTimers = {};

  /// 默认超时时间（毫秒）
  static const int _defaultTimeout = 30000;

  /// 注册 Action 实例
  /// [actionId] Action 的唯一标识符
  /// [action] zego_callkit 的 Action 实例
  /// [timeout] 超时时间（毫秒），默认 30 秒
  void registerAction(
    String actionId,
    dynamic action, {
    int timeout = _defaultTimeout,
  }) {
    _actionMap[actionId] = action;

    ZegoSignalingLoggerService.logInfo(
      'Action registered: $actionId, timeout: ${timeout}ms',
      tag: 'signaling',
      subTag: 'callkit action manager',
    );

    // 设置超时清理
    _timeoutTimers[actionId] = Timer(Duration(milliseconds: timeout), () {
      ZegoSignalingLoggerService.logWarn(
        'Action timeout: $actionId',
        tag: 'signaling',
        subTag: 'callkit action manager',
      );
      _cleanupAction(actionId);
    });
  }

  /// 执行 Action 的 fulfill 方法
  /// [actionId] Action 的唯一标识符
  Future<void> fulfillAction(String actionId) async {
    final action = _actionMap[actionId];
    if (action != null) {
      try {
        action.fulfill();
        ZegoSignalingLoggerService.logInfo(
          'Action fulfilled: $actionId',
          tag: 'signaling',
          subTag: 'callkit action manager',
        );
      } catch (e) {
        ZegoSignalingLoggerService.logError(
          'Failed to fulfill action: $actionId, error: $e',
          tag: 'signaling',
          subTag: 'callkit action manager',
        );
      } finally {
        _cleanupAction(actionId);
      }
    } else {
      ZegoSignalingLoggerService.logWarn(
        'Action not found for fulfill: $actionId',
        tag: 'signaling',
        subTag: 'callkit action manager',
      );
    }
  }

  /// 执行 Action 的 fail 方法
  /// [actionId] Action 的唯一标识符
  Future<void> failAction(String actionId) async {
    final action = _actionMap[actionId];
    if (action != null) {
      try {
        action.fail();
        ZegoSignalingLoggerService.logInfo(
          'Action failed: $actionId',
          tag: 'signaling',
          subTag: 'callkit action manager',
        );
      } catch (e) {
        ZegoSignalingLoggerService.logError(
          'Failed to fail action: $actionId, error: $e',
          tag: 'signaling',
          subTag: 'callkit action manager',
        );
      } finally {
        _cleanupAction(actionId);
      }
    } else {
      ZegoSignalingLoggerService.logWarn(
        'Action not found for fail: $actionId',
        tag: 'signaling',
        subTag: 'callkit action manager',
      );
    }
  }

  /// 检查 Action 是否存在
  /// [actionId] Action 的唯一标识符
  bool hasAction(String actionId) {
    return _actionMap.containsKey(actionId);
  }

  /// 获取 Action 实例（仅用于调试）
  /// [actionId] Action 的唯一标识符
  dynamic getAction(String actionId) {
    return _actionMap[actionId];
  }

  /// 清理 Action 资源
  /// [actionId] Action 的唯一标识符
  void _cleanupAction(String actionId) {
    _actionMap.remove(actionId);
    _timeoutTimers[actionId]?.cancel();
    _timeoutTimers.remove(actionId);

    ZegoSignalingLoggerService.logInfo(
      'Action cleaned up: $actionId',
      tag: 'signaling',
      subTag: 'callkit action manager',
    );
  }

  /// 清理所有 Action 资源
  void cleanupAll() {
    final actionCount = _actionMap.length;
    _actionMap.clear();
    for (final timer in _timeoutTimers.values) {
      timer.cancel();
    }
    _timeoutTimers.clear();

    ZegoSignalingLoggerService.logInfo(
      'All actions cleaned up, count: $actionCount',
      tag: 'signaling',
      subTag: 'callkit action manager',
    );
  }

  /// 获取当前注册的 Action 数量
  int get actionCount => _actionMap.length;

  /// 生成唯一的 Action ID
  static String generateActionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return '${timestamp}_$random';
  }
}
