import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/follow.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/screens/profile/edit_profile.dart';
import 'package:provider/provider.dart';

class ProfileStats extends StatelessWidget {

  final UserProps profile;

  const ProfileStats({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseRepository _databaseRepository = DatabaseRepository();

    final _currentUser = Provider.of<CurrentUser>(context);

    bool isOwnProfile = _currentUser.uid == profile.uid;

    final _boldText = TextStyle(
        fontWeight: FontWeight.w700, color: Colors.grey[900], fontSize: 18);

    final _normalText = TextStyle(color: Colors.grey[900], fontSize: 12);

    toggleFollow() async {
      await _databaseRepository.toggleFollow(uid: profile.uid, currentUser: _currentUser.uid);
    }

    Widget _profileActionButton(bool isOwnProfile) {
      if (isOwnProfile) {
        return FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, EditProfile.id);
          },
          child: Text(
            "Edit Profile",
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300], width: 1.0)),
          color: Colors.white,
          textColor: Colors.black,
        );
      } else {
        return FutureBuilder(
          future: _databaseRepository.followStatus(
              uid: profile.uid, currentUser: _currentUser.uid),
          builder: (context, data) {

            if (data.hasData) {
              String text;
              Color bg_color;
              Color border_color;
              Color text_color;

              if (data.data["isFollowing"]) {
                text = "Following";
                bg_color = Colors.white;
                border_color = Colors.grey[300];
                text_color = Colors.black;

              } else {
                if (data.data["isFollowed"]) {
                  text = "Follow back";

                } else {
                  text = "Follow";

                }
                bg_color = Colors.blue[400];
                text_color = Colors.white;
                border_color = Colors.grey[300];

              }
              return FlatButton(
                onPressed: () async {
                  await _databaseRepository.toggleFollow(uid: profile.uid, currentUser: _currentUser.uid);
                  print("Pressed");
                },
                child: Text(
                  text,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: border_color, width: 1.0)),
                color: bg_color,
                textColor: text_color,
              );
            } else {
              return FlatButton(
                onPressed: null,
                child: Text(
                  "Loading",
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[300], width: 1.0)),
                color: Colors.white,
                textColor: Colors.black,
              );
            }
          },
        );
      }
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: profile.avatar == "default"
                    ? AssetImage('assets/images/default_avatar.png')
                    : CachedNetworkImageProvider(profile.avatar),
                backgroundColor: Colors.grey[200],
                radius: 40,
              ),
              SizedBox(
                width: 32,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FutureBuilder<List<Post>>(
                          future: _databaseRepository.getProfilePost(
                              uid: profile.uid),
                          builder: (context, data) {
                            if (data.hasData) {
                              return Text(
                                data.data.length.toString(),
                                style: _boldText,
                              );
                            } else {
                              return CupertinoActivityIndicator(
                                animating: true,
                              );
                            }
                          },
                        ),
                        Text(
                          "Posts",
                          style: _normalText,
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FutureBuilder<List<Follower>>(
                          future: _databaseRepository.getFollowers(
                              uid: profile.uid),
                          builder: (context, data) {
                            if (data.hasData) {
                              return Text(
                                data.data.length.toString(),
                                style: _boldText,
                              );
                            } else {
                              return CupertinoActivityIndicator(
                                animating: true,
                              );
                            }
                          },
                        ),
                        Text(
                          "Followers",
                          style: _normalText,
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FutureBuilder<List<Following>>(
                          future: _databaseRepository.getFollowings(
                              uid: profile.uid),
                          builder: (context, data) {
                            if (data.hasData) {
                              return Text(
                                data.data.length.toString(),
                                style: _boldText,
                              );
                            } else {
                              return CupertinoActivityIndicator(
                                animating: true,
                              );
                            }
                          },
                        ),
                        Text(
                          "Following",
                          style: _normalText,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Text(
                profile.fullName,
                style: _normalText.copyWith(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 4,
              ),
//              this.profile.isVerified ? Icon(MdiIcons.checkDecagram, color: Colors.blue[400], size: 18,) : Text("")
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            profile.bio,
            style: TextStyle(),
          ),
          SizedBox(
            height: 16,
          ),
          _profileActionButton(isOwnProfile)
        ],
      ),
    );
  }
}
