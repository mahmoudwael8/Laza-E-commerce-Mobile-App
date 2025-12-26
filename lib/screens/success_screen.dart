import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
              child: Icon(Icons.check_circle, size: 100, color: Colors.green),
            ),
            SizedBox(height: 30),
            Text("Payment Successful!", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Your order is on the way", style: GoogleFonts.poppins(color: Colors.grey)),
            SizedBox(height: 40),
            TextButton(
              onPressed: () {
    // 1. Clear the cart first
    // Make sure 'CartProvider' is the correct name of your class
            Provider.of<CartProvider>(context, listen: false).clear();

    // 2. Navigate to Home
    // Use pushAndRemoveUntil so the user can't go "back" to the success screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false, // This removes all previous screens from the stack
    );
  },
              child: Text("Back to Home", style: GoogleFonts.poppins(color: Color(0xFF6C63FF))),
            )
          ],
        ),
      ),
    );
  }
}