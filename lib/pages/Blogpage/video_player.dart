import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  final String? videoUrl;
  const ChewieDemo({super.key, this.videoUrl});

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController1 = VideoPlayerController.networkUrl(Uri.parse((widget
                .videoUrl?.isNotEmpty ??
            false)
        ? widget.videoUrl.toString()
        : 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'));
    _videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse(
        'https://www.sample-videos.com/video123/mp4/480/big_buck_bunny_480p_20mb.mp4'));
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1!,
        aspectRatio: 3 / 1,
        autoPlay: true,
        looping: true,
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext? context, Widget? child) {
              return VideoScaffold(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: Container(
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: provider,
                  ),
                ),
              );
            },
          );
        }
        // Try playing around with some of these other options:

        // showControls: false,
        // materialProgressColors: ChewieProgressColors(
        //   playedColor: Colors.red,
        //   handleColor: Colors.blue,
        //   backgroundColor: Colors.grey,
        //   bufferedColor: Colors.lightGreen,
        // ),
        // placeholder: Container(
        //   color: Colors.grey,
        // ),
        // autoInitialize: true,
        );
  }

  @override
  void dispose() {
    _videoPlayerController1?.dispose();
    _videoPlayerController2?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: _chewieController!,
      ),
    );
  }
}

class VideoScaffold extends StatefulWidget {
  const VideoScaffold({super.key, this.child});

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _VideoScaffoldState();
}

class _VideoScaffoldState extends State<VideoScaffold> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
