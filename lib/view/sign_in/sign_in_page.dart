import 'package:chat/common_widgets/loading_overlay_widget.dart';
import 'package:flutter/cupertino.dart';

import 'sign_in_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  String _message(dynamic exception) {
    if (exception is FirebaseException) {
      return exception.message ?? exception.toString();
    }
    if (exception is PlatformException) {
      return exception.message ?? exception.toString();
    }
    return exception.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInController = ref.watch(signInControllerProvider);
    ref.listen<SignInController>(
      signInControllerProvider,
      (_, model) async {
        if (model.error != null) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Failed"),
                content: Text(_message(model.error)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  )
                ],
              );
            },
          );
        }
      },
    );
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
                      await signInController.signInWithGoogle();
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
