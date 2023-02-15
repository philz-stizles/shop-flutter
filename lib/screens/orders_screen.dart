import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/widgets/widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        body: ListView.builder(
          itemCount: orderProvider.orders.length,
          itemBuilder: (context, index) {
            var item = orderProvider.orders[index];
            return OrderItemCard(orderItem: item);
          },
        ),
        drawer: const AppDrawer());
  }
}
