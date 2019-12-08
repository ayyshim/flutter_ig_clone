import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/screens/feeds/single_post.dart';

class ProfilePosts extends StatelessWidget {

  final String uid;

  const ProfilePosts({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DatabaseRepository databaseRepository = DatabaseRepository();

    return FutureBuilder<List<Post>>(
      future: databaseRepository.getProfilePost(uid: this.uid),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Expanded(
            child: GridView.count(crossAxisCount: 3,
              children: List.generate(snapshot.data.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                       return SinglePostScreen(post: snapshot.data[index],);
                      }
                    ));
                  },
                  child: GridTile(
                    child: Card(
                        color: Colors.blue.shade200,
                        child: Image(
                          image: CachedNetworkImageProvider(snapshot.data[index].image),
                        ),
                      elevation: 0,
                    ),
                  ),
                );
              }),
            )
          );
        } else {
          return Container(
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 10,
                animating: true,
              ),
            ),
          );
        }
      },
    );
  }
}
