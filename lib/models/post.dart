import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';

class Post {
  final String id;
  final String uid;
  final String caption;
  final String image;
  final Timestamp timestamp;

  Post({this.id, this.uid, this.caption, this.image, this.timestamp});

  factory Post.fromDoc(DocumentSnapshot snapshot) {
    return Post(
      id: snapshot.documentID,
      uid: snapshot.data["uid"],
      image: snapshot.data["image"],
      caption: snapshot.data["caption"],
      timestamp: snapshot.data["timestamp"]
    );
  }
}

class SinglePost {
  final String id;
  final bool isLiked;
  final int likeCount;
  final String lastLikedBy;
  final User lastLikedByUID;
  final String username;
  final String avatar;

  SinglePost({this.id, this.isLiked, this.likeCount, this.lastLikedBy, this.lastLikedByUID, this.username, this.avatar});
}

class Likes {
  final String uid;
  final String pid;
  final Timestamp timestamp;

  Likes({this.uid, this.pid, this.timestamp});
}