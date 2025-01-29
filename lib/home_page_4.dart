import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/raports_page.dart';

Widget fourthHomePage(BuildContext context) {
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
              builder: (context) => const RaportsPage(),
            ),
          );
        },
        child: Image.asset(
          'images/kartki4.png',
          height: screenHeight * 0.5,
          width: screenWidth * 0.78,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
