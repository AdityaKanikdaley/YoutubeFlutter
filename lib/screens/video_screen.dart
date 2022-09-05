import 'package:flutter/material.dart';
import 'package:youtube/models/video_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({this.videoItem});

  final VideoItem videoItem;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.video.resourceId.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {}
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title:
            Text(widget.videoItem.video.title, style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                  _isPlayerReady = true;
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      //bottom
                      color: Colors.black54,
                      offset: Offset(5, 5),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      //top
                      color: Colors.grey[800],
                      offset: Offset(-4, -4),
                      blurRadius: 6.0,
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.videoItem.video.title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Text("Description:",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(widget.videoItem.video.description,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}