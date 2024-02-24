import 'dart:async';

import 'package:diva/screens/fakecall/fakecall.dart';
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

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle tap events based on the index here
      switch (index) {
        case 0:
          // Handle Home icon tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          // Handle Search icon tapped
          _launchURL(context, "https://www.divasfordefense.com/");

          break;
        case 2:
          // Handle Notification icon tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FakeCallPage()),
          );
          break;
        case 3:
          // Handle Profile icon tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
          break;
      }
    });
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(url);
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error as needed, e.g., show a snackbar or dialog to the user
    }
  }

  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSms(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "Sent");
    } else {
      Fluttertoast.showToast(msg: "Failed");
    }
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permission is denied");
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
        Fluttertoast.showToast(
            msg: "Location permission is permanently denied");
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

  void startTimelyLocationUpdates() {
    // Start timer to call getAndSendSms function every 15 minutes
    getAndSendSms();
    Timer.periodic(const Duration(minutes: 15), (timer) {
      getAndSendSms();
    });
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
      body: Padding(
        padding: const EdgeInsets.only(
            top: 55.0, left: 20.0, right: 20.0, bottom: 30.0),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Add your navigation logic or any action when the image is clicked
                    Fluttertoast.showToast(
                        msg: "Something went wrong! Cannot open DivaBot");
                    // You can navigate to a new screen using Navigator, for example:
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => YourNewScreen()));
                  },
                  child: Image.asset(
                    'assets/safest_route.png', // Replace with your actual image asset path
                    width:
                        double.infinity, // Make the image take the full width
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 0.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Emergency Contacts',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const EmergencyCarousel(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(
                          15) // Set your desired background color here
                      ),
                  child: Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, bottom: 5.0, left: 0.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' Share your Location',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // Handle click for the first container
                              startTimelyLocationUpdates();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                      'assets/fluent_timer-32-regular.png'),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    'Every 15 minutes',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                              width:
                                  16.0), // Adjust the spacing between the containers as needed
                          InkWell(
                            onTap: () {
                              // Handle click for the second container
                              getAndSendSms();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Image.asset('assets/location_black.png'),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    'Send current location',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 0.0),
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
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            'assets/chatbot1.png',
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await launch(
                                        "https://65d1ee4a91a5a729bbed22ef--thunderous-hamster-9b8cd9.netlify.app/");
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Something went wrong! Cannot open DivaBot");
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.green.shade600,
                                  ),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(400, 65),
                                  ),
                                ),
                                child: const Text(
                                  'Chat with Diva Bot',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.png', width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/store.png', width: 24, height: 24),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/fake_call.png', width: 24, height: 24),
            label: 'Fake Call',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/settings.png', width: 24, height: 24),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
