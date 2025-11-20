import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'db_instance.dart';

class UserCrud {
  FirebaseFirestore get firestore => Get.find<CloudDb>().db;
  FirebaseAuth get auth => FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => auth.currentUser?.uid;

  // Get user's favorite places
  Future<List<String>> getUserFavorites() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data['favoritePlaces'] != null) {
          return List<String>.from(data['favoritePlaces']);
        }
      }
      return [];
    } catch (e) {
      print('Error getting user favorites: $e');
      return [];
    }
  }

  // Add restaurant to user's favorites
  Future<bool> addToFavorites(String restaurantId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;

      final userRef = firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data();
        List<String> favorites = data != null && data['favoritePlaces'] != null
            ? List<String>.from(data['favoritePlaces'])
            : [];

        if (!favorites.contains(restaurantId)) {
          favorites.add(restaurantId);
          await userRef.update({'favoritePlaces': favorites});
        }
      } else {
        // Create user document if it doesn't exist
        await userRef.set({
          'favoritePlaces': [restaurantId],
        });
      }
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove restaurant from user's favorites
  Future<bool> removeFromFavorites(String restaurantId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;

      final userRef = firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data['favoritePlaces'] != null) {
          List<String> favorites = List<String>.from(data['favoritePlaces']);
          favorites.remove(restaurantId);
          await userRef.update({'favoritePlaces': favorites});
        }
      }
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  // Check if restaurant is in user's favorites
  Future<bool> isFavorite(String restaurantId) async {
    try {
      final favorites = await getUserFavorites();
      return favorites.contains(restaurantId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }
}

