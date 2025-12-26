import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // سحب المستخدم الحالي مباشرة من Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    // اللون الموف الموحد (Laza Purple)
    const primaryPurple = Color(0xFF9775FA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile Info", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold) // جعل الكلمة بيضاء
        ),
        centerTitle: true,
        backgroundColor: primaryPurple, // جعل البار موف
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // جعل سهم الرجوع أبيض
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: primaryPurple, // جعل الأفاتار موف
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // عرض الاسم (يجلب الاسم المسجل في الـ Auth)
            _buildInfoTile("User Name",  user?.email ?? "Not Set"),

            const SizedBox(height: 10),

            // عرض الإيميل مباشرة
            _buildInfoTile("Email", user?.email ?? "No Email"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple, // جعل الزرار موف
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Logout", 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold) // كتابة بيضاء
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D1E20))),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF8F9098))),
      tileColor: const Color(0xFFF5F6FA), // رمادي فاتح متناسق مع باقي التطبيق
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}