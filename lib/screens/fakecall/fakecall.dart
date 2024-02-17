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
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Your home page content here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _assetsAudioPlayer.open(Audio('assets/ringtone.mp3'));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IncomingCallPage(_assetsAudioPlayer)),
          );
        },
        child: const Text('call me'),
      ),
    );
  }
}
