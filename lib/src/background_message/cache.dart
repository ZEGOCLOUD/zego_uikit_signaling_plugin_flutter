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

Future<void> clearAndroidHandler() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(handlerCacheKey);
}
