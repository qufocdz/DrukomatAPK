import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget mapPage(BuildContext context) {
  return GoogleMapWidget();
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;

  // Initial position for the map
  final LatLng _initialPosition =
      const LatLng(51.107883, 17.038538); // Wroclaw, Poland

  // Markers to display on the map
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(51.107883, 17.038538), // Example marker
      infoWindow: InfoWindow(
        title: 'Wroclaw',
        snippet: 'Sample Location',
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
