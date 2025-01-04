import 'package:flutter/material.dart';
import 'globals.dart';

class PaymentPage extends StatelessWidget {
  final double totalPrice;

  // Constructor to receive the total price
  const PaymentPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text('Płatność BLIK'),
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BLIK Logo or Heading
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

            // Instructions
            const Text(
              'Wprowadź kod BLIK, aby zapłacić za zamówienie.',
              style: TextStyle(
                fontSize: 16,
                color: Color(richBlack),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Display the total price
            Text(
              'Do zapłaty: ${totalPrice.toStringAsFixed(2)} zł',
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
                maxLength: 6, // BLIK codes are 6 digits
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
              ),
            ),
            const SizedBox(height: 40),

            // Confirm Button
            ElevatedButton(
              onPressed: () {
                // Mock payment confirmation, navigate back or show success dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(beige),
                    title: const Text(
                      'Płatność zakończona',
                      style: TextStyle(
                        color: Color(midnightGreen),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: const Text(
                      'Dziękujemy za zamówienie!',
                      style: TextStyle(color: Color(richBlack)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Return to Ordering Page
                          Navigator.pop(context); // Return to Map
                          Navigator.pop(context); // Return to Main
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Color(midnightGreen)),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(midnightGreen),
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
    );
  }
}
