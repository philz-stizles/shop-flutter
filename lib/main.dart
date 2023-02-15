import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/providers.dart';
import 'package:shop/routes.dart';
import 'package:shop/screens/screens.dart';
import 'package:shop/themes.dart';

Future<void> main() async {
  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.production");
  } else {
    await dotenv.load(fileName: ".env.development");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
              create: (context) => ProductProvider(),
              update: (context, authProvider, productProvider) =>
                  productProvider!..update(authProvider.token)),
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
              create: (_) => OrderProvider(),
              update: (context, authProvider, previousOrderProvider) =>
                  OrderProvider(
                      authToken: authProvider.token,
                      orders: previousOrderProvider == null
                          ? []
                          : previousOrderProvider.orders))
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: theme(),
            home: authProvider.isAuthenticated
                ? const DashboardScreen()
                : FutureBuilder(
                    future: authProvider.tryAutoLogin(),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> autoLoginSnapshot) {
                      return autoLoginSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen();
                    },
                  ),
            routes: routes,
          ),
        ));
    // return MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    //       ChangeNotifierProvider<ProductProvider>(
    //           create: (_) => ProductProvider()),
    //       ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
    //       ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider())
    //     ],
    //     child: Consumer<AuthProvider>(
    //       builder: (context, authProvider, child) => MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         title: 'Flutter Demo',
    //         theme: theme(),
    //         home: authProvider.isAuthenticated
    //             ? const DashboardScreen()
    //             : const AuthScreen(),
    //         routes: routes,
    //       ),
    //     ));
    // return ChangeNotifierProvider(
    //   create: (_) => ProductProvider(),
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'Flutter Demo',
    //     theme: theme(),
    //     home: const DashboardScreen(),
    //     routes: routes,
    //   ),
    // );
  }
}
