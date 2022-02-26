// ignore_for_file: prefer_const_constructors

import 'package:chat/common_widgets/avatar.dart';
import 'package:chat/model/chanel_model.dart';
import 'package:chat/model/message_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/service/firestore_database.dart';
import 'package:chat/view/chat/widgets/chat_buble.dart';
import 'package:chat/view/chat/widgets/chat_footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageStreamProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, channelId) {
  return FireStoreDatabase().messageStream(channelId);
});

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.channel, required this.oppositeUser}) : super(key: key);
  final Channel? channel;
  final UserModel oppositeUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Channel? _channel;
  final _messageController = TextEditingController();
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // late final String _channelId;
  @override
  void initState() {
    super.initState();
    _channel = widget.channel;
    // _channelId = channelId(FirebaseAuth.instance.currentUser!.uid, widget.oppositeUser.id);
  }

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Consumer(
                  builder: (context, ref, _) {
                    final _channelId = channelId(_currentUserId, widget.oppositeUser.id);
                    final messages = ref.watch(messageStreamProvider(_channelId)).value;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        reverse: true,
                        itemCount: messages?.length ?? 0,
                        itemBuilder: (context, index) {
                          bool isMine = _currentUserId == messages?[index].senderId;

                          return MessageItem(
                            isMine: isMine,
                            message: messages![index].textMessage,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 3);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            ChatFooter(
              textController: _messageController,
              onSendMessage: onSendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void onSendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }
    if (_channel == null) {
      var userId1 = FirebaseAuth.instance.currentUser!.uid;
      var userId2 = widget.oppositeUser.id;
      _channel = Channel(
        id: channelId(userId1, userId2),
        memberIds: [userId1, userId2],
        lastMessage: _messageController.text,
        lastTime: Timestamp.now(),
        unRead: {
          userId1: false,
          userId2: true,
        },
      );

      FireStoreDatabase().updateChannel(_channel!.id, _channel!.toMap());
    }
    var docRef = FirebaseFirestore.instance.collection('messages').doc();
    var message = Message(
      id: docRef.id,
      textMessage: _messageController.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
      sendAt: Timestamp.now(),
      channelId: _channel!.id,
    );
    FireStoreDatabase().addMessage(message);

    var channelUpdateData = {
      'lastMessage': message.textMessage,
      'lastTime': message.sendAt,
      'unRead': {
        _currentUserId: false,
        widget.oppositeUser.id: true,
      },
    };
    FireStoreDatabase().updateChannel(_channel!.id, channelUpdateData);

    _messageController.clear();
  }
}
