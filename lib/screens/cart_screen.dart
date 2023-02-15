import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Chip(
                      label: Text(
                          '\$${cartProvider.cartTotalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).primaryTextTheme.titleLarge),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Provider.of<OrderProvider>(context, listen: false)
                              .addOrder(
                                  cart: cartProvider.cart.values.toList(),
                                  totalAmount: cartProvider.cartTotalAmount);

                          cartProvider.clear();
                          Navigator.of(context)
                              .pushNamed(OrdersScreen.routeName);
                        },
                        child: const Text('ORDER NOW'))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                var value = cartProvider.cart.values.toList()[index];
                var key = cartProvider.cart.keys.toList()[index];
                return CartItemCard(
                    productId: key,
                    id: value.id,
                    title: value.title,
                    price: value.price,
                    quantity: value.quantity);
              },
            ))
          ],
        ));
  }
}
