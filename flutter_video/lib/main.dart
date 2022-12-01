import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_video/videoCapture.dart';
import 'package:flutter_video/videoPlayer.dart';

Future<void> main() async {
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
    return SingleChildScrollView(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            msg,
          ),
          ElevatedButton(
            child: const Text('Capture Video'),
            onPressed: () => _navigateToVideoCapture(context),
          ),
          ElevatedButton(
            child: const Text('Run Test'),
            onPressed: () => _runTest(context),
          ),
          if (videoFile != null)
            VideoPlayerScreen(videoFile: File(videoFile!.path)),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _navigateToVideoCapture(BuildContext context) async {
    reset();
    final XFile result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => VideoCapture()));
    if (!mounted) return;

    final message = "Video captured ${result.path}";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      msg = message;
      videoFile = result;
    });
  }

  Future<void> _runTest(BuildContext context) async {
    reset();
    Stopwatch watch = Stopwatch()..start();
    final XFile result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => VideoCapture(runTest: true)));
    if (!mounted) return;

    final message =
        "Test took ${watch.elapsedMilliseconds} ms which is ${watch.elapsedMilliseconds - VideoCapture.recordingTime} ms more than the targetCaptureTime of ${VideoCapture.recordingTime} ms";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      msg = message;
      videoFile = result;
    });
  }

  void reset() {
    setState(() {
      msg = "";
      videoFile = null;
    });
  }
}
