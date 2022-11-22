import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoCapture extends StatefulWidget {
  final List<CameraDescription> cameras;
  const VideoCapture({Key? key, required this.cameras}) : super(key: key);

  @override
  State<VideoCapture> createState() => _VideoCaptureState();
}

class _VideoCaptureState extends State<VideoCapture> {
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    return CameraPreview(cameraController);
  }
}
