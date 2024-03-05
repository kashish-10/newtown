import 'package:diva/db/db_services.dart';
import 'package:diva/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'dart:async';

class TimelyLocationUpdatePage extends StatefulWidget {
  const TimelyLocationUpdatePage({Key? key}) : super(key: key);

  @override
  _TimelyLocationUpdatePageState createState() =>
      _TimelyLocationUpdatePageState();
}

class _TimelyLocationUpdatePageState extends State<TimelyLocationUpdatePage> {
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
    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "https://maps.google.com/?daddr=${_currentPosition!.latitude},${_currentPosition!.longitude}";
    if (await _isPermissionGranted()) {
      for (var element in contactList) {
        _sendSms(element.number, "Locate me here: $messageBody");
      }
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
      appBar: AppBar(
        title: const Text('Timely Location Update'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Add function to send location updates
                getAndSendSms();
              },
              child: const Text('Send Location Update'),
            ),
            const SizedBox(height: 20), // Adding some spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Add function to start timely location updates
                startTimelyLocationUpdates();
              },
              child: const Text('Timely Location Update'),
            ),
          ],
        ),
      ),
    );
  }
}
