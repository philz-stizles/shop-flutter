import 'package:flutter/material.dart';
import 'package:shop/screens/screens.dart';
import 'package:shop/widgets/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  AuthScreen.routeName: (_) => const AuthScreen(),
  DashboardScreen.routeName: (_) => const DashboardScreen(),
  ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
  CartScreen.routeName: (_) => const CartScreen(),
  OrdersScreen.routeName: (_) => const OrdersScreen(),
  ProductManageScreen.routeName: (_) => const ProductManageScreen(),
  ProductEditScreen.routeName: (_) =>
      const LoadingOverlay(child: ProductEditScreen()),
};
