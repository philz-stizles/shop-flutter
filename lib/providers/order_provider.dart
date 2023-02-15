import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop/models/models.dart';

class OrderProvider with ChangeNotifier {
  final _baseUrl = dotenv.get('FIREBASE_BASE_URL');
  final String? authToken;
  List<OrderItemModel> _orders = [];
  var isLoading = false;

  OrderProvider({this.authToken, orders}) {
    _orders = orders;
  }

  List<OrderItemModel> get orders => [..._orders];

  int get orderProductCount => _orders.length;

  Future<void> fetchOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      final uri = '$_baseUrl/orders.json?auth=$authToken';
      final response = await http.get(Uri.parse(uri));
      final responseBody = json.decode(response.body) as Map<String, dynamic>?;
      if (responseBody == null) {
        return;
      }

      // responseBody.forEach((key, value) {
      //   _orders.add(OrderItemModel(
      //       id: id,
      //       totalAmount: totalAmount,
      //       products: products,
      //       orderedAt: orderedAt));
      // });
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
      isLoading = true;
      notifyListeners();

      // Add order to server.
      final uri = '$_baseUrl/orders.json?auth=$authToken';
      final timestamp = DateTime.now();
      final response = await http.post(Uri.parse(uri),
          body: json.encode({
            'totalAmount': totalAmount,
            'products': cart,
            'orderedAt': timestamp.toIso8601String(),
          }));
      final responseBody = json.decode(response.body) as Map<String, dynamic>?;
      if (responseBody == null) {
        return;
      }

      // Add order to local list.
      // _orders.add(OrderItemModel(
      //     id: id,
      //     totalAmount: totalAmount,
      //     products: cart,
      //     orderedAt: timestamp));
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

  void removeById(String orderId) {
    _orders.removeWhere((element) => element.id == orderId);
    notifyListeners();
  }
}
