import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class UserProps {
  String _uid;
  String _fullName;
  String _email;
  String _bio;
  String _avatar;


  String get uid => _uid;
  set uid(String uid) {
    _uid = uid;
  }

  String get fullName => _fullName;
  set fullName(String fullName) {
    _fullName = fullName;
  }

  String get email => _email;
  set email(String email) {
    _email = email;
  }

  String get bio => _bio;
  set bio(String bio) {
    _bio = bio;
  }

  String get avatar => _avatar;
  set avatar(String avatar) {
    _avatar = avatar;
  }
}

class User extends UserProps{

  User({String $uid, String $fullName, String $email, String $bio, String $avatar}) {
    uid = $uid;
    fullName = $fullName;
    email = $email;
    bio = $bio ?? "";
    avatar = $avatar;
  }

  factory User.fromDoc(DocumentSnapshot snapshot) {
    return User(
        $uid: snapshot.documentID,
      $fullName: snapshot.data["fullName"],
      $email: snapshot.data["email"],
      $bio: snapshot.data["bio"] ?? "",
      $avatar: snapshot.data["avatar"]
    );
  }
}

class CurrentUser extends ChangeNotifier with UserProps{
  CurrentUser();
}