import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube/models/channel_info.dart';
import 'package:youtube/models/video_list.dart';
import 'package:youtube/screens/video_screen.dart';
import 'package:youtube/screens/webView.dart';
import 'package:youtube/utils/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChannelInfo _channelInfo;
  VideosList _videosList;
  Item _item;
  bool _loading;
  String _playListId;
  String _nextPageToken;
  ScrollController _scrollController;

  final dateFormat = new DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _loading = true;
    _nextPageToken = '';
    _scrollController = ScrollController();
    _videosList = VideosList();
    _videosList.videos = [];
    _getChannelInfo();
  }

  _getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    print('_playListId $_playListId');
    await _loadVideos();
    setState(() {
      _loading = false;
    });
  }

  _loadVideos() async {
    VideosList tempVideosList = await Services.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    _nextPageToken = tempVideosList.nextPageToken;
    _videosList.videos.addAll(tempVideosList.videos);
    print('videos: ${_videosList.videos.length}');
    print('_nextPageToken $_nextPageToken');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: _loading
              ? Text('Loading...')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "Youtube",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      "Flutter",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                )
          // title: Text(_loading ? 'Loading...' : 'YouTubeFlutter'),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInfoView(),
            NotificationListener<ScrollEndNotification>(
              onNotification: (ScrollNotification notification) {
                if (_videosList.videos.length >=
                    int.parse(_item.statistics.videoCount)) {
                  return true;
                }
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  _loadVideos();
                }
                return true;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _videosList.videos.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  VideoItem videoItem = _videosList.videos[index];
                  return InkWell(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VideoPlayerScreen(
                          videoItem: videoItem,
                        );
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
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
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: videoItem
                                .video.thumbnails.thumbnailsDefault.url,
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  videoItem.video.title,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Published on: ${dateFormat.format(videoItem.video.publishedAt)}",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            !_loading
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(10),
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
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => webView()));
                      },
                      child: const Text(
                        'Search in Youtube',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _buildInfoView() {
    return _loading
        ? Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.8,
            child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      //bottom
                      color: Colors.black54,
                      offset: Offset(5, 5),
                      blurRadius: 6.0,
                    ),
                    BoxShadow(
                      //top
                      color: Colors.grey[800],
                      offset: Offset(-5, -5),
                      blurRadius: 6.0,
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: CachedNetworkImageProvider(
                      _item.snippet.thumbnails.medium.url,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _item.snippet.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text('Videos: ${_item.statistics.videoCount}',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  Text('Subscribers: ${_item.statistics.subscriberCount}',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  Text(_item.snippet.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          );
  }
}