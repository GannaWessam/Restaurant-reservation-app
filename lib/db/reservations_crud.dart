import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restaurant_reservation_app/services/notification_service.dart';

import '../models/reservation_model.dart';
import '../models/restaurant_model.dart';
import 'db_instance.dart';

class ReservationsCrud {
  // final FirebaseFirestore firestore = Get.find<CloudDb>().db;
  // Lazy initialization - only access Firestore when firestore is first accessed
  FirebaseFirestore get firestore => Get.find<CloudDb>().db;
  final notificationService = Get.find<NotificationService>();

  Future<void> addReservation(ReservationModel reservation) async {
    try {
      await firestore.collection('reservations').doc(reservation.id).set(reservation.toJson());
      print('Reservation added: ${reservation.id}');

      notificationService.sendNotificationToAllDevices(
        //ghoniem's phone token (in our firbase project)
        // token:"fyyVeXViTzO4pXgK9Rhu99:APA91bG_IX-hA3SeXI6FUEhZO5Zx1dZHJROkJ0jC_OtzZViv2oDqXsnu9wgatG9_Eb07024MZACM6-5MhDqjfx5dbElTuxD4UktrODaEN4NoOs7lRAo6_ro",
        // token: "fMEi3k7oTsmtpj1cwZf173:APA91bFu_d5Ch6IXmtiLrb8aSjNSrEu2AbYRQRjFru_shbm-qa1VMY5UTo4a3Irvi4UHQR9Wq5QRyzzpGLhS9_BBhvIhv4xdMFqizqcgckW2h6RFA_3j_jY",
        title: "New Reservation",
        body: "A new table has been booked!",
        data: {
          "screen": "reservations",
        }, reservedRestaurant: reservation.restaurantName,
      );


    } catch (e) {
      print('Error adding reservation: $e');
    }
  }

  Future<List<ReservationModel>> getReservations() async { //lel vendor
    try {
      final reservationsSnapshot = await firestore.collection('reservations').get();
      return reservationsSnapshot.docs.map((reservation)=>
          ReservationModel.fromJson(reservation.data())).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<ReservationModel>> getReservationsByUserId(String userId) async { //lel user
    try {
      final reservationsSnapshot =
        await firestore.collection('reservations').where('userId', isEqualTo: userId).get();
      return reservationsSnapshot.docs.map((reservation)=>
          ReservationModel.fromJson(reservation.data())).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get reservations by restaurant and time slot (across all dates)
  Future<List<ReservationModel>> getReservationsByRestaurantAndTimeSlot(
    String restaurantName,
    String timeSlot,
  ) async {
    try {
      final reservationsSnapshot = await firestore
          .collection('reservations')
          .where('restaurantName', isEqualTo: restaurantName)
          .where('timeSlot', isEqualTo: timeSlot)
          .get();
      return reservationsSnapshot.docs
          .map((reservation) => ReservationModel.fromJson(reservation.data()))
          .toList();
    } catch (e) {
      print('Error getting reservations by restaurant and time slot: $e');
      return [];
    }
  }

  // Get reservations by restaurant, time slot, and scheduled date (single calendar day)
  Future<List<ReservationModel>> getReservationsByRestaurantTimeSlotAndDate(
    String restaurantName,
    String timeSlot,
    DateTime scheduledDate,
  ) async {
    try {
      // Normalize to just the date part to be consistent
      final normalizedDate = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
      ).toIso8601String();

      final reservationsSnapshot = await firestore
          .collection('reservations')
          .where('restaurantName', isEqualTo: restaurantName)
          .where('timeSlot', isEqualTo: timeSlot)
          .where('scheduledDate', isEqualTo: normalizedDate)
          .get();

      return reservationsSnapshot.docs
          .map((reservation) => ReservationModel.fromJson(reservation.data()))
          .toList();
    } catch (e) {
      print('Error getting reservations by restaurant, time slot and date: $e');
      return [];
    }
  }

  // Delete a reservation
  Future<void> deleteReservation(String reservationId) async {
    try {
      await firestore.collection('reservations').doc(reservationId).delete();
      print('Reservation deleted: $reservationId');
    } catch (e) {
      print('Error deleting reservation: $e');
      rethrow;
    }
  }
}