import 'package:get/get.dart';
import 'favorites_controller.dart';

/// RestaurantDetailController - ViewModel in MVVM pattern
/// Handles business logic and state management for restaurant detail screen
class RestaurantDetailController extends GetxController {
  final FavoritesController _favoritesController = Get.find<FavoritesController>();

  // Reactive state
  final Rxn<String> selectedTimeSlot = Rxn<String>();

  // Available time slots
  final List<String> timeSlots = [
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
  ];

  // Set selected time slot
  void setTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  // Toggle favorite
  Future<void> toggleFavorite(String restaurantId) async {
    await _favoritesController.toggleFavorite(restaurantId);
  }

  // Check if restaurant is favorite
  bool isFavorite(String restaurantId) {
    return _favoritesController.isFavorite(restaurantId);
  }
}

