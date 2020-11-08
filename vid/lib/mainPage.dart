import 'package:fire/video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
//import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'camera.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  double volumeValue = 100;
  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        //aspectRatio: 3 / 2,
        autoPlay: true,
        allowFullScreen: true
        //looping: true,
        );

    _chewieController.setVolume(100.0);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        child: Column(
           //mainAxisAlignment: MainAxisAlignment.center,
           //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           /* Container(
              child: Text(
                widget.user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),*/
            Container(height:10),
            Container(
              child: OutlineButton(
                child: Text("LogOut"),
                onPressed: () {
                  _signOut().whenComplete(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FirebaseAuthDemo()));
                  });
                },
              ),
            ),
            Expanded(
             // child: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
           //   ),
            ),
            Slider(
              min: 0,
              max: 100,
              value: volumeValue,
              onChanged: (value) {
                setState(() {
                  volumeValue = value;
                });
                _videoPlayerController1.setVolume(volumeValue);
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(240, 10, 10, 10),
              child: CameraWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}
