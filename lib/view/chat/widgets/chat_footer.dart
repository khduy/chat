import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatFooter extends StatelessWidget {
  const ChatFooter({
    Key? key,
    required this.textController,
    required this.onSendMessage,
  }) : super(key: key);

  final TextEditingController textController;
  final Function() onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: textController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                fillColor: Colors.black12,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: 'Aa',
              ),
            ),
          ),
        ),
        CupertinoButton(
          child: const Icon(
            Icons.send_rounded,
            size: 32,
          ),
          padding: EdgeInsets.zero,
          onPressed: onSendMessage,
        )
      ],
    );
  }
}
