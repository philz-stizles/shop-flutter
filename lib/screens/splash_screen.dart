import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('...Loading')));
  }
}
