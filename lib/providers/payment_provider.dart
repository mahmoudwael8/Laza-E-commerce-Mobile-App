import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Simulate or execute a payment process
  // providers/payment_provider.dart

Future<void> processPayment({
  required String cardNumber,
  required String expiryDate,
  required String cardHolderName,
  required String cvvCode,
  required double amount,
  required VoidCallback onSuccess,
}) async {
  _isLoading = true;
  notifyListeners();

  try {
    // Add a timeout to prevent infinite loading
    await FirebaseFirestore.instance.collection('payments').add({
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'amount': amount,
      'status': 'Success',
      'timestamp': FieldValue.serverTimestamp(),
    }).timeout(const Duration(seconds: 10));

    _isLoading = false;
    notifyListeners();
    
    // THIS MUST BE OUTSIDE THE TRY BLOCK OR AT THE VERY END
    onSuccess(); 
    
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    // This will tell you WHY it's just reloading instead of navigating
    Fluttertoast.showToast(
      msg: "Firebase Error: ${e.toString()}",
      toastLength: Toast.LENGTH_LONG,
    );
    print("PAYMENT ERROR: $e");
  }
}
}