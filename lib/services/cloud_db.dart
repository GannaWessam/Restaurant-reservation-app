import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDb {
  CloudDb._();

  static CloudDb get instance => CloudDb._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReservation(Reservation reservation) async {
    await _firestore.collection('reservations').doc(reservation.id).set(reservation.toJson());
    print('Reservation added: ${reservation.id}');
  }
}
