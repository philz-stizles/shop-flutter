import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/models.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final _baseUrl = dotenv.get('FIREBASE_BASE_URL');
  String? _authToken;
  var isLoading = false;
  // var _showOnlyFavorites = false;

  void update(String? authToken) {
    _authToken = authToken;
  }

  // final List<ProductModel> _products = [];
  List<ProductModel> _products = [
    ProductModel(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductModel(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductModel(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductModel(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<ProductModel> get products => [..._products];

  List<ProductModel> get favoriteProducts =>
      _products.where((element) => element.isFavorite).toList();

  // List<ProductModel> get products => _showOnlyFavorites
  //     ? _products.where((element) => element.isFavorite).toList()
  //     : [..._products];

  // void showAll() {
  //   _showOnlyFavorites = false;
  //   notifyListeners();
  // }

  // void showOnlyFavorites() {
  //   _showOnlyFavorites = true;
  //   notifyListeners();
  // }

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();

      final uri = '$_baseUrl/product.json?auth=$_authToken';
      final response = await http.get(Uri.parse(uri));
      final responseBody = json.decode(response.body);
      // _products = responseBody
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void createProduct(ProductModel product) {
    var uuid = const Uuid();
    product.id = uuid.v1();
    _products.add(product);
    notifyListeners();
  }

  Future<void> createProductAsync(ProductModel product) async {
    try {
      isLoading = true;
      notifyListeners();

      // Save product to remote server.
      final uri = '$_baseUrl/product.json?auth=$_authToken';
      final response = await http.post(Uri.parse(uri), body: product.toJson());
      final responseBody = json.decode(response.body);

      // Add product to local list.
      product.id = responseBody['name'];
      _products.add(product);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> deleteProductAsync(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      // Delete product from Server.
      final uri = '$_baseUrl/products/$id.json?auth=$_authToken';
      await http.delete(Uri.parse(uri));

      // Delete product locally.
      _products.removeWhere((element) => element.id == id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateProduct(String id, ProductModel updatedProduct) {
    final productIndex = _products.indexWhere((element) => element.id == id);
    _products.insert(productIndex, updatedProduct);
    notifyListeners();
  }

  Future<void> updateProductAsync(
      String id, ProductModel updatedProduct) async {
    try {
      isLoading = true;
      notifyListeners();

      // Update product on Server.
      final uri = '$_baseUrl/products/$id.json?auth=$_authToken';

      await http.patch(Uri.parse(uri), body: updatedProduct.toJson());

      // Update product locally
      final productIndex = _products.indexWhere((element) => element.id == id);
      _products.insert(productIndex, updatedProduct);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ProductModel findById(String id) =>
      _products.firstWhere((element) => element.id == id);
}
