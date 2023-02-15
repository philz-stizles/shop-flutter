import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/screens/screens.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 45,
          leading: const Padding(
            padding: EdgeInsets.only(left: 15),
            child: CircleAvatar(
              child: SizedBox(
                width: 10,
                height: 10,
              ),
            ),
          ),
          title: const Text('Hello phil'),
        ),
        ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(DashboardScreen.routeName)),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName)),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductManageScreen.routeName)),
        const Divider(),
        const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            }),
        const Divider(),
      ],
    ));
  }
}
