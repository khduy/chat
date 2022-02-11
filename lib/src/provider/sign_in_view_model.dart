import 'package:chat/src/provider/general_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final signInViewModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(firebaseAuth: ref.watch(firebaseAuthProvider)),
);

class SignInViewModel with ChangeNotifier {
  SignInViewModel({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;
  bool isLoading = false;
  dynamic error;

  Future<void> signInWithGoogle() async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      error = null;
    } catch (e) {
      error = e;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
