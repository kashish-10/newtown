import 'package:diva/provider/auth_provider.dart';
import 'package:diva/screens/add_contacts.dart';
import 'package:diva/screens/fakecall/fakecall.dart';
import 'package:diva/screens/location_update.dart';
import 'package:diva/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://media.istockphoto.com/vectors/purple-user-icon-in-the-circle-a-solid-gradient-vector-id1095289632?k=20&m=1095289632&s=612x612&w=0&h=_glHdsV95Q3uZHTpFNIeaJpzGMpy6fplJP5G6YUgfmk='),
                    ),
                    // Positioned(
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(Icons.add_a_photo),
                    //   ),
                    // ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '(+91) 123 456 7890',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Age: 20',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Divider(color: Colors.grey),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Edit Emergency Contacts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddContacts()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Timely Location Update'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TimelyLocationUpdatePage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('Safe Audio'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SafeAudioPage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Fake Call'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FakeCallPage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text('Trigger'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TriggerPage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.shopping_bag_rounded),
            title: const Text('Buy Safety Products'),
            onTap: () async {
              // Add logout functionality here
              await launch("https://www.divasfordefense.com/");
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Add logout functionality here
              // ap.userSignOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Sample pages for each feature
// class EditEmergencyContactsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Emergency Contacts'),
//       ),
//       body: const Center(
//         child: Text('Edit Emergency Contacts Page'),
//       ),
//     );
//   }
// }

// class TimelyLocationUpdatePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Timely Location Update'),
//       ),
//       body: const Center(
//         child: Text('Timely Location Update Page'),
//       ),
//     );
//   }
// }

// class SafeShakePage extends StatelessWidget {
//   const SafeShakePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Safe Shake'),
//       ),
//       body: const Center(
//         child: Text('Safe Shake Page'),
//       ),
//     );
//   }
// }

class SafeAudioPage extends StatelessWidget {
  const SafeAudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Audio'),
      ),
      body: const Center(
        child: Text('Safe Audio Page'),
      ),
    );
  }
}

// class FakeCallPage extends StatelessWidget {
//   const FakeCallPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fake Call'),
//       ),
//       body: const Center(
//         child: Text('Fake Call Page'),
//       ),
//     );
//   }
// }

class TriggerPage extends StatelessWidget {
  const TriggerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trigger'),
      ),
      body: const Center(
        child: Text('Trigger Page'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.purple),
    home: const SettingsPage(),
  ));
}
