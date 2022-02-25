import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.brandBlue,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: 0.95,
    appBarElevation: 0,
    transparentStatusBar: false,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    lightIsWhite: true,
    useSubThemes: false,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );

  static final ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.brandBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.surface,
    appBarOpacity: 0.95,
    appBarElevation: 0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    darkIsTrueBlack: false,
    useSubThemes: false,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
}
