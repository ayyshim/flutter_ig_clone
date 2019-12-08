import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/resources/storage_repositories.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  
  final File image;

  const UploadScreen({Key key, this.image}) : super(key: key);
  
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isLoading = false;

  String caption = "";

  @override
  Widget build(BuildContext context) {


    final CurrentUser _currentUser = Provider.of<CurrentUser>(context);

    final DatabaseRepository _databaseRepository = DatabaseRepository();
    final StorageRepositories _storageRepository = StorageRepositories();

    _share() async {
      setState(() {
        isLoading = true;
      });
      String url = await _storageRepository.uploadImage(uid: _currentUser.uid, image: widget.image, isDp: false);
      await _databaseRepository.uploadPost(uid: _currentUser.uid, image: url, caption: caption);

      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey[900],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("New Post",
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w600
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              _share();
            },
            child: Text("Share",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue[600],
                fontSize: 18
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          isLoading == true ? LinearProgressIndicator(
            backgroundColor: Colors.indigo,
          ) : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Image.file(widget.image,
                  height: 70,
                  width: 70,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (val) {
                      setState(() {
                        caption = val;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0)
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }


}
