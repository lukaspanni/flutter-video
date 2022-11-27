import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoCapture extends StatefulWidget {
  final List<CameraDescription> cameras;
  const VideoCapture({Key? key, required this.cameras}) : super(key: key);

  @override
  State<VideoCapture> createState() => _VideoCaptureState();
}

class _VideoCaptureState extends State<VideoCapture> {
  int cameraIndex = 0;
  late CameraController cameraController;
  late Future<void> initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera(widget.cameras[0]);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CameraPreview(cameraController),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(!cameraController.value.isRecordingVideo
                              ? 'Capture Video'
                              : 'Stop Recording'),
                          onPressed: () => _handleClick(context),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: changeCamera,
                                child: const Icon(Icons.change_circle))),
                      ],
                    )
                  ],
                )));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
        setState(() => {}); // force text update
        await storeVideo(result);
        if (!mounted) return;
        Navigator.pop(context, result);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> storeVideo(XFile video) async {
    video.saveTo(await buildPlatformSpecificPath(video));
    print('Video saved to ${video.path}');
  }

  void changeCamera() {
    cameraIndex = (cameraIndex + 1) % widget.cameras.length;
    print(cameraIndex);
    _initializeCamera(widget.cameras[cameraIndex]);
  }

  void _initializeCamera(CameraDescription camera) {
    cameraController = CameraController(camera, ResolutionPreset.max);
    initializeCameraControllerFuture = cameraController
        .initialize()
        .then((_) => setState(() {}))
        .catchError((e) => print(e));
  }

  void test() {
    //possible settings
    // cameraController.setExposureMode()
    // cameraController.setExposureOffset()
    // cameraController.setExposurePoint()
    // cameraController.setFlashMode(mode)
    // cameraController.setFocusMode(mode)
    // cameraController.setFocusPoint(point)
    // cameraController.setZoomLevel(level)

    //also resolution presets
    ResolutionPreset.low; // 320x240 (Android) 352x288 (iOS)
    ResolutionPreset.medium; // 720x480 (Android) 640x480 (iOS)
    ResolutionPreset.high; // 1280x720
    ResolutionPreset.veryHigh; // 1920x1080
    ResolutionPreset.ultraHigh; // 3840x2160
  }

  Future<String> buildPlatformSpecificPath(XFile video) async {
    String baseFolder = '';

    if (!Platform.isAndroid) {
      baseFolder = (await getApplicationDocumentsDirectory()).path;
    } else {
      baseFolder = '/storage/emulated/0/Documents';
    }
    String videoFolder = '$baseFolder/crossVideo';

    Directory dir = Directory(videoFolder);
    if (!await dir.exists()) await dir.create(recursive: true);
    return '$videoFolder/${video.name}';
  }
}
