import '../models/reservation_model.dart';

/// ReservationService - Manages all reservations (in-memory storage)
/// In a real app, this would connect to a database or API
class ReservationService {
  // Singleton pattern
  static final ReservationService _instance = ReservationService._internal();
  factory ReservationService() => _instance;
  ReservationService._internal();

  // In-memory storage for reservations
  final List<ReservationModel> _reservations = [];

  /// Add a new reservation
  void addReservation(ReservationModel reservation) {
    _reservations.add(reservation);
  }

  /// Get all reservations
  List<ReservationModel> getReservations() {
    return List.from(_reservations);
  }

  /// Cancel a reservation by ID
  void cancelReservation(String reservationId) {
    _reservations.removeWhere((reservation) => reservation.id == reservationId);
  }

  /// Clear all reservations
  void clearAllReservations() {
    _reservations.clear();
  }

  /// Get reservation by ID
  ReservationModel? getReservationById(String id) {
    try {
      return _reservations.firstWhere((reservation) => reservation.id == id);
    } catch (e) {
      return null;
    }
  }
}

