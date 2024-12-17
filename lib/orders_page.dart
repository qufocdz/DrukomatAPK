import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'selected_order_page.dart';

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

  return RawScrollbar(
    thumbColor: const Color(midnightGreen),
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
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
            child: ListTile(
              title: Text(
                'Nr. druku #${order["number"]}',
                style: const TextStyle(
                  color: Color(richBlack),
                ),
              ),
              subtitle: Text(
                'Status: ${order["status"]}',
                style: const TextStyle(
                  color: Color(richBlack),
                ),
              ),
              trailing: const Text(
                'Więcej ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(richBlack),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
