import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MapController _mapController = MapController();
  List<Marker> markers = []; // List to hold markers

  void _sendLocation(LatLng latlng) async {
    //backend URL
    var url = Uri.parse('http://192.168.???.255:5000/send-location');
  
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode({'latitude': latlng.latitude.toString(), 'longitude': latlng.longitude.toString()}));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
  
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: latlng,
          builder: (ctx) => Container(
            child: Icon(Icons.location_on, color: Colors.red,),
          ),
        ),
      );
      _sendLocation(latlng); // Send location to backend (Our flask app)
    });
  }

  @override
Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('OpenStreetMap Flutter')),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(45.5231, -122.6765), // Default location
            zoom: 13.0,
            onTap: (_, latlng) => _handleTap(latlng), // Handle map tap
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(markers: markers), // Display markers
          ],
        ),
      ),
    );
  }
}
