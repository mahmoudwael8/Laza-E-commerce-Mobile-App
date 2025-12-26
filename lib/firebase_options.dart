
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBSwwXcAsazIKHUlOFeE9lS23HnfK1AkYw",
      authDomain: "laza-ecommerce-581f1.firebaseapp.com",
      projectId: "laza-ecommerce-581f1",
      storageBucket: "laza-ecommerce-581f1.firebasestorage.app",
      messagingSenderId: "267063126358",
      appId: "1:267063126358:web:68a6507e10cf9e403c0ef7",
    );
  }
}
