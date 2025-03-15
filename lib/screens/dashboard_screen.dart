import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
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
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   // Method 1:
  //   // _isLoading = true;

  //   // Provider.of<ProductProvider>(context, listen: false)
  //   //     .fetchAndSetProducts()
  //   //     .then((_) {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });

  //   // Method 2:
  //   // Future.delayed(Duration.zero).then((_) async {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });

  //   //   await Provider.of<ProductProvider>(context, listen: false)
  //   //       .fetchAndSetProducts();

  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

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
        body: Stack(
          children: [
            ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
            if (_isLoading)
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: const Opacity(
                    opacity: 0.8,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black54),
                  )),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        drawer: const AppDrawer());
  }
}
