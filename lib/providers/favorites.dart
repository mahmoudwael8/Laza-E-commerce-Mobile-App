import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import 'package:laza_ecommerce/services/auth_service.dart';
import '../services/api_services.dart';
import '../models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  final Map<int, Product> _items = {};

  Map<int, Product> get items => _items;

  bool isFavorite(int id) {
    return _items.containsKey(id);
  }

  void toggleFavorite(Product product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items.putIfAbsent(product.id, () => product);
    }
    notifyListeners();
    _syncToFirestore();
  }

  // Sync with Firestore (Requirement: favorites/{userId}/items/{productId})
  Future<void> _syncToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favCollection = FirebaseFirestore.instance
        .collection('favorites')
        .doc(user.uid)
        .collection('items');

    // For this MVP, we re-save the list. 
    // In a production app, you would optimize to only add/remove the specific ID.
    // First, clear existing (simple approach)
    // Real-world: use batch writes or individual set/delete
    
    // We will just add the current one for now to ensure persistence
    for (var item in _items.values) {
      await favCollection.doc(item.id.toString()).set({
        'id': item.id,
        'title': item.title,
        'price': item.price,
        'imageUrl': item.imageUrl,
      });
    }
  }
}



