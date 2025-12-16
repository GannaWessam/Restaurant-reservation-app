import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:restaurant_reservation_app/controllers/auth_controller.dart';
import 'package:restaurant_reservation_app/controllers/favorites_controller.dart';
import 'package:restaurant_reservation_app/controllers/restaurants_list_controller.dart';
import 'package:restaurant_reservation_app/controllers/restaurant_detail_controller.dart';
import 'package:restaurant_reservation_app/controllers/table_selection_controller.dart';
import 'package:restaurant_reservation_app/controllers/my_reservations_controller.dart';
import 'package:restaurant_reservation_app/db/vendor_crud.dart';
import 'package:restaurant_reservation_app/services/auth_service.dart';
import 'package:restaurant_reservation_app/db/reservations_crud.dart';
import 'package:restaurant_reservation_app/db/restaurant_crud.dart';
import 'package:restaurant_reservation_app/db/category_crud.dart';
import 'package:restaurant_reservation_app/db/user_crud.dart';
import 'package:restaurant_reservation_app/db/db_instance.dart';
import 'package:restaurant_reservation_app/services/notification_service.dart';
import 'firebase_options.dart';

// Import pages
import 'pages/splash_screen.dart';
import 'pages/login_screen.dart';
import 'pages/register_screen.dart';
import 'pages/categories_screen.dart';
import 'pages/restaurants_list_screen.dart';
import 'pages/restaurant_detail_screen.dart';
import 'pages/table_selection_screen.dart';
import 'pages/my_reservations_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';


//get specific device token (static for one mobile in our case - but will work dynamiclly on web)
// final FirebaseMessaging _fcm = FirebaseMessaging.instance;

// Store the web token so it can be accessed from other parts of the app
// String? webFcmToken;

// Future<String?> getToken() async {
//   try {
//     // For web, configure the service worker path if needed
//     if (kIsWeb) {
//       await _fcm.setAutoInitEnabled(true);
//     }
//     String? token = await _fcm.getToken();
//     if (kIsWeb && token != null) {
//       webFcmToken = token; // Store web token
//     }
//     print("\n\n\n Device Token: $token \n\n\n");
//     return token;
//   } catch (e) {
//     print("\n\n\n Error getting FCM token: $e \n\n\n");
//     // Don't crash the app if token retrieval fails
//     return null;
//   }
// }

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // Optional: handle background data
//   print('Background message: ${message.messageId}');
// }



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request notification permission for all platforms
  // This should be done early, before getting the token
  // try {
  //   final NotificationSettings settings = await _fcm.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
    
  //   print("Notification permission status: ${settings.authorizationStatus}");
    
  //   // For web, small delay to ensure service worker is ready
  //   if (kIsWeb) {
  //     await Future.delayed(const Duration(milliseconds: 500));
  //   }
  // } catch (e) {
  //   print("Error requesting notification permission: $e");
  // }

  // Get token (with error handling) - defer to avoid blocking app startup
  // getToken().then((token) {
  //   if (kIsWeb && token != null) {
  //     webFcmToken = token;
  //   }
  // }).catchError((e) {
  //   print("Failed to get FCM token: $e");
  // });

  // FirebaseMessaging.onBackgroundMessage(
  //   firebaseMessagingBackgroundHandler,
  // );

  // // Init local notifications
  // await NotificationService.init();

  // // Listen to foreground messages
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   NotificationService.showForeground(message);
  // });

  // Register services as permanent dependencies
  // Register CloudDb first since ReservationsCrud and RestaurantCrud depend on it
  Get.put(CloudDb(), permanent: true);
  Get.put(AuthService(), permanent: true);
  // Register NotificationService before ReservationsCrud since ReservationsCrud depends on it
  Get.put(NotificationService(), permanent: true);
  Get.put(ReservationsCrud(), permanent: true);
  Get.put(RestaurantCrud(), permanent: true);
  Get.put(CategoryCrud(), permanent: true);
  Get.put(UserCrud(), permanent: true);
  // Get.put(VendorCrud(), permanent: true);



  // Register FavoritesController as permanent so it persists across screens
  Get.put(FavoritesController(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fatoorna - Restaurant Reservations',

      // Configure routes
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AuthController());
          }),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AuthController());
          }),
        ),
        GetPage(
          name: '/home',
          page: () => const CategoriesScreen(),
        ),
        GetPage(
          name: '/restaurants',
          page: () => const RestaurantsListScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => RestaurantsListController());
          }),
        ),
        GetPage(
          name: '/table-selection',
          page: () => const TableSelectionScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => TableSelectionController());
          }),
        ),
        GetPage(
          name: '/restaurant-detail',
          page: () => const RestaurantDetailScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => RestaurantDetailController());
          }),
        ),
        GetPage(
          name: '/my-reservations',
          page: () => const MyReservationsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MyReservationsController());
          }),
        ),
      ],

      // Apply custom theme with color palette
      theme: _buildTheme(),
    );
  }

  // Theme based on Beautiful Palette 2
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,

      // Color Palette
      primaryColor: const Color(0xFFB08968), // Medium brown
      scaffoldBackgroundColor: const Color(0xFFEDE0D4), // Lightest beige

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFB08968), // Medium brown
        secondary: Color(0xFF7F5539), // Dark brown
        tertiary: Color(0xFF9C6644), // Brown
        surface: Color(0xFFE6CCB2), // Light tan
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF7F5539), // Dark brown for text
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB08968),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF7F5539),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF7F5539),
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF7F5539),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF9C6644),
          fontSize: 14,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDDB892)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDDB892)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB08968), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9C6644)),
        prefixIconColor: Color(0xFF9C6644),
        suffixIconColor: Color(0xFF9C6644),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7F5539), // Dark brown
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF7F5539),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
