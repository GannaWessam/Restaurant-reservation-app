import 'package:get/get.dart';
import '../models/restaurant_model.dart';
import 'favorites_controller.dart';
import '../db/restaurant_crud.dart';

/// RestaurantsListController - ViewModel in MVVM pattern
/// Handles business logic and state management for restaurants list screen
class RestaurantsListController extends GetxController {
  final FavoritesController _favoritesController = Get.find<FavoritesController>();
  final RestaurantCrud _restaurantCrud = Get.find<RestaurantCrud>();

  // Reactive state
  final RxString selectedFilter = 'All'.obs;
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = false.obs;
   final RxString searchQuery = ''.obs;

  
  // Internal state (not reactive - only used for logic)
  String _currentCategory = '';
  

  @override
  void onInit() {
    super.onInit();
  }

  // Load restaurants for a category from database
  Future<void> loadRestaurantsForCategory(String category) async {
    if (_currentCategory == category && restaurants.isNotEmpty) {
      // Already loaded for this category
      return;
    }

    _currentCategory = category;
    isLoading.value = true;
     searchQuery.value = '';


    try {
      final List<RestaurantModel> loadedRestaurants = 
          await _restaurantCrud.getRestaurantsByCategory(category);
      restaurants.value = loadedRestaurants;
    } catch (e) {
      print('Error loading restaurants: $e');
      restaurants.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Restaurant data by category (fallback/static data - can be removed if not needed)
  final Map<String, List<RestaurantModel>> restaurantsByCategory = {
  //   'French Breakfast': [
  //     RestaurantModel(
  //       id: 'fr_1',
  //       name: 'Le Petit Café',
  //       category: 'French Breakfast',
  //       distance: '0.5 km away',
  //       rating: 4.8,
  //       tables: '15 tables',
  //       imagePath: 'french.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'fr_2',
  //       name: 'Bistro Paris',
  //       category: 'French Breakfast',
  //       distance: '1.2 km away',
  //       rating: 4.6,
  //       tables: '10 tables',
  //       imagePath: 'french.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'fr_3',
  //       name: 'Croissant Corner',
  //       category: 'French Breakfast',
  //       distance: '2.0 km away',
  //       rating: 4.7,
  //       tables: '8 tables',
  //       imagePath: 'french.jpg',
  //     ),
  //   ],
  //   'American Breakfast': [
  //     RestaurantModel(
  //       id: 'am_1',
  //       name: 'Morning Diner',
  //       category: 'American Breakfast',
  //       distance: '1.2 km away',
  //       rating: 4.5,
  //       tables: '10 tables',
  //       imagePath: 'american.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'am_2',
  //       name: 'The Breakfast Club',
  //       category: 'American Breakfast',
  //       distance: '1.8 km away',
  //       rating: 4.7,
  //       tables: '20 tables',
  //       imagePath: 'american.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'am_3',
  //       name: 'Pancake House',
  //       category: 'American Breakfast',
  //       distance: '0.9 km away',
  //       rating: 4.4,
  //       tables: '12 tables',
  //       imagePath: 'american.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'am_4',
  //       name: 'All Day Breakfast',
  //       category: 'American Breakfast',
  //       distance: '1.5 km away',
  //       rating: 4.6,
  //       tables: '15 tables',
  //       imagePath: 'american.jpg',
  //     ),
  //   ],
  //   'Egyptian Breakfast': [
  //     RestaurantModel(
  //       id: 'eg_1',
  //       name: 'Nile Breakfast',
  //       category: 'Egyptian Breakfast',
  //       distance: '0.8 km away',
  //       rating: 4.7,
  //       tables: '12 tables',
  //       imagePath: 'egypt.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'eg_2',
  //       name: 'Ful & Falafel House',
  //       category: 'Egyptian Breakfast',
  //       distance: '0.5 km away',
  //       rating: 4.8,
  //       tables: '10 tables',
  //       imagePath: 'egypt.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'eg_3',
  //       name: 'Baladi Kitchen',
  //       category: 'Egyptian Breakfast',
  //       distance: '1.1 km away',
  //       rating: 4.5,
  //       tables: '8 tables',
  //       imagePath: 'egypt.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'eg_4',
  //       name: 'Egyptian Heritage',
  //       category: 'Egyptian Breakfast',
  //       distance: '1.7 km away',
  //       rating: 4.9,
  //       tables: '14 tables',
  //       imagePath: 'egypt.jpg',
  //     ),
  //   ],
  //   'Healthy Breakfast': [
  //     RestaurantModel(
  //       id: 'he_1',
  //       name: 'Green Bowl',
  //       category: 'Healthy Breakfast',
  //       distance: '1.5 km away',
  //       rating: 4.6,
  //       tables: '8 tables',
  //       imagePath: 'healthy.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'he_2',
  //       name: 'Fresh Start Café',
  //       category: 'Healthy Breakfast',
  //       distance: '0.7 km away',
  //       rating: 4.8,
  //       tables: '12 tables',
  //       imagePath: 'healthy.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'he_3',
  //       name: 'Juice & Smoothie Bar',
  //       category: 'Healthy Breakfast',
  //       distance: '1.3 km away',
  //       rating: 4.5,
  //       tables: '6 tables',
  //       imagePath: 'healthy.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'he_4',
  //       name: 'Organic Kitchen',
  //       category: 'Healthy Breakfast',
  //       distance: '2.1 km away',
  //       rating: 4.7,
  //       tables: '10 tables',
  //       imagePath: 'healthy.jpg',
  //     ),
  //   ],
  //   'Coffee Breakfast': [
  //     RestaurantModel(
  //       id: 'co_1',
  //       name: 'Bean & Brew',
  //       category: 'Coffee Breakfast',
  //       distance: '0.3 km away',
  //       rating: 4.9,
  //       tables: '6 tables',
  //       imagePath: 'coffee.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'co_2',
  //       name: 'Espresso Lane',
  //       category: 'Coffee Breakfast',
  //       distance: '0.8 km away',
  //       rating: 4.7,
  //       tables: '8 tables',
  //       imagePath: 'coffee.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'co_3',
  //       name: 'The Coffee Roasters',
  //       category: 'Coffee Breakfast',
  //       distance: '1.4 km away',
  //       rating: 4.8,
  //       tables: '5 tables',
  //       imagePath: 'coffee.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'co_4',
  //       name: 'Artisan Coffee House',
  //       category: 'Coffee Breakfast',
  //       distance: '1.0 km away',
  //       rating: 4.6,
  //       tables: '7 tables',
  //       imagePath: 'coffee.jpg',
  //     ),
  //   ],
  //   'Turkish Breakfast': [
  //     RestaurantModel(
  //       id: 'tu_1',
  //       name: 'Istanbul Table',
  //       category: 'Turkish Breakfast',
  //       distance: '2.0 km away',
  //       rating: 4.4,
  //       tables: '14 tables',
  //       imagePath: 'Turkish breakfast.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'tu_2',
  //       name: 'Bosphorus Breakfast',
  //       category: 'Turkish Breakfast',
  //       distance: '1.6 km away',
  //       rating: 4.7,
  //       tables: '12 tables',
  //       imagePath: 'Turkish breakfast.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'tu_3',
  //       name: 'Sultan\'s Kitchen',
  //       category: 'Turkish Breakfast',
  //       distance: '0.9 km away',
  //       rating: 4.8,
  //       tables: '10 tables',
  //       imagePath: 'Turkish breakfast.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'tu_4',
  //       name: 'Turkish Delight',
  //       category: 'Turkish Breakfast',
  //       distance: '1.8 km away',
  //       rating: 4.5,
  //       tables: '16 tables',
  //       imagePath: 'Turkish breakfast.jpg',
  //     ),
  //   ],
  //   'Open Buffet Breakfast': [
  //     RestaurantModel(
  //       id: 'bu_1',
  //       name: 'Grand Buffet',
  //       category: 'Open Buffet Breakfast',
  //       distance: '1.8 km away',
  //       rating: 4.5,
  //       tables: '20 tables',
  //       imagePath: 'open buffet.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'bu_2',
  //       name: 'International Feast',
  //       category: 'Open Buffet Breakfast',
  //       distance: '2.2 km away',
  //       rating: 4.6,
  //       tables: '25 tables',
  //       imagePath: 'open buffet.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'bu_3',
  //       name: 'All You Can Eat',
  //       category: 'Open Buffet Breakfast',
  //       distance: '1.5 km away',
  //       rating: 4.4,
  //       tables: '30 tables',
  //       imagePath: 'open buffet.jpg',
  //     ),
  //     RestaurantModel(
  //       id: 'bu_4',
  //       name: 'Breakfast Paradise',
  //       category: 'Open Buffet Breakfast',
  //       distance: '2.5 km away',
  //       rating: 4.7,
  //       tables: '22 tables',
  //       imagePath: 'open buffet.jpg',
  //     ),
  };

  // Get filtered restaurants (uses reactive restaurants list)
List<RestaurantModel> getFilteredRestaurants() {
    List<RestaurantModel> list = restaurants.toList();

    if (selectedFilter.value == 'Favorite places') {
      list = list.where((r) => _favoritesController.isFavorite(r.id)).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list
          .where(
            (r) => r.name.toLowerCase().contains(query),
          )
          .toList();
    }

    return list;
  }

  // Get favorite count for current restaurants
  int getFavoriteCount() {
    return restaurants.where((r) => _favoritesController.isFavorite(r.id)).length;
  }

  // Calculate average rating
  double getAverageRating(List<RestaurantModel> restaurants) {
    if (restaurants.isEmpty) return 0.0;
    final totalRating = restaurants.fold(0.0, (sum, restaurant) => sum + restaurant.rating);
    return totalRating / restaurants.length;
  }

  // Set filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Toggle favorite
  Future<void> toggleFavorite(String restaurantId) async {
    await _favoritesController.toggleFavorite(restaurantId);
  }

   void setSearchQuery(String value) {
    searchQuery.value = value;
  }

}

