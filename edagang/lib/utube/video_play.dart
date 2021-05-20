import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPlay extends StatefulWidget {
  String vid,title;
  VideoPlay(this.vid, this.title);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {

  YoutubePlayerController _controller;
  bool _isPlayerReady;

  Future<VideoY> fetchSnippet() async {
    final response = await http.get(
      Uri.parse('https://noembed.com/embed?url=https://www.youtube.com/watch?v=tUCC4TOBOQQ'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final responseJson = jsonDecode(response.body);
    return VideoY.fromMap(responseJson);
  }

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Video_player',parameters:null);
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.vid,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
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
    return WillPopScope(
      onWillPop: () {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new VideoList()),);
        Navigator.pop(context);
        return Future.value(true);
        /*SystemNavigator.pop();
        return Future.value(true);*/
      },
      child: OrientationBuilder(builder:
          (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            backgroundColor: Colors.black87,
            body: Container(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                  _isPlayerReady = true;
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 10,),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: Icon(
                       Icons.share,
                        color: Colors.deepOrange.shade500,
                      ),
                      onPressed: ()  async {
                        await FlutterShare.share(
                          title: 'Cartsini Video',
                          text: '',
                          linkUrl: 'https://shopapp.e-dagang.asia/video/'+widget.vid,
                          chooserTitle: widget.title ?? '',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {
                      print('Player is ready.');
                      _isPlayerReady = false;
                    },
                  ),
                ),
                Container(
                  child: Text(
                    '',
                  ),
                ),
              ],
            )
          );
        }
      }),
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
            _isPlayerReady = true;
          },
        ),
      ),
    );*/
  }
}

class VideoY {
  //final String id;
  final String title;
  final String thumbnailUrl;
  final int thumbnailWidth;
  final int thumbnailHeight;
  final String authorName;

  VideoY({
    //this.id,
    this.authorName,
    this.thumbnailUrl,
    this.thumbnailWidth,
    this.thumbnailHeight,
    this.title,
  });

  factory VideoY.fromMap(Map<String,dynamic> snippet){
    return VideoY(
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnail_url'],
      authorName: snippet['author_name'],
      thumbnailWidth: snippet['thumbnail_width'],
      thumbnailHeight: snippet['thumbnail_height'],
    );
  }
}
