// CallKit Adapter 模块
//
// 该模块提供了 CallKit 功能的适配器模式实现，
// 用于解耦 zego_uikit_prebuilt_call 与 zego_callkit 的直接依赖。
//
// 主要组件：
// - ActionManager: 管理 CallKit Action 的生命周期
// - EventConverter: 转换 zego_callkit 事件为结构化事件
// - ActionData: 定义各种 Action 的数据结构
// - ActionTypes: 定义 Action 类型枚举

// 导出 Action 类型
export 'action_types.dart';

// 导出 Action 管理器
export 'action_manager.dart';

// 导出事件转换器
export 'event_converter.dart';
