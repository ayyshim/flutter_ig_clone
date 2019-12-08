import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/constants/firebase_refs.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {

  Future<String> uploadImage(File image, String uid, {bool isDp = true}) async {
    String path;
    if(isDp) {
      path = "dp/$uid";
    } else {
      path = "posts/${Uuid().v1()}_$uid";
    }

    StorageUploadTask uploadTask = storage.child('users/${path}.jpg').putFile(
        image);

    StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask
        .events.listen((event) {
      print('Event ${event.type}');
    });
    StorageTaskSnapshot uploaded_file = await uploadTask.onComplete;
    streamSubscription.cancel();

    String url = await uploaded_file.ref.getDownloadURL();

    return url;
  }

  Future delete({String url}) async {
    StorageReference storageReference = await storage.getStorage().getReferenceFromUrl(url);
    await storageReference.delete();
  }


}