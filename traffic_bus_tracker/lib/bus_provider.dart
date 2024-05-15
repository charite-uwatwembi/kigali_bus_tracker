import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Bus {
  final String id;
  final String name;
  final LatLng location;

  Bus({required this.id, required this.name, required this.location});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'],
      location: LatLng(json['location']['lat'], json['location']['lng']),
    );
  }
}

class BusProvider with ChangeNotifier {
  List<Bus> _buses = [];

  List<Bus> get buses => _buses;

  Future<void> fetchBuses() async {
    final response = await http.get(Uri.parse('https://api.example.com/kigali_buses'));
    final List<dynamic> data = json.decode(response.body);
    _buses = data.map((json) => Bus.fromJson(json)).toList();
    notifyListeners();
  }

  void findNearestBus(LatLng userLocation) {
    if (_buses.isEmpty) return;

    Bus? nearestBus;
   
