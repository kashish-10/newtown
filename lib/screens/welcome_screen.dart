import 'package:diva/provider/auth_provider.dart';
import 'package:diva/screens/home_screen.dart';
import 'package:diva/screens/register_screen.dart';
import 'package:diva/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/front_image.jpeg",
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "DIVA GUARD",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // custom button
                SizedBox(
                  width: 300, // Set the desired width here
                  height: 40,
                  child: CustomButton(
                    onPressed: () {
                      ap.isSignedIn == true
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                    },
                    text: "Let's Get Started",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
