import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'bus_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BusProvider(),
      child: MaterialApp(
        title: 'Kigali Bus Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  final Location location = Location();
  LatLng? currentLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final loc = await location.getLocation();
    setState(() {
      currentLocation = LatLng(loc.latitude!, loc.longitude!);
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLocation!,
          infoWindow: InfoWindow(title: 'You are here'),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kigali Bus Tracker'),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 14.0,
              ),
              markers: _markers,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findNearestBus,
        child: Icon(Icons.directions_bus),
      ),
    );
  }

  void _findNearestBus() {
    Provider.of<BusProvider>(context, listen: false).findNearestBus(currentLocation!);
  }
}
