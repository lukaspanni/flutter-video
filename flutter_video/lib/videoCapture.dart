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
    //Controllable resolution Preset!
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.max);
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

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: CameraPreview(cameraController),
        ),
        ElevatedButton(
          child: Text(!cameraController.value.isRecordingVideo
              ? 'Capture Video'
              : 'Stop Recording'),
          onPressed: () => _handleClick(context),
        ),
      ],
    ));
  }

  Future<void> _handleClick(BuildContext context) async {
    if (!cameraController.value.isRecordingVideo) {
      try {
        await cameraController.startVideoRecording();
        setState(() => {}); // force text update
      } catch (e) {
        print(e);
      }
    } else {
      try {
        final XFile result = await cameraController.stopVideoRecording();
        setState(() => {}); // force text updater
        if (!mounted) return;
        Navigator.pop(context, result);
      } catch (e) {
        print(e);
      }
    }
  }
}
