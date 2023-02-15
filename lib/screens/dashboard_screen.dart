import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/screens/screens.dart';
import 'package:shop/widgets/widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

enum FilterProducts { all, favorites }

class _DashboardScreenState extends State<DashboardScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // var productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Buy\'Mall'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterProducts value) {
                setState(() {
                  switch (value) {
                    case FilterProducts.all:
                      // productProvider.showAll();
                      _showOnlyFavorites = false;
                      break;
                    case FilterProducts.favorites:
                      // productProvider.showOnlyFavorites();
                      _showOnlyFavorites = true;
                      break;
                    default:
                  }
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: FilterProducts.all, child: Text('Show All')),
                const PopupMenuItem(
                    value: FilterProducts.favorites,
                    child: Text('Only Favorites'))
              ],
              icon: const Icon(Icons.more_vert),
            ),
            Consumer<CartProvider>(
                builder: (_, cartProvider, ch) => AppBadge(
                      value: cartProvider.cartProductCount.toString(),
                      child: ch!,
                    ),
                child: IconButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const CartScreen())),
                    icon: const Icon(Icons.shopping_cart)))
          ],
        ),
        body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
        drawer: const AppDrawer());
  }
}
