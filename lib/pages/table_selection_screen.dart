import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant_model.dart';
import '../controllers/table_selection_controller.dart';
import '../services/auth_service.dart';

class TableSelectionScreen extends GetView<TableSelectionController> {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final RestaurantModel restaurant = args['restaurant'];
    final String timeSlot = args['timeSlot'];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Your Table',
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              '${restaurant.name} • $timeSlot',
                              style: GoogleFonts.tajawal(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Legend
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildLegendItem(
                        context,
                        Colors.green[600]!,
                        'Available',
                      ),
                      _buildLegendItem(
                        context,
                        const Color(0xFF8D6E63),
                        'Selected',
                      ),
                      _buildLegendItem(
                        context,
                        Colors.red[600]!,
                        'Unavailable',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Restaurant Floor Plan
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: 700,
                        child: Stack(
                          children: [
                            // Tables with chairs
                            ...controller.tables.map((table) {
                              return Positioned(
                                left: table['x'] as double,
                                top: table['y'] as double,
                                child: _buildTableWithChairs(context, table),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 16),
            
            // Selected Chairs Info
            Obx(() {
              if (controller.selectedChairs.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8D6E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8D6E63).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_seat,
                      color: const Color(0xFF8D6E63),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.selectedChairs.length} ${controller.selectedChairs.length == 1 ? 'Seat' : 'Seats'} Selected',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            'Tap seats to add or remove',
                            style: GoogleFonts.tajawal(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            // Bottom Button
            Container(
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
                child: Obx(() {
                  final isEmpty = controller.selectedChairs.isEmpty;
                  
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isEmpty
                          ? null
                          : () {
                              // Check if user is logged in before confirming reservation
                              if (!controller.isLoggedIn) {
                                _showLoginRequiredDialog(restaurant, timeSlot);
                              } else {
                                _confirmReservation(restaurant, timeSlot);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8D6E63),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isEmpty
                            ? 'Select Seats to Reserve'
                            : 'Reserve',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEmpty
                              ? Colors.grey[500]
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTableWithChairs(BuildContext context, Map<String, dynamic> table) {
    final shape = table['shape'] as String;
    final size = table['size'] as double;
    final width = table['width'] as double? ?? size;
    final chairs = table['chairs'] as List;

    return SizedBox(
      width: width + 100,
      height: size + 100,
      child: Stack(
        children: [
          // Table in center
          Positioned(
            left: 50,
            top: 50,
            child: Container(
              width: width,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: shape == 'round' ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: shape != 'round' ? BorderRadius.circular(8) : null,
              ),
            ),
          ),
          // Chairs around table
          ...chairs.map((chair) {
            return _buildChairAtPosition(
              context,
              chair,
              width,
              size,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChairAtPosition(
    BuildContext context,
    Map<String, dynamic> chair,
    double tableWidth,
    double tableHeight,
  ) {
    final chairId = chair['id'] as int;
    final position = chair['position'] as String;
    final isBooked = chair['booked'] as bool;

    const double baseOffset = 50.0;
    const double chairDistance = 8.0;
    const double chairWidth = 28.0;
    const double chairHeight = 32.0;

    double getLeft() {
      final centerX = baseOffset + tableWidth / 2;
      switch (position) {
        case 'top':
        case 'bottom':
          return centerX - chairWidth / 2;
        case 'top-right':
        case 'bottom-right':
          return centerX + 20;
        case 'right':
          return baseOffset + tableWidth + chairDistance;
        case 'left':
          return baseOffset - chairDistance - chairWidth;
        case 'top-left':
        case 'bottom-left':
          return centerX - 20 - chairWidth;
        default:
          return centerX;
      }
    }

    double getTop() {
      final centerY = baseOffset + tableHeight / 2;
      switch (position) {
        case 'top':
        case 'top-right':
        case 'top-left':
          return baseOffset - chairDistance - chairHeight;
        case 'bottom':
        case 'bottom-right':
        case 'bottom-left':
          return baseOffset + tableHeight + chairDistance;
        case 'right':
        case 'left':
          return centerY - chairHeight / 2;
        default:
          return centerY;
      }
    }

    return Obx(() {
      final isSelected = controller.selectedChairs.contains(chairId);
      final isAvailable = !isBooked && controller.isChairAvailable(chairId);
      
      return Positioned(
        left: getLeft(),
        top: getTop(),
        child: GestureDetector(
          onTap: isAvailable
              ? () {
                  controller.toggleChair(chairId);
                }
              : null,
          child: Container(
            width: chairWidth,
            height: chairHeight,
            decoration: BoxDecoration(
              color: isBooked || !isAvailable
                  ? Colors.red[600]
                  : isSelected
                      ? const Color(0xFF8D6E63)
                      : Colors.green[600],
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showLoginRequiredDialog(
    RestaurantModel restaurant,
    String timeSlot,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Login Required',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Please log in to make a reservation.',
          style: GoogleFonts.tajawal(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.cairo(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to login, and pass reservation data to return here after login
              Get.toNamed('/login', arguments: {
                'returnRoute': '/table-selection',
                'restaurant': restaurant,
                'timeSlot': timeSlot,
                'selectedChairs': controller.selectedChairs.toList(),
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8D6E63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.cairo(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReservation(
    RestaurantModel restaurant,
    String timeSlot,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirm Reservation',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Obx(() {
          final seatCount = controller.selectedChairs.length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.restaurant, 'Restaurant', restaurant.name),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.access_time, 'Time', timeSlot),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.event_seat, 'Seats', '$seatCount ${seatCount == 1 ? 'seat' : 'seats'}'),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.cairo(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final seatCount = controller.selectedChairs.length;
              await controller.confirmReservation();
              
              Get.back();
              Get.back();
              Get.back();
              
              Get.snackbar(
                'Reservation Confirmed!',
                'Your $seatCount ${seatCount == 1 ? 'seat' : 'seats'} at ${restaurant.name} is reserved for $timeSlot',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
                icon: const Icon(Icons.check_circle, color: Colors.white),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8D6E63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.cairo(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
