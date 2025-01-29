import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/service_page.dart';

Widget thirdHomePage(BuildContext context, Map<String, dynamic> user) {
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
              builder: (context) => ServicePage(currentUserId: user["_id"]),
            ),
          );
        },
        child: Image.asset(
          'images/kartki3.png',
          height: screenHeight * 0.5,
          width: screenWidth * 0.78,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
