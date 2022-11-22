import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;
  const VideoPlayerScreen({Key? key, required this.videoFile})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.file(widget.videoFile)
      ..setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 500,
                  child: Stack(children: [
                    AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: VideoProgressIndicator(videoController,
                            allowScrubbing: true)),
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(videoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          videoController.value.isPlaying
                              ? videoController.pause()
                              : videoController.play();
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: () {
                        setState(() {
                          videoController.seekTo(Duration.zero);
                        });
                      },
                    ),
                  ],
                )
              ],
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
