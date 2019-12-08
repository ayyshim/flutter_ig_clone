import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  final String id;
  final String currentUser;
  final String userLooked;
  final Timestamp timestamp;

  SearchHistory({this.id, this.currentUser, this.userLooked, this.timestamp});

  factory SearchHistory.fromDoc(DocumentSnapshot snapshot) {
    return SearchHistory(
      timestamp: snapshot.data["timestamp"],
      currentUser: snapshot.data["currentUser"],
      userLooked: snapshot.data["userLooked"],
      id: snapshot.documentID
    );
  }
}