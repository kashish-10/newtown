import 'dart:convert';

import 'package:diva/screens/map_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SafestRouteForm extends StatefulWidget {
  const SafestRouteForm({Key? key}) : super(key: key);

  @override
  State<SafestRouteForm> createState() => _SafestRouteFormState();
}

class _SafestRouteFormState extends State<SafestRouteForm> {
  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safest Route'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 55.0, left: 20.0, right: 20.0, bottom: 30.0),
        child: Column(
          children: [
            TextField(
              controller: startLocationController,
              decoration: const InputDecoration(labelText: 'Start Location'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: endLocationController,
              decoration: const InputDecoration(labelText: 'End Location'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String startLocation = startLocationController.text;
                String endLocation = endLocationController.text;
                List<LatLng> coordinates =
                    await callApi(startLocation, endLocation);

                // Navigate to MapPage and pass coordinates
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MapPage(dynamicPoints: coordinates)),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<LatLng>> callApi(String startLocation, String endLocation) async {
    final apiUrl = 'https://2e62-34-16-146-30.ngrok-free.app/safest_path';

    final parameters = {
      'start_loc': startLocation,
      'end_loc': endLocation,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(parameters),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        List<LatLng> coordinates = parseCoordinates(response.body);
        return coordinates;
      } else {
        print('Failed to call API. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  List<LatLng> parseCoordinates(String responseBody) {
    final parsed = json.decode(responseBody)["safest_route"];
    return List<LatLng>.from(parsed.map((coord) {
      return LatLng(coord["lat"], coord["lng"]);
    }));
  }
}
