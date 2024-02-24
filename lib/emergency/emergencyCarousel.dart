import 'package:flutter/material.dart';
import 'package:diva/emergency/emergencyContacts/AmbulanceEmergency.dart';
import 'package:diva/emergency/emergencyContacts/ArmyEmergency.dart';
import 'package:diva/emergency/emergencyContacts/FirebrigadeEmergency.dart';
import 'package:diva/emergency/emergencyContacts/PoliceEmergency.dart';

class EmergencyCarousel extends StatelessWidget {
  const EmergencyCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: const [
            PoliceEmergency(),
            AmbulanceEmergency(),
            FireEmergency(),
            ArmyEmergency()
          ]),
    );
  }
}
