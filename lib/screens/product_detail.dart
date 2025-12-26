import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../providers/favorites.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows image to go behind the back button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        // هنا بنغير الأيقونة بناءً على هل المنتج في المفضلة ولا لأ
        icon: Icon(
          Provider.of<FavoritesProvider>(context).isFavorite(product.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: Provider.of<FavoritesProvider>(context).isFavorite(product.id)
              ? Colors.red
              : Colors.black,
        ),
        onPressed: () {
          // 1. استدعاء وظيفة الإضافة أو الحذف من الـ Provider
          Provider.of<FavoritesProvider>(context, listen: false)
              .toggleFavorite(product);

          // 2. إظهار رسالة تأكيد للمستخدم
          final isNowFav = Provider.of<FavoritesProvider>(context, listen: false)
              .isFavorite(product.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isNowFav 
                    ? "Added ${product.title} to Favorites!" 
                    : "Removed ${product.title} from Favorites!",
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: isNowFav ? Colors.redAccent : Colors.grey,
            ),
          );
        },
      ),
    ),
  ),
],
      ),
      body: Column(
        children: [
          // 1. Large Product Image
          Expanded(
            flex: 5, // Takes up top 50% of screen
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // 2. Product Info & Actions
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Men's Style", // Static category for MVP
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1F22),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1F22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        product.description,
                        style: TextStyle(color: Colors.grey[600], height: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    // "Add to Cart" Button
                    onPressed: () {
                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added ${product.title} to Cart!"),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                    child: const Text("Add to Cart"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
