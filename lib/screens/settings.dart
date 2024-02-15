import 'package:diva/screens/add_contacts.dart';
import 'package:diva/screens/contacts_screen.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: AssetImage('assets/front_image.jpeg'),
                    ),
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
                          '(+91)123 456 7890',
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
                SizedBox(height: 20),
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
                    builder: (context) => TimelyLocationUpdatePage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.shield),
            title: const Text('Safe Shake'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SafeShakePage()),
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
                MaterialPageRoute(builder: (context) => SafeAudioPage()),
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
                MaterialPageRoute(builder: (context) => FakeCallPage()),
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
                MaterialPageRoute(builder: (context) => TriggerPage()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Add logout functionality here
            },
          ),
        ],
      ),
    );
  }
}

// Sample pages for each feature
class EditEmergencyContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Emergency Contacts'),
      ),
      body: const Center(
        child: Text('Edit Emergency Contacts Page'),
      ),
    );
  }
}

class TimelyLocationUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timely Location Update'),
      ),
      body: const Center(
        child: Text('Timely Location Update Page'),
      ),
    );
  }
}

class SafeShakePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Shake'),
      ),
      body: const Center(
        child: Text('Safe Shake Page'),
      ),
    );
  }
}

class SafeAudioPage extends StatelessWidget {
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

class FakeCallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Call'),
      ),
      body: const Center(
        child: Text('Fake Call Page'),
      ),
    );
  }
}

class TriggerPage extends StatelessWidget {
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
    home: SettingsPage(),
  ));
}
