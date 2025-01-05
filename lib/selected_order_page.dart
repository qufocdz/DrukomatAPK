import 'package:flutter/material.dart';
import 'globals.dart';

class SelectedOrderPage extends StatelessWidget {
  final Map<String, dynamic> order;

  // Constructor to receive the order data
  SelectedOrderPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracting order details
    final creationDate = order[
        "CreationDate"]; // Using toDate() to convert Firestore Date to DateTime
    final formattedDate =
        "${creationDate.year}-${creationDate.month.toString().padLeft(2, '0')}-${creationDate.day.toString().padLeft(2, '0')} ${creationDate.hour.toString().padLeft(2, '0')}:${creationDate.minute.toString().padLeft(2, '0')}";

    final orderStatus = getStatus(order["Status"]);

    // Extracting file information
    final file = order["File"];
    final quantity = file["quantity"];
    final color = file["isColorPrint"];
    final format = file["format"];
    final userFile = file["fileName"];
    final orderNumber = (creationDate.millisecondsSinceEpoch / 1000)
        .toInt(); // Use milliseconds for order number

    // Extract and format the completion date from the database
    String? formattedCompletionDate;
    if (order["CompletionDate"] != null &&
        (order["Status"] == 3 || order["Status"] == 4)) {
      final completionDate = order["CompletionDate"]
          .toDate(); // Convert Firestore Date to DateTime
      formattedCompletionDate =
          "${completionDate.year}-${completionDate.month.toString().padLeft(2, '0')}-${completionDate.day.toString().padLeft(2, '0')} ${completionDate.hour.toString().padLeft(2, '0')}:${completionDate.minute.toString().padLeft(2, '0')}";
    }

    // Extract collection code if status is 3
    final collectionCode = order["CollectionCode"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Zamówienie #$orderNumber'),
        centerTitle: true,
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: Container(
        color: const Color(verdigris),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Card with status, creation date, and completion date
            _buildDetailCard(
              context,
              title: 'Informacje o realizacji zamówienia',
              details: [
                _buildOrderDetailRow('Status zamówienia:', orderStatus),
                _buildOrderDetailRow('Data zamówienia:', formattedDate),
                if (formattedCompletionDate != null)
                  _buildOrderDetailRow(
                      'Data wydrukowania:', formattedCompletionDate),
              ],
            ),
            // Grouped card for file information
            _buildDetailCard(
              context,
              title: 'Informacje o druku',
              details: [
                _buildOrderDetailRow('Liczba kopii:', '$quantity'),
                _buildOrderDetailRow('Kolor:', color ? "Kolor" : "Czarnobiały"),
                _buildOrderDetailRow('Format:', format),
                _buildOrderDetailRow('Nazwa pliku:', userFile),
              ],
            ),
            // Collection code card (only if status is 3)
            if (order["Status"] == 3)
              _buildCollectionCodeCard(context, collectionCode),
          ],
        ),
      ),
    );
  }

  // Helper method to create a unified styled card
  Widget _buildDetailCard(BuildContext context,
      {required String title, required List<Widget> details}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(beige),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(midnightGreen),
              ),
            ),
            const SizedBox(height: 8),
            ...details,
          ],
        ),
      ),
    );
  }

  // Helper method to create the collection code card
  Widget _buildCollectionCodeCard(BuildContext context, String collectionCode) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.amber.shade300, // A distinct color from the current palette
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Kod odbioru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              collectionCode,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create individual rows in the card
  Widget _buildOrderDetailRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(midnightGreen),
            ),
          ),
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(richBlack),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to map status number to text
  String getStatus(int? status) {
    switch (status) {
      case 1:
        return 'Oczekujące';
      case 2:
        return 'W trakcie drukowania';
      case 3:
        return 'Gotowe do odbioru';
      case 4:
        return 'Odebrane';
      default:
        return 'Nieznany status';
    }
  }
}
