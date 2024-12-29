import 'package:flutter/material.dart';
import 'globals.dart';
import 'mongodb.dart';

class OrderingPage extends StatelessWidget {
  final Drukomat drukomat;
  final List<Map<String, dynamic>> currentOrderBasket = [];

  OrderingPage({super.key, required this.drukomat});

  // Function to show the confirmation dialog with a customized style
  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color(beige), // Match background color with the app
          title: const Text(
            'Uwaga!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(midnightGreen), // Match title color with the app
            ),
          ),
          content: const Text(
            'Twój koszyk nie zostanie zapisany. Czy na pewno chcesz anulować zamówienie?',
            style: TextStyle(
              fontSize: 16,
              color: Color(richBlack), // Match body text color with the app
            ),
          ),
          actions: <Widget>[
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(midnightGreen), // Button text color
                backgroundColor: const Color(beige), // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Nie',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Confirm button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to previous page
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(midnightGreen), // Button text color
                backgroundColor: Colors.red, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Anuluj',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the exit confirmation dialog when back is pressed
        await _showExitDialog(context);
        return false; // Return false to prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: const Color(verdigris),
        appBar: AppBar(
          title: const Center(child: Text('Zamawianie druku')),
          backgroundColor: const Color(midnightGreen), // Use midnightGreen
          foregroundColor: const Color(electricBlue), // Use electricBlue
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drukomat details in a card - placed at the top
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color(beige),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drukomat.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(midnightGreen),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Row widget to keep label and text in the same line
                      Row(
                        children: [
                          const Text(
                            'Adres: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make label bold
                              color: Color(richBlack),
                            ),
                          ),
                          Text(
                            drukomat.address ?? "Not available",
                            style: const TextStyle(
                              color: Color(richBlack),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Row for Miasto
                      Row(
                        children: [
                          const Text(
                            'Miasto: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make label bold
                              color: Color(richBlack),
                            ),
                          ),
                          Text(
                            drukomat.city ?? "Not available",
                            style: const TextStyle(
                              color: Color(richBlack),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Row for Status
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make label bold
                              color: Color(richBlack),
                            ),
                          ),
                          Text(
                            drukomat.status.toString(),
                            style: const TextStyle(
                              color: Color(richBlack),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Row for Opis
                      Row(
                        children: [
                          const Text(
                            'Opis: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make label bold
                              color: Color(richBlack),
                            ),
                          ),
                          Text(
                            drukomat.description ?? "Not available",
                            style: const TextStyle(
                              color: Color(richBlack),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10), // Reduced the gap here

              // Basket card with constant width, moved to the top
              Container(
                width: double
                    .infinity, // To make the width constant and full-width
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(beige),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Aktualne zamówienie:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(midnightGreen),
                          ),
                        ),
                        const SizedBox(height: 10),
                        currentOrderBasket.isEmpty
                            ? const Text(
                                "Twój koszyk jest pusty.",
                                style: TextStyle(
                                  color: Color(richBlack),
                                ),
                              )
                            : Column(
                                children: currentOrderBasket
                                    .map(
                                      (item) => Text(
                                        "- ${item['itemName']} (x${item['quantity']})",
                                        style: const TextStyle(
                                          color: Color(richBlack),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                        const SizedBox(height: 20),

                        // Smaller Add to Order Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // No functionality, button is just a placeholder
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  midnightGreen), // Button background color
                              foregroundColor:
                                  const Color(beige), // Button text color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12), // Reduced padding
                              elevation: 5, // Button shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // Rounded corners
                              ),
                            ),
                            child: const Text(
                              'Dodaj do zamówienia',
                              style: TextStyle(
                                fontSize: 16, // Reduced font size
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Pay for Order Button - No functionality attached
              ElevatedButton(
                onPressed: () {
                  // No functionality, button is just a placeholder
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(midnightGreen), // Button background color
                  foregroundColor: const Color(beige), // Button text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 5, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Zapłać za zamówienie',
                  style: TextStyle(
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
