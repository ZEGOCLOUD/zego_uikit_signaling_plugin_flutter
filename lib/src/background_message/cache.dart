// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'defines.dart';

Future<Map<String, dynamic>> getAndroidHandlers() async {
  final prefs = await SharedPreferences.getInstance();

  final jsonString = prefs.getString(handlerCacheKey) ?? '';

  if (jsonString.isEmpty) {
    return {};
  }

  Map<String, dynamic> handlersMap = {};
  try {
    handlersMap = jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
  } catch (e) {
    debugPrint('signaling, '
        'background message handler,'
        'get cache, parse handler json error:$e');
  }

  return handlersMap;
}

Future<void> clearAndroidHandler({String key = ''}) async {
  final prefs = await SharedPreferences.getInstance();
  if (key.isEmpty) {
    debugPrint('signaling, '
        'background message handler,'
        'remove all handlers');

    prefs.remove(handlerCacheKey);
  } else {
    final jsonString = prefs.getString(handlerCacheKey) ?? '';

    if (jsonString.isNotEmpty) {
      Map<String, dynamic> handlersMap = {};
      try {
        handlersMap = jsonDecode(jsonString) as Map<String, dynamic>? ?? {};
      } catch (e) {
        debugPrint('signaling, '
            'background message handler,'
            'get cache, parse handler json error:$e, '
            'json:$jsonString');
      }

      handlersMap.remove(key);
      debugPrint('signaling, '
          'background message handler,'
          'remove $key, update handler cache to $handlersMap');
      await prefs.setString(handlerCacheKey, jsonEncode(handlersMap));
    }
  }
}
