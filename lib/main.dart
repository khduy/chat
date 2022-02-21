import 'general_provider.dart';
import 'view/home/home_page.dart';

import 'view/sign_in/sign_in_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';



import 'common_widgets/auth_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.brandBlue,
        surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
        blendLevel: 18,
        appBarStyle: FlexAppBarStyle.primary,
        appBarOpacity: 0.95,
        appBarElevation: 8,
        transparentStatusBar: false,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: true,
        swapColors: false,
        lightIsWhite: true,
        useSubThemes: false,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.brandBlue,
        surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
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
      ),
      themeMode: ThemeMode.light,
      home: AuthWidget(
        nonSignedInBuilder: (context) => SignInPage(),
        signedInBuilder: (context) => HomePage(),
      ),
    );
  }
}
