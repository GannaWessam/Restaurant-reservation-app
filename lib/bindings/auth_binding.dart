import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';

/// Service Locator using GetX Bindings
/// This implements the MVVM pattern:
/// - Model: UserModel
/// - View: LoginScreen, RegisterScreen
/// - ViewModel: AuthController
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthService as a singleton (Service Locator pattern)
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    
    // Register AuthController (ViewModel)
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
