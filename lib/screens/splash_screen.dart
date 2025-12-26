// lib/features/splash/presentation/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/onboarding_gender_screen.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;

  const SplashScreen({super.key, this.duration = const Duration(seconds: 2)});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingGenderScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const splashPurple = Color(0xFF9775FA);
    return const Scaffold(
      backgroundColor: splashPurple,
body: const SafeArea(
  child: Center(
    child: Text(
      'LAZA',
      style: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
    );
  }
}