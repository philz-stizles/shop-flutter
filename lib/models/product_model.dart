import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  ProductModel(
      {this.id,
      required this.title,
      required this.description,
      this.imageUrl,
      required this.price,
      this.isFavorite = false});
  String? id;
  late final String title;
  late final String description;
  String? imageUrl;
  late final double price;
  late bool isFavorite;
  final _baseUrl = dotenv.get('FIREBASE_BASE_URL');

  ProductModel.fromMap(String productId, Map<String, dynamic> map) {
    id = productId;
    title = map['title'];
    description = map['description'];
    price = map['price'];
    imageUrl = map['imageUrl'];
    isFavorite = map['isFavorite'];
  }

  String toJson({String? userId}) {
    return json.encode({
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdBy': userId
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  void toggleIsFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void _setFavorite(bool previousValue) {
    isFavorite = previousValue;
    notifyListeners();
  }

  Future<void> toggleIsFavoriteAsync(String authToken,
      {required String userId}) async {
    final prevFavoriteStatus = isFavorite;
    try {
      isFavorite = !isFavorite;
      notifyListeners();

      // Save product to remote server.
      final uri = '$_baseUrl/favorites/$userId/$id.json?auth=$authToken';
      final response =
          await http.put(Uri.parse(uri), body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavorite(prevFavoriteStatus);
      }
    } catch (e) {
      _setFavorite(prevFavoriteStatus);
      rethrow;
    }
  }

  @override
  String toString() {
    return '''{
      id: $id, 
      title: $title, 
      description: $description, 
      price: $price, 
      imageUrl: $imageUrl
      }''';
  }
}
