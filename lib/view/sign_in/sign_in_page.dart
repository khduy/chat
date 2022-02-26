import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/alert_dialog/exception_alert_dialog.dart';
import '../../common_widgets/loading_overlay_widget.dart';
import 'sign_in_controller.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInController = ref.watch(signInControllerProvider);
    ref.listen<SignInController>(
      signInControllerProvider,
      (_, model) async {
        if (model.error != null) {
          await showExceptionAlertDialog(
            context: context,
            title: 'Failed',
            exception: model.error,
          );
        }
      },
    );

    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.2),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    color: theme.brightness == Brightness.dark ? Colors.white : null,
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Messenger',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text(
                      'Sign in with Google',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    onPressed: () async {
                      await signInController.onSignIn();
                    },
                  ),
                ],
              ),
            ),
          ),
          LoadingOverlay(signInController.isLoading),
        ],
      ),
    );
  }
}
