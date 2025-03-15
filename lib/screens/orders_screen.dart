import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/widgets/widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const String routeName = '/orders';

  // @override
  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        body: FutureBuilder(
            future: _onRefresh(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Stack(
                  children: [
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: const Opacity(
                          opacity: 0.8,
                          child: ModalBarrier(
                              dismissible: false, color: Colors.black54),
                        )),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else {
                if (snapshot.hasError) {
                  // handle error here
                  return const Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) =>
                        RefreshIndicator(
                            child: ListView.builder(
                                itemCount: orderProvider.orders.length,
                                itemBuilder: (context, index) {
                                  var item = orderProvider.orders[index];
                                  return OrderItemCard(orderItem: item);
                                }),
                            onRefresh: () => _onRefresh(context)),
                  );
                }
              }
            }),
        drawer: const AppDrawer());
  }
}

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   static const String routeName = '/orders';

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;

//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       try {
//         setState(() {
//           _isLoading = true;
//         });
//         await Provider.of<OrderProvider>(context, listen: false)
//             .fetchAndSetOrders();
//       } catch (e) {
//         if (kDebugMode) {
//           print(e);
//         }
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     });
//     super.initState();
//   }

//   Future<void> _onRefresh(BuildContext context) async {
//     await Provider.of<OrderProvider>(context, listen: false)
//         .fetchAndSetOrders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var orderProvider = Provider.of<OrderProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Your Orders'),
//         ),
//         body: RefreshIndicator(
//             child: Stack(
//               children: [
//                 ListView.builder(
//                   itemCount: orderProvider.orders.length,
//                   itemBuilder: (context, index) {
//                     var item = orderProvider.orders[index];
//                     return OrderItemCard(orderItem: item);
//                   },
//                 ),
//                 if (_isLoading)
//                   BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
//                       child: const Opacity(
//                         opacity: 0.8,
//                         child: ModalBarrier(
//                             dismissible: false, color: Colors.black54),
//                       )),
//                 if (_isLoading)
//                   const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//               ],
//             ),
//             onRefresh: () => _onRefresh(context)),
//         drawer: const AppDrawer());
//   }
// }
