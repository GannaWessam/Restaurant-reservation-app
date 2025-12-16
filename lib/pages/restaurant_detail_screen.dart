import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../models/restaurant_model.dart';
import '../controllers/restaurant_detail_controller.dart';
import '../controllers/favorites_controller.dart';
import 'table_selection_screen.dart';
import 'my_reservations_screen.dart';

ImageProvider? _buildDetailImageProvider(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return null;

  // Network URL
  if (imagePath.startsWith('http')) {
    return NetworkImage(imagePath);
  }

  // Asset path
  if (imagePath.startsWith('assets/')) {
    return AssetImage(imagePath);
  }

  // Base64 (with or without data URL prefix)
  String base64String = imagePath;
  if (base64String.startsWith('data:image')) {
    final commaIndex = base64String.indexOf(',');
    if (commaIndex != -1) {
      base64String = base64String.substring(commaIndex + 1);
    }
  }

  try {
    final bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  } catch (_) {
    // If decoding fails, return null so placeholder can be shown
    return null;
  }
}

class RestaurantDetailScreen extends GetView<RestaurantDetailController> {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get restaurant from navigation arguments
    final RestaurantModel restaurant = Get.arguments as RestaurantModel;
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      restaurant.name,
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        final isFavorite = favoritesController.isFavorite(restaurant.id);
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Theme.of(context).colorScheme.secondary,
                            size: 28,
                          ),
                          onPressed: () {
                            controller.toggleFavorite(restaurant.id);
                          },
                        );
                      }),
                      PopupMenuButton<String>(
                        offset: const Offset(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          if (value == 'reservations') {
                            Get.toNamed('/my-reservations');
                          } else if (value == 'signout') {
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
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        image: _buildDetailImageProvider(restaurant.imagePath) != null
                            ? DecorationImage(
                                image: _buildDetailImageProvider(restaurant.imagePath)!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _buildDetailImageProvider(restaurant.imagePath) == null
                          ? Center(
                              child: Icon(
                                Icons.restaurant,
                                size: 80,
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                              ),
                            )
                          : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Restaurant Info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          restaurant.distance,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        restaurant.category,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Available Tables
                    Text(
                      'Available Tables',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.table_restaurant,
                            color: Colors.green[700],
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              restaurant.tables,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Select Date
                    Text(
                      'Select Date',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Date Picker Button
                    Obx(() {
                      final selectedDate = controller.selectedDate.value;
                      return GestureDetector(
                        onTap: () async {
                          final DateTime now = DateTime.now();
                          final DateTime firstDate = now;
                          final DateTime lastDate = now.add(const Duration(days: 365));
                          
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? now,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          
                          if (picked != null) {
                            controller.setDate(picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedDate != null
                                ? Theme.of(context).primaryColor.withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedDate != null
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: selectedDate != null
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[600],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reservation Date',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.getFormattedDate(),
                                      style: GoogleFonts.cairo(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: selectedDate != null
                                            ? Theme.of(context).colorScheme.secondary
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 24),
                    
                    // Select Time Slot
                    Text(
                      'Select Time Slot',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Time Slots Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: controller.timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = controller.timeSlots[index];
                        
                        return Obx(() {
                          final isSelected = controller.selectedTimeSlot.value == timeSlot;
                          
                          return GestureDetector(
                            onTap: () {
                              controller.setTimeSlot(timeSlot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                timeSlot,
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Bottom Button
            Obx(() {
              final selectedTimeSlot = controller.selectedTimeSlot.value;
              final selectedDate = controller.selectedDate.value;
              final isReady = selectedTimeSlot != null && selectedDate != null;
              
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: !isReady
                          ? null
                          : () {
                              Get.toNamed(
                                '/table-selection',
                                arguments: {
                                  'restaurant': restaurant,
                                  'timeSlot': selectedTimeSlot,
                                  'scheduledDate': selectedDate,
                                },
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        selectedDate == null
                            ? 'Select a Date'
                            : selectedTimeSlot == null
                                ? 'Select a Time Slot'
                                : 'Choose Your Table',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !isReady
                              ? Colors.grey[500]
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
