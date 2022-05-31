import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-varios-9a670-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  late Product selectedProduct;

  //Necesitamos utilizar el token del usuario para decirle a firebase
  //que tenemos permisos para cargar los productos
  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;
  bool isModified = false;

  File? newPictureFile;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'idToken') ?? '',
    });

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
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'idToken') ?? '',
    });
    final resp = await http.post(url, body: product.toJson());

    print(resp.body);
    product.id = json.decode(resp.body)['name'];
    products.add(product);

    return product.id!;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth': await storage.read(key: 'idToken') ?? '',
    });
    final resp = await http.put(url, body: product.toJson());

    print(resp.body);

    products[products.indexWhere((element) => element.id == product.id)] =
        product;
    return product.id!;
  }

  void updateSelectedProductImage(String? path) {
    //Con esto ya tengo el archivo
    newPictureFile = File.fromUri(Uri(path: path));
    selectedProduct.image = path;

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dzlellhaq/image/upload?upload_preset=atwdfnpe');

    //Creamos la petición
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    //Adjuntamos el archivo
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      return null;
    }

    newPictureFile = null;
    isSaving = false;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
