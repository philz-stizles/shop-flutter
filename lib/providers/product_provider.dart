import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';
import 'package:shop/models/models.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final _baseUrl = dotenv.get('FIREBASE_BASE_URL');
  String? _authToken;
  String? _userId;
  // var _showOnlyFavorites = false;

  void update({String? authToken, String? userId}) {
    _authToken = authToken;
    _userId = userId;
  }

  List<ProductModel> _products = [];

  // List<ProductModel> _products = productTable;

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

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    try {
      // Retrieve products.
      var productsUri = '$_baseUrl/products.json?auth=$_authToken';
      if (filterByUser) {
        productsUri += '&orderBy="createdBy"&equalTo="$_userId"';
      }
      final response = await http.get(Uri.parse(productsUri));
      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      // Retrieve favorite products.
      final favsUri = '$_baseUrl/favorites/$_userId.json?auth=$_authToken';
      final favsResponse = await http.get(Uri.parse(favsUri));
      final favsResponseBody = json.decode(favsResponse.body);

      _products = responseBody.keys.map((key) {
        var value = responseBody[key];
        value['isFavorite'] =
            favsResponseBody == null ? false : favsResponseBody[key] ?? false;
        return ProductModel.fromMap(key, value);
      }).toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }
  }

  String? createProduct(ProductModel product) {
    var uuid = const Uuid();
    product.id = uuid.v1();
    _products.add(product);
    notifyListeners();
    return product.id;
  }

  Future<void> createProductAsync(ProductModel product) async {
    try {
      // Save product to remote server.
      final uri = '$_baseUrl/products.json?auth=$_authToken';
      final response = await http.post(Uri.parse(uri),
          body: product.toJson(userId: _userId));
      final responseBody = json.decode(response.body);

      // Add product to local list.
      product.id = responseBody['name'];
      _products.add(product);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void deleteProduct(String? id) {
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> deleteProductAsync(String id) async {
    try {
      // Optimistic updating.
      // Delete product locally.
      final productIndex = _products.indexWhere((element) => element.id == id);
      var existingProduct = _products[productIndex];
      _products.removeAt(productIndex);
      notifyListeners();

      // Delete product from server
      final uri = '$_baseUrl/products/$id.json?auth=$_authToken';
      final response = await http.delete(Uri.parse(uri));
      if (response.statusCode >= 400) {
        _products.insert(productIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateProduct(String id, ProductModel updatedProduct) {
    final productIndex = _products.indexWhere((element) => element.id == id);
    _products[productIndex] = updatedProduct;
    notifyListeners();
  }

  Future<void> updateProductAsync(String id, ProductModel updated) async {
    try {
      final productIndex = _products.indexWhere((element) => element.id == id);
      if (productIndex >= 0) {
        // Update product on Server.
        final uri = '$_baseUrl/products/$id.json?auth=$_authToken';

        await http.patch(Uri.parse(uri), body: updated.toJson());

        // Update product locally
        _products[productIndex] = updated;
        notifyListeners();
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  ProductModel findById(String id) =>
      _products.firstWhere((element) => element.id == id);
}
