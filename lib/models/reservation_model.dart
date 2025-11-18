/// ReservationModel - Model for storing reservation data
class ReservationModel {
  final String id;
  final String restaurantName;
  final String restaurantCategory;
  final String timeSlot;
  final int seatCount;
  final List<int> seatIds;
  final DateTime reservationDate;
  final String? restaurantImage;

  ReservationModel({
    required this.id,
    required this.restaurantName,
    required this.restaurantCategory,
    required this.timeSlot,
    required this.seatCount,
    required this.seatIds,
    required this.reservationDate,
    this.restaurantImage,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantName': restaurantName,
      'restaurantCategory': restaurantCategory,
      'timeSlot': timeSlot,
      'seatCount': seatCount,
      'seatIds': seatIds,
      'reservationDate': reservationDate.toIso8601String(),
      'restaurantImage': restaurantImage,
    };
  }

  // Create from JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      restaurantName: json['restaurantName'],
      restaurantCategory: json['restaurantCategory'],
      timeSlot: json['timeSlot'],
      seatCount: json['seatCount'],
      seatIds: List<int>.from(json['seatIds']),
      reservationDate: DateTime.parse(json['reservationDate']),
      restaurantImage: json['restaurantImage'],
    );
  }
}

