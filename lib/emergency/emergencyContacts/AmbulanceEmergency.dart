import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AmbulanceEmergency extends StatelessWidget {
  const AmbulanceEmergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _callNumber("108");
            },
            child: Container(
              height: 60,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  "assets/ambulance 1.png",
                  height: 50,
                ),
              ),
            ),
          ),
          const Text("Ambulance")
        ],
      ),
    );
  }
}

_callNumber(number) async {
  await FlutterPhoneDirectCaller.callNumber(number);
}
