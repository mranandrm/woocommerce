import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/services/woocommerce_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WooCommerceService _service = WooCommerceService();
  Map<String, dynamic>? product;
  bool loading = true;
  String? error;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    try {
      final response = await _service.getProductById(widget.productId.toString());
      setState(() {
        product = response;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String fixImageUrl(String url) {
    return url.replaceFirst("https://localhost", "http://192.168.1.98");
  }

  double calculateTotalPrice() {
    double price = double.tryParse(product?["price"] ?? "0") ?? 0;
    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product?["name"] ?? "Product Detail"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Error: $error"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product?["images"] != null && product!["images"].isNotEmpty)
              Image.network(
                fixImageUrl(product!["images"][0]["src"]),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              product?["name"] ?? "",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₹${product?["price"] ?? "0"}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product?["description"] ?? "",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // 🔹 Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle, color: Colors.red, size: 32),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add_circle, color: Colors.green, size: 32),
                ),
              ],
            ),

            // 🔹 Total Price Preview
            const SizedBox(height: 12),
            Center(
              child: Text(
                "Total: ₹${calculateTotalPrice().toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString("token");

                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please login first")),
                      );
                      return;
                    }

                    final cartResponse = await _service.addToCart(
                      widget.productId,
                      quantity: quantity,
                      token: token,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Added to cart successfully")),
                    );

                    print("Cart response: $cartResponse");
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
