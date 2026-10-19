import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.onAddToCart,
  });
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              product.tagline,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(product.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Text('Özellikler', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Column(
              children: product.specs.entries.map((spec) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(spec.key),
                  trailing: Text(spec.value.toString()),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isAddedToCart
                    ? null
                    : () {
                        widget.onAddToCart?.call();

                        setState(() {
                          isAddedToCart = true;
                        });
                      },
                icon: Icon(
                  isAddedToCart ? Icons.check : Icons.add_shopping_cart,
                ),
                label: Text(isAddedToCart ? 'Sepete Eklendi' : 'Sepete Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
