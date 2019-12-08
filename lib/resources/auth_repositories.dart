import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class AuthRepository {

  final _method = AuthMethod();

  // Streams current user authentication state in the app.
  Stream<FirebaseUser> current_auth_state() => _method.current_auth_state();

  // Streams current authenticated user data from firestore.
  Stream<User> current_user_data(String _uid) => _method.current_user_data(_uid);

  // Login function.
  Future login(String _email, String _password) => _method.login(_email, _password);

  // Register function.
  Future register(String _email, String _password, String _fullName) => _method.register(_email, _password, _fullName);

  // Logout function.
  Future logout() => _method.logout();

}