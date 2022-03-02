import 'package:chat/model/user_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/service/local_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../general_provider.dart';

final signInControllerProvider = ChangeNotifierProvider<SignInController>(
  (ref) => SignInController(firebaseAuth: ref.watch(firebaseAuthProvider)),
);

class SignInController with ChangeNotifier {
  SignInController({required this.firebaseAuth}) {
    currentUser = firebaseAuth.currentUser != null
        ? UserModel.fromFirebaseUser(firebaseAuth.currentUser!)
        : null;

    firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        currentUser = UserModel.fromFirebaseUser(user);
      } else {
        currentUser = firebaseAuth.currentUser != null
            ? UserModel.fromFirebaseUser(firebaseAuth.currentUser!)
            : null;
      }
    });
  }

  final FirebaseAuth firebaseAuth;

  final _fireStoreDatabase = FireStoreDatabase();

  late UserModel? currentUser;
  bool isLoading = false;
  dynamic error;

  Future<void> _signInWithGoogle() async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      // fix auto pick old account to login in Android
      await GoogleSignIn().signOut();
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

  Future<bool> _isCurrentUserExist() async {
    return await _fireStoreDatabase.isUserExist(firebaseAuth.currentUser!.uid);
  }

  Future<void> _saveCurrentUserToDB() async {
    final user = UserModel.fromFirebaseUser(firebaseAuth.currentUser!);
    _fireStoreDatabase.setUserToDB(user);
  }

  Future<void> onSignIn() async {
    await _signInWithGoogle();
    if (!await _isCurrentUserExist()) {
      _saveCurrentUserToDB();
    }
  }

  Future<void> onSignOut() async {
    await firebaseAuth.signOut();
  }
}
