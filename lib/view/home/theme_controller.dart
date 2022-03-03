import '../../general_provider.dart';
import '../../service/local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeControllerProvider = ChangeNotifierProvider<ThemeController>((ref) {
  final localService = ref.read(localServiceProvider);
  return ThemeController(localService: localService);
});

class ThemeController extends ChangeNotifier {
  ThemeController({required this.localService}) {
    themeMode = localService.getThemeMode();
    notifyListeners();
  }
  late ThemeMode themeMode;
  LocalService localService;

  void changeThemeMode() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    localService.setThemeMode(themeMode);
    notifyListeners();
  }
}
