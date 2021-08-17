import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  const VideoPlayerScreen({Key key, this.videoUrl,this.title}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      '${widget.videoUrl}',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 20,),
                        Text("${widget.title}",style: TextStyle(color: AppTheme.black,
                          fontSize: 18,fontWeight: FontWeight.w600,fontFamily: AppConstants.fontName,),),

                      ],
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // If the video is playing, pause it.
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          // If the video is paused, play it.
                          _controller.play();
                        }
                        setState(() {
                        });
                      },
                      child: Icon(
                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.primaryColorDark,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}