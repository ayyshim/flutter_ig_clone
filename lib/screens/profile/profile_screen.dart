import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/Utility.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_repositories.dart';
import 'package:instagram_clone/screens/profile/profile_posts.dart';
import 'package:instagram_clone/screens/profile/profile_stats.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatefulWidget {

  final UserProps currentUser;
  final UserProps user;

  const ProfileScreen({Key key, this.currentUser, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {

    UserProps _profile = widget.user ?? widget.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: Navigator.canPop(context) ? AppBar(
        title: Text( Utility.clip_fullname(name: _profile.fullName) ,
          style: TextStyle(
              color: Colors.grey[900]
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[50],
        actions: <Widget>[
          widget.user == null ? IconButton(
              onPressed: () => _logout(),
              icon: Icon(MdiIcons.menu),
              color: Colors.grey[900]
          ): Container()
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey[900],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ) : AppBar(
        title: Text( Utility.clip_fullname(name: _profile.fullName) ,
          style: TextStyle(
              color: Colors.grey[900]
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[50],
        actions: <Widget>[
          widget.user == null ? IconButton(
              onPressed: () => _logout(),
              icon: Icon(MdiIcons.menu),
              color: Colors.grey[900]
          ): Container()
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ProfileStats(profile: _profile,),
            Divider(

            ),
            ProfilePosts(uid: _profile.uid,)
          ],

        ),
      ),
    );
  }

  _logout() async{
    await _authRepository.logout();
  }
}
