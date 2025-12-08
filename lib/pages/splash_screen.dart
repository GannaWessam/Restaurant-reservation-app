import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Navigate to home (categories) after 5 seconds
  Future<void> _navigateToLogin() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await Future.delayed(const Duration(seconds: 4));
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB892), // Tan color from palette
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            
            // Restaurant Icon - Custom Design
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Circle
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9C6644),
                      width: 2.5,
                    ),
                  ),
                ),
                // Inner Circle
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9C6644),
                      width: 1.5,
                    ),
                  ),
                ),
                // Decorative dots
                Positioned(
                  top: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF9C6644),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 15,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF9C6644),
                    ),
                  ),
                ),
                // Restaurant Utensils Icon
                Icon(
                  Icons.restaurant_menu,
                  size: 70,
                  color: const Color(0xFF7F5539),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // App Name - Arabic Style Font
            Text(
              'Fatoorna',
              style: GoogleFonts.cairo(
                fontSize: 52,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5C3D2E),
                letterSpacing: 2,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tagline
            Text(
              'Your Table Awaits, Your Day Begins.',
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: const Color(0xFF7F5539),
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const Spacer(flex: 2),
            
            // Loading Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: const Color(0xFFEDE0D4),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF9C6644),
                      ),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '9C6644',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF9C6644),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

