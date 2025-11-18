# Authentication Module - Extraction Package

This package contains a complete authentication module extracted from the Tour Guide Flutter project. It includes login, registration, Firebase authentication, and GetX state management.

## 📁 Package Contents

```
Restaurant-reservation-app/lib/
├── pages/
│   ├── login_screen.dart
│   └── register_screen.dart
├── controllers/
│   └── auth_controller.dart
├── services/
│   └── auth_service.dart
├── models/
│   └── user_model.dart
└── bindings/
    └── auth_binding.dart
```

## ✨ Features

- **Login Screen**: Beautiful gradient UI with email/password authentication
- **Register Screen**: User registration with name, email, and password
- **Auth Controller**: GetX-based state management with form validation
- **Auth Service**: Firebase Authentication integration
- **User Model**: Data model for user information
- **Password Visibility Toggle**: Show/hide password functionality
- **Loading States**: Visual feedback during authentication
- **Form Validation**: Email and password validation with error messages
- **Navigation**: Seamless routing between login/register screens

## 🚀 Quick Start

### 1. Install Dependencies

The required dependencies need to be added to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
```

Run: `flutter pub get`

### 2. Firebase Setup

1. Create a Firebase project at https://console.firebase.com
2. Add your app (Android/iOS/Web)
3. Download and add configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
4. Enable Email/Password authentication in Firebase Console

### 3. Initialize Firebase

In your `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Run: flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

### 4. Configure Routes

Your app must have a `/home` route as the authentication redirects there after successful login/register:

```dart
GetPage(
  name: '/home',
  page: () => HomeScreen(), // Your home screen
),
```

### 5. Apply Theme (Optional)

The screens are designed with a dark gradient theme. You can customize colors in your theme configuration.

## 📋 Important Notes

### Required Routes

Your app must have these routes configured:
- `/login` - Login screen
- `/register` - Register screen
- `/home` - Home screen (redirect after successful auth)

### Optional: Custom Font

The login/register screens use the 'Caveat' font for headings. Either:
1. Add the font to your assets, or
2. Remove the `fontFamily: 'Caveat'` line from both screens

## 🎨 Customization

### Change App Name
In both `login_screen.dart` and `register_screen.dart`, update:
```dart
Text('Welcome to Restaurant Reservations', ...) // Change to your app name
```

### Modify Validation Rules
Edit `auth_controller.dart`:
- Email validation: Lines 24-32
- Password validation: Lines 33-36
- Registration validation: Lines 53-64

### Update Success Navigation
Change the route after successful auth in `auth_controller.dart`:
```dart
Get.offAllNamed('/home') // Change to your desired route
```

## 🔧 API Reference

### AuthController

**Properties:**
- `nameController` - TextEditingController for name input
- `emailController` - TextEditingController for email input
- `passwordController` - TextEditingController for password input
- `isPasswordVisible` - RxBool for password visibility toggle
- `isSubmitting` - RxBool for loading state

**Methods:**
- `togglePasswordVisibility()` - Toggle password visibility
- `submit()` - Handle login
- `register()` - Handle registration

### AuthService

**Methods:**
- `signUp(name, email, password)` - Create new user, returns UserModel?
- `signIn(email, password)` - Sign in user, returns bool
- `signOut()` - Sign out current user, returns bool
- `isLoggedIn()` - Check if user is logged in, returns bool
- `resetPassword(email)` - Send password reset email, returns bool

### UserModel

**Properties:**
- `uid` (required) - User ID from Firebase
- `fullName` - User's full name
- `email` - User's email
- `password` - User's password (Note: Consider not storing this)
- `currentLat` - Current latitude
- `currentLng` - Current longitude
- `favoritePlaces` - List of favorite place IDs
- `visitedPlaces` - List of visited place IDs

## 🛡️ Security Considerations

1. **Password Storage**: The current UserModel stores passwords. Consider removing this for security.
2. **Password in Print Statements**: The AuthService prints errors. Be careful in production.
3. **Validation**: Add more robust password validation (uppercase, numbers, special chars).
4. **Rate Limiting**: Implement rate limiting for login attempts.

## 🐛 Troubleshooting

### Firebase Not Initialized
- Ensure `Firebase.initializeApp()` is called before `runApp()`
- Run `flutterfire configure` to generate Firebase options

### Import Errors
- Ensure all dependencies are installed with `flutter pub get`

### Navigation Errors
- Verify all routes are properly configured
- Check that GetX is initialized with `GetMaterialApp`

### Theme Issues
- Ensure your theme has all required properties
- Or remove theme-dependent customizations from screens

## 📞 Need Help?

If you encounter issues:
1. Check that all files are in the correct directories
2. Verify all import paths are correct
3. Ensure Firebase is properly configured
4. Check that all dependencies are installed
5. Verify routes are configured correctly

## 📄 License

This module is extracted from the Tour Guide project. Modify and use as needed for your project.

---

**Happy Coding! 🚀**

