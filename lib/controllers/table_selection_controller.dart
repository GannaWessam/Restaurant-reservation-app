import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _restaurant = args['restaurant'] as RestaurantModel;
      _timeSlot = args['timeSlot'] as String;
      
      // Restore selected chairs if returning from login
      if (args.containsKey('selectedChairs')) {
        final savedChairs = args['selectedChairs'] as List<dynamic>;
        selectedChairs.addAll(savedChairs.map((e) => e as int));
      }
      
      loadTablesAndReservations();
    }
  }

  // Parse number of tables from restaurant.tables string (e.g., "15 tables" -> 15)
  int _parseTableCount(String tablesString) {
    try {
      final match = RegExp(r'(\d+)').firstMatch(tablesString);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
      return 6; // Default fallback
    } catch (e) {
      print('Error parsing table count: $e');
      return 6; // Default fallback
    }
  }

  // Generate table layout based on number of tables
  List<Map<String, dynamic>> _generateTableLayout(int tableCount) {
    final List<Map<String, dynamic>> generatedTables = [];
    
    // Predefined layouts for different table counts
    final List<List<Map<String, dynamic>>> layouts = [
      // Layout for 1-3 tables
      <Map<String, dynamic>>[
        <String, dynamic>{'x': 100.0, 'y': 50.0, 'shape': 'round', 'size': 60.0, 'chairs': 4},
        <String, dynamic>{'x': 200.0, 'y': 50.0, 'shape': 'square', 'size': 50.0, 'chairs': 4},
        <String, dynamic>{'x': 150.0, 'y': 200.0, 'shape': 'round', 'size': 80.0, 'chairs': 6},
      ],
      // Layout for 4-6 tables
      <Map<String, dynamic>>[
        <String, dynamic>{'x': 20.0, 'y': 30.0, 'shape': 'square', 'size': 50.0, 'chairs': 4},
        <String, dynamic>{'x': 200.0, 'y': 30.0, 'shape': 'square', 'size': 50.0, 'chairs': 4},
        <String, dynamic>{'x': 90.0, 'y': 180.0, 'shape': 'round', 'size': 80.0, 'chairs': 8},
        <String, dynamic>{'x': 20.0, 'y': 380.0, 'shape': 'round', 'size': 60.0, 'chairs': 4},
        <String, dynamic>{'x': 200.0, 'y': 380.0, 'shape': 'round', 'size': 60.0, 'chairs': 4},
        <String, dynamic>{'x': 70.0, 'y': 540.0, 'shape': 'rectangle', 'size': 60.0, 'width': 120.0, 'chairs': 6},
      ],
      // Layout for 7+ tables (extend as needed)
      <Map<String, dynamic>>[
        <String, dynamic>{'x': 20.0, 'y': 30.0, 'shape': 'square', 'size': 50.0, 'chairs': 4},
        <String, dynamic>{'x': 200.0, 'y': 30.0, 'shape': 'square', 'size': 50.0, 'chairs': 4},
        <String, dynamic>{'x': 90.0, 'y': 180.0, 'shape': 'round', 'size': 80.0, 'chairs': 8},
        <String, dynamic>{'x': 20.0, 'y': 380.0, 'shape': 'round', 'size': 60.0, 'chairs': 4},
        <String, dynamic>{'x': 200.0, 'y': 380.0, 'shape': 'round', 'size': 60.0, 'chairs': 4},
        <String, dynamic>{'x': 70.0, 'y': 540.0, 'shape': 'rectangle', 'size': 60.0, 'width': 120.0, 'chairs': 6},
        <String, dynamic>{'x': 300.0, 'y': 100.0, 'shape': 'round', 'size': 60.0, 'chairs': 4},
        <String, dynamic>{'x': 300.0, 'y': 300.0, 'shape': 'square', 'size': 50.0, 'chairs': 4},
      ],
    ];

    final layoutIndex = tableCount <= 3 ? 0 : (tableCount <= 6 ? 1 : 2);
    final baseLayout = layouts[layoutIndex];
    
    int chairIdCounter = 1;
    
    for (int i = 0; i < tableCount && i < baseLayout.length; i++) {
      final tableConfig = baseLayout[i];
      final tableId = i + 1;
      final numChairs = tableConfig['chairs'] as int;
      
      // Generate chairs based on shape
      final List<Map<String, dynamic>> chairs = [];
      if (tableConfig['shape'] == 'round') {
        if (numChairs == 4) {
          chairs.addAll([
            {'id': chairIdCounter++, 'position': 'top', 'booked': false},
            {'id': chairIdCounter++, 'position': 'right', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom', 'booked': false},
            {'id': chairIdCounter++, 'position': 'left', 'booked': false},
          ]);
        } else if (numChairs == 6) {
          chairs.addAll([
            {'id': chairIdCounter++, 'position': 'top-left', 'booked': false},
            {'id': chairIdCounter++, 'position': 'top', 'booked': false},
            {'id': chairIdCounter++, 'position': 'top-right', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom-right', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom-left', 'booked': false},
          ]);
        } else if (numChairs == 8) {
          chairs.addAll([
            {'id': chairIdCounter++, 'position': 'top-left', 'booked': false},
            {'id': chairIdCounter++, 'position': 'top', 'booked': false},
            {'id': chairIdCounter++, 'position': 'top-right', 'booked': false},
            {'id': chairIdCounter++, 'position': 'right', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom-right', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom', 'booked': false},
            {'id': chairIdCounter++, 'position': 'bottom-left', 'booked': false},
            {'id': chairIdCounter++, 'position': 'left', 'booked': false},
          ]);
        }
      } else if (tableConfig['shape'] == 'square') {
        chairs.addAll([
          {'id': chairIdCounter++, 'position': 'top', 'booked': false},
          {'id': chairIdCounter++, 'position': 'right', 'booked': false},
          {'id': chairIdCounter++, 'position': 'bottom', 'booked': false},
          {'id': chairIdCounter++, 'position': 'left', 'booked': false},
        ]);
      } else if (tableConfig['shape'] == 'rectangle') {
        chairs.addAll([
          {'id': chairIdCounter++, 'position': 'top-left', 'booked': false},
          {'id': chairIdCounter++, 'position': 'top-right', 'booked': false},
          {'id': chairIdCounter++, 'position': 'right', 'booked': false},
          {'id': chairIdCounter++, 'position': 'bottom-right', 'booked': false},
          {'id': chairIdCounter++, 'position': 'bottom-left', 'booked': false},
          {'id': chairIdCounter++, 'position': 'left', 'booked': false},
        ]);
      }

      final table = {
        'id': tableId,
        'x': tableConfig['x'] as double,
        'y': tableConfig['y'] as double,
        'shape': tableConfig['shape'] as String,
        'size': tableConfig['size'] as double,
        if (tableConfig['width'] != null) 'width': tableConfig['width'] as double,
        'chairs': chairs,
      };
      
      generatedTables.add(table);
    }
    
    return generatedTables;
  }

  // Load tables and reservations
  Future<void> loadTablesAndReservations() async {
    if (_restaurant == null || _timeSlot == null) return;

    isLoading.value = true;
    
    try {
      // Parse table count from restaurant.tables
      final tableCount = _parseTableCount(_restaurant!.tables);
      
      // Generate table layout
      final generatedTables = _generateTableLayout(tableCount);
      
      // Load existing reservations for this restaurant and time slot
      final reservations = await _reservationsCrud.getReservationsByRestaurantAndTimeSlot(
        _restaurant!.name,
        _timeSlot!,
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
    if (_restaurant == null || _timeSlot == null) return;
    if (selectedChairs.isEmpty) return;

    // Check if user is logged in
    final userId = currentUserId;
    if (userId == null) {
      // Redirect to login with return route
      Get.toNamed('/login', arguments: {
        'returnRoute': '/table-selection',
        'restaurant': _restaurant,
        'timeSlot': _timeSlot,
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
      reservationDate: DateTime.now(),
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

  // Check if user is logged in
  bool get isLoggedIn => _authService.isLoggedIn();
}

