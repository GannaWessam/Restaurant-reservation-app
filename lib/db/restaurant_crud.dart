import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/restaurant_model.dart';
import 'db_instance.dart';

class RestaurantCrud {
  // final FirebaseFirestore firestore = Get.find<CloudDb>().db;
  // Lazy initialization - only access Firestore when firestore is first accessed
  FirebaseFirestore get firestore => Get.find<CloudDb>().db;

  Future<void> addRestaurant(RestaurantModel restaurant) async { //vendor
    await firestore.collection('restaurants').doc(restaurant.id).set(restaurant.toJson());
    print('Restaurant added: ${restaurant.id}');
  }
  Future<void> getAllRestaurants() async { //vendor
    await firestore.collection('restaurants').get();
  }
  Future<void> getRestaurantsByCategory(String category) async { //user
      await firestore.collection('restaurants').where('category', isEqualTo: category).get();
    }

}