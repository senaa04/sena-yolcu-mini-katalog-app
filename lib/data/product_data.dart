import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductData {
  static Future<List<Product>> loadProducts() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/products.json',
    );

    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    final List<dynamic> productList = jsonData['data'] ?? [];

    return productList
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }
}