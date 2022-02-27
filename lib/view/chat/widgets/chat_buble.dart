import 'package:chat/common_widgets/avatar.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.isMine,
    required this.message,
    this.photoUrl,
  }) : super(key: key);
  final bool isMine;
  final String message;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMine)
          Avatar(
            radius: 12,
            photoURL: photoUrl,
          ),
        SizedBox(width: isMine ? 0 : 4),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isMine ? Theme.of(context).primaryColor : Colors.grey[300],
          ),
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: isMine ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
