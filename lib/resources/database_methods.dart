import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/constants/firebase_refs.dart';
import 'package:instagram_clone/models/follow.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/search_history.dart';
import 'package:instagram_clone/models/user.dart';

class DatabaseMethod {

  Future<User> getUserByUID(String uid) async {
    DocumentSnapshot userDoc = await user_col.document(uid).get();
    return User.fromDoc(userDoc);
  }

  Future saveUserData({String uid, Map<String, dynamic> data}) async {
    await user_col.document(uid).updateData(data);
  }

  Future<List<User>> searchUser(String fullName, String uid) async {
    QuerySnapshot querySnapshot = await user_col.where("fullName", isGreaterThanOrEqualTo: fullName).getDocuments(source: Source.serverAndCache);
    List<User> res = querySnapshot.documents.where((_doc) => _doc.documentID != uid).map((DocumentSnapshot snapshot) {
      return User.fromDoc(snapshot);
    }) .toList();

    return res;
  }

  void saveRecentSearch(String user, String userLooked) async {
    QuerySnapshot query_snapshot = await search_col.where(
        "currentUser", isEqualTo: user).where(
        "userLooked", isEqualTo: userLooked).getDocuments();

    if (query_snapshot.documents.length > 0) {
      DocumentSnapshot documentSnapshot = query_snapshot.documents[0];
      Map<String, dynamic> data = {
        "timestamp": FieldValue.serverTimestamp()
      };

      await search_col.document(documentSnapshot.documentID).updateData(data);
    } else {
      Map<String, dynamic> data = {
        "currentUser": user,
        "userLooked": userLooked,
        "timestamp": FieldValue.serverTimestamp()
      };

      await search_col.add(data);
    }
  }

  Future<List<SearchHistory>> searchHistory({String uid}) async {
    final QuerySnapshot querySnapshot = await search_col.where("currentUser", isEqualTo: uid).orderBy("timestamp").getDocuments(source: Source.serverAndCache);
    List<SearchHistory> _searchUser = querySnapshot.documents.map(
        (DocumentSnapshot snapshot) {
          return SearchHistory.fromDoc(snapshot);
        }
    ).toList();
    return _searchUser;
  }
  
  Future<List<Follower>> getFollowers({String uid}) async {
    final QuerySnapshot querySnapshot = await follow_col.where("following", isEqualTo: uid).getDocuments(source: Source.serverAndCache);
    List<Follower> _followers = querySnapshot.documents.map((DocumentSnapshot snapShot) {
      Follower follower = Follower();
      follower.user = snapShot.data["user"];
      follower.following = snapShot.data["following"];
      return follower;
    }).toList();
    
    return _followers;
  }

  Future<List<Following>> getFollowings({String uid}) async {
    final QuerySnapshot querySnapshot = await follow_col.where("user", isEqualTo: uid).getDocuments(source: Source.serverAndCache);
    List<Following> _followings = querySnapshot.documents.map((DocumentSnapshot snapShot) {
      Following following = Following();
      following.user = snapShot.data["user"];
      following.following = snapShot.data["following"];
      return following;
    }).toList();

    return _followings;
  }

  Future followStatus({String uid, String currentUser}) async {

    final QuerySnapshot _isFollowing = await follow_col.where("user", isEqualTo: currentUser).where("following", isEqualTo: uid).getDocuments(source: Source.serverAndCache);
    final QuerySnapshot _isFollowed = await follow_col.where("user", isEqualTo: uid).where("following", isEqualTo: currentUser).getDocuments(source: Source.serverAndCache);

    Map<String, bool> status = {
      "isFollowing": _isFollowing.documents.length != 0,
      "isFollowed": _isFollowed.documents.length != 0
    };

    return status;
  }

  Future followToggle({String uid, String currentUser}) async {
    final QuerySnapshot _querySnapshot = await follow_col.where("user", isEqualTo: currentUser).where("following", isEqualTo: uid).getDocuments(source: Source.serverAndCache);

    if (_querySnapshot.documents.length != 0) {
      await follow_col.document(_querySnapshot.documents[0].documentID).delete();
    } else {
      Map<String, dynamic> _data = {
        "following": uid,
        "user": currentUser
      };
      await follow_col.add(_data);
    }
  }

  Future uploadPost({String uid, String image, String caption}) async {
    Map<String, dynamic> data = {
      "uid": uid,
      "image": image,
      "caption": caption,
      "timestamp": FieldValue.serverTimestamp()
    };

    await post_col.add(data);
  }


  Future<List<Post>> getProfilePosts({String uid}) async {
    final QuerySnapshot querySnapshot = await post_col.where("uid", isEqualTo: uid).orderBy("timestamp", descending: true).getDocuments(source: Source.serverAndCache);

    List<Post> posts = querySnapshot.documents.map(
        (doc) {
          return Post.fromDoc(doc);
        }
    ).toList();

    return posts;
  }

  Future<SinglePost> getSinglePostMetaData({String pid, String p_uid, String currentUser}) async {
    final User user = await getUserByUID(p_uid);
    final String username = user.fullName;
    final String avatar = user.avatar;

    final QuerySnapshot totalLikeQuery = await like_col.where("pid", isEqualTo: pid).orderBy("timestamp", descending: true).getDocuments(source: Source.serverAndCache);
    int totalCount = totalLikeQuery.documents.length;

    String lastLikedBy = null;
    User lastLikedByUser = null;
    bool isLiked = false;

    if(totalCount > 0) {

      final User lastLiked = await getUserByUID(totalLikeQuery.documents[0].data["uid"]);
      lastLikedBy = lastLiked.fullName;
      lastLikedByUser = lastLiked;

      final QuerySnapshot isLikedQuery = await like_col.where("pid", isEqualTo: pid).where("uid", isEqualTo: currentUser).getDocuments();
      isLiked = isLikedQuery.documents.length != 0;

    }


    SinglePost post = SinglePost(
      id: pid,
      avatar: avatar,
      isLiked: isLiked,
      lastLikedBy: lastLikedBy,
      lastLikedByUID: lastLikedByUser,
      likeCount: totalCount,
      username: username,
    );

    return post;

  }

  Future toggleHeart({String pid, String currentUser}) async {
    final QuerySnapshot likeQuerySnapshot = await like_col.where("pid", isEqualTo: pid).where("uid", isEqualTo: currentUser).getDocuments(source: Source.serverAndCache);

    if(likeQuerySnapshot.documents.length != 0) {
      await like_col.document(likeQuerySnapshot.documents[0].documentID).delete();
    } else {
      Map<String, dynamic> data = {
        "pid": pid,
        "uid": currentUser,
        "timestamp": FieldValue.serverTimestamp()
      };

      await like_col.add(data);
    }
  }

  Future delete({String pid}) async {
    await post_col.document(pid).delete();
  }

  Future editCaption({String pid, String caption}) async {
    await post_col.document(pid).updateData({
      "caption": caption
    });
  }
}