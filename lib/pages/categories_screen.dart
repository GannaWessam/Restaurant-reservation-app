import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../db/category_crud.dart';
import '../models/category_model.dart';
import 'my_reservations_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _isLoading.value = true;
    
    try {
      final CategoryCrud categoryCrud = Get.find<CategoryCrud>();
      
      // Fetch categories from Firebase (restaurantCount is already stored in each category)
      final categories = await categoryCrud.getAllCategories();
      
      _categories.value = categories;
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  String _getCategoryDisplayText(CategoryModel category) {
    if (_isLoading.value) {
      return 'Loading...';
    }
    final count = category.restaurantCount;
    if (count == 0) {
      return 'Available soon';
    } else if (count == 1) {
      return '1 restaurant';
    } else {
      return '$count restaurants';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user name (mock for now)
    final String userName = '';///USER NAME
    final AuthService authService = Get.find<AuthService>();
    final bool isLoggedIn = authService.isLoggedIn();

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
                    PopupMenuButton<String>(
                      offset: const Offset(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'reservations') {
                          if (isLoggedIn) {
                            Get.toNamed('/my-reservations');
                          } else {
                            Get.toNamed('/login');
                          }
                        } else if (value == 'auth') {
                          if (isLoggedIn) {
                            // Sign out and return to login
                            authService.signOut();
                            Get.offAllNamed('/login');
                          } else {
                            // Go to login when logged out
                            Get.toNamed('/login');
                          }
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
                          value: 'auth',
                          child: Row(
                            children: [
                              Icon(
                                isLoggedIn ? Icons.logout : Icons.login,
                                color: isLoggedIn ? Colors.red[600] : Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isLoggedIn ? 'Sign Out' : 'Sign In',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isLoggedIn ? Colors.red[600] : Theme.of(context).colorScheme.secondary,
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
                                    'discover our categories',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Obx(() => Text(
                                        'Available Categories is ${_categories.length}',
                                        style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Expanded(
                          //   child: Container(
                          //     padding: const EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           'Restaurants near',
                          //           style: TextStyle(
                          //             fontSize: 10,
                          //             color: Colors.grey[600],
                          //           ),
                          //         ),
                          //         const SizedBox(height: 3),
                          //         Text(
                          //           '14 in your area',
                          //           style: GoogleFonts.cairo(
                          //             fontSize: 11,
                          //             fontWeight: FontWeight.w600,
                          //             color: Theme.of(context).colorScheme.secondary,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
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
                    // _buildFilterChip(context, 'Most booked', false),//////////
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Breakfast Category Cards with Images - Dynamically loaded from Firebase
                Obx(() {
                  if (_isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  if (_categories.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No categories available',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back later for new categories',
                              style: GoogleFonts.tajawal(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    children: _categories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 12),
                          _buildBreakfastCard(
                            context,
                            category,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),
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
    CategoryModel category,
  ) {
    // Helper to build image provider from base64
    ImageProvider? _buildImageProvider(String? imageBase64) {
      if (imageBase64 == null || imageBase64.isEmpty) return null;
      
      try {
        // Handle data URL prefix if present
        String base64String = imageBase64;
        if (base64String.startsWith('data:image')) {
          final commaIndex = base64String.indexOf(',');
          if (commaIndex != -1) {
            base64String = base64String.substring(commaIndex + 1);
          }
        }
        
        final bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (e) {
        print('Error decoding base64 image: $e');
        return null;
      }
    }
    
    final imageProvider = _buildImageProvider(category.imageBase64);
    
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Get.toNamed('/restaurants', arguments: {'category': category.name});
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: imageProvider != null
                    ? DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageProvider == null
                  ? Center(
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 60,
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    )
                  : null,
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
                          category.name,
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _getCategoryDisplayText(category),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.description ?? 'Discover delicious breakfast options.',
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
                        category.peakTime ?? 'Peak: 9:00 AM',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/restaurants', arguments: {'category': category.name});
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

