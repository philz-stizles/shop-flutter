import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge(
      {super.key, required this.child, required this.value, this.color});

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: color ?? Theme.of(context).colorScheme.secondary),
              padding: const EdgeInsets.all(2.0),
              constraints:
                  const BoxConstraints(minWidth: 16.0, minHeight: 16.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              )),
        ),
      ],
    );
  }
}
