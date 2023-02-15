import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/screens/product_edit_screen.dart';
import 'package:shop/widgets/widgets.dart';

class ProductManageScreen extends StatefulWidget {
  const ProductManageScreen({super.key});
  static const String routeName = '/product-manage';

  @override
  State<ProductManageScreen> createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ProductEditScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return Column(
              children: [
                ProductItemCard(
                    id: product.id!,
                    title: product.title,
                    imageUrl: product.imageUrl!),
                const Divider()
              ],
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
