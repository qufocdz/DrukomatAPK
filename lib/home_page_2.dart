import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/orders_page.dart';

Widget secondHomePage(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrdersPage(),
            ),
          );
        },
        child: Image.asset(
          'images/kartki2.png',
          height: screenHeight * 0.5,
          width: screenWidth * 0.78,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
