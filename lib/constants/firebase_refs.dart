
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final Firestore _store = Firestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

final CollectionReference user_col = _store.collection("users");
final CollectionReference search_col = _store.collection("searchHistory");
final CollectionReference follow_col = _store.collection("follows");
final CollectionReference post_col = _store.collection("posts");
final CollectionReference like_col = _store.collection("likes");


final StorageReference storage = _storage.ref();
