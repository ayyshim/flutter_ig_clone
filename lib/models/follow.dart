import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Follow {
  String _following;

  String get following => _following;

  set following(String following) {
    _following = following;
  }

  String _user;

  String get user => _user;

  set user(String user) {
    _user = user;
  }
}

class Follower extends Follow{}

class Following extends Follow{}