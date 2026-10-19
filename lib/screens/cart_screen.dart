import 'package:flutter/material.dart';

import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartProducts;
  final void Function(Product) onRemove;

  const CartScreen({
    super.key,
    required this.cartProducts,
    required this.onRemove,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeProduct(Product product) {
    widget.onRemove(product);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: widget.cartProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Sepetiniz boş', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Alışverişe devam ederek ürün ekleyebilirsiniz.'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = widget.cartProducts[index];

                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.tagline),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            removeProduct(product);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Checkout'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
