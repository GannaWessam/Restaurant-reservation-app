// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import 'db_instance.dart';
//
// class VendorCrud{
//   FirebaseFirestore get firestore => Get.find<CloudDb>().db;
//
//   Future<void> addVendor(vendorModel vendor) async {
//     try {
//       await firestore.collection('vendors').doc(vendor.id).set(vendor.toJson());
//       print('vendor added: ${vendor.id}');
//     } catch (e) {
//       print('Error adding vendor: $e');
//     }
//   }
//   // Future<String> getVendorTokenById(int vendorId) async { //lel user
//     try {
//       final vendor = await firestore.collection('vendors').doc(vendorId).get();
//       if (vendor.exists) {
//         final data = vendor.data();
//         if (data != null && data['token'] != null) {
//           return data['token'];
//         }
//         return'';
//       }
//       return '';
//     } catch (e) {
//       print(e);
//       return '';
//     }
//   }
// }