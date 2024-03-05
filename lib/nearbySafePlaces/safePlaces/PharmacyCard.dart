import 'package:flutter/material.dart';

class PharmacyCard extends StatelessWidget {
  final Function openMapFunc;

  const PharmacyCard({Key? key, required this.openMapFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              openMapFunc("Pharmacies near me");
            },
            child: Container(
              height: 60,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  "assets/pharmacy1.png",
                  height: 50,
                ),
              ),
            ),
          ),
          const Text("Pharmacies")
        ],
      ),
    );
  }
}
