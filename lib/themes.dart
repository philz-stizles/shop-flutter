import 'package:flutter/material.dart';

ThemeData theme() => ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Lato',
    primarySwatch: Colors.purple,
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.purple, accentColor: Colors.deepOrange));
