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
                    OrderButton(cartProvider: cartProvider)
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
                    id: value.id!,
                    title: value.title,
                    price: value.price,
                    quantity: value.quantity);
              },
            ))
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cartProvider,
  });

  final CartProvider cartProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return TextButton(
        onPressed: widget.cartProvider.cartTotalAmount <= 0 || _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrderProvider>(context, listen: false)
                    .addOrderAsync(
                        cart: widget.cartProvider.cart.values.toList(),
                        totalAmount: widget.cartProvider.cartTotalAmount);
                setState(() {
                  _isLoading = false;
                });
                widget.cartProvider.clear();
                navigator.pushNamed(OrdersScreen.routeName);
              },
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('ORDER NOW'));
  }
}
