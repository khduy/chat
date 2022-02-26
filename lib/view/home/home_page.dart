import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/chanel_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/search/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../general_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final channelStreamProvider =
    StreamProvider.autoDispose.family<List<Channel>, String>((ref, userId) {
  return FireStoreDatabase().channelStream(userId);
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final channels = ref.watch(channelStreamProvider(firebaseAuth.currentUser!.uid));
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
              child: Hero(
                tag: 'searchBar',
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
              ),
              borderRadius: BorderRadius.circular(8),
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => const SearchPage(),
                    transitionsBuilder: (c, a1, a2, child) {
                      return FadeTransition(
                        opacity: a1,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: channels.maybeWhen(
              data: (channels) {
                if (channels.isEmpty) {
                  return Center(
                    child: Text(
                      'No Channels',
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    var opositeUser = channel.members
                        .firstWhere((user) => user.id != firebaseAuth.currentUser!.uid);
                    return ListTile(
                      leading: Avatar(
                        photoURL: opositeUser.photoUrl,
                      ),
                      title: Text(opositeUser.displayName),
                      subtitle: Text(channel.lastMessage),
                      onTap: () {},
                    );
                  },
                );
              },
              orElse: () => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
