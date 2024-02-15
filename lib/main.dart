import "package:diva/provider/auth_provider.dart";
import "package:diva/screens/add_contacts.dart";
import "package:diva/screens/contacts_screen.dart";
import "package:diva/screens/settings.dart";
import "package:diva/screens/welcome_screen.dart";
import "package:firebase_core/firebase_core.dart";
import "package:provider/provider.dart";
import 'firebase_options.dart';
import "package:flutter/material.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: WelcomeScreen(),
        title: "DivaGuard",
      ),
    );
  }
}
