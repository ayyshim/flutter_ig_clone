import 'dart:io';

import 'package:instagram_clone/resources/storage_methods.dart';

class StorageRepositories {

  final _method = StorageMethod();

  // Upload image and get download link.
  Future<String> uploadImage({String uid, File image, bool isDp = true}) => _method.uploadImage(image, uid, isDp: isDp);

  // Delete image
  Future delete({String url}) => _method.delete(url: url);
}