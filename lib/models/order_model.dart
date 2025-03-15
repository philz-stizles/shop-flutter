import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/models.dart';

class OrderItemModel with ChangeNotifier {
  OrderItemModel(
      {this.id,
      required this.totalAmount,
      required this.products,
      required this.orderedAt});
  String? id;
  late final double totalAmount;
  late final List<CartItemModel> products;
  late final DateTime orderedAt;

  OrderItemModel.fromMap(String orderId, Map<String, dynamic> map) {
    id = orderId;
    totalAmount = map['totalAmount'];
    products = (map['products'] as List<dynamic>)
        .map((product) => CartItemModel.fromMap(map: json.decode(product)))
        .toList();
    orderedAt = DateTime.parse(map['orderedAt']);
  }

  String toJson() {
    return json.encode({
      'totalAmount': totalAmount,
      'products': products.map((item) => item.toJson()).toList(),
      'orderedAt': orderedAt.toIso8601String(),
    });
  }
}
