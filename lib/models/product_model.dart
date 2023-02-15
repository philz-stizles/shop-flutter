import 'package:flutter/material.dart';

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

  ProductModel.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['description'];
    price = map['price'];
    imageUrl = map['imageUrl'];
    isFavorite = map['isFavorite'];
  }

  Map<String, dynamic> toJson() {
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
}
