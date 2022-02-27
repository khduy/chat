import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/channel_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/chat/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChannelsListView extends StatelessWidget {
  const ChannelsListView({
    Key? key,
    required this.firebaseAuth,
    required this.channels,
  }) : super(key: key);

  final FirebaseAuth firebaseAuth;
  final List<Channel> channels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        var oppositeUser =
            channel.members.firstWhere((user) => user.id != firebaseAuth.currentUser!.uid);
        var currentUser =
            channel.members.firstWhere((user) => user.id == firebaseAuth.currentUser!.uid);
        final bool isUnread = channel.unRead[currentUser.id]!;
        return ListTile(
          leading: Avatar(
            photoURL: oppositeUser.photoUrl,
          ),
          title: Text(
            oppositeUser.displayName,
            style: isUnread ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          subtitle: Text(
            (channel.sendBy == oppositeUser.id ? '' : 'You: ') + channel.lastMessage,
            style: isUnread
                ? TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.light ? Colors.black : Colors.white,
                  )
                : null,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  oppositeUser: oppositeUser,
                  channel: channel,
                ),
              ),
            );
            if (isUnread) {
              channel.unRead[currentUser.id] = false;
              var data = {
                'unRead': channel.unRead,
              };
              FireStoreDatabase().updateChannel(channel.id, data);
            }
          },
        );
      },
    );
  }
}
