import 'package:flutter/material.dart';
import 'globals.dart';
import 'mongodb.dart';
import 'add_to_order_page.dart';
import 'payment_page.dart';

class OrderingPage extends StatefulWidget {
  final Drukomat drukomat;
  final List<Map<String, dynamic>> currentOrderBasket = [];

  OrderingPage({super.key, required this.drukomat});

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  // Function to show the confirmation dialog with a customized style
  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(beige),
          title: const Text(
            'Uwaga!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(midnightGreen),
            ),
          ),
          content: const Text(
            'Twój koszyk nie zostanie zapisany. Czy na pewno chcesz anulować zamówienie?',
            style: TextStyle(
              fontSize: 16,
              color: Color(richBlack),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(midnightGreen),
                backgroundColor: const Color(beige),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Nie',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to previous page
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(midnightGreen),
                backgroundColor: Colors.red,
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

  // Method to calculate the total price of the cart
  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.currentOrderBasket) {
      totalPrice += item['price']; // Adjusted to account for quantity
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _showExitDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(verdigris),
        appBar: AppBar(
          title: const Center(child: Text('Zamawianie druku')),
          backgroundColor: const Color(midnightGreen),
          foregroundColor: const Color(electricBlue),
        ),
        body: SingleChildScrollView(
          // Make the body scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                          widget.drukomat.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(midnightGreen),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Adres: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(richBlack),
                              ),
                            ),
                            Text(
                              widget.drukomat.address ?? "Not available",
                              style: const TextStyle(
                                color: Color(richBlack),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(richBlack),
                              ),
                            ),
                            Text(
                              widget.drukomat.status == 1
                                  ? "aktywny"
                                  : "nieaktywny",
                              style: const TextStyle(
                                color: Color(richBlack),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
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
                          widget.currentOrderBasket.isEmpty
                              ? const Text(
                                  "Twój koszyk jest pusty.",
                                  style: TextStyle(
                                    color: Color(richBlack),
                                  ),
                                )
                              : Column(
                                  children: widget.currentOrderBasket
                                      .map(
                                        (item) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "- ${item['fileName']} (x${item['quantity']})",
                                              style: const TextStyle(
                                                color: Color(richBlack),
                                              ),
                                            ),
                                            Text(
                                              "  Format: ${item['format']}",
                                              style: const TextStyle(
                                                color: Color(richBlack),
                                              ),
                                            ),
                                            Text(
                                              "  Wydruk: ${item['isColorPrint'] ? 'Kolor' : 'Czarnobiały'}",
                                              style: const TextStyle(
                                                color: Color(richBlack),
                                              ),
                                            ),
                                            Text(
                                              "  Cena: ${item['price']} zł",
                                              style: const TextStyle(
                                                color: Color(richBlack),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddToOrderPage(),
                                  ),
                                );
                                if (result != null &&
                                    result['file'] != null &&
                                    result['file'] != '') {
                                  setState(() {
                                    widget.currentOrderBasket.add({
                                      'fileName': result['file'],
                                      'isColorPrint': result['isColorPrint'],
                                      'format': result['format'],
                                      'quantity': result['copies'],
                                      'price': result['price'], // Add price
                                    });
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(midnightGreen),
                                foregroundColor: const Color(beige),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Dodaj do zamówienia',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(beige),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Łączna cena:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(midnightGreen),
                          ),
                        ),
                        Text(
                          '${_calculateTotalPrice().toStringAsFixed(2)} zł',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(midnightGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: widget.currentOrderBasket.isEmpty
                      ? null
                      : () {
                          // Calculate the total price and pass it to the PaymentPage
                          double totalPrice = _calculateTotalPrice();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                  totalPrice: totalPrice), // Passing the price
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.currentOrderBasket.isEmpty
                        ? Colors.grey
                        : const Color(midnightGreen),
                    foregroundColor: const Color(beige),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Zapłać za zamówienie',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
