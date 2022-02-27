import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/channel_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/chat/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChannelTile extends StatelessWidget {
  ChannelTile({Key? key, required this.channel}) : super(key: key);
  final Channel channel;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final oppositeUser = channel.members.firstWhere(
      (user) => user.id != _firebaseAuth.currentUser!.uid,
    );
    final currentUser = channel.members.firstWhere(
      (user) => user.id == _firebaseAuth.currentUser!.uid,
    );
    final isUnread = channel.unRead[currentUser.id]!;
    final theme = Theme.of(context);
    return InkWell(
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Avatar(
              radius: 26,
              photoURL: oppositeUser.photoUrl,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oppositeUser.displayName,
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (channel.sendBy == oppositeUser.id ? '' : 'You: ') + channel.lastMessage,
                        style: isUnread
                            ? TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                              )
                            : TextStyle(
                                color: theme.hintColor,
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '  ' + String.fromCharCode(0x00B7) + '  ' + 'now',
                      style: isUnread
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : TextStyle(
                              color: theme.hintColor,
                            ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }
}
