import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/general_provider.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/chat/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStreamProvider = StreamProvider.autoDispose<List<UserModel>>((ref) {
  final searchInput = ref.watch(searchInputProvider);
  return FireStoreDatabase().findUser(searchInput);
});

final searchInputProvider = StateProvider.autoDispose<String>((ref) => '');

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userStreamProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      onChanged: (value) => ref.read(searchInputProvider.notifier).state = value,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(8.0),
                        fillColor:
                            theme.brightness == Brightness.light ? Colors.black12 : Colors.white12,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.search,
                            color: theme.hintColor,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
                        hintText: 'Enter user name',
                      ),
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('Cancle'),
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            Expanded(
              child: users.when(
                loading: () => const Center(child: Text('Loading...')),
                error: (error, stack) => const Text('Oops, something unexpected happened'),
                data: (value) {
                  if (value.isEmpty) {
                    return const Center(child: Text('No results'));
                  }
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final user = value[index];
                      return ListTile(
                        leading: Avatar(
                          photoURL: user.photoUrl,
                        ),
                        title: Text(user.displayName),
                        subtitle: Text('@' + user.userName),
                        onTap: () {
                          onUserTap(context, user);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onUserTap(BuildContext context, UserModel user) async {
    var currentUser = FirebaseAuth.instance.currentUser!;
    var channelID = channelId(user.id, currentUser.uid);

    var channel = await FireStoreDatabase().getChannel(channelID);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          channel: channel,
          oppositeUser: user,
        ),
      ),
    );
  }
}
