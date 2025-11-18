// import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// AuthService - Service layer for authentication
/// TEMPORARY MOCK VERSION - Replace with Firebase when ready
// class AuthService {
//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Mock sign up - simulates successful registration
//   Future<UserModel?> signUp(String name, String email, String password) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(seconds: 1));
//
//       // Return mock user
//       UserModel newUser = UserModel(
//         uid: 'mock_${DateTime.now().millisecondsSinceEpoch}',
//         fullName: name,
//         email: email,
//         password: password,
//       );
//       return newUser;
//     } catch (e) {
//       print('Error in sign up: $e');
//       return null;
//     }
//   }
//
//   // Mock sign in - always returns true for demo
//   Future<bool> signIn(String email, String password) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(seconds: 1));
//
//       // For demo, accept any credentials
//       return true;
//     } catch (e) {
//       print('Error in sign in: $e');
//       return false;
//     }
//   }
//
//   // Mock sign out
//   Future<bool> signOut() async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 500));
//       return true;
//     } catch (e) {
//       print('Error in sign out: $e');
//       return false;
//     }
//   }
//
//   // Mock logged in check
//   bool isLoggedIn() => false;
//
//   // Mock password reset
//   Future<bool> resetPassword(email) async {
//     try {
//       await Future.delayed(const Duration(seconds: 1));
//       return true;
//     } catch (e) {
//       print('Error in resetPassword: $e');
//       return false;
//     }
//   }
// }

/*
 * TO ENABLE FIREBASE:
 *
 * 1. Run: flutterfire configure
 * 2. Uncomment Firebase imports in main.dart
 * 3. Replace this file with the code below:
 *
 * import 'package:firebase_auth/firebase_auth.dart';
 * import '../models/user_model.dart';
 *
 * class AuthService {
 *   final FirebaseAuth _auth = FirebaseAuth.instance;
 *
 *   Future<UserModel?> signUp(String name, String email, String password) async {
 *     try {
 *       UserCredential result = await _auth.createUserWithEmailAndPassword(
 *           email: email, password: password);
 *       User? user = result.user;
 *
 *       UserModel newUser = UserModel(
 *         uid: user!.uid,
 *         fullName: name,
 *         email: email,
 *         password: password,
 *       );
 *       return newUser;
 *     } catch (e) {
 *       print('Error in sign up: $e');
 *       return null;
 *     }
 *   }
 *
 *   Future<bool> signIn(String email, String password) async {
 *     try {
 *       await _auth.signInWithEmailAndPassword(email: email, password: password);
 *       return true;
 *     } catch (e) {
 *       print('Error in sign in: $e');
 *       return false;
 *     }
 *   }
 *
 *   Future<bool> signOut() async {
 *     try {
 *       await _auth.signOut();
 *       return true;
 *     } catch (e) {
 *       print('Error in sign out: $e');
 *       return false;
 *     }
 *   }
 *
 *   bool isLoggedIn() => _auth.currentUser != null;
 *
 *   Future<bool> resetPassword(email) async {
 *     try {
 *       await _auth.sendPasswordResetEmail(email: email);
 *       return true;
 *     } catch (e) {
 *       print('Error in resetPassword: $e');
 *       return false;
 *     }
 *   }
 * }
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:restaurant_reservation_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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