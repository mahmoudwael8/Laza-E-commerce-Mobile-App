// lib/features/onboarding/presentation/onboarding_gender_screen.dart
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../main.dart';


class OnboardingGenderScreen extends StatefulWidget {
  const OnboardingGenderScreen({super.key});

  @override
  State<OnboardingGenderScreen> createState() => _OnboardingGenderScreenState();
}

class _OnboardingGenderScreenState extends State<OnboardingGenderScreen> {
  String selectedGender = 'Women';

  void _goToLogin() {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const AuthWrapper()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD6C9FF), Color(0xFF9775FA)],
          ),
        ),
        child: Stack(
          children: [
            // Image
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Image.asset(
                  'assets/images/Screen1.png',
                  height: MediaQuery.of(context).size.height * 0.55,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom Card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Look Good, Feel Good',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your individual & unique style and look amazing everyday.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: _GenderButton(
                            title: 'Men',
                            isSelected: selectedGender == 'Men',
                            onTap: () {
                              setState(() => selectedGender = 'Men');
                              _goToLogin();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _GenderButton(
                            title: 'Women',
                            isSelected: selectedGender == 'Women',
                            onTap: () {
                              setState(() => selectedGender = 'Women');
                              _goToLogin();
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: _goToLogin,
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
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

class _GenderButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9775FA) : const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}