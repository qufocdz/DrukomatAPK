import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'selected_order_page.dart'; // Import the page that displays the selected order

Widget ordersPage(BuildContext context) {
  final List<Map<String, String>> orders = [
    {"number": "00043345", "status": "Gotowe do odbioru", "price": "50 PLN"},
    {"number": "00042694", "status": "Oczekujące", "price": "100 PLN"},
    {"number": "00042393", "status": "Oczekujące", "price": "30 PLN"},
    {"number": "00041742", "status": "Oczekujące", "price": "30 PLN"},
    {"number": "00032851", "status": "W trakcie drukowania", "price": "30 PLN"},
    {"number": "00032340", "status": "W trakcie drukowania", "price": "30 PLN"},
    {"number": "00032432", "status": "W trakcie drukowania", "price": "30 PLN"},
    {"number": "00028338", "status": "Odebrane", "price": "30 PLN"},
    {"number": "00022537", "status": "Odebrane", "price": "30 PLN"},
    {"number": "00015336", "status": "Odebrane", "price": "30 PLN"},
    {"number": "00012335", "status": "Odebrane", "price": "30 PLN"},
  ];

  return Scaffold(
    backgroundColor: const Color(verdigris), // Apply background color
    appBar: AppBar(
      title: const Text("Zamówienia"),
      centerTitle: true,
      backgroundColor: const Color(midnightGreen), // AppBar background color
      foregroundColor: const Color(electricBlue), // AppBar text color
    ),
    body: RawScrollbar(
      thumbColor: const Color(midnightGreen), // Apply the scrollbar thumb color
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the SelectedOrderPage when an order is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectedOrderPage(order: order),
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color(beige), // Card background color
              child: ListTile(
                title: Text(
                  'Nr. druku #${order["number"]}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(midnightGreen), // Title text color
                  ),
                ),
                subtitle: Text(
                  'Status: ${order["status"]}',
                  style: const TextStyle(
                    color: Color(richBlack), // Subtitle text color
                  ),
                ),
                trailing: const Text(
                  'Więcej',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(richBlack), // Trailing text color
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
