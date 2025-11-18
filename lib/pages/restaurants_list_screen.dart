import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant_model.dart';
import 'restaurant_detail_screen.dart';
import 'my_reservations_screen.dart';

class RestaurantsListScreen extends StatefulWidget {
  const RestaurantsListScreen({super.key});

  @override
  State<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  // Filter selection
  String _selectedFilter = 'All';

  // Restaurant data by category using RestaurantModel
  final Map<String, List<RestaurantModel>> _restaurantsByCategory = {
    'French Breakfast': [
      RestaurantModel(
        id: 'fr_1',
        name: 'Le Petit Café',
        category: 'French Breakfast',
        distance: '0.5 km away',
        rating: 4.8,
        tables: '15 tables',
        imagePath: 'french.jpg',
      ),
      RestaurantModel(
        id: 'fr_2',
        name: 'Bistro Paris',
        category: 'French Breakfast',
        distance: '1.2 km away',
        rating: 4.6,
        tables: '10 tables',
        imagePath: 'french.jpg',
      ),
      RestaurantModel(
        id: 'fr_3',
        name: 'Croissant Corner',
        category: 'French Breakfast',
        distance: '2.0 km away',
        rating: 4.7,
        tables: '8 tables',
        imagePath: 'french.jpg',
      ),
    ],
    'American Breakfast': [
      RestaurantModel(
        id: 'am_1',
        name: 'Morning Diner',
        category: 'American Breakfast',
        distance: '1.2 km away',
        rating: 4.5,
        tables: '10 tables',
        imagePath: 'american.jpg',
      ),
      RestaurantModel(
        id: 'am_2',
        name: 'The Breakfast Club',
        category: 'American Breakfast',
        distance: '1.8 km away',
        rating: 4.7,
        tables: '20 tables',
        imagePath: 'american.jpg',
      ),
      RestaurantModel(
        id: 'am_3',
        name: 'Pancake House',
        category: 'American Breakfast',
        distance: '0.9 km away',
        rating: 4.4,
        tables: '12 tables',
        imagePath: 'american.jpg',
      ),
      RestaurantModel(
        id: 'am_4',
        name: 'All Day Breakfast',
        category: 'American Breakfast',
        distance: '1.5 km away',
        rating: 4.6,
        tables: '15 tables',
        imagePath: 'american.jpg',
      ),
    ],
    'Egyptian Breakfast': [
      RestaurantModel(
        id: 'eg_1',
        name: 'Nile Breakfast',
        category: 'Egyptian Breakfast',
        distance: '0.8 km away',
        rating: 4.7,
        tables: '12 tables',
        imagePath: 'egypt.jpg',
      ),
      RestaurantModel(
        id: 'eg_2',
        name: 'Ful & Falafel House',
        category: 'Egyptian Breakfast',
        distance: '0.5 km away',
        rating: 4.8,
        tables: '10 tables',
        imagePath: 'egypt.jpg',
      ),
      RestaurantModel(
        id: 'eg_3',
        name: 'Baladi Kitchen',
        category: 'Egyptian Breakfast',
        distance: '1.1 km away',
        rating: 4.5,
        tables: '8 tables',
        imagePath: 'egypt.jpg',
      ),
      RestaurantModel(
        id: 'eg_4',
        name: 'Egyptian Heritage',
        category: 'Egyptian Breakfast',
        distance: '1.7 km away',
        rating: 4.9,
        tables: '14 tables',
        imagePath: 'egypt.jpg',
      ),
    ],
    'Healthy Breakfast': [
      RestaurantModel(
        id: 'he_1',
        name: 'Green Bowl',
        category: 'Healthy Breakfast',
        distance: '1.5 km away',
        rating: 4.6,
        tables: '8 tables',
        imagePath: 'healthy.jpg',
      ),
      RestaurantModel(
        id: 'he_2',
        name: 'Fresh Start Café',
        category: 'Healthy Breakfast',
        distance: '0.7 km away',
        rating: 4.8,
        tables: '12 tables',
        imagePath: 'healthy.jpg',
      ),
      RestaurantModel(
        id: 'he_3',
        name: 'Juice & Smoothie Bar',
        category: 'Healthy Breakfast',
        distance: '1.3 km away',
        rating: 4.5,
        tables: '6 tables',
        imagePath: 'healthy.jpg',
      ),
      RestaurantModel(
        id: 'he_4',
        name: 'Organic Kitchen',
        category: 'Healthy Breakfast',
        distance: '2.1 km away',
        rating: 4.7,
        tables: '10 tables',
        imagePath: 'healthy.jpg',
      ),
    ],
    'Coffee Breakfast': [
      RestaurantModel(
        id: 'co_1',
        name: 'Bean & Brew',
        category: 'Coffee Breakfast',
        distance: '0.3 km away',
        rating: 4.9,
        tables: '6 tables',
        imagePath: 'coffee.jpg',
      ),
      RestaurantModel(
        id: 'co_2',
        name: 'Espresso Lane',
        category: 'Coffee Breakfast',
        distance: '0.8 km away',
        rating: 4.7,
        tables: '8 tables',
        imagePath: 'coffee.jpg',
      ),
      RestaurantModel(
        id: 'co_3',
        name: 'The Coffee Roasters',
        category: 'Coffee Breakfast',
        distance: '1.4 km away',
        rating: 4.8,
        tables: '5 tables',
        imagePath: 'coffee.jpg',
      ),
      RestaurantModel(
        id: 'co_4',
        name: 'Artisan Coffee House',
        category: 'Coffee Breakfast',
        distance: '1.0 km away',
        rating: 4.6,
        tables: '7 tables',
        imagePath: 'coffee.jpg',
      ),
    ],
    'Turkish Breakfast': [
      RestaurantModel(
        id: 'tu_1',
        name: 'Istanbul Table',
        category: 'Turkish Breakfast',
        distance: '2.0 km away',
        rating: 4.4,
        tables: '14 tables',
        imagePath: 'Turkish breakfast.jpg',
      ),
      RestaurantModel(
        id: 'tu_2',
        name: 'Bosphorus Breakfast',
        category: 'Turkish Breakfast',
        distance: '1.6 km away',
        rating: 4.7,
        tables: '12 tables',
        imagePath: 'Turkish breakfast.jpg',
      ),
      RestaurantModel(
        id: 'tu_3',
        name: 'Sultan\'s Kitchen',
        category: 'Turkish Breakfast',
        distance: '0.9 km away',
        rating: 4.8,
        tables: '10 tables',
        imagePath: 'Turkish breakfast.jpg',
      ),
      RestaurantModel(
        id: 'tu_4',
        name: 'Turkish Delight',
        category: 'Turkish Breakfast',
        distance: '1.8 km away',
        rating: 4.5,
        tables: '16 tables',
        imagePath: 'Turkish breakfast.jpg',
      ),
    ],
    'Open Buffet Breakfast': [
      RestaurantModel(
        id: 'bu_1',
        name: 'Grand Buffet',
        category: 'Open Buffet Breakfast',
        distance: '1.8 km away',
        rating: 4.5,
        tables: '20 tables',
        imagePath: 'open buffet.jpg',
      ),
      RestaurantModel(
        id: 'bu_2',
        name: 'International Feast',
        category: 'Open Buffet Breakfast',
        distance: '2.2 km away',
        rating: 4.6,
        tables: '25 tables',
        imagePath: 'open buffet.jpg',
      ),
      RestaurantModel(
        id: 'bu_3',
        name: 'All You Can Eat',
        category: 'Open Buffet Breakfast',
        distance: '1.5 km away',
        rating: 4.4,
        tables: '30 tables',
        imagePath: 'open buffet.jpg',
      ),
      RestaurantModel(
        id: 'bu_4',
        name: 'Breakfast Paradise',
        category: 'Open Buffet Breakfast',
        distance: '2.5 km away',
        rating: 4.7,
        tables: '22 tables',
        imagePath: 'open buffet.jpg',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Get the category from navigation arguments
    final String category = Get.arguments?['category'] ?? 'Breakfast';
    
    // Get restaurants for this category
    List<RestaurantModel> restaurants = _restaurantsByCategory[category] ?? [];
    
    // Filter restaurants based on selected filter
    List<RestaurantModel> filteredRestaurants = _selectedFilter == 'Favorite places'
        ? restaurants.where((restaurant) => restaurant.isFavorite).toList()
        : restaurants;
    
    // Calculate average rating from filtered restaurants
    double averageRating = 0.0;
    if (filteredRestaurants.isNotEmpty) {
      double totalRating = filteredRestaurants.fold(0.0, (sum, restaurant) => sum + restaurant.rating);
      averageRating = totalRating / filteredRestaurants.length;
    }
    
    // Count favorite restaurants
    int favoriteCount = restaurants.where((r) => r.isFavorite).length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and back button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 28,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.restaurant_menu,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Fatoorna',
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      offset: const Offset(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'reservations') {
                          // Navigate to my reservations screen
                          Get.to(() => const MyReservationsScreen());
                        } else if (value == 'signout') {
                          // Sign out
                          Get.offAllNamed('/login');
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'reservations',
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'My Reservations',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'signout',
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Sign Out',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Category Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.toUpperCase(),
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Discover restaurants near you',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Browse handpicked restaurants serving $category. Book your table in seconds.',
                        style: GoogleFonts.tajawal(
                          fontSize: 12,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available now',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${filteredRestaurants.length} restaurants',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Average rating',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        averageRating.toStringAsFixed(1),
                                        style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Section Title
                Text(
                  'Nearby restaurants',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Filter Chips
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'All';
                        });
                      },
                      child: _buildFilterChip(
                        context,
                        'All',
                        _selectedFilter == 'All',
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Favorite places';
                        });
                      },
                      child: _buildFilterChip(
                        context,
                        'Favorite places ($favoriteCount)',
                        _selectedFilter == 'Favorite places',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Restaurant Grid (2 columns)
                filteredRestaurants.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Icon(
                                _selectedFilter == 'Favorite places'
                                    ? Icons.star_border
                                    : Icons.restaurant_menu,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedFilter == 'Favorite places'
                                    ? 'No favorite restaurants'
                                    : 'No restaurants found',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedFilter == 'Favorite places'
                                    ? 'Mark restaurants as favorites to see them here'
                                    : 'Check back later for new restaurants',
                                style: GoogleFonts.tajawal(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = filteredRestaurants[index];
                          return _buildRestaurantCard(context, restaurant);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected 
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(
    BuildContext context,
    RestaurantModel restaurant,
  ) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Get.to(
            () => const RestaurantDetailScreen(),
            arguments: restaurant,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: restaurant.imagePath != null
                    ? DecorationImage(
                        image: AssetImage(restaurant.imagePath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Placeholder only if no image
                  if (restaurant.imagePath == null)
                    Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                  // Favorite Star Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          restaurant.isFavorite = !restaurant.isFavorite;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          restaurant.isFavorite 
                              ? Icons.star 
                              : Icons.star_border,
                          color: restaurant.isFavorite 
                              ? Colors.amber 
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              restaurant.distance,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              restaurant.rating.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        restaurant.tables,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
