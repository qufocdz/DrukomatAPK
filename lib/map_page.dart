import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mongodb.dart';
import 'ordering_page.dart';
import 'globals.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  Drukomat? selectedDrukomat; // To store the selected drukomat

  final LatLng _initialPosition =
      LatLng(50.86500986794984, 15.68169157995246);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadDrukomats() async {
    try {
      List<Drukomat> drukomats = await MongoDB.fetchDrukomats();
      print ("test $drukomats" );

      // final List<Map<String, dynamic>> data =
      //     await MongoDB.drukomatCollection.find(<String, dynamic>{}).toList();
      // print("Fetched data: $data");
      // if (data.isEmpty) {
      //   print("No Drukomats found in the database.");
      //   return;
      // }
//       List<Drukomat> drukomats = data.map<Drukomat>((item) {
//   print('Item: $item'); // Wyświetla zawartość item
//   return Drukomat.fromMap(item);
// }).toList();

      setState(() {
        _markers.clear();

        for (var drukomat in drukomats) {
          _markers.add(Marker(
            markerId: MarkerId(drukomat.name),
            position: drukomat.location,
            infoWindow: InfoWindow(
              title: drukomat.name,
              snippet: drukomat.address ?? 'No address available',
              onTap: () {
                setState(() {
                  selectedDrukomat = drukomat; // Set the selected drukomat
                });
              },
            ),
          ));
        }
      });
    } catch (e) {
      print("Error fetching drukomats: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDrukomats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Mapa Drukomatów')),
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(midnightGreen),
        ),
        child: Column(
          children: [
            // Google Map displaying markers
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.0,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onTap: (_) {
                  setState(() {
                    selectedDrukomat =
                        null; // Unselect the drukomat when tapping on the map
                  });
                },
              ),
            ),

            // Show additional button if a drukomat is selected
            if (selectedDrukomat != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the OrderingPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderingPage(drukomat: selectedDrukomat!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(richBlack),
                    backgroundColor:
                        const Color(electricBlue), // Text color on button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    elevation: 5, // Add shadow to the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Zamów w wybranym drukomacie!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// class Drukomat {
//   final String name;
//   final LatLng location;
//   final String? address;
//   final String? city;
//   final int? status;
//   final String? description;

//   Drukomat({
//     required this.name,
//     required this.location,
//     this.address,
//     this.city,
//     this.status,
//     this.description,
//   });

//   factory Drukomat.fromMap(Map<String, dynamic> map) {
//     double latitude = double.tryParse(map['Latitude']?.toString() ?? '0.0') ?? 0.0;
//     double longitude = double.tryParse(map['Longitude']?.toString() ?? '0.0') ?? 0.0;
//     print("________________");
//     print("nazwa ${map['Name']}");
//     print("addres ${map['Address']}");
//     print("miasto ${map['City']}");
//     print("opis ${map['Description']}");
//     print("________________");
//     return Drukomat(
//       name: map['Name'] ?? 'Unknown',
//       location: LatLng(latitude, longitude),
//       address: map['Address'],
//       city: map['City'],
//       status: map['Status'],
//       description: map['Description'],
//     );
//   }
// }
