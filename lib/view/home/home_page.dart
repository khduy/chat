import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/view/search/search_page.dart';
import 'package:flutter/cupertino.dart';

import '../../general_provider.dart';

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
          child: Avatar(
            photoURL: firebaseAuth.currentUser?.photoURL,
          ),
        ),
        actions: [
          CupertinoButton(
            child: Icon(
              Icons.logout,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () async {
              await firebaseAuth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? Colors.black12 : Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.hintColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search',
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(8),
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
