import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class IncomingCallPage extends StatelessWidget {
  final AssetsAudioPlayer assetsAudioPlayer;

  const IncomingCallPage(this.assetsAudioPlayer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://media.istockphoto.com/vectors/purple-user-icon-in-the-circle-a-solid-gradient-vector-id1095289632?k=20&m=1095289632&s=612x612&w=0&h=_glHdsV95Q3uZHTpFNIeaJpzGMpy6fplJP5G6YUgfmk=',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'ServiceNow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Calling...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 80),
                  Icon(
                    Icons.mic_off,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 80),
                  Icon(
                    Icons.bluetooth,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 80),
                  Icon(
                    Icons.dialpad,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 90),
                  Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
              SizedBox(height: 100),
              SizedBox(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.call_end,
                      color: Colors.red,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
