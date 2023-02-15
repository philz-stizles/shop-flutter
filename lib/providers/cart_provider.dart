import 'package:flutter/material.dart';
import 'package:shop/models/models.dart';

class CartProvider with ChangeNotifier {
  final String? authToken;
  final Map<String, CartItemModel> _cart = {};

  CartProvider({this.authToken});

  Map<String, CartItemModel> get cart => {..._cart};

  int get cartProductCount => _cart.length;

  double get cartTotalAmount {
    var totalAmount = 0.0;
    _cart.forEach((key, value) {
      totalAmount += (value.quantity * value.price);
    });

    return totalAmount;
  }

  void add(
      {required String productId,
      required String title,
      required double price}) {
    if (_cart.containsKey(productId)) {
      _cart.update(
          productId,
          (existing) => CartItemModel(
              id: existing.id,
              title: existing.title,
              price: existing.price,
              quantity: existing.quantity + 1));
    } else {
      _cart.putIfAbsent(
          productId,
          () => CartItemModel(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }

    notifyListeners();
  }

  void removeById(String cartId) {
    _cart.removeWhere((id, element) => element.id == cartId);
    notifyListeners();
  }

  void removeByProductId(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cart.containsKey(productId)) {
      return;
    }

    if (_cart[productId]!.quantity > 1) {
      _cart.update(productId, (cartItemModel) {
        cartItemModel.quantity - 1;
        return cartItemModel;
      });
    } else {
      _cart.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _cart.clear();
    notifyListeners();
  }
}
