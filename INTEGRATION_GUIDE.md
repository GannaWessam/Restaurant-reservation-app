# Step-by-Step Integration Guide

This guide will walk you through integrating the authentication module into the Restaurant Reservation Flutter app.

## Prerequisites

- Flutter SDK installed (3.0.0 or higher)
- A code editor (VS Code, Android Studio, etc.)
- Firebase account (free tier is fine)
- Basic knowledge of Flutter and Dart

## Step 1: Install Dependencies

1. Open `pubspec.yaml`
2. Add dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  cupertino_icons: ^1.0.8
```

3. Run:
```bash
flutter pub get
```

## Step 2: Setup Firebase

### 2.1: Install Firebase CLI

```bash
# Install Firebase tools
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login
```

### 2.2: Configure Firebase for Your Project

```bash
# In your project root
flutterfire configure
```

This will:
- Prompt you to select/create a Firebase project
- Ask which platforms you want to support
- Generate `lib/firebase_options.dart` file
- Configure Firebase for your platforms

### 2.3: Enable Email/Password Authentication

1. Go to https://console.firebase.google.com
2. Select your project
3. Go to **Authentication** > **Sign-in method**
4. Click on **Email/Password**
5. Enable it and save

## Step 3: Create Home Screen

Create a simple home screen that users will see after login.

Create the file `lib/pages/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Reservations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text('Browse restaurants and make reservations'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to restaurant list
              },
              child: const Text('Browse Restaurants'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Step 4: Configure Main Application

Update your `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import pages
import 'pages/login_screen.dart';
import 'pages/register_screen.dart';
import 'pages/home_screen.dart';

// Import bindings
import 'bindings/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Reservations',
      
      // Set initial route
      initialRoute: '/login',
      
      // Configure routes
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
        ),
      ],
      
      // Apply theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1B3377),
        scaffoldBackgroundColor: const Color(0xFF0C1323),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF84AAF6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF273E65),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF213555)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF213555)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF84AAF6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF84AAF6),
          ),
        ),
      ),
    );
  }
}
```

## Step 5: Platform-Specific Configuration

### Android Configuration

1. Edit `android/app/build.gradle`:

```gradle
android {
    // ... other config
    
    defaultConfig {
        minSdkVersion 21  // Change from 16 to 21
        // ... other config
    }
}
```

2. Edit `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath 'com.google.gms:google-services:4.3.15'  // Add this
        // ... other dependencies
    }
}
```

3. Add to the bottom of `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS Configuration

1. Edit `ios/Podfile`:

```ruby
# Uncomment this line
platform :ios, '12.0'
```

2. Run:
```bash
cd ios
pod install
cd ..
```

## Step 6: Test the Application

### Run on an emulator/device:

```bash
# Android
flutter run

# iOS (Mac only)
flutter run -d ios

# Web
flutter run -d chrome
```

### Test the flow:

1. **Registration:**
   - Open the app → You should see Login screen
   - Click "Sign up"
   - Enter name, email, password
   - Click "Sign Up"
   - You should be redirected to Home screen

2. **Login:**
   - Logout from Home screen
   - Enter registered email and password
   - Click "Sign In"
   - You should be redirected to Home screen

3. **Validation:**
   - Try submitting empty forms
   - Try invalid email formats
   - Try short passwords
   - Check that error messages appear

## Step 7: Customize for Your Restaurant App

### Update App Branding

You can keep the restaurant-themed text or customize further:
- Login screen: "Welcome to Restaurant Reservations"
- Register screen: "Join us and reserve your favorite tables!"

### Modify Theme Colors

In `main.dart`, update the theme colors to match your brand identity.

### Add More Features

- Add forgot password screen using `AuthService.resetPassword()`
- Add user profile screen
- Add email verification
- Implement restaurant listing and reservation features

## Common Issues & Solutions

### Issue: "Firebase not initialized"
**Fix**: Ensure `await Firebase.initializeApp()` is in main() before runApp()

### Issue: "Route not found"
**Fix**: Check that all routes in auth_controller.dart match your getPages configuration

### Issue: "Import errors"
**Fix**: All imports should use `package:restaurant_reservation_app/...`

### Issue: "Build failed"
**Fix**: 
- Run `flutter clean`
- Run `flutter pub get`
- Try rebuilding

### Issue: "Firebase auth errors"
**Fix**: 
- Check Firebase console that Email/Password is enabled
- Verify `firebase_options.dart` exists
- Check internet connection

## Next Steps

✅ Authentication is now integrated!

**Recommended additions:**
1. Add email verification
2. Implement password reset flow
3. Add user profile management
4. Store user data in Firestore
5. Add session persistence
6. Implement restaurant listing
7. Create reservation system
8. Add booking history

## Need More Help?

- Check Firebase documentation: https://firebase.google.com/docs/auth
- Check GetX documentation: https://pub.dev/packages/get
- Review the AUTH_README.md and DEPENDENCIES.md files

**Happy coding! 🎉**

