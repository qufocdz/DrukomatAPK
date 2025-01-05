import 'package:flutter/material.dart';
import 'globals.dart';
import 'mongodb.dart'; // Import the MongoDB helper for database operations
import 'dart:math'; // For generating random collection code

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> orders; // Change to accept multiple orders

  // Constructor to receive the total price and order data (multiple orders)
  const PaymentPage({Key? key, required this.totalPrice, required this.orders})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _blikController = TextEditingController();

  // Generate random CollectionCode in the format of a capital letter followed by 5 digits
  String generateCollectionCode() {
    final random = Random();
    final letter =
        String.fromCharCode(random.nextInt(26) + 65); // Random letter (A-Z)
    final digits = List.generate(5, (index) => random.nextInt(10))
        .join(); // Random 5 digits
    return '$letter$digits';
  }

  // Method to check if the BLIK code is valid (exactly 6 digits)
  bool isBLIKCodeValid() {
    return _blikController.text.length == 6;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard opens
      appBar: AppBar(
        title: const Text('Płatność BLIK'),
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: SingleChildScrollView(
        // Enables scrolling when keyboard opens
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Zapłać BLIK',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(richBlack),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Wprowadź kod BLIK, aby zapłacić za zamówienie.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(richBlack),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Do zapłaty: ${widget.totalPrice.toStringAsFixed(2)} zł',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(midnightGreen),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // BLIK Code Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _blikController,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: Color(midnightGreen),
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '000000',
                    hintStyle: const TextStyle(
                      fontSize: 32,
                      color: Color(richBlack),
                    ),
                    filled: true,
                    fillColor: const Color(beige),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '', // Hide counter
                  ),
                  onChanged: (text) {
                    setState(
                        () {}); // Update the state when the BLIK code changes
                  },
                ),
              ),
              const SizedBox(height: 40),

              // Confirm Payment Button
              ElevatedButton(
                onPressed: isBLIKCodeValid()
                    ? () async {
                        // Payment handling logic remains unchanged
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBLIKCodeValid()
                      ? const Color(midnightGreen)
                      : Colors.grey,
                  foregroundColor: const Color(beige),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Potwierdź',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to ordering page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Anuluj płatność',
                  style: TextStyle(
                    color: Color(beige),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
