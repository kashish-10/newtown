import "package:diva/flutterBackgroundServices.dart";
import "package:diva/provider/auth_provider.dart";
import "package:diva/screens/home_screen.dart";
import "package:diva/screens/settings.dart";
import "package:diva/screens/splash_screen.dart";
import "package:diva/screens/welcome_screen.dart";
import "package:firebase_core/firebase_core.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'firebase_options.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diva Guard',
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: isAppOpeningForFirstTime(),
          builder: (context, AsyncSnapshot<bool?> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
              );
            }
            if (snap.hasData && snap.data != null) {
              if (snap.data!) {
                return HomePage();
              } else {
                return SplashScreen();
              }
            } else {
              return Container(
                color: Colors.white,
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> isAppOpeningForFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool("appOpenedBefore") ?? false;
    if (!result) {
      prefs.setBool("appOpenedBefore", true);
    }
    return result;
  }
}
