import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_repositories.dart';
import 'package:instagram_clone/screens/home/home_screen.dart';
import 'package:instagram_clone/screens/login/login_screen.dart';
import 'package:instagram_clone/screens/profile/edit_profile.dart';
import 'package:instagram_clone/screens/register/register_screen.dart';
import 'package:instagram_clone/screens/search/search_area.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  FirebaseAnalytics analytics = FirebaseAnalytics();

  final AuthRepository _authRepository = AuthRepository();

  Widget _lodingScreen() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(

        ),
      ),
    );
  }

  _getHomeScreen() {
    return StreamBuilder(
      stream: _authRepository.current_auth_state(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return LoginScreen();
        } else {
          Provider.of<CurrentUser>(context).uid= snapshot.data.uid;
          return StreamBuilder<User>(
              stream: _authRepository.current_user_data(snapshot.data.uid),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return _lodingScreen();
                } else {
                  if(snapshot.hasError) {
                    print(snapshot.error.toString());
                  }

                  Provider.of<CurrentUser>(context).fullName = snapshot.data.fullName;
                  Provider.of<CurrentUser>(context).avatar = snapshot.data.avatar;
                  Provider.of<CurrentUser>(context).email = snapshot.data.email;
                  Provider.of<CurrentUser>(context).bio = snapshot.data.bio;
                  return HomeScreen();
                }

              }
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Questrial'
        ),
        title: "Instagram Clone",
        home: _getHomeScreen(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(
            analytics: analytics
          )
        ],
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          EditProfile.id: (context) => EditProfile(data: Provider.of<CurrentUser>(context),),
          SearchArea.id: (context) => SearchArea()
        },
      ),
    );
  }
}
