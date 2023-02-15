import 'package:flutter/material.dart';

class CartItemModel with ChangeNotifier {
  CartItemModel(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
  final String id;
  final String title;

  final double price;
  final int quantity;
}
