import 'package:flutter/material.dart';
import 'package:laza_ecommerce/services/auth_service.dart';
import '../services/api_services.dart';
import '../models/product_model.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'package:laza_ecommerce/screens/user_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;

  // ✅ Search
  final TextEditingController _searchCtrl = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  static const _primaryPurple = Color(0xFF9775FA);
  static const _textDark = Color(0xFF1D1E20);
  static const _textGrey = Color(0xFF8F9098);
  static const _cardBg = Color(0xFFF5F6FA);

  @override
  void initState() {
    super.initState();

    _productsFuture = ApiService.getProducts();

    // ✅ لما الداتا تيجي من API نخزنها للفلترة
    _productsFuture.then((list) {
      if (!mounted) return;
      setState(() {
        _allProducts = list;
        _filteredProducts = List.from(list);
      });
    });

    // ✅ Listener للبحث
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.trim().toLowerCase();

      setState(() {
        if (q.isEmpty) {
          _filteredProducts = List.from(_allProducts);
        } else {
          _filteredProducts = _allProducts
              .where((p) => p.title.toLowerCase().contains(q))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي (بدون منيو - محاذاة يمين)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _CircleIconButton(
                    icon: Icons.person_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CircleIconButton(
                    icon: Icons.favorite_border,
                    iconColor: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CircleIconButton(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CircleIconButton(
                    icon: Icons.logout,
                    iconColor: Colors.grey,
                    onTap: () async => await AuthService().signOut(),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                'Hello',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const Text(
                'Welcome to Laza.',
                style: TextStyle(fontSize: 13, color: _textGrey),
              ),

              const SizedBox(height: 15),

              // ✅ شريط البحث (controller)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, size: 18, color: _textGrey),
                          hintText: "Search...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: _textGrey, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.mic, color: Colors.white, size: 18),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _SectionHeader(title: 'New Arrival', onAction: () {}),
              const SizedBox(height: 10),

              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: _primaryPurple),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading products"));
                  }

                  // ✅ اعرض الفلتر بدل snapshot.data
                  final products = _filteredProducts;

                  if (products.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "No products found",
                          style: TextStyle(color: _textGrey),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      return _ProductCard(
                        product: products[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: products[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
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
  }
}

// -------------------- Widgets مساعدة --------------------

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = const Color(0xFF1D1E20),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(color: Color(0xFFF5F6FA), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAction;
  const _SectionHeader({required this.title, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D1E20)),
        ),
        GestureDetector(
          onTap: onAction,
          child: const Text(
            "View All",
            style: TextStyle(color: Color(0xFF8F9098), fontSize: 12),
          ),
        ),
      ],
    );
  }
}