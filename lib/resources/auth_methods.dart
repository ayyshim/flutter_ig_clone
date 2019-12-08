import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/constants/firebase_refs.dart';
import 'package:instagram_clone/models/user.dart';

class AuthMethod {

  Stream<FirebaseUser> current_auth_state() {
    return auth.onAuthStateChanged;
  }

  Stream<User> current_user_data(String uid) {
    return user_col.document(uid).snapshots(includeMetadataChanges: false).map(
            (DocumentSnapshot _doc) => User.fromDoc(_doc)
    );
  }

  Future login(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      print(user.uid);
      return user;
    } catch(e) {
      return e;
    }
  }

  Future register(String email, String password, String fullName) async{
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // Save record
      Map<String, dynamic> data = {
        "fullName": fullName,
        "avatar": "default",
        "email": email,
      };

      await user_col.document(user.uid).setData(data);

      return User($uid: user.uid, $email: email, $fullName: fullName, $avatar: "default");

    } catch(e) {
      return e;
    }
  }

  Future logout() async {
    await auth.signOut();
  }

}