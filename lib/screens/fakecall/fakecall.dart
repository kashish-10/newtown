import 'package:diva/screens/fakecall/incoming_call.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class FakeCallPage extends StatefulWidget {
  const FakeCallPage({super.key});

  @override
  State<FakeCallPage> createState() => _FakeCallPageState();
}

class _FakeCallPageState extends State<FakeCallPage> {
  var uuid = const Uuid();
  late AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1nstagram'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/background_image.jpg',
            fit: BoxFit.cover,
          ),
          // "Call Me" Button
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                _assetsAudioPlayer.open(Audio('assets/ringtone.mp3'));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomingCallPage(_assetsAudioPlayer),
                  ),
                );
              },
              child: const Text('call me'),
            ),
          ),
        ],
      ),
    );
  }
}
