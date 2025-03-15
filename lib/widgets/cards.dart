import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/models.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/screens/screens.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({super.key});

  // {super.key, required this.id, required this.title, this.imageUrl});

  // final String id;
  // final String title;
  // final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<ProductModel>(context);
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: GridTile(
        footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
                onPressed: () => product.toggleIsFavoriteAsync(
                    authProvider.token!,
                    userId: authProvider.userId!),
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              onPressed: () {
                cartProvider.add(
                    productId: product.id!,
                    title: product.title,
                    price: product.price);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Product added to cart!'),
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () =>
                          cartProvider.removeSingleItem(product.id!)),
                ));
              },
              icon: Icon(Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.secondary),
            )),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: SizedBox(
            width: double.infinity,
            child: Image.network(
              product.imageUrl!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard(
      {super.key,
      required this.id,
      required this.price,
      required this.quantity,
      required this.title,
      required this.productId});

  final String productId;
  final String id;
  final String title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.6),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: const Icon(Icons.delete),
        ),
        onDismissed: (direction) => cartProvider.removeByProductId(productId),
        confirmDismiss: (direction) => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  icon: Icon(Icons.remove_shopping_cart_rounded,
                      color: Theme.of(context).colorScheme.secondary),
                  title: const Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                      'Do you want to remove the selected item from the cart?',
                      textAlign: TextAlign.center),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('No')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'))
                  ],
                )),
        direction: DismissDirection.endToStart,
        key: ValueKey(id),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FittedBox(
                      child: Text('\$$price'),
                    ),
                  ),
                ),
                title: Text(title),
                subtitle: Text('Total: \$${quantity * price}'),
                trailing: Text('${quantity}x'),
              )),
        ));
  }
}

class OrderItemCard extends StatefulWidget {
  const OrderItemCard({super.key, required this.orderItem});

  final OrderItemModel orderItem;

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.orderItem.totalAmount}'),
          subtitle: Text(DateFormat('dd/mm/yyyy hh:mm')
              .format(widget.orderItem.orderedAt)),
          trailing: IconButton(
              onPressed: () => setState(() {
                    _isExpanded = !_isExpanded;
                  }),
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more)),
        ),
        if (_isExpanded)
          SizedBox(
              height: min(widget.orderItem.products.length * 20 + 10, 100),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListView(
                  children: widget.orderItem.products
                      .map((product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${product.quantity}x \$${product.price}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList(),
                ),
              ))
      ]),
    );
  }
}

class ProductItemCard extends StatelessWidget {
  const ProductItemCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () async {
                    final response = await Navigator.of(context).pushNamed(
                        ProductEditScreen.routeName,
                        arguments: id) as Map<String, dynamic>?;

                    if (response != null &&
                        response['status'] != null &&
                        response['status'] == true &&
                        response['message'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response['message'])));
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: () =>
                      Provider.of<ProductProvider>(context, listen: false)
                          .deleteProductAsync(id),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}

class ProductStackedCard extends StatelessWidget {
  const ProductStackedCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // width: double.infinity,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  color: Colors.black54),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const CartScreen())),
                        child: Icon(Icons.shopping_cart,
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class ImagePreviewCard extends StatelessWidget {
  const ImagePreviewCard({
    super.key,
    this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 100,
        child: DecoratedBox(
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: imageUrl == null || imageUrl!.isEmpty
              ? const Center(
                  child: Text('Enter a URL'),
                )
              : Image.network(imageUrl!, fit: BoxFit.cover),
        ));
  }
}
