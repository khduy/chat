// ignore_for_file: prefer_const_constructors

import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/chanel_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/view/chat/widgets/chat_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.channel, required this.oppositeUser}) : super(key: key);
  final Channel? channel;
  final UserModel oppositeUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Channel? _channel;
  var _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Avatar(photoURL: widget.oppositeUser.photoUrl),
            const SizedBox(width: 8),
            Text(widget.oppositeUser.displayName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          ChatFooter(
            textController: _messageController,
            onSendMessage: () {},
          ),
        ],
      ),
    );
  }
}
