import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/restaurant_model.dart';
import 'db_instance.dart';

class ReservationsCrud {
  // final FirebaseFirestore firestore = Get.find<CloudDb>().db;
  // Lazy initialization - only access Firestore when firestore is first accessed
  FirebaseFirestore get firestore => Get.find<CloudDb>().db;

   Future<void> addReservation(RestaurantModel reservation) async {
    await firestore.collection('reservations').doc(reservation.id).set(reservation.toJson());
    print('Reservation added: ${reservation.id}');
  }
  Future<void> getReservations() async { //lel vendor
    await firestore.collection('reservations').get();
  }
  Future<void> getReservationsByUserId(String userId) async { //lel user
    await firestore.collection('reservations').where('userId', isEqualTo: userId).get();
  }
}