import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'selected_order_page.dart'; // Import the page that shows order details
import 'mongodb.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders =
      []; // To store orders fetched from MongoDB
  bool isLoading = true; // Track if data is being loaded

  // Function to fetch orders
  Future<void> fetchOrders() async {
    try {
      if (user != null && user!['_id'] != null) {
        String userID = user!['_id'].toHexString();
        final fetchedOrders = await MongoDB.fetchOrders(userID);
        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } else {
        print("User is not logged in or userID is null.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text("Zamówienia"),
        centerTitle: true,
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: RawScrollbar(
        thumbColor: const Color(midnightGreen),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : orders.isEmpty
                ? Center(
                    child:
                        Text("Brak zamówień", style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      // Extract CreationDate timestamp and convert it to DateTime
                      final creationTimestamp = order["CreationDate"].seconds;
                      final creationDate = DateTime.fromMillisecondsSinceEpoch(
                          creationTimestamp * 1000);
                      final formattedDate =
                          "${creationDate.year}-${creationDate.month.toString().padLeft(2, '0')}-${creationDate.day.toString().padLeft(2, '0')} ${creationDate.hour.toString().padLeft(2, '0')}:${creationDate.minute.toString().padLeft(2, '0')}";

                      final orderStatus = getStatus(order["Status"]);

                      final orderNumber = (creationTimestamp / 1000).toInt();

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the OrderDetailPage when an order is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedOrderPage(
                                order: order,
                              ), // Pass order to the details page
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: const Color(beige),
                          child: ListTile(
                            title: Text(
                              'Nr. druku #$orderNumber', // Use last 8 characters of _id as order number
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(midnightGreen)),
                            ),
                            subtitle: Text(
                              'Data zamówienia: $formattedDate',
                              style: const TextStyle(
                                  fontSize: 14, color: Color(richBlack)),
                            ),
                            trailing: Text(
                              orderStatus,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(midnightGreen)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

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
