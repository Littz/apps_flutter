import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';

class WebviewBixon extends StatefulWidget {
  final url, title;
  WebviewBixon(this.url, this.title);
  @override
  _WebviewBixonState createState() => _WebviewBixonState(this.url, this.title);
}

class _WebviewBixonState extends State<WebviewBixon> {
  var _url, _title;
  _WebviewBixonState(this._url, this._title);
  String selectedUrl = '';

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _history = [];

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _url = widget.url;

    print("URL Init: $_url");

    flutterWebViewPlugin.close();

    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        _scaffoldKey.currentState.showSnackBar(const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
          print("URL changed: $url");
        });
      }
    });

    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
          print("URL state changed: ${state.url}");
          print("URL state type: ${state.type}");

          /*if (state.url.contains('/order/success')) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'success')),);
          } else if (state.url.contains('/order/failed')) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
          }*/

        });
      }
    });
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _history.clear();

    super.dispose();
    flutterWebViewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: _url,
      appBar: new PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            /*title: new Text('',
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Color(0xff084B8C), fontSize: 18),
              ),
            ),*/
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(_title),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,

      initialChild: Container(
        child: const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xff357FEB)),
              strokeWidth: 1.7
          ),
        ),
      ),
    );
  }
}