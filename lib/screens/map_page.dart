import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:diva/consts.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final List<LatLng> dynamicPoints;

  const MapPage({Key? key, required this.dynamicPoints}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(28.54467, 77.201501);
  LatLng? _currentP;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _currentP =
        widget.dynamicPoints.isNotEmpty ? widget.dynamicPoints.first : null;
    generatePolyLineFromPoints();
    if (_currentP != null) {
      _cameraToPosition(_currentP!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _pGooglePlex,
                zoom: 13,
              ),
              markers: Set<Marker>.from(markers),
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  void generatePolyLineFromPoints() async {
    PolylineId id = PolylineId("poly");
    List<LatLng> polylineCoordinates =
        List.from(widget.dynamicPoints); // Copy the dynamic points

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 8,
    );

    // Add markers for dynamically generated points
    for (int i = 0; i < widget.dynamicPoints.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId("_dynamicPoint_$i"),
          icon: BitmapDescriptor.defaultMarker,
          position: widget.dynamicPoints[i],
        ),
      );
    }

    setState(() {
      markers.addAll(markers);
      polylines[id] = polyline;
    });
  }
}
