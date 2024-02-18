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
import 'package:url_launcher/url_launcher.dart';

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
                padding: EdgeInsets.only(right: 230.0),
                child: Text(
                  'Emergency',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.explore, size: 32),
                onPressed: () {
                  // Implement the functionality for explorer icon tap
                  // For now, it just shows a toast message
                  // Fluttertoast.showToast(msg: 'Explorer icon tapped!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
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
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearby Safe Places',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const NearbySafePlaces(),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Get home safe',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 200), // Width and height adjusted
                backgroundColor: Colors.purple.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the radius as needed
                ), // Background color set to green
              ),
              child: const Text(
                'Get the safest route while you travel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // Text color set to black
                  fontSize: 35, // Increase text size
                  fontWeight: FontWeight.bold, // Make text bold
                ), // Text color set to black
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Need any suggestions',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                try {
                  await launch(
                      "https://65d1ee4a91a5a729bbed22ef--thunderous-hamster-9b8cd9.netlify.app/");
                } catch (e) {
                  print(e);
                  Fluttertoast.showToast(
                      msg: "Something went wrong! Cannot open DivaBot");
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 65), // Width and height adjusted
                backgroundColor:
                    Colors.green.shade600, // Background color set to green
              ),
              child: const Text(
                'Chat with Diva Bot',
                style: TextStyle(
                  color: Colors.white, // Text color set to black
                  fontSize: 35, // Increase text size
                  fontWeight: FontWeight.bold, // Make text bold
                ), // Text color set to black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
