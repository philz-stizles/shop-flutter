import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/widgets/widgets.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key, required this.showOnlyFavorites});

  final bool showOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = showOnlyFavorites
        ? productProvider.favoriteProducts
        : productProvider.products;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemCount: products.length,
      itemBuilder: (context, index) {
        var item = products[index];
        return ChangeNotifierProvider.value(
          value: item,
          child: const ProductGridCard(),
        );
      },
    );
  }
}
