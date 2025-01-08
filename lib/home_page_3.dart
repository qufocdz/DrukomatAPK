import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/service_page.dart';

Widget thirdHomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate directly to OrdersPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ServiceWidget(), // Use OrdersPage here
              ),
            );
          },
          child: Image.asset(
            'images/kartki2.png',
            height: 380.0,
            width: 240.0,
          ),
        ),
      ),
    );
  }