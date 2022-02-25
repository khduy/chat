import 'package:cloud_firestore/cloud_firestore.dart';

class Channel {
  final String id;
  final List<String> memberIds;
  final String lastMessage;
  final Timestamp lastTime;
  final Map<String, bool> unRead;

  Channel({
    required this.id,
    required this.memberIds,
    required this.lastMessage,
    required this.lastTime,
    required this.unRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberIds': memberIds,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
      'unRead': unRead,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] ?? '',
      memberIds: List<String>.from(map['memberIds']),
      lastMessage: map['lastMessage'] ?? '',
      lastTime: map['lastTime'] as Timestamp,
      unRead: map['unRead'],
    );
  }
  factory Channel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Channel(
      id: snapshot.id,
      memberIds: List<String>.from(snapshot['memberIds']),
      lastMessage: snapshot['lastMessage'] ?? '',
      lastTime: snapshot['lastTime'] as Timestamp,
      unRead: snapshot['unRead'],
    );
  }
}
