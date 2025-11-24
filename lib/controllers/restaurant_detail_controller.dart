import 'package:get/get.dart';
import 'favorites_controller.dart';

/// RestaurantDetailController - ViewModel in MVVM pattern
/// Handles business logic and state management for restaurant detail screen
class RestaurantDetailController extends GetxController {
  final FavoritesController _favoritesController = Get.find<FavoritesController>();

  // Reactive state
  final Rxn<String> selectedTimeSlot = Rxn<String>();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

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

  // Set selected date
  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  // Get formatted date string
  String getFormattedDate() {
    if (selectedDate.value == null) return 'Select Date';
    final date = selectedDate.value!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);
    
    if (selectedDay == today) {
      return 'Today, ${_formatDate(date)}';
    } else if (selectedDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatDate(date)}';
    } else {
      return _formatDate(date);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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

