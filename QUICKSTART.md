# 🚀 Quick Start Guide

## Prerequisites
- Flutter SDK (3.0.0+)
- Firebase account
- Firebase CLI and FlutterFire CLI

## Setup Instructions

### 1. Install Dependencies
```bash
cd Restaurant-reservation-app
flutter pub get
```

### 2. Setup Firebase

#### Install Firebase CLI (if not already installed)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login
```

#### Configure Firebase
```bash
# Run this in your project directory
flutterfire configure
```

This will:
- Create or select a Firebase project
- Generate `lib/firebase_options.dart` with your config
- Set up Android, iOS, and Web platforms

#### Enable Email/Password Authentication
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Authentication** → **Sign-in method**
4. Enable **Email/Password**
5. Save

### 3. Run the App

```bash
# Run on connected device or emulator
flutter run

# For specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS (Mac only)
```

## 📱 Testing the App

1. **Register a new account:**
   - Tap "Sign up"
   - Enter name, email, password
   - Tap "Sign Up"
   - You'll be redirected to home screen

2. **Login:**
   - Tap logout (if logged in)
   - Enter email and password
   - Tap "Sign In"

3. **Test validation:**
   - Try empty fields
   - Try invalid email
   - Try short password

## 🏗️ Architecture Overview

This app uses **GetX + MVVM + Service Locator** pattern:

```
Model (Data)
  ↓
Service (API)
  ↓
ViewModel/Controller (Logic)
  ↓
View (UI)
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed explanation.

## 🎨 Theme

The app uses **Beautiful Palette 2** with warm, earthy tones:
- Primary: Medium Brown (#B08968)
- Secondary: Dark Brown (#7F5539)
- Background: Light Beige (#EDE0D4)

All colors are centralized in `main.dart` theme configuration.

## 📁 Project Structure

```
lib/
├── main.dart              # Entry point, theme, routes
├── firebase_options.dart  # Firebase config (auto-generated)
├── models/               # Data models
├── pages/                # UI screens
├── controllers/          # Business logic
├── services/            # API services
└── bindings/            # Dependency injection
```

## 🔧 Common Issues

### Firebase not initialized
**Solution:** Run `flutterfire configure` and restart the app

### Import errors
**Solution:** Run `flutter pub get` and restart IDE

### Build errors on Android
**Solution:** 
- Ensure `minSdkVersion` is at least 21 in `android/app/build.gradle`
- Run `flutter clean` then `flutter pub get`

### Pod install errors (iOS)
**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
```

## 📚 Next Steps

- Add more screens (Restaurant list, booking, profile)
- Implement Firestore for data storage
- Add image upload functionality
- Implement push notifications
- Add payment integration

## 🆘 Need Help?

- See [ARCHITECTURE.md](ARCHITECTURE.md) for architecture details
- See [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) for step-by-step setup
- See [DEPENDENCIES.md](DEPENDENCIES.md) for dependency info

---

**Happy Coding! 🎉**

