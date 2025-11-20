import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
  // Lazy initialization - only access Firebase Auth when _auth is first accessed
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Future<UserModel?> signUp(String name,String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      UserModel newUser = UserModel(
        uid: user!.uid,
        fullName: name,
        email: email,
        password: password,
      );
      return newUser;
    } catch (e) {
      print('Error in sign up: $e');
      return null;
    }
  }
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password); //stores token in local phone
      return true;
    } catch (e) {
      print('Error in sign up: $e');
      return false;
    }
  }
  Future<bool> signOut() async {
    try {
      await _auth.signOut(); //htshel el token from local phone
      return true;
    } catch (e) {
      print('Error in sign out: $e');
      return false;
    }
  }
  bool isLoggedIn() => _auth.currentUser != null;

  Future<bool> resetPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Error in resetPassword: $e');
      return false;
    }
  }


}