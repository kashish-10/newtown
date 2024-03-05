import 'package:diva/db/db_services.dart';
import 'package:diva/model/contacts_model.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

sendMessage(String messageBody) async {
  List<TContact> contactList = await DatabaseHelper().getContactList();
  if (contactList.isEmpty) {
    Fluttertoast.showToast(msg: "No emergency contact exists");
  } else {
    for (var i = 0; i < contactList.length; i++) {
      Telephony.backgroundInstance
          .sendSms(to: contactList[i].number, message: messageBody)
          .then((value) {
        Fluttertoast.showToast(msg: "Message Sent");
      });
    }
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "Diva Guard",
    "Foreground Service",
    description: "used for imp notification",
    importance: Importance.high,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: "Diva Guard",
        initialNotificationTitle: "Foreground Service",
        initialNotificationContent: "initializing",
        foregroundServiceNotificationId: 888,
      ));
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  late Position currentPosition;

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
          .then((Position position) {
        currentPosition = position;
        print("current location ${position.latitude} ${position.longitude}");
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });

      ShakeDetector.autoStart(
          shakeThresholdGravity: 7,
          shakeSlopTimeMS: 500,
          shakeCountResetTime: 2000,
          minimumShakeCount: 5,
          onPhoneShake: () async {
            if (await Vibration.hasVibrator() ?? false) {
              // print("Test 2");
              if (await Vibration.hasCustomVibrationsSupport() ?? false) {
                // print("Test 3");
                Vibration.vibrate(duration: 1000);
              } else {
                // print("Test 4");
                Vibration.vibrate();
                await Future.delayed(const Duration(milliseconds: 500));
                Vibration.vibrate();
              }
              // print("Test 5");
            }
            String messageBody =
                "https://maps.google.com/?daddr=${currentPosition.latitude},${currentPosition.longitude}";
            sendMessage("I am in trouble, Locate me here: $messageBody");
          });
    }
  }

  flutterLocalNotificationsPlugin.show(
    888,
    "Diva Guard",
    "Shake Feature enabled",
    const NotificationDetails(
        android: AndroidNotificationDetails(
      "Diva Guard",
      "Foreground Service",
      channelDescription: "used for imp notification",
      icon: 'ic_bg_service_small',
      ongoing: true,
      playSound: false,
    )),
  );
}
