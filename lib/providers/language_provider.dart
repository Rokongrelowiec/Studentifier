import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  String currentLang = 'system';
  bool isSystemLang = true;

  Locale? get locale {
    if (currentLang == 'system') {
      isSystemLang = true;
      currentLang = Platform.localeName.split('_').first;
    } else {
      isSystemLang = false;
    }
    if (currentLang == 'en') {
      return Locale('en');
    } else if (currentLang == 'pl') {
      return Locale('pl');
    } else {
      return Locale('en');
    }
  }

  changeLang(String locale) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('language', locale);
    currentLang = locale;
    notifyListeners();
  }

  initialize() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    currentLang = _prefs.getString('language') ?? 'system';
    notifyListeners();
  }
}