import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mighty_school/util/app_constants.dart';

class ThemeController extends GetxController {
  final SharedPreferences sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(AppConstants.theme, _darkTheme);
    update();
  }

  void _loadCurrentTheme() {
    if (sharedPreferences.containsKey(AppConstants.theme)) {
      _darkTheme = sharedPreferences.getBool(AppConstants.theme) ?? false;
    } else {
      final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _darkTheme = platformBrightness == Brightness.dark;
    }
    update();
  }
}
