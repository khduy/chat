import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class UserModel extends HiveObject {

  final String id;

  final String displayName;


  final String userName;


  final String photoUrl;

  UserModel({
    required this.id,
    required this.displayName,
    required this.userName,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'userName': userName,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      userName: map['userName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      displayName: snapshot['displayName'] ?? '',
      userName: snapshot['userName'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
    );
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      displayName: user.displayName!,
      userName: user.email!.replaceAll('@gmail.com', ''),
      photoUrl: user.photoURL!,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, displayName: $displayName, userName: $userName, photoUrl: $photoUrl)';
  }
}
