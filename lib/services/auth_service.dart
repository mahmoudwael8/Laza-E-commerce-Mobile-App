import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up & Save to Firestore
  Future<void> signUp({required String email, required String password}) async {
    try {
      // 1. Create User in Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // 2. Save User Data to Firestore (Required by PDF)
      User? user = result.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(), // Server time
        });
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Login
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }


  // دالة لجلب بيانات المستخدم الحالي من Firestore
Future<DocumentSnapshot> getUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await FirebaseFirestore.instance
        .collection('users') // تأكد أن اسم الـ collection هو 'users'
        .doc(user.uid)
        .get();
  }
  throw Exception("No user logged in");
}
}

