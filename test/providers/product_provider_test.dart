import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/product_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.development");

  group('Testing Product Provider', () {
    var productProvider = ProductProvider();

    test('A new product should be added', () {
      final newProduct = ProductModel(
        title: 'Test title',
        description: 'Test description',
        price: 20.99,
      );

      productProvider.createProduct(newProduct);
      expect(productProvider.products.contains(newProduct), true);
    });

    test('An existing product should be removed', () {
      final newProduct = ProductModel(
        title: 'Test title',
        description: 'Test description',
        price: 20.99,
      );

      final id = productProvider.createProduct(newProduct);
      expect(productProvider.products.contains(newProduct), true);
      productProvider.deleteProduct(id);
      expect(productProvider.products.contains(newProduct), false);
    });
  });
}
