import 'dart:math';

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
  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.currentOrderBasket) {
      totalPrice += item['price'];
    }
    return totalPrice;
  }

  String _generateRandomCollectionCode() {
    final random = Random();
    final letter = String.fromCharCode(random.nextInt(26) + 65);
    final digits = random.nextInt(100000).toString().padLeft(5, '0');

    return '$letter$digits';
  }

  @override
  Widget build(BuildContext context) {
    final addressParts = widget.drukomat.address?.split(',') ?? [];

    final street = addressParts.length > 0 ? addressParts[0].trim() : '';
    final city = addressParts.length > 1 ? addressParts[1].trim() : '';
    final postalCode = addressParts.length > 2 ? addressParts[2].trim() : '';

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
                              'Ulica: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(richBlack),
                              ),
                            ),
                            Text(
                              street.isNotEmpty ? street : "Brak",
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
                              'Miasto: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(richBlack),
                              ),
                            ),
                            Text(
                              city.isNotEmpty ? city : "Brak",
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
                              'Kraj: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(richBlack),
                              ),
                            ),
                            Text(
                              postalCode.isNotEmpty ? postalCode : "Brak",
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
                                        (item) => Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(midnightGreen),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          item['isTemplate'] ==
                                                                  true
                                                              ? item[
                                                                  'templateName']
                                                              : item['fileName'] ??
                                                                  'Dokument',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                midnightGreen),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color: Color(
                                                                richBlack)),
                                                        onPressed: () =>
                                                            _removeFromBasket(
                                                                item),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                  _buildPrintSettings(item),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'Cena: ${item['price'].toStringAsFixed(2)} zł',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(richBlack),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                      'price': result['price'],
                                      'encodedFile': result['base64File'],
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
                          double totalPrice = _calculateTotalPrice();

                          List<Map<String, dynamic>> ordersData =
                              widget.currentOrderBasket.map((item) {
                            return {
                              'drukomatID': widget.drukomat.drukomatID,
                              'file': {
                                'fileName': item['fileName'],
                                'isColorPrint': item['isColorPrint'],
                                'format': item['format'],
                                'quantity': item['quantity'],
                                'encodedFile': item['encodedFile'],
                              },
                              'totalPrice': item['price'],
                              'userID': user?['_id'],
                              'orderDate': DateTime.now().toIso8601String(),
                              'status': 1,
                              'collectionCode': _generateRandomCollectionCode(),
                              'completionDate': null,
                            };
                          }).toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                orders: ordersData,
                                totalPrice: totalPrice,
                              ),
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

  Widget _buildPrintSettings(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Format: ${item['format']}',
          style: const TextStyle(color: Color(richBlack)),
        ),
        Text(
          'Kopie: ${item['quantity']}',
          style: const TextStyle(color: Color(richBlack)),
        ),
        Text(
          'Wydruk w kolorze: ${item['isColorPrint'] ? 'Tak' : 'Nie'}',
          style: const TextStyle(color: Color(richBlack)),
        ),
      ],
    );
  }

  void _removeFromBasket(Map<String, dynamic> item) {
    setState(() {
      widget.currentOrderBasket.remove(item);
    });
  }
}
