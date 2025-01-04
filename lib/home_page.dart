import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/map_page.dart'; // Import the mapPage widget

Widget homePage(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: const Color(midnightGreen),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Text(
                'Witaj, ${user?['FirstName']} ${user?['LastName']}!', // No `const` here
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
            },
            child: Image.asset(
              'images/kartki1.png',
              height: 400.0,
              width: 250.0,
            ),
          ),
        ],
      ),
    ),
  );
}
