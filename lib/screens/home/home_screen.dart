import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/feeds/feeds_screen.dart';
import 'package:instagram_clone/screens/notification/notification_screen.dart';
import 'package:instagram_clone/screens/profile/profile_screen.dart';
import 'package:instagram_clone/screens/search/search_screen.dart';
import 'package:instagram_clone/screens/upload_post/upload_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  static final String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _current_tab = 0;

  @override
  Widget build(BuildContext context) {

    final _current_user = Provider.of<CurrentUser>(context);

    var _tabs = [
      FeedsScreen(),
      SearchScreen(uid: _current_user.uid,),
      null,
      NotificationScreen(),
      ProfileScreen(currentUser: _current_user, user: null,),
    ];


    return Scaffold(
      body: SafeArea(
        child: _tabs[_current_tab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[700],
        unselectedLabelStyle: TextStyle(
          color: Colors.black12
        ),
        selectedItemColor: Colors.grey[900],
        selectedLabelStyle: TextStyle(
          color: Colors.black
        ),
        onTap: (int index) {
          if(index == 2) {
            showModalBottomSheet(context: context, builder: (BuildContext context) {
              return Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(MdiIcons.camera),
                        title: new Text('Open camera'),
                        onTap: () {
                          _openCamera();
                        }
                    ),
                    new ListTile(
                      leading: new Icon(MdiIcons.album),
                      title: new Text('Select from album'),
                      onTap: () {
                        _pickImageFromAlbum();
                      },
                    ),
                  ],
                ),
              );
            });
          } else {
            setState(() {
              _current_tab = index;
            });
          }
        },
        currentIndex: _current_tab,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.homeVariant),
            icon: Icon(MdiIcons.homeVariantOutline),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.cardSearch),
            icon: Icon(MdiIcons.cardSearchOutline),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.camera),
            icon: Icon(MdiIcons.cameraOutline),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.heart),
            icon: Icon(MdiIcons.heartOutline),
            title: Text("Notification"),
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: CachedNetworkImageProvider(_current_user.avatar),
            ),
            title: Text("Home"),
          )
        ],
      ),
    );
  }
  void _openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    File croppedImage = await _cropImage(image);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
       return UploadScreen(image: croppedImage,);
      }
    ));
  }

  void _pickImageFromAlbum() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedImage = await _cropImage(image);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return UploadScreen(image: croppedImage,);
        }
    ));
  }

  _cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        compressQuality: 40,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Adjust Image'
        )
    );
    Navigator.pop(context);
    return croppedImage;
  }
}
