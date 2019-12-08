import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/resources/storage_repositories.dart';
import 'package:instagram_clone/widgets/labeled_input_field.dart';
import 'package:instagram_clone/widgets/progress_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditProfile extends StatefulWidget {

  static final String id = "edit_profile";

  final CurrentUser data;

  const EditProfile({Key key, this.data}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  File _image = null;
  String _name = "", _bio = "";

  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final StorageRepositories _storageRepositories = StorageRepositories();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = widget.data.fullName;
    _bio = widget.data.bio;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(MdiIcons.closeCircleOutline),
          color: Colors.grey[900],
        ),
        title: Text("Edit Profile",
          style: TextStyle(
            color: Colors.grey[900]
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if(_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _save_change();
              }
            },
            icon: Icon(MdiIcons.check),
            color: Colors.blue[400],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 28,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      backgroundImage: _loadDisplayPicture(widget.data),
                      radius: 50,
                    ),
                    SizedBox(height: 12,),
                    InkWell(
                      onTap: () {
                        _showImageChangeOption();
                      },
                      child: Text(
                        "Change Profile Photo",
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 18
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 28,),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    LabeledInputField(
                      initalValue: widget.data.fullName,
                      label: "Name",
                      onChanged: (name) {
                        setState(() {
                          _name = name;
                        });
                      },
                      validator: (String name) {
                        if(name.isEmpty) {
                          return "Name can not be blank.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 14,),
                    LabeledInputField(
                      textInputType: TextInputType.multiline,
                      initalValue: widget.data.bio,
                      label: "Bio",
                      onChanged: (bio) {
                        setState(() {
                          _bio = bio;
                        });
                      },
                      validator: (String bio) {
                        if(bio.length > 100) {
                          return "Bio can not be more than 100 characters.";
                        } else {
                          return null;
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _loadDisplayPicture(CurrentUser data) {
    return _image == null ? data.avatar == "default" ?
        AssetImage("assets/images/default_avatar.png")
        : CachedNetworkImageProvider(data.avatar)
        : FileImage(_image);
  }

  _save_change() async {

    if(_name == widget.data.fullName && _bio == widget.data.bio && _image == null) {
      Navigator.pop(context);
    } else {
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context) =>
              WillPopScope(
                onWillPop: () async => false,
                child: ProgressDialog(
                  title: "Saving change.",
                ),
              )
      );

      Map<String, dynamic> _data = {
        "fullName": _name,
        "bio": _bio.trim(),
      };

      if(_image != null) {
        String url = await _storageRepositories.uploadImage(uid: widget.data.uid, image: _image);
        _data["avatar"] = url;
      }

      await _databaseRepository.saveUserData(uid: widget.data.uid, data: _data);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  _showImageChangeOption() {
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
  }

  _openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    File croppedImage = await _cropImage(image);
    setState(() {
      _image = croppedImage;
    });
  }

  _pickImageFromAlbum() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedImage = await _cropImage(image);
    setState(() {
      _image = croppedImage;
    });

  }

  _cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Adjust Image'
        )
    );
    Navigator.pop(context);
    return croppedImage;
  }
}
