import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.photoURL, this.radius}) : super(key: key);
  final String? photoURL;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black12,
      backgroundImage: photoURL != null ? CachedNetworkImageProvider(photoURL!) : null,
      radius: radius,
      child: photoURL == null ? Icon(Icons.person, size: radius) : null,
    );
  }
}
