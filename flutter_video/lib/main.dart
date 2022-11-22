import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_video/videoCapture.dart';
import 'package:flutter_video/videoPlayer.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  // wait for initialization before accessing cameras
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  print(cameras);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Video App'),
          ),
          body: const VideoContainer()),
    );
  }
}

class VideoContainer extends StatefulWidget {
  const VideoContainer({super.key});

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  String msg = "";
  XFile? videoFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            msg,
          ),
          ElevatedButton(
            child: Text('Capture Video'),
            onPressed: () => _navigateToVideoCapture(context),
          ),
          if (videoFile != null)
            VideoPlayerScreen(videoFile: File(videoFile!.path)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _navigateToVideoCapture(BuildContext context) async {
    final XFile result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoCapture(cameras: cameras)));
    if (!mounted) return;

    final message = "Video captured ${result.path}";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      msg = message;
      videoFile = result;
    });
  }
}
