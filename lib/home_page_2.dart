import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/orders_page.dart';

Widget secondHomePage(BuildContext context) {
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
            height: 380.0,
            width: 240.0,
          ),
        ),
      ),
    );
  }