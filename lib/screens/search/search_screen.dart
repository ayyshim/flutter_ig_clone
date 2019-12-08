import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/search_history.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/screens/profile/profile_screen.dart';
import 'package:instagram_clone/screens/search/search_area.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {

  final String uid;

  const SearchScreen({Key key, this.uid}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final DatabaseRepository _databaseRepository = DatabaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: Container(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, SearchArea.id);
            },
            splashColor: Colors.transparent,
            child: Row(
              children: <Widget>[
                Icon(Icons.search,
                  color: Colors.grey[900],
                ),
                SizedBox(
                  width: 8,
                ),
                Text("Search",
                  style: TextStyle(
                    color: Colors.grey[500]
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Recent searches",
                style: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            FutureBuilder<List<SearchHistory>>(
              future: _databaseRepository.searchHistory(uid: widget.uid),
              builder: (context, userData) {
                if(userData.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: userData.data.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<User>(
                          future: _databaseRepository.getUserByUID(uid: userData.data[index].userLooked),
                          builder: (context, snapshot) {
                            if(snapshot.hasData) {
                              return _profile_tiles(snapshot.data);
                            } else {
                              return CupertinoActivityIndicator(animating: true, radius: 5,);
                            }
                          },
                        )  ;
                      },
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CupertinoActivityIndicator(animating: true, radius: 10,),
                    ),
                  );
                }
              },
            )
          ],
        ),
      )
    );
  }

  Widget _profile_tiles(User _user) {
    if(_user != null) {
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            CurrentUser currentUser = Provider.of<CurrentUser>(context);
            return ProfileScreen(currentUser: currentUser, user: _user,);
          }));
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _user.avatar == "default" ? AssetImage("assets/images/default_avatar.png") : CachedNetworkImageProvider(_user.avatar),
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 10,),
                Text(_user.fullName,
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
