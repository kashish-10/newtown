import 'package:diva/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:diva/emergency/emergencyCarousel.dart';
import 'package:diva/nearbySafePlaces/NearbySafePlaces.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:diva/db/db_services.dart';
import 'package:diva/model/contacts_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Position _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSms(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permission are denied");
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
        Fluttertoast.showToast(
            msg: "Location permissions are permanently denied");
      }
    }
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAndSendSms() async {
    // String recipients = "8278681942";
    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "https://maps.google.com/?daddr=${_currentPosition.latitude},${_currentPosition.longitude}";
    // String messageBody = "https://maps.google.com/?daddr=25.7821353,84.7102497";
    if (await _isPermissionGranted()) {
      for (var element in contactList) {
        _sendSms(element.number, "I am in trouble $messageBody");
      }
      // _sendSms(recipients, "I am in trouble $messageBody");
    } else {
      Fluttertoast.showToast(msg: "Something is wrong. Please try again.");
    }
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 240.0),
                child: Text(
                  'Emergency',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.explore),
                onPressed: () {
                  // Implement the functionality for explorer icon tap
                  // For now, it just shows a toast message
                  // Fluttertoast.showToast(msg: 'Explorer icon tapped!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.purple[100],
        child: Column(
          children: [
            const EmergencyCarousel(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearby Safe Places',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const NearbySafePlaces(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getAndSendSms();
              },
              child: const Text('Send location!'),
            ),
          ],
        ),
      ),
    );
  }
}
