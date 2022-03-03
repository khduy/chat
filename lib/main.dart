import 'constants/app_const.dart';
import 'view/home/theme_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/theme.dart';

import 'view/home/home_page.dart';

import 'view/sign_in/sign_in_page.dart';

import 'common_widgets/auth_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox<int>(AppConst.themeModeBox);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(themeControllerProvider);
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,
      home: AuthWidget(
        nonSignedInBuilder: (context) => const SignInPage(),
        signedInBuilder: (context) => const HomePage(),
      ),
    );
  }
}
