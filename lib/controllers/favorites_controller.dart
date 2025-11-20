import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../db/user_crud.dart';

/// FavoritesController - ViewModel in MVVM pattern
/// Handles business logic and state management for favorites
class FavoritesController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserCrud _userCrud = Get.find<UserCrud>();

  // Reactive state
  final RxList<String> favoriteIds = <String>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from Firestore
  Future<void> loadFavorites() async {
    if (!_authService.isLoggedIn()) {
      favoriteIds.clear();
      return;
    }

    isLoading.value = true;
    try {
      final favorites = await _userCrud.getUserFavorites();
      favoriteIds.value = favorites;
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Check if restaurant is favorite
  bool isFavorite(String restaurantId) {
    return favoriteIds.contains(restaurantId);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String restaurantId) async {
    // Check if user is logged in
    if (!_authService.isLoggedIn()) {
      // Redirect to login page
      Get.toNamed('/login', arguments: {
        'returnRoute': Get.currentRoute, //key returnRoute as a flag 3lshan elpage t3rf trg3le eh 
        'returnArgs': Get.arguments, //key returnArgs as a flag 3lshan elpage t3rf trg3le data eh
      });
      return;
    }

    try {
      if (isFavorite(restaurantId)) {
        // Remove from favorites
        final success = await _userCrud.removeFromFavorites(restaurantId);
        if (success) {
          favoriteIds.remove(restaurantId);
          Get.snackbar(
            'Removed from favorites',
            'Restaurant removed from your favorites',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Add to favorites
        final success = await _userCrud.addToFavorites(restaurantId);
        if (success) {
          favoriteIds.add(restaurantId);
          Get.snackbar(
            'Added to favorites',
            'Restaurant added to your favorites',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Failed to update favorites. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get favorite count
  int get favoriteCount => favoriteIds.length;

  // Filter restaurants by favorites
  List<T> filterFavorites<T>(List<T> restaurants, String Function(T) getId) {
    // فـ getId هو مجرد function بتقول للدالة ازاي تجيب الـ id من كل عنصر.
    return restaurants.where((restaurant) => isFavorite(getId(restaurant))).toList();
  }
}

