import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoPlay extends StatefulWidget {
  String vid,title;
  VideoPlay(this.vid, this.title);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Video_player',parameters:null);
    super.initState();

    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.vid,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(_listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;

        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      });
    } else if (_isPlayerReady && mounted && _controller.value.isFullScreen){
      setState(() {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              print('Settings Tapped!');
            },
          ),
        ],
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          FullScreenButton(),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) => Scaffold(
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
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _space,
                  _text('Title', _videoMetaData.title),
                  _space,
                  _text('Channel', _videoMetaData.author),
                  //_space,
                  //_text('Video Id', _videoMetaData.videoId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

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
