// Flutter imports:
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

// Package imports:
import 'package:flutter_logs_yoer/flutter_logs_yoer.dart';

/// @nodoc
class ZegoSignalingLoggerService {
  static bool isZegoLoggerInit = false;

  /// init log
  Future<void> initLog() async {
    if (isZegoLoggerInit) {
      return;
    }

    if (kIsWeb) {
      return;
    }

    try {
      await FlutterLogsYoer.initLogs(
              logLevelsEnabled: [
                LogLevel.INFO,
                LogLevel.WARNING,
                LogLevel.ERROR,
                LogLevel.SEVERE
              ],
              timeStampFormat: TimeStampFormat.TIME_FORMAT_24_FULL,
              directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
              logTypesEnabled: ['device', 'network', 'errors'],
              logFileExtension: LogFileExtension.LOG,
              logsWriteDirectoryName: 'ZegoUIKits',
              logsExportDirectoryName: 'ZegoUIKits/Exported',
              useCachesDirectory: true,
              debugFileOperations: true,
              isDebuggable: true)
          .then((value) {
        FlutterLogsYoer.setDebugLevel(0);
        FlutterLogsYoer.logInfo(
          'signaling',
          'log init done',
          '==========================================',
        );
      });

      isZegoLoggerInit = true;
    } catch (e) {
      debugPrint('signaling init logger error:$e');
    }
  }

  /// clear logs
  Future<void> clearLogs() async {
    FlutterLogsYoer.clearLogs();
  }

  /// log info
  static Future<void> logInfo(
    String logMessage, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLoggerInit) {
      debugPrint(
          '[INFO] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogsYoer.logInfo(tag, subTag, logMessage);
  }

  /// log warn
  static Future<void> logWarn(
    String logMessage, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLoggerInit) {
      debugPrint(
          '[WARN] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogsYoer.logWarn(tag, subTag, logMessage);
  }

  /// log error
  static Future<void> logError(
    String logMessage, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLoggerInit) {
      debugPrint(
          '[ERROR] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogsYoer.logError(tag, subTag, logMessage);
  }

  /// log error trace
  static Future<void> logErrorTrace(
    String logMessage,
    Error e, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLoggerInit) {
      debugPrint(
          '[ERROR] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogsYoer.logErrorTrace(tag, subTag, logMessage, e);
  }
}
