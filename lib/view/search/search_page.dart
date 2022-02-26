import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/chat/chat_page.dart';
import 'package:chat/view/search/widgets/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              child: Hero(
                tag: 'searchBar',
                child: Material(
                  type: MaterialType.transparency,
                  child: SearchBar(
                    onChanged: (value) => ref.read(searchInputProvider.notifier).state = value,
                    onCancle: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            Expanded(
              child: users.when(
                loading: () => Column(
                  children: const [
                    SizedBox(height: 20),
                    Text('Searching...'),
                  ],
                ),
                error: (error, stack) => const Text('Oops, something unexpected happened'),
                data: (value) {
                  if (value.isEmpty) {
                    return Column(
                      children: const [
                        SizedBox(height: 20),
                        Text('No results'),
                      ],
                    );
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
