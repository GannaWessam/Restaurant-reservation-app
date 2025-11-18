# Required Dependencies

## Core Dependencies

Add these to your `pubspec.yaml` file under the `dependencies:` section:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  get: ^4.7.2
  
  # Firebase
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  
  # UI (if using Material Design)
  cupertino_icons: ^1.0.8
```

## Dev Dependencies

Add these under `dev_dependencies:` section:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## Installation Steps

1. **Add dependencies to pubspec.yaml**
2. **Run installation command:**
   ```bash
   flutter pub get
   ```

3. **Install Firebase CLI (if not already installed):**
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

4. **Configure Firebase for your project:**
   ```bash
   flutterfire configure
   ```
   This will:
   - Create a Firebase project (or select existing one)
   - Generate `firebase_options.dart` file
   - Configure platforms (Android, iOS, Web)

## Platform-Specific Setup

### Android

1. Add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Firebase requires minimum SDK 21
    }
}
```

2. Add to `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

3. Add to `android/app/build.gradle` (at the bottom):
```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS

1. Update `ios/Podfile` minimum deployment target:
```ruby
platform :ios, '12.0'
```

2. Run:
```bash
cd ios
pod install
cd ..
```

### Web

1. Add Firebase SDK to `web/index.html` (before closing `</body>` tag):
```html
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-auth-compat.js"></script>
```

## Version Compatibility

| Package | Minimum Version | Tested Version |
|---------|----------------|----------------|
| Flutter SDK | 3.0.0 | 3.8.1 |
| Dart SDK | 2.17.0 | 3.8.1 |
| get | 4.6.0 | 4.7.2 |
| firebase_core | 2.0.0 | 4.2.0 |
| firebase_auth | 4.0.0 | 6.1.1 |

## Dependency Details

### get (GetX)
- **Purpose**: State management, routing, dependency injection
- **Used for**: 
  - Controller management (AuthController)
  - Navigation (Get.toNamed, Get.offAllNamed)
  - Reactive state (Obx, RxBool)
  - Snackbar notifications
- **Documentation**: https://pub.dev/packages/get

### firebase_core
- **Purpose**: Firebase initialization and configuration
- **Used for**: 
  - Firebase.initializeApp()
  - Platform configuration
- **Documentation**: https://pub.dev/packages/firebase_core

### firebase_auth
- **Purpose**: Firebase Authentication
- **Used for**: 
  - User registration (createUserWithEmailAndPassword)
  - User login (signInWithEmailAndPassword)
  - User logout (signOut)
  - Password reset (sendPasswordResetEmail)
  - Current user management
- **Documentation**: https://pub.dev/packages/firebase_auth

## Verification

After installation, verify everything is set up correctly:

```bash
# Check dependencies
flutter pub get

# Verify Flutter setup
flutter doctor

# Check Firebase configuration
flutter pub run firebase_core:check
```

## Troubleshooting

### Issue: "Firebase not initialized"
**Solution**: Ensure Firebase.initializeApp() is called in main() before runApp()

### Issue: "Package not found"
**Solution**: Run `flutter pub get` and restart your IDE

### Issue: "Version conflict"
**Solution**: Run `flutter pub upgrade` to get compatible versions

### Issue: "Firebase CLI not found"
**Solution**: 
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

### Issue: "Build failed on Android"
**Solution**: Check minSdkVersion is at least 21

### Issue: "Pod install failed on iOS"
**Solution**: 
```bash
cd ios
pod deintegrate
pod install
cd ..
```

