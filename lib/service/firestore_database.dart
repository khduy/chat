import 'package:chat/model/chanel_model.dart';
import 'package:chat/model/message_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String channelId(String id1, String id2) {
  if (id1.hashCode < id2.hashCode) {
    return '$id1-$id2';
  }
  return '$id2-$id1';
}

class FireStoreDatabase {
  Future<bool> isUserExist(String id) async {
    final snap = await FirebaseFirestore.instance.collection('users').doc().get();
    return snap.exists;
  }

  Future<void> setUserToDB(UserModel user) async {
    FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toMap());
  }

  Stream<List<UserModel>> findUser(String username) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: username)
        .snapshots()
        .map((snapShot) {
      List<UserModel> rs = [];

      for (var element in snapShot.docs) {
        rs.add(UserModel.fromDocumentSnapshot(element));
      }

      return rs;
    });
  }

  Future<Channel?> getChannel(String channelId) async {
    return FirebaseFirestore.instance.collection('channels').doc(channelId).get().then((chanel) {
      if (chanel.exists) {
        return Channel.fromDocumentSnapshot(chanel);
      }
      return null;
    });
  }

  Future<void> updateChannel(String channelId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addMessage(Message message) async {
    await FirebaseFirestore.instance.collection('messages').add(message.toMap());
  }

  Stream<List<Message>> messageStream(String channelId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('channelId', isEqualTo: channelId)
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Message> rs = [];
      for (var element in querySnapshot.docs) {
        rs.add(Message.fromDocumentSnapshot(element));
      }
      return rs;
    });
  }
}
