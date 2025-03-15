import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop/models/models.dart';

class OrderProvider with ChangeNotifier {
  final _baseUrl = dotenv.get('FIREBASE_BASE_URL');
  String? _authToken;
  String? _userId;
  // final List<OrderItemModel> _orders = [];
  List<OrderItemModel> _orders = [];
  var isLoading = false;

  void update({String? authToken, String? userId}) {
    _authToken = authToken;
    _userId = userId;
  }

  List<OrderItemModel> get orders => [..._orders];

  int get orderProductCount => _orders.length;

  Future<void> fetchAndSetOrders() async {
    try {
      // final uri = '$_baseUrl/orders.json?auth=$_authToken';
      final uri = '$_baseUrl/orders/$_userId.json?auth=$_authToken';
      final response = await http.get(Uri.parse(uri));
      final responseBody = json.decode(response.body) as Map<String, dynamic>?;
      if (responseBody == null) {
        return;
      }

      _orders = responseBody.keys
          .map((key) => OrderItemModel.fromMap(key, responseBody[key]))
          .toList()
          .reversed
          .toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void addOrder(
      {required List<CartItemModel> cart, required double totalAmount}) {
    _orders.insert(
        0,
        OrderItemModel(
            id: DateTime.now().toString(),
            totalAmount: totalAmount,
            products: cart,
            orderedAt: DateTime.now()));
    notifyListeners();
  }

  Future<void> addOrderAsync(
      {required List<CartItemModel> cart, required double totalAmount}) async {
    try {
      // Add order to server.
      final newOrder = OrderItemModel(
          totalAmount: totalAmount, products: cart, orderedAt: DateTime.now());
      // final uri = '$_baseUrl/orders.json?auth=$_authToken';
      final uri = '$_baseUrl/orders/$_userId.json?auth=$_authToken';
      final response = await http.post(Uri.parse(uri), body: newOrder.toJson());
      final responseBody = json.decode(response.body) as Map<String, dynamic>?;
      if (responseBody == null) {
        return;
      }

      // Add order to local list.
      newOrder.id = responseBody['name'];
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void removeById(String orderId) {
    _orders.removeWhere((element) => element.id == orderId);
    notifyListeners();
  }
}
