import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/resources/storage_repositories.dart';
import 'package:instagram_clone/screens/feeds/edit_caption.dart';
import 'package:instagram_clone/screens/profile/profile_screen.dart';
import 'package:instagram_clone/widgets/progress_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SinglePostScreen extends StatefulWidget {

  final Post post;

  const SinglePostScreen({Key key, this.post}) : super(key: key);

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {

  bool isLiked = false;

  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final StorageRepositories _storageRepositories = StorageRepositories();

  Future<SinglePost> getSinglePostMeta(String currentUser) async{

    SinglePost _singlePost = await _databaseRepository.getSinglePostMeta(pid: widget.post.id, p_uid: widget.post.uid, currentUser: currentUser);

    if(_singlePost.isLiked != isLiked) {
      setState(() {
        isLiked = _singlePost.isLiked;
      });
    }

    return _singlePost;
  }

  @override
  Widget build(BuildContext context) {
    final CurrentUser _currentUser = Provider.of<CurrentUser>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          color: Colors.grey[900],
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        backgroundColor: Colors.grey[50],
        title: Text("Posts",
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: FutureBuilder<SinglePost>(
        future: getSinglePostMeta(_currentUser.uid),
        builder: (context, asyncData) {
          if(asyncData.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  backgroundImage: CachedNetworkImageProvider(asyncData.data.avatar),
                                  radius: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        user: asyncData.data.lastLikedByUID,
                                        currentUser: _currentUser,
                                      )
                                    ));
                                  },
                                  child: Text(asyncData.data.username,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                )
                              ],
                            ),
                            _currentUser.uid == widget.post.uid ?
                              IconButton(
                                  icon: Icon(MdiIcons.dotsVertical),
                                  onPressed: () {
                                    showDialog(builder: (context) {
                                      return AlertDialog(
                                        titlePadding: EdgeInsets.all(14),
                                        contentPadding: EdgeInsets.all(0),
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        content: Container(
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              ListTile(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) {
                                                      return EditCaptionScreen(post: widget.post,);
                                                    }
                                                  ));
                                                },
                                                title: Text("Edit caption"),
                                                isThreeLine: false,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  showDialog(context: context, builder: (context) {
                                                    return ProgressDialog(title: "Deleting...",);
                                                  });
                                                  _delete();
                                                },
                                                title: Text("Delete",
                                                  style: TextStyle(
                                                    color: Colors.redAccent
                                                  ),
                                                ),
                                                isThreeLine: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }, context: context);
                                  },
                                ) : SizedBox(width: 0,)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onDoubleTap: () {
                        _toggleHeart(_currentUser.uid);
                      },
                      child: Image(
                        image: CachedNetworkImageProvider(widget.post.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: isLiked ? Icon(MdiIcons.heart) : Icon(MdiIcons.heartOutline),
                            color: isLiked ? Colors.redAccent : Colors.grey[900],
                            onPressed: () {
                              _toggleHeart(_currentUser.uid);
                            },
                            iconSize: 24,
                          ),
                          IconButton(
                            icon: Icon(MdiIcons.commentOutline),
                            color: Colors.grey[900],
                            onPressed: () {},
                            iconSize: 24,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: asyncData.data.likeCount == 0 ?
                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 14
                              ),
                              children: [
                                TextSpan(text: "Liked by 0"),
                              ]
                          ),
                        ) : asyncData.data.likeCount == 1 ?
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 14
                            ),
                            children: [
                              TextSpan(text: "Liked by "),
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ProfileScreen(currentUser: _currentUser,
                                        user: asyncData.data.lastLikedByUID,
                                      )
                                  ));
                                },
                                text: asyncData.data.lastLikedBy, style: TextStyle(
                                  fontWeight: FontWeight.w600
                              ),
                              ),
                            ]
                        ),
                      ) : RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 14
                            ),
                            children: [
                              TextSpan(text: "Liked by "),
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ProfileScreen(currentUser: _currentUser,
                                      user: asyncData.data.lastLikedByUID,
                                    )
                                  ));
                                },
                                text: asyncData.data.lastLikedBy, style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(text: "${asyncData.data.likeCount - 1} other(s)", style: TextStyle(
                                  fontWeight: FontWeight.w600
                              ))
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.post.caption.isNotEmpty ?
                          Wrap(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        user: asyncData.data.lastLikedByUID,
                                        currentUser: _currentUser,
                                      )
                                  ));
                                },
                                child: Text(asyncData.data.username, style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w600
                                ),),
                              ),
                              SizedBox(width: 10,),
                              Text(widget.post.caption)
                            ],
                          )
                      : SizedBox(),
                    )

                  ],
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                ),
              ),
            );
          }
        },
      )
    );
  }

  _toggleHeart(String currentUser) async {
    await _databaseRepository.toggleLike(pid: widget.post.id, currentUser: currentUser);
    setState(() {
      isLiked = !this.isLiked;
    });
  }

  _delete() async {
    await _storageRepositories.delete(url: widget.post.image);
    await _databaseRepository.delete(pid: widget.post.id);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
