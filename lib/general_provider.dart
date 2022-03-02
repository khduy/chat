import 'package:chat/service/local_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider =
    StreamProvider<User?>((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final localServiceProvider = Provider<LocalService>((ref) => LocalService());
