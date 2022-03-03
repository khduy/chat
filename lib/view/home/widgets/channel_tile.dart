import '../../../common_widgets/avatar.dart';
import '../../../model/channel_model.dart';
import '../../../model/user_model.dart';
import '../../chat/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChannelTile extends StatelessWidget {
  ChannelTile({Key? key, required this.channel}) : super(key: key) {
    _oppositeUser = channel.members.firstWhere(
      (user) => user.id != _firebaseAuth.currentUser!.uid,
    );
    _currentUser = channel.members.firstWhere(
      (user) => user.id == _firebaseAuth.currentUser!.uid,
    );
    _isUnread = channel.unRead[_currentUser.id]!;
  }
  final Channel channel;
  final _firebaseAuth = FirebaseAuth.instance;

  late final UserModel _oppositeUser;
  late final UserModel _currentUser;
  late final bool _isUnread;

  String _dateFormat(DateTime date) {
    final dif = DateTime.now().difference(date);

    if (dif < const Duration(days: 1)) {
      return DateFormat('hh:mm a').format(date);
    } else if (dif < const Duration(days: 10)) {
      return DateFormat('EEE d').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              oppositeUser: _oppositeUser,
              channel: channel,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Avatar(
              radius: 26,
              photoURL: _oppositeUser.photoUrl,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _oppositeUser.displayName,
                  style: TextStyle(
                    fontWeight: _isUnread ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (channel.sendBy == _oppositeUser.id ? '' : 'You: ') + channel.lastMessage,
                        style: _isUnread
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
                    const SizedBox(width: 8),
                    Text(
                      _dateFormat(channel.lastTime.toDate()),
                      style: _isUnread
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
