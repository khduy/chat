import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../provider/general_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              firebaseAuth.currentUser!.photoURL ??
                  'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg',
            ),
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await firebaseAuth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
