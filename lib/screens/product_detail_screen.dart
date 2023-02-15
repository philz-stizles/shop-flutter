import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});
  static const String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context)!.settings.arguments as String;
    var product = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ));
  }
}
