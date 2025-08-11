/// CallKit Action 类型枚举
/// 定义了所有支持的 CallKit Action 类型
enum ZegoSignalingPluginCallKitActionType {
  /// 开始通话 Action
  start,

  /// 接听通话 Action
  answer,

  /// 结束通话 Action
  end,

  /// 设置通话保持状态 Action
  setHeld,

  /// 设置静音状态 Action
  setMuted,

  /// 设置群组通话 Action
  setGroup,

  /// 播放 DTMF 音调 Action
  playDTMF,

  /// 超时执行 Action
  timedOut,
}
