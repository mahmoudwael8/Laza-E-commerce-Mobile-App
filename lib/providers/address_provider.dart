import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> saveAddress({
    required String name,
    required String country,
    required String city,
    required String phone,
    required String address,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('addresses').add({
        'name': name,
        'country': country,
        'city': city,
        'phone': phone,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
