import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  String currentLang = 'en';

  Locale? get locale {
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
    currentLang = _prefs.getString('language') ?? 'en';
    notifyListeners();
  }
}