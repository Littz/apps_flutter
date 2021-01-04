import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';

const kAndroidUserAgent = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://devmain.e-dagang.asia/public/virtualshow/index.htm';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();


class VirtualShowRoom extends StatefulWidget {
  final url, title;
  VirtualShowRoom(this.url, this.title);
  @override
  _VirtualShowRoomState createState() => _VirtualShowRoomState(this.url, this. title);
}

class _VirtualShowRoomState extends State<VirtualShowRoom> {
  var _url, _title;
  _VirtualShowRoomState(this._url, this._title);
  String selectedUrl = '';

  final flutterWebViewPlugin = new FlutterWebviewPlugin();


  // On destroy stream
  StreamSubscription _onDestroy;
  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;
  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;
  //final _urlCtrl = TextEditingController(text: selectedUrl);
  //final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _history = [];

  @override
  void initState() {

    super.initState();
    _title = widget.title;
    _url = widget.url;

    print("URL Init: $_url");

    flutterWebViewPlugin.close();

    /*_urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });*/

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
          if (mounted) {
            setState(() {
              _history.add('onProgressChanged: $progress');
            });
          }
        });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
          if (mounted) {
            setState(() {
              _history.add('Scroll in Y Direction: $y');
            });
          }
        });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
          if (mounted) {
            setState(() {
              _history.add('Scroll in X Direction: $x');
            });
          }
        });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            setState(() {
              _history.add('onStateChanged: ${state.type} ${state.url}');
            });
          }
        });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
          if (mounted) {
            setState(() {
              _history.add('onHttpError: ${error.code} ${error.url}');
            });
          }
        });

  }


  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      //key: _scaffoldKey,
      url: _url,
      userAgent: kAndroidUserAgent,
      clearCookies: false,
      clearCache: false,
      hidden: true,
      appCacheEnabled: true,
      supportMultipleWindows: true,

      //javascriptChannels: jsChannels,
      //mediaPlaybackRequiresUserGesture: false,
      /*appBar: new PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: new AppBar(
            centerTitle: false,
            elevation: 1.0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: new Text(_title,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.white,),
              ),
            ),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xff2877EA),
                        Color(0xffA0CCE8),
                      ]
                  ),
                )
            ),
          )
      ),*/
      //withJavascript: true,
      //withLocalUrl: true,
      ////withZoom: true,
      ////withLocalStorage: true,
      ////hidden: true,
      //clearCache: true,
      //clearCookies: true,
      //enableAppScheme: true,
      //displayZoomControls: true,
      //withOverviewMode: true,
      //supportMultipleWindows: true,
      //appCacheEnabled: true,
      //allowFileURLs: true,
      //useWideViewPort: true,

      initialChild: Container(
        child: const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xffC62132)),
              strokeWidth: 1.5
          ),
        ),
      ),
    );
  }
}