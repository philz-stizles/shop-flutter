import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/screens/screens.dart';

Widget createCartScreen() => ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider(),
      child: const MaterialApp(home: CartScreen()),
    );

void main() {
  // await dotenv.load(fileName: ".env.development");

  group('Cart Screen Widget Tests', () {
    testWidgets('Testing if ListView shows up.', (tester) async {
      await tester.pumpWidget(createCartScreen());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Testing if ListView shows up.', (tester) async {
      await tester.pumpWidget(createCartScreen());
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
