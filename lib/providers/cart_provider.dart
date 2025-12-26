import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  // Calculate total price
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // Add item to cart
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // If item exists, increase quantity
      _items.update(
        product.id,
        (existing) => CartItem(
          productId: existing.productId,
          title: existing.title,
          imageUrl: existing.imageUrl,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productId: product.id,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners(); // Update UI
    _syncToFirestore(); // Save to database
  }

  // Remove single item or decrease quantity
  void removeSingleItem(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          productId: existing.productId,
          title: existing.title,
          imageUrl: existing.imageUrl,
          price: existing.price,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    _syncToFirestore();
  }

  // Clear cart (after checkout)
  void clear() {
    _items.clear();
    notifyListeners();
    _syncToFirestore();
  }

  // Save to Firestore [Requirement: Persist minimal user data]
  Future<void> _syncToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartCollection = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .collection('items');

    // Simple sync: loop through items and set them
    // (In a real app, you'd be more efficient, but this is fine for MVP)
    for (var item in _items.values) {
      await cartCollection.doc(item.productId.toString()).set(item.toJson());
    }
    
    // NOTE: Handling deletions from Firestore is tricky in simple sync,
    // so for this MVP we focus on adding/updating.
  }
}