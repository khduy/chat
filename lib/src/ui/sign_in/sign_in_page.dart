import 'package:chat/src/ui/base_widgets/loading_overlay_widget.dart';

import '../../provider/sign_in_view_model.dart';

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
    final signInViewModel = ref.watch(signInViewModelProvider);
    ref.listen<SignInViewModel>(
      signInViewModelProvider,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signInViewModel.signInWithGoogle();
                  },
                  child: const Text('Sign in with Google'),
                ),
              ],
            ),
          ),
          LoadingOverlay(signInViewModel.isLoading),
        ],
      ),
    );
  }
}