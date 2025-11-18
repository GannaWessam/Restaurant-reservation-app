import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Track favorite status for each category
  final Map<String, bool> _favorites = {
    'French Breakfast': false,
    'American Breakfast': false,
    'Egyptian Breakfast': false,
    'Healthy Breakfast': false,
    'Coffee Breakfast': false,
    'Turkish Breakfast': false,
    'Open Buffet Breakfast': false,
  };

  @override
  Widget build(BuildContext context) {
    // Get user name (mock for now)
    final String userName = 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
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
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          Get.offAllNamed('/login');
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Welcome Card (More Compact)
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
                        'GOOD MORNING, ${userName.toUpperCase()}',
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Reserve your next breakfast in seconds',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover handpicked breakfast spots. Book ahead and stay organized.',
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
                                    'Last booking',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Yesterday • 9:10 AM',
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
                                    'Restaurants near',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '14 in your area',
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
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Section Title
                Text(
                  'Breakfast cuisines',
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
                    _buildFilterChip(context, 'All cuisines', true),
                    const SizedBox(width: 12),
                    _buildFilterChip(context, 'Most booked', false),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Breakfast Category Cards with Images
                _buildBreakfastCard(
                  context,
                  'French Breakfast',
                  'FRENCH',
                  '12 tables',
                  'Butter croissants, seasonal jam and café au lait. Perfect for a light, slow morning with strong coffees and warm pastry aromas.',
                  'Peak: 9:00 AM',
                  'french.jpg',
                ),
                
                const SizedBox(height: 12),
                
                _buildBreakfastCard(
                  context,
                  'American Breakfast',
                  'AMERICAN',
                  '8 tables',
                  'Fluffy pancakes, crispy bacon and sunny-side eggs. A hearty classic breakfast to fuel your morning.',
                  'Peak: 8:30 AM',
                  'american.jpg',
                ),
                
                const SizedBox(height: 12),
                
                _buildBreakfastCard(
                  context,
                  'Egyptian Breakfast',
                  'EGYPTIAN',
                  '10 tables',
                  'Ful medames, fresh baladi bread and Egyptian tea. Traditional flavors to start your day authentically.',
                  'Peak: 7:00 AM',
                  'egypt.jpg',
                ),
                
                const SizedBox(height: 12),
                
                _buildBreakfastCard(
                  context,
                  'Healthy Breakfast',
                  'HEALTHY',
                  '15 tables',
                  'Fresh fruit bowls, granola and smoothies. Nutritious options for a energizing morning.',
                  'Peak: 8:00 AM',
                  'healthy.jpg',
                ),
                
                const SizedBox(height: 12),
                
                _buildBreakfastCard(
                  context,
                  'Coffee Breakfast',
                  'COFFEE',
                  '6 tables',
                  'Specialty coffee and artisan pastries. Perfect for coffee lovers seeking quality brews.',
                  'Peak: 9:30 AM',
                  'coffee.jpg',
                ),
                
                const SizedBox(height: 12),
                
                _buildBreakfastCard(
                  context,
                  'Turkish Breakfast',
                  'TURKISH',
                  '9 tables',
                  'Cheese platter, olives, honey and Turkish tea. A rich spread of Mediterranean flavors.',
                  'Peak: 8:00 AM',
                  'Turkish breakfast.jpg',
                ),
                
                const SizedBox(height: 12),
                
                _buildBreakfastCard(
                  context,
                  'Open Buffet Breakfast',
                  'BUFFET',
                  '20 tables',
                  'All-you-can-eat breakfast buffet. Variety of international dishes to satisfy every craving.',
                  'Peak: 9:00 AM',
                  'open buffet.jpg',
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

  Widget _buildBreakfastCard(
    BuildContext context,
    String title,
    String category,
    String tables,
    String description,
    String peakTime,
    String? imagePath, // Will use this when images are provided
  ) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Get.toNamed('/restaurants', arguments: {'category': title});
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with real breakfast images (Smaller)
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: imagePath != null
                    ? DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Placeholder only if no image
                  if (imagePath == null)
                    Center(
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 60,
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
                          _favorites[title] = !(_favorites[title] ?? false);
                        });
                      },
                    child: Container(
                        padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                      ),
                        child: Icon(
                          _favorites[title] == true 
                              ? Icons.star 
                              : Icons.star_border,
                          color: _favorites[title] == true 
                              ? Colors.amber 
                              : Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card Content (More compact)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tables,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        peakTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/restaurants', arguments: {'category': title});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 25),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'View details',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

