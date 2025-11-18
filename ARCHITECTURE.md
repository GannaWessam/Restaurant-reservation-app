# Architecture Documentation

## 🏗️ Design Pattern: MVVM + Service Locator

This project follows **MVVM (Model-View-ViewModel)** pattern with **GetX** for state management and **Service Locator** pattern for dependency injection.

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point, theme configuration, routes
├── models/                      # MODEL layer
│   └── user_model.dart         # User data model
├── pages/                       # VIEW layer
│   ├── login_screen.dart       # Login UI
│   └── register_screen.dart    # Register UI
├── controllers/                 # VIEWMODEL layer
│   └── auth_controller.dart    # Authentication business logic
├── services/                    # SERVICE layer
│   └── auth_service.dart       # Firebase authentication service
└── bindings/                    # SERVICE LOCATOR
    └── auth_binding.dart       # Dependency injection setup
```

## 🎨 Color Palette (Beautiful Palette 2)

```dart
Primary Colors:
- #EDE0D4 - Lightest beige (Background)
- #E6CCB2 - Light tan (Surface)
- #DDB892 - Tan (Borders)
- #B08968 - Medium brown (Primary)
- #7F5539 - Dark brown (Secondary, Buttons)
- #9C6644 - Brown (Tertiary, Text)
```

## 🔄 MVVM Pattern Implementation

### Model (Data Layer)
**Location:** `models/user_model.dart`

- Represents data structure
- Pure Dart classes
- Contains `toJson()` and `fromJson()` methods for serialization

```dart
UserModel
├── Properties: uid, fullName, email, etc.
├── toJson() - Convert to Map
└── fromJson() - Create from Map
```

### View (Presentation Layer)
**Location:** `pages/`

- UI components (LoginScreen, RegisterScreen)
- Uses `GetView<Controller>` for automatic controller access
- Observes state changes with `Obx()`
- No business logic - only UI rendering

```dart
LoginScreen extends GetView<AuthController>
├── Uses Theme.of(context) for styling
├── Observes controller.isSubmitting with Obx()
└── Calls controller methods on user actions
```

### ViewModel (Business Logic Layer)
**Location:** `controllers/auth_controller.dart`

- Extends `GetxController`
- Handles business logic and validation
- Manages reactive state with `.obs` variables
- Communicates with services
- No direct UI manipulation

```dart
AuthController extends GetxController
├── State: isPasswordVisible, isSubmitting
├── Methods: submit(), register(), togglePasswordVisibility()
├── Validation logic
└── Uses AuthService for API calls
```

## 🔧 Service Locator Pattern

**Location:** `bindings/auth_binding.dart`

GetX Bindings act as a Service Locator, managing dependency injection:

```dart
AuthBinding extends Bindings
├── Register AuthService (singleton)
└── Register AuthController
```

### How it works:

1. **Registration** (in Binding):
   ```dart
   Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
   Get.lazyPut<AuthController>(() => AuthController());
   ```

2. **Retrieval** (in Controller):
   ```dart
   final AuthService _authService = Get.find<AuthService>();
   ```

3. **Automatic** (in View):
   ```dart
   class LoginScreen extends GetView<AuthController>
   // 'controller' is automatically available
   ```

## 🚀 Data Flow

```
User Action (View)
    ↓
Controller Method (ViewModel)
    ↓
Validation & State Update
    ↓
Service Call (Service Layer)
    ↓
Firebase API
    ↓
Response back to Controller
    ↓
Update Reactive State
    ↓
View Auto-Updates (Obx)
```

### Example: Login Flow

1. **User enters credentials and taps "Sign In"**
   ```dart
   // View (login_screen.dart)
   ElevatedButton(onPressed: controller.submit)
   ```

2. **Controller validates and calls service**
   ```dart
   // ViewModel (auth_controller.dart)
   Future<void> submit() async {
     // Validation
     isSubmitting.value = true;
     final signedIn = await _authService.signIn(email, password);
     isSubmitting.value = false;
     // Navigation
   }
   ```

3. **Service communicates with Firebase**
   ```dart
   // Service (auth_service.dart)
   Future<bool> signIn(String email, String password) async {
     await _auth.signInWithEmailAndPassword(...);
   }
   ```

4. **View reacts to state changes**
   ```dart
   // View (login_screen.dart)
   Obx(() => controller.isSubmitting.value 
     ? CircularProgressIndicator() 
     : Text('Sign In')
   )
   ```

## 🎯 Key Principles

### 1. Separation of Concerns
- **Models**: Data only
- **Views**: UI only
- **ViewModels**: Business logic only
- **Services**: API/Backend communication only

### 2. Single Responsibility
Each class has one clear purpose:
- `UserModel`: Represent user data
- `LoginScreen`: Display login UI
- `AuthController`: Handle auth logic
- `AuthService`: Manage Firebase calls

### 3. Dependency Injection
- Services are injected via GetX bindings
- Controllers don't create service instances
- Easy to test and mock

### 4. Reactive State Management
- State changes automatically update UI
- Use `.obs` for reactive variables
- Use `Obx()` in views to observe changes

## 🧪 Benefits of This Architecture

1. **Testable**: Easy to unit test ViewModels and Services
2. **Maintainable**: Clear structure, easy to find and fix issues
3. **Scalable**: Easy to add new features following the same pattern
4. **Reusable**: Services and ViewModels can be reused
5. **Simple**: GetX reduces boilerplate significantly

## 📝 Adding New Features

To add a new feature (e.g., Restaurant Listing):

1. **Create Model** (`models/restaurant_model.dart`)
   ```dart
   class RestaurantModel { }
   ```

2. **Create Service** (`services/restaurant_service.dart`)
   ```dart
   class RestaurantService { }
   ```

3. **Create Controller** (`controllers/restaurant_controller.dart`)
   ```dart
   class RestaurantController extends GetxController { }
   ```

4. **Create View** (`pages/restaurant_list_screen.dart`)
   ```dart
   class RestaurantListScreen extends GetView<RestaurantController> { }
   ```

5. **Create Binding** (`bindings/restaurant_binding.dart`)
   ```dart
   class RestaurantBinding extends Bindings { }
   ```

6. **Add Route** (in `main.dart`)
   ```dart
   GetPage(name: '/restaurants', page: () => RestaurantListScreen(), binding: RestaurantBinding())
   ```

## 🔗 References

- [GetX Documentation](https://pub.dev/packages/get)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Service Locator Pattern](https://en.wikipedia.org/wiki/Service_locator_pattern)
- [Firebase Auth](https://firebase.google.com/docs/auth)

---

**Keep it simple, keep it clean! 🚀**

