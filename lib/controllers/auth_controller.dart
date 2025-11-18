import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

/// AuthController - ViewModel in MVVM pattern
/// Handles business logic and state management for authentication
class AuthController extends GetxController {
  // Text controllers for form inputs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reactive state variables
  final RxBool isPasswordVisible = false.obs;
  final RxBool isSubmitting = false.obs;
  
  // Service Locator - Get the AuthService instance
  final AuthService _authService = Get.find<AuthService>();


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> submit() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (email.isEmpty) {
      Get.snackbar('Missing email', 'Please enter your email', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar('Invalid email', 'Enter a valid email address', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (password.isEmpty || password.length < 6) {
      Get.snackbar('Invalid password', 'Password must be at least 6 characters', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    
    final signedIn = await _authService.signIn(email, password);
    
    isSubmitting.value = false;

    if (signedIn) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Error signing in',
        'Please check your email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty) {
      Get.snackbar('Missing name', 'Please enter your full name', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar('Invalid email', 'Please enter a valid email', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Weak password', 'Password must be at least 8 characters', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    
    final success = await _authService.signUp(name, email, password);
    
    isSubmitting.value = false;

    if (success != null) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Registration failed',
        'Something went wrong. Please try again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

