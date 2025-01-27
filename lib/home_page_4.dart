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
          // Navigate directly to OrdersPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrdersPage(), // Use OrdersPage here
            ),
          );
        },
        child: Image.asset(
          'images/kartki2.png',
          height: screenHeight * 0.5, // Use 60% of the screen height
          width: screenWidth * 0.78, // Use 80% of the screen width
          fit: BoxFit
              .contain, // Ensure the image fits within the given dimensions
        ),
      ),
    ),
  );
}
