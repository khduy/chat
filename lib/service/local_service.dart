import '../constants/app_const.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

class LocalService {
  void setThemeMode(ThemeMode themeMode) {
    int data;
    switch (themeMode) {
      case ThemeMode.dark:
        data = 1;
        break;
      default:
        data = 0;
        break;
    }

    Hive.box<int>(AppConst.themeModeBox).put(AppConst.themeModeKey, data);
  }

  ThemeMode getThemeMode() {
    int? themeMode = Hive.box<int>(AppConst.themeModeBox).get(AppConst.themeModeKey);
    if (themeMode == 1) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }
}
