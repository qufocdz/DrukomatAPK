import 'package:flutter/material.dart';
import 'globals.dart';
import 'mongodb.dart';
import 'dart:math';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> orders;

  const PaymentPage({Key? key, required this.totalPrice, required this.orders})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _blikController = TextEditingController();
  bool isProcessing = false;

  String generateCollectionCode() {
    final random = Random();
    final letter = String.fromCharCode(random.nextInt(26) + 65);
    final digits = List.generate(5, (index) => random.nextInt(10)).join();
    return '$letter$digits';
  }

  bool isBLIKCodeValid() {
    return _blikController.text.length == 6;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(verdigris),
          appBar: AppBar(
            title: const Text('Płatność BLIK'),
            backgroundColor: const Color(midnightGreen),
            foregroundColor: const Color(electricBlue),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      counterText: '',
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: isBLIKCodeValid() && !isProcessing
                      ? () async {
                          setState(() {
                            isProcessing = true;
                          });

                          try {
                            bool paymentSuccess = true;

                            if (paymentSuccess) {
                              for (var orderData in widget.orders) {
                                final orderToSave = {
                                  'Status': 1,
                                  'CreationDate': DateTime.now().toUtc(),
                                  'CompletionDate': null,
                                  'DrukomatID': orderData['drukomatID'],
                                  'CollectionCode': generateCollectionCode(),
                                  'UserID': orderData['userID'],
                                  'File': orderData['file'],
                                };

                                await MongoDB.saveOrder(orderToSave);
                              }

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
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                            color: Color(midnightGreen)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(beige),
                                title: const Text(
                                  'Błąd zapisu',
                                  style: TextStyle(
                                    color: Color(midnightGreen),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  'Nie udało się zapisać zamówienia. Spróbuj ponownie.',
                                  style: TextStyle(color: Color(richBlack)),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                          color: Color(midnightGreen)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } finally {
                            setState(() {
                              isProcessing = false;
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBLIKCodeValid() && !isProcessing
                        ? const Color(midnightGreen)
                        : Colors.grey,
                    foregroundColor: const Color(beige),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
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
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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
        if (isProcessing)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
