import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/channel_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/home/home_controller.dart';
import 'package:chat/view/home/widgets/channels_listview.dart';
import 'package:chat/view/home/widgets/empty_channels.dart';
import 'package:chat/view/home/widgets/user_infor_dialog.dart';
import 'package:chat/view/search/search_page.dart';
import 'package:chat/view/sign_in/sign_in_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../general_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final channelStreamProvider =
    StreamProvider.autoDispose.family<List<Channel>, String>((ref, userId) {
  return FireStoreDatabase().channelStream(userId);
});

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
          child: Consumer(
            builder: (context, ref, child) {
              final signInController = ref.watch(signInControllerProvider.notifier);
              final currentUser = signInController.currentUser!;
              return GestureDetector(
                child: Avatar(
                  photoURL: currentUser.photoUrl,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return InforDialog(
                        user: currentUser,
                        onSignOut: signInController.onSignOut,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: <Widget>[
          Consumer(builder: (context, ref, child) {
            final themeController = ref.watch(themeControllerProvider.notifier);
            return IconButton(
              splashRadius: 20,
              splashColor: Colors.transparent,
              icon: Icon(
                themeController.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: themeController.changeThemeMode,
            );
          }),
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
          Consumer(
            builder: (context, ref, child) {
              final firebaseAuth = ref.watch(firebaseAuthProvider);
              final channels = ref.watch(channelStreamProvider(firebaseAuth.currentUser!.uid));
              return Expanded(
                child: channels.maybeWhen(
                  data: (channels) {
                    if (channels.isEmpty) {
                      return child!;
                    }
                    return ChannelsListView(
                      firebaseAuth: firebaseAuth,
                      channels: channels,
                    );
                  },
                  orElse: () => const SizedBox(),
                ),
              );
            },
            child: const EmptyChannels(),
          )
        ],
      ),
    );
  }
}
