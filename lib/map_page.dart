import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mongodb.dart';
import 'ordering_page.dart';
import 'globals.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  Drukomat? selectedDrukomat;

  final LatLng _initialPosition =
      const LatLng(50.86500986794984, 15.68169157995246);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadDrukomats() async {
    try {
      List<Drukomat> drukomats = await MongoDB.fetchDrukomats();
      print("test $drukomats");

      final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(32, 32)),
        'images/ikonadrukomat.png',
      );

      setState(() {
        markers.clear();

        for (var drukomat in drukomats) {
          markers.add(Marker(
            markerId: MarkerId(drukomat.name),
            icon: customIcon,
            position: drukomat.location,
            infoWindow: InfoWindow(
              title: drukomat.name,
              snippet: drukomat.address ?? 'No address available',
            ),
            onTap: () {
              setState(() {
                selectedDrukomat = drukomat;
              });
            },
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
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.0,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onTap: (_) {
                  setState(() {
                    selectedDrukomat = null;
                  });
                },
              ),
            ),
            if (selectedDrukomat != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      selectedDrukomat!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(electricBlue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedDrukomat!.address ?? 'No address available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
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
                        backgroundColor: const Color(electricBlue),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        elevation: 5,
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
