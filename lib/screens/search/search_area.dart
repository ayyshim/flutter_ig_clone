import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/database_repositories.dart';
import 'package:instagram_clone/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class SearchArea extends StatefulWidget {
  static final String id = "search_area";

  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  String _searching = "";

  List<User> _search_list = [];
  bool isLoading = false;

  final _searchController = TextEditingController();


  final DatabaseRepository _databaseRepository = DatabaseRepository();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.grey[900],
          ),
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.backspace),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                hintText: "Search"),
            onChanged: (searching) {
              setState(() {
                _searching = searching;
              });
              _search();
            },
          ),
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _search_list.length,
                    itemBuilder: (context, index) {
                      User _user = _search_list[index];
                      return _profile_tiles(_user);
                    })));
  }

  Widget _profile_tiles(User _user) {
    if(_user != null) {
      return InkWell(
        onTap: () {
          _save_search_history(_user.uid);
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

  _save_search_history(String userLooked) {
    final CurrentUser _current_user = Provider.of<CurrentUser>(context);;

    _databaseRepository.saveRecentSearch(currentUser: _current_user.uid, userLooked: userLooked);
  }

  _search() async {
    final CurrentUser _current_user = Provider.of<CurrentUser>(context);;

    setState(() {
      isLoading = true;
    });
    List<User> res = await _databaseRepository.searchUser(_searching, _current_user.uid);
    setState(() {
      isLoading = false;
      _search_list = res;
    });
  }
}
