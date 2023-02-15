import 'package:flutter/material.dart';
import 'package:shop/models/models.dart';

class OrderItemModel with ChangeNotifier {
  OrderItemModel(
      {required this.id,
      required this.totalAmount,
      required this.products,
      required this.orderedAt});
  final String id;
  final double totalAmount;

  final List<CartItemModel> products;
  final DateTime orderedAt;
}
