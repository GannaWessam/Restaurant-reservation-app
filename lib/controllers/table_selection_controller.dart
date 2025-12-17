import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/restaurant_model.dart';
import '../models/reservation_model.dart';
import '../db/reservations_crud.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';

/// TableSelectionController - ViewModel in MVVM pattern
/// Handles business logic and state management for table selection screen
class TableSelectionController extends GetxController {
  final ReservationsCrud _reservationsCrud = Get.find<ReservationsCrud>();
  final AuthService _authService = Get.find<AuthService>();
  final ReservationService _reservationService = ReservationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Reactive state
  final RxSet<int> selectedChairs = <int>{}.obs;
  final RxList<Map<String, dynamic>> tables = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  RestaurantModel? _restaurant;
  String? _timeSlot;
  DateTime? _scheduledDate;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _restaurant = args['restaurant'] as RestaurantModel;
      _timeSlot = args['timeSlot'] as String;
      _scheduledDate = args['scheduledDate'] as DateTime?;
      
      // Restore selected chairs if returning from login
      if (args.containsKey('selectedChairs')) {
        final savedChairs = args['selectedChairs'] as List<dynamic>;
        selectedChairs.addAll(savedChairs.map((e) => e as int));
      }
      
      loadTablesAndReservations();
    }
  }

  // Parse table and seat information from restaurant.tables string 
  // Handles formats like: "15 tables" or "Table 1: 6 seats, Table 2: 5 seats, Table 3: 4 seats"
  // Returns a list of maps with table info: [{'tableNumber': 1, 'seats': 6}, {'tableNumber': 2, 'seats': 5}, ...]
  List<Map<String, int>> _parseTableInfo(String tablesString) {
    try {
      final List<Map<String, int>> tableInfoList = [];
      
      // Check if the format is "Table X: Y seats"
      final tableMatches = RegExp(r'Table\s+(\d+):\s*(\d+)\s*seats?', caseSensitive: false).allMatches(tablesString);
      
      if (tableMatches.isNotEmpty) {
        for (var match in tableMatches) {
          final tableNumber = int.parse(match.group(1)!);
          final seatCount = int.parse(match.group(2)!);
          tableInfoList.add({'tableNumber': tableNumber, 'seats': seatCount});
        }
        print('Parsed table info: $tableInfoList');
        return tableInfoList;
      }
      
      // Otherwise, try to extract number from formats like "15 tables" and use default seat counts
      final match = RegExp(r'(\d+)\s*tables?', caseSensitive: false).firstMatch(tablesString);
      if (match != null) {
        final tableCount = int.parse(match.group(1)!);
        // Create default tables with 4 seats each
        for (int i = 1; i <= tableCount; i++) {
          tableInfoList.add({'tableNumber': i, 'seats': 4});
        }
        return tableInfoList;
      }
      
      // If nothing matches, return default
      print('Could not parse table info from: $tablesString, using default');
      return [
        {'tableNumber': 1, 'seats': 4},
        {'tableNumber': 2, 'seats': 4},
        {'tableNumber': 3, 'seats': 6},
      ];
    } catch (e) {
      print('Error parsing table info: $e');
      return [
        {'tableNumber': 1, 'seats': 4},
        {'tableNumber': 2, 'seats': 4},
      ];
    }
  }

  // Generate table layout based on parsed table information
  List<Map<String, dynamic>> _generateTableLayout(List<Map<String, int>> tableInfoList) {
    final List<Map<String, dynamic>> generatedTables = [];
    
    int chairIdCounter = 1;
    double yPosition = 50.0;
    const double verticalSpacing = 220.0;
    const double xPosition = 50.0;
    
    for (var tableInfo in tableInfoList) {
      final tableId = tableInfo['tableNumber']!;
      final numChairs = tableInfo['seats']!;
      
      // Determine table shape and size based on number of chairs
      String shape;
      double size;
      double? width;
      
      if (numChairs <= 4) {
        shape = 'square';
        size = 50.0;
      } else if (numChairs <= 6) {
        shape = 'round';
        size = 70.0;
      } else if (numChairs <= 8) {
        shape = 'round';
        size = 80.0;
      } else {
        shape = 'rectangle';
        size = 60.0;
        width = 140.0;
      }
      
      // Generate chairs dynamically based on actual seat count
      final List<Map<String, dynamic>> chairs = _generateChairsForTable(numChairs, chairIdCounter);
      chairIdCounter += numChairs;

      final table = {
        'id': tableId,
        'x': xPosition,
        'y': yPosition,
        'shape': shape,
        'size': size,
        if (width != null) 'width': width,
        'chairs': chairs,
      };
      
      generatedTables.add(table);
      yPosition += verticalSpacing;
    }
    
    return generatedTables;
  }

  // Calculate dynamic canvas height based on generated tables
  double get canvasHeight {
    if (tables.isEmpty) return 700.0;
    double maxHeight = 700.0;
    for (final table in tables) {
      final y = table['y'] as double;
      final size = table['size'] as double;
      maxHeight = math.max(maxHeight, y + size + 140); // padding for chairs and spacing
    }
    return maxHeight;
  }

  // Generate chairs for a table based on seat count using angular distribution
  List<Map<String, dynamic>> _generateChairsForTable(int numChairs, int startingChairId) {
    final List<Map<String, dynamic>> chairs = [];
    int chairId = startingChairId;
    
    // Use angular distribution for even spacing around the table
    // Start from top (-90 degrees) and go clockwise
    for (int i = 0; i < numChairs; i++) {
      // Calculate angle for even distribution (starting from top)
      // -90 degrees (top) and going clockwise
      final angle = -90 + (360 / numChairs) * i;
      
      chairs.add({
        'id': chairId++,
        'position': 'angle',
        'angle': angle,
        'booked': false,
      });
    }
    
    return chairs;
  }

  // Load tables and reservations
  Future<void> loadTablesAndReservations() async {
    if (_restaurant == null || _timeSlot == null || _scheduledDate == null) return;

    isLoading.value = true;
    
    try {
      // Parse table information from restaurant.tables
      final tableInfoList = _parseTableInfo(_restaurant!.tables);
      
      // Generate table layout with actual seat counts
      final generatedTables = _generateTableLayout(tableInfoList);
      
      // Load existing reservations for this restaurant, time slot and scheduled date
      final reservations =
          await _reservationsCrud.getReservationsByRestaurantTimeSlotAndDate(
        _restaurant!.name,
        _timeSlot!,
        _scheduledDate!,
      );
      
      // Collect all booked seat IDs
      final Set<int> bookedSeatIds = {};
      for (var reservation in reservations) {
        bookedSeatIds.addAll(reservation.seatIds);
      }
      
      // Apply business rule: If any seat in a table is booked, mark entire table as unavailable
      for (var table in generatedTables) {
        final chairs = table['chairs'] as List<Map<String, dynamic>>;
        bool hasBookedSeat = false;
        
        // Check if any chair in this table is booked
        for (var chair in chairs) {
          final chairId = chair['id'] as int;
          if (bookedSeatIds.contains(chairId)) {
            hasBookedSeat = true;
            break;
          }
        }
        
        // If table has at least one booked seat, mark all seats as unavailable
        if (hasBookedSeat) {
          for (var chair in chairs) {
            chair['booked'] = true;
          }
        } else {
          // Mark individual booked seats
          for (var chair in chairs) {
            final chairId = chair['id'] as int;
            chair['booked'] = bookedSeatIds.contains(chairId);
          }
        }
      }
      
      tables.value = generatedTables;
    } catch (e) {
      print('Error loading tables and reservations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle chair selection
  void toggleChair(int chairId) {
    if (selectedChairs.contains(chairId)) {
      selectedChairs.remove(chairId);
    } else {
      // Check if chair is available (not booked and table is not fully booked)
      final chair = _getChairById(chairId);
      if (chair != null && !chair['booked'] as bool) {
        selectedChairs.add(chairId);
      }
    }
  }

  // Get chair by ID
  Map<String, dynamic>? _getChairById(int chairId) {
    for (var table in tables.value) {
      final chairs = table['chairs'] as List<Map<String, dynamic>>;
      for (var chair in chairs) {
        if (chair['id'] as int == chairId) {
          return chair;
        }
      }
    }
    return null;
  }

  // Check if chair is available (not booked and table is not fully booked)
  bool isChairAvailable(int chairId) {
    final chair = _getChairById(chairId);
    if (chair == null) return false;
    
    // If chair is booked, it's not available
    if (chair['booked'] as bool) return false;
    
    // Check if the table has any booked seats (business rule)
    final table = _getTableByChairId(chairId);
    if (table != null) {
      final chairs = table['chairs'] as List<Map<String, dynamic>>;
      for (var c in chairs) {
        if (c['booked'] as bool) {
          return false; // Table has booked seats, so all seats are unavailable
        }
      }
    }
    
    return true;
  }

  // Get table by chair ID
  Map<String, dynamic>? _getTableByChairId(int chairId) {
    for (var table in tables.value) {
      final chairs = table['chairs'] as List<Map<String, dynamic>>;
      for (var chair in chairs) {
        if (chair['id'] as int == chairId) {
          return table;
        }
      }
    }
    return null;
  }

  // Confirm reservation
  Future<void> confirmReservation() async {
    if (_restaurant == null || _timeSlot == null || _scheduledDate == null) return;
    if (selectedChairs.isEmpty) return;

    // Final availability check in case seats were taken while confirming
    final stillAvailable = await ensureSelectionAvailable();
    if (!stillAvailable) {
      Get.snackbar(
        'Seats unavailable',
        'Some seats were just reserved. Please pick others.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
      return;
    }

    // Check if user is logged in
    final userId = currentUserId;
    if (userId == null) {
      // Redirect to login with return route
      Get.toNamed('/login', arguments: {
        'returnRoute': '/table-selection',
        'restaurant': _restaurant,
        'timeSlot': _timeSlot,
        'scheduledDate': _scheduledDate,
        'selectedChairs': selectedChairs.toList(),
      });
      return;
    }

    final reservation = ReservationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId, // Include user ID
      restaurantName: _restaurant!.name,
      restaurantCategory: _restaurant!.category,
      timeSlot: _timeSlot!,
      seatCount: selectedChairs.length,
      seatIds: selectedChairs.toList()..sort(),
      reservationDate: DateTime.now(), // When reservation was created
      scheduledDate: _scheduledDate!, // When reservation is scheduled for
      restaurantImage: _restaurant!.imagePath,
    );

    // Save to Firestore
    try {
      await _reservationsCrud.addReservation(reservation);
    } catch (e) {
      print('Error saving reservation to Firestore: $e');
    }

    // Also save to in-memory service (for backward compatibility)
    _reservationService.addReservation(reservation);

    // Reload tables to reflect new bookings
    await loadTablesAndReservations();
    
    // Clear selections
    selectedChairs.clear();
  }

  // Re-check reservations to ensure currently selected seats are still free
  Future<bool> ensureSelectionAvailable() async {
    if (_restaurant == null || _timeSlot == null || _scheduledDate == null) return false;

    try {
      final reservations =
          await _reservationsCrud.getReservationsByRestaurantTimeSlotAndDate(
        _restaurant!.name,
        _timeSlot!,
        _scheduledDate!,
      );

      final Set<int> bookedSeatIds = {};
      for (var reservation in reservations) {
        bookedSeatIds.addAll(reservation.seatIds);
      }

      final hasConflict = selectedChairs.any(bookedSeatIds.contains);
      if (hasConflict) {
        selectedChairs.removeWhere(bookedSeatIds.contains);
        await loadTablesAndReservations(); // refresh UI with latest bookings
      }

      return !hasConflict;
    } catch (e) {
      print('Error validating seat availability: $e');
      return false;
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => _authService.isLoggedIn();
}

