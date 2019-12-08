import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/follow.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/search_history.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_methods.dart';

class DatabaseRepository {

  final _method = DatabaseMethod();

  Future<User> getUserByUID({String uid}) => _method.getUserByUID(uid);

  // Save user data
  Future saveUserData({String uid, Map<String, dynamic> data}) => _method.saveUserData(uid: uid, data: data);

  // Search user
  Future<List<User>> searchUser(String fullName, String uid) => _method.searchUser(fullName, uid);

  // Save search history
  void saveRecentSearch({String currentUser, String userLooked}) => _method.saveRecentSearch(currentUser, userLooked);

  // Show search history
  Future<List<SearchHistory>> searchHistory({String uid}) => _method.searchHistory(uid: uid);

  // Get followers
  Future<List<Follower>> getFollowers({String uid}) => _method.getFollowers(uid: uid);

  // Get followings
  Future<List<Following>> getFollowings({String uid}) => _method.getFollowings(uid: uid);

  // Get follow status
  Future followStatus({String uid, String currentUser}) => _method.followStatus(uid: uid, currentUser: currentUser);

  // Toggle follow
  Future toggleFollow({String uid, String currentUser}) => _method.followToggle(currentUser: currentUser, uid: uid);

  // Upload post
  Future uploadPost({String uid, String image, String caption}) => _method.uploadPost(image: image, uid: uid,caption: caption);

  // get profile posts
  Future<List<Post>> getProfilePost({String uid}) => _method.getProfilePosts(uid: uid);

  // get single post detail
  Future<SinglePost> getSinglePostMeta({String pid, String p_uid, String currentUser}) => _method.getSinglePostMetaData(currentUser: currentUser, p_uid: p_uid, pid: pid);

  // Toggle like
  Future toggleLike({String pid, String currentUser}) => _method.toggleHeart(currentUser: currentUser, pid: pid);

  // Delete post
  Future delete({String pid}) => _method.delete(pid: pid);

  // Edit caption
  Future editCaption({String pid, String caption}) => _method.editCaption(pid: pid, caption: caption);
}