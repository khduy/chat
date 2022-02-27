import 'package:chat/model/channel_model.dart';
import 'package:chat/view/home/widgets/channel_tile.dart';
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
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        return ChannelTile(channel: channel);
      },
    );
  }
}
