import 'dart:convert';

import 'package:flutter/material.dart';

class CartItemModel with ChangeNotifier {
  CartItemModel(
      {this.id,
      required this.title,
      required this.price,
      required this.quantity});
  String? id;
  late final String title;
  late final double price;
  late final int quantity;

  CartItemModel.fromMap({String? cartId, required Map<String, dynamic> map}) {
    id = cartId;
    title = map['title'];
    price = map['price'];
    quantity = map['quantity'];
  }

  String toJson() {
    return json.encode({
      'title': title,
      'price': price,
      'quantity': quantity,
    });
  }
}
