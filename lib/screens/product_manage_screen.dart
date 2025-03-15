import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/screens/product_edit_screen.dart';
import 'package:shop/widgets/widgets.dart';

class ProductManageScreen extends StatelessWidget {
  const ProductManageScreen({super.key});
  static const String routeName = '/product-manage';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.waiting)
                  ? Stack(children: [
                      BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: const Opacity(
                            opacity: 0.8,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.black54),
                          )),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ])
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                        final products = productProvider.products;
                        return Padding(
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
                        );
                      }))),
      drawer: const AppDrawer(),
    );
  }
}

// class ProductManageScreen extends StatelessWidget {
//   const ProductManageScreen({super.key});
//   static const String routeName = '/product-manage';

//   Future<void> _onRefresh(BuildContext context) async {
//     await Provider.of<ProductProvider>(context, listen: false)
//         .fetchAndSetProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final products = Provider.of<ProductProvider>(context).products;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Products'),
//         actions: [
//           IconButton(
//               onPressed: () =>
//                   Navigator.of(context).pushNamed(ProductEditScreen.routeName),
//               icon: const Icon(Icons.add))
//         ],
//       ),
//       body: RefreshIndicator(
//           onRefresh: () => _onRefresh(context),
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 var product = products[index];
//                 return Column(
//                   children: [
//                     ProductItemCard(
//                         id: product.id!,
//                         title: product.title,
//                         imageUrl: product.imageUrl!),
//                     const Divider()
//                   ],
//                 );
//               },
//             ),
//           )),
//       drawer: const AppDrawer(),
//     );
//   }
// }
