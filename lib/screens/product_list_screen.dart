import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  final List<Product> cartProducts = [];
  bool isLoading = true;
  String? errorMessage;

  String searchText = '';

  List<Product> get filteredProducts {
    final query = searchText.toLowerCase();

    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.tagline.toLowerCase().contains(query);
    }).toList();
  }

  void addToCart(Product product) {
    final bool alreadyAdded = cartProducts.any((item) => item.id == product.id);

    if (!alreadyAdded) {
      setState(() {
        cartProducts.add(product);
      });
    }
  }

  void removeFromCart(Product product) {
    setState(() {
      cartProducts.removeWhere((item) => item.id == product.id);
    });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final loadedProducts = await ProductData.loadProducts();

      if (!mounted) return;

      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Ürünler yüklenemedi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: [
          Center(child: Text('${cartProducts.length}')),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CartScreen(
                      cartProducts: cartProducts,
                      onRemove: removeFromCart,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : products.isEmpty
          ? const Center(child: Text('Ürün bulunamadı.'))
          : Column(
              children: [
                // banner paddingi
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/banner.png',
                      width: double.infinity,

                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                //arama kutusu paddingi
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Ürün ara...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text('Aramaya uygun ürün bulunamadı.'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.65,
                              ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailScreen(
                                        product: product,
                                        onAddToCart: () {
                                          addToCart(product);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
