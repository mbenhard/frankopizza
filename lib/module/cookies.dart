import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieStorage {
  static const String key = 'frankoCookies';

  static List<Map<String, dynamic>> cookiesToJson(List<Cookie> cookies) {
    return cookies.map((cookie) => cookieToJson(cookie)).toList();
  }

  static Map<String, dynamic> cookieToJson(Cookie cookie) {
    return {
      'name': cookie.name,
      'value': cookie.value,
      'domain': cookie.domain,
      'path': cookie.path,
    };
  }

  static Cookie jsonToCookie(Map<String, dynamic> json) {
    return Cookie(
      name: json['name'],
      value: json['value'],
      domain: json['domain'],
      path: json['path'],
    );
  }

  static List<Cookie> getCookiesFromPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(key)) {
        final jsonString = prefs.getString(key);
        final List<dynamic> jsonList = jsonDecode(jsonString!);
        return jsonList.map((json) => jsonToCookie(json)).toList();
      } else {
        return [];
      }
    });

    return [];
  }

  static Future<void> saveCookiesToPrefs(List<Cookie> cookies) async {
    final prefs = await SharedPreferences.getInstance();
    final value = cookiesToJson(cookies);
    Logger().w(jsonEncode(value));
    prefs.setString(key, jsonEncode(value));
  }
}
