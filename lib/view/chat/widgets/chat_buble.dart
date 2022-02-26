import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.isMine, required this.message}) : super(key: key);
  final bool isMine;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
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
