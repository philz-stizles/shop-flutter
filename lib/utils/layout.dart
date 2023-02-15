// import 'package:flutter/material.dart';

// class Layout {
//   static MediaQueryData _mediaQueryData;
//   static double screenWidth;
//   static double screenHeight;
//   static double defaultSize;
//   static Orientation orientation;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     orientation = _mediaQueryData.orientation;
//   }

//   // Get the proportionate height as per screen size
//   double getProportionateScreenHeight(double inputHeight) {
//     double screenHeight = Layout.screenHeight;
//     // 812 is the layout height that designers use
//     return (inputHeight / 812.0) * screenHeight;
//   }

//   // Get the proportionate width as per screen size
//   double getProportionateScreenWidth(double inputWidth) {
//     double screenWidth = Layout.screenWidth;
//     // 375 is the layout height that designers use
//     return (inputWidth / 375.0) * screenWidth;
//   }
// }
