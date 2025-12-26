import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites.dart'; // تأكد من المسار الصحيح
import 'product_detail.dart'; // استيراد صفحة التفاصيل للانتقال إليها عند الضغط

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب البيانات من Provider
    final favoriteProvider = Provider.of<FavoritesProvider>(context);
    final favoriteItems = favoriteProvider.items.values.toList();

    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء مثل الرئيسية
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(color: Color(0xFF1D1E20), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1D1E20), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                "Your favorites list is empty!",
                style: TextStyle(color: Color(0xFF8F9098), fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: favoriteItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // منتجين في الصف
                mainAxisSpacing: 8, // مسافة رأسية ضئيلة جداً كما طلبت
                crossAxisSpacing: 12, // مسافة أفقية
                childAspectRatio: 0.82, // نفس النسبة المستخدمة في الصفحة الرئيسية
              ),
              itemBuilder: (context, index) {
                final product = favoriteItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    // القالب الرمادي الموحد (نفس تصميم الرئيسية)
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // منطقة الصورة
                        Expanded(
                          child: Stack(
                            children: [
                              Center(
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain, // الصورة كاملة داخل القالب
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                              // زر حذف سريع من المفضلة (اختياري، يمكنك حذفه إذا أردت تطابقاً كلياً)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => favoriteProvider.toggleFavorite(product),
                                  child: const Icon(Icons.close, size: 18, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // اسم المنتج
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF1D1E20),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // السعر
                        Text(
                          "\$${product.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1D1E20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}