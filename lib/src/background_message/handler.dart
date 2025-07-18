// Dart imports:
import 'dart:convert';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import '../log/logger_service.dart';
import 'cache.dart';
import 'defines.dart';

@pragma('vm:entry-point')
Future<void> onSignalingBackgroundMessageReceived(ZPNsMessage message) async {
  debugPrint('signaling, '
      'background message handler,'
      'onSignalingBackgroundMessageReceived');

  await invokeBackgroundMessageHandler(message);
}

Future<void> registerBackgroundMessageHandler(
  ZegoSignalingPluginBackgroundMessageHandler handler,
) async {
  await getAndroidHandlers().then((handlersMap) async {
    final prefs = await SharedPreferences.getInstance();
    final CallbackHandle callbackHandle =
        PluginUtilities.getCallbackHandle(handler.callback)!;

    ZegoSignalingLoggerService.logInfo(
      'register, previous cache:$handlersMap, '
      'now add, key:${handler.key}, handle:${callbackHandle.toRawHandle()}, ',
      tag: 'signaling',
      subTag: 'background message handler',
    );

    handlersMap[handler.key] = callbackHandle.toRawHandle();

    ZegoSignalingLoggerService.logInfo(
      'register, now cache:$handlersMap,',
      tag: 'signaling',
      subTag: 'background message handler',
    );

    await prefs.setString(handlerCacheKey, jsonEncode(handlersMap));
  }).then((_) {
    ZegoSignalingLoggerService.logInfo(
      'register done, key:${handler.key}',
      tag: 'signaling',
      subTag: 'background message handler',
    );
  });
}

Future<void> invokeBackgroundMessageHandler(ZPNsMessage message) async {
  await getAndroidHandlers().then((handlersMap) {
    debugPrint('signaling, '
        'background message handler,'
        'invoke, cache map:$handlersMap');

    handlersMap.forEach((key, callbackHandle) {
      try {
        final callbackHandler =
            CallbackHandle.fromRawHandle(callbackHandle as int? ?? 0);
        debugPrint('signaling, '
            'background message handler,'
            'invoke, key:$key, handle:$callbackHandle');

        PluginUtilities.getCallbackFromHandle(callbackHandler)?.call(message);
      } catch (e) {
        debugPrint('signaling, '
            'background message handler,'
            'invoke offline handler error:$e');
      }
    });
  });
}
