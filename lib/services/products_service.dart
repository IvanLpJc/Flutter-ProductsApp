import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-varios-9a670-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final product = Product.fromMap(value);
      product.id = key;
      products.add(product);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future createOrUpdateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());

    print(resp.body);
    product.id = json.decode(resp.body)['name'];
    products.add(product);

    return product.id!;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());

    print(resp.body);

    products[products.indexWhere((element) => element.id == product.id)] =
        product;
    return product.id!;
  }
}
