import 'dart:async';

import 'package:dinokino_tablet/components/rating_dialog.dart';
import 'package:dinokino_tablet/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.movie});
  final Movie movie;
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoPlayerController videoPlayerController =
      VideoPlayerController.asset("assets/videos/video_dinosaurs.mp4");
  late final Timer timer;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: GestureDetector(
                onTap: () {
                  if (videoPlayerController.value.isPlaying) {
                    setState(() {
                      videoPlayerController.pause();
                    });
                  } else {
                    setState(() {
                      videoPlayerController.play();
                    });
                  }
                },
                child: VideoPlayer(videoPlayerController),
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 24,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    Get.back(
                      result: {'isFromVideo': true, 'movie': widget.movie},
                    );
                    Get.dialog(RatingDialog(movie: widget.movie));
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            left: 48,
            right: 48,
            bottom: 32,
            height: 100,
            child: Row(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xff00C8C4)),
                  ),
                  onPressed: () {
                    if (videoPlayerController.value.isPlaying) {
                      setState(() {
                        videoPlayerController.pause();
                      });
                    } else {
                      setState(() {
                        videoPlayerController.play();
                      });
                    }
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                Stack(
                  children: [
                    Container(
                      height: 10,
                      width: Get.width * .5,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                    Container(
                      height: 10,
                      width: getProgressWidth(),
                      decoration: BoxDecoration(color: Color(0xff00C8C4)),
                    ),
                  ],
                ),
                Text(timeRemaining()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void init() async {
    timer = Timer.periodic(1.seconds, (_) {
      setState(() {});
    });
    try {
      setState(() {});
      await videoPlayerController.initialize();
      await videoPlayerController.play();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double getProgressWidth() {
    if (videoPlayerController.value.duration.inSeconds == 0) return 0;
    return (Get.width * .5) *
        (videoPlayerController.value.position.inSeconds /
            videoPlayerController.value.duration.inSeconds);
  }

  String timeRemaining() {
    final remaining =
        videoPlayerController.value.duration -
        videoPlayerController.value.position;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
