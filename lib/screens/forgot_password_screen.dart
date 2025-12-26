import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  
  // اللون الأزرق الغامق
  final Color primaryColor = const Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // زرار الرجوع الدائري الرمادي زي فيجما
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF5F6FA),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Forgot Password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            // 💡 استخدام الصورة التي أرسلتِها
            Image.asset(
              "assets/images/forgot_password.png", 
              height: 200, 
              fit: BoxFit.contain,
            ),
            
            const SizedBox(height: 50),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Email Address", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter your email address",
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE7E8EA))),
                  ),
                ),
              ],
            ),
            
            const Spacer(),

            const Text(
              "Please write your email to receive a confirmation link to set a new password.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // زرار التأكيد الأزرق الغامق
      bottomNavigationBar: InkWell(
        onTap: _isLoading ? null : _sendResetEmail,
        child: Container(
          height: 75,
          color: primaryColor,
          child: Center(
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Confirm Mail",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
          ),
        ),
      ),
    );
  }

  // 💡 وظيفة إرسال الإيميل الحقيقية
  Future<void> _sendResetEmail() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your email")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Official Reset Link Sent! Check your inbox."), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}