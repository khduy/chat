import 'package:chat/model/chanel_model.dart';
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
        .where('userName', isEqualTo: username)
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
}
