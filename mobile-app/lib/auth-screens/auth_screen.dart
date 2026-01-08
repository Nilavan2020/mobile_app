import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_service.dart';
import 'create_account_screen.dart'; // Import the CreateAccountScreen
import 'login_screen.dart'; // Import the LoginScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background with decorative elements
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 350,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Background gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0xFFFFF4E6), // Light orange tint
                            Color(0xFFFFE5CC), // Medium orange tint
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Rectangles
                    Positioned(
                      bottom: 100,
                      left: 20,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFDD671F).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 150,
                      right: 30,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFB84A1A).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 120,
                      child: Transform.rotate(
                        angle: 0.15,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFFDD671F).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      right: 100,
                      child: Transform.rotate(
                        angle: -0.25,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFFB84A1A).withOpacity(0.35),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    // Bubbles/Circles
                    Positioned(
                      bottom: 80,
                      right: 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFDD671F).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 180,
                      left: 50,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xFFB84A1A).withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 250,
                      right: 150,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFDD671F).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      left: 200,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFB84A1A).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 300,
                      left: 150,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xFFDD671F).withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main content centered
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200.0), // Push content up from bottom
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/primary_logo.png',
                      height: 180,
                      width: 180,
                    ),
                    const SizedBox(height: 60),
                    // Login and Create Account Buttons
                    Consumer<LocaleService>(
                      builder: (context, localeService, child) {
                        final t = (String key) => LocaleService.translate(key, localeService.locale.languageCode);
                        
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Login Button
                            SizedBox(
                              width: 280,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Navigate to Login Screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  side: const BorderSide(color: Color(0xFFDD671F), width: 2),
                                ),
                                child: Text(
                                  t('login'),
                                  style: const TextStyle(
                                    color: Color(0xFFDD671F),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Create Account Button
                            SizedBox(
                              width: 280,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to CreateAccountScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CreateAccountScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: Color(0xFFDD671F),
                                  elevation: 2,
                                ),
                                child: Text(
                                  t('create_account'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
