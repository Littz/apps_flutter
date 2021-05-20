import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/video_play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'widgets/page_slide_right.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, _model)
    {
      return Scaffold(
        appBar: AppBar(
          title: Text('Video Gallery',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,),
            ),
          ),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            var data = _model.videoList[index];
            var d1 = data.link.split("v=");
            var vlink = d1[1];

            return Card(
              margin: EdgeInsets.all(5.0),
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 245,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, SlideRightRoute(page: VideoPlay(vlink.toString(),data.title)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 155,
                            alignment: Alignment.center,
                            child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                    child: CachedNetworkImage(imageUrl: 'http://img.youtube.com/vi/' + vlink + '/0.jpg',
                                      placeholder: (context, url) => Container(
                                        width: 30,
                                        height: 30,
                                        color: Colors.transparent,
                                        child: CupertinoActivityIndicator(radius: 15,),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                            'assets/icons/ic_image_error.png',
                                            fit: BoxFit.cover,
                                          ),
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
                                      //height: 260,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      CupertinoIcons.arrowtriangle_right_circle,
                                      color: Colors.white, size: 50,),
                                  ),
                                ]
                            ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.bottomLeft,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.title,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500,),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            /*Text(
                                      '',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),*/
                            /*SizedBox(height: 2,),
                            Text(
                              data.vr_desc,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w600,),
                              ),
                            ),*/
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            );

            /*return Container(
                height: 265,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                  ),
                  elevation: 1.0,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    onTap: () {
                      Navigator.push(context, SlideRightRoute(
                          page: VideoPlay(vlink.toString(),data.title)));
                    },
                    child: Stack(
                        children: [
                          Container(
                            //height: 260,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8)),
                              child: CachedNetworkImage(
                                imageUrl: 'http://img.youtube.com/vi/' +
                                    vlink + '/0.jpg',
                                placeholder: (context, url) =>
                                    Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.transparent,
                                      child: CupertinoActivityIndicator(
                                        radius: 15,),
                                    ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      'assets/icons/ic_image_error.png',
                                      fit: BoxFit.cover,
                                    ),
                                fit: BoxFit.fill,
                                //height: 260,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              CupertinoIcons.arrowtriangle_right_circle,
                              color: Colors.white, size: 50,),
                          ),
                        ]
                    ),
                  ),
                )
            );*/
          },
          itemCount: _model.videoList.length,
          separatorBuilder: (context, _) => const SizedBox(height: 4.0),
        ),
      );
    });
  }
}


