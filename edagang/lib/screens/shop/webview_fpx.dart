import 'dart:async';
import 'package:edagang/screens/shop/payment_status.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';

class WebViewContainer extends StatefulWidget {
  final token;
  final url;
  final title, nett, addrs;
  WebViewContainer(this.url, this.token, this.title, this.nett, this.addrs);
  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url, _token;
  _WebViewContainerState(this._url);
  String _title, _nett, _addr;
  String selectedUrl = '';

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  final _scaffoldKeyFpx = GlobalKey<ScaffoldState>();
  final _history = [];

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Cartsini_Fpx_webview',parameters:null);
    super.initState();
    _title = widget.title;
    _nett = widget.nett;
    _addr = widget.addrs;
    _url = widget.url;
    _token = widget.token;

    print("URL Init: $_url");

    flutterWebViewPlugin.close();

    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        print('Webview Destroyed');
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

          if (state.url.contains('/order/success')) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'success')),);
          } else if (state.url.contains('/order/failed')) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
          }
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
    return WillPopScope(
        key: _scaffoldKeyFpx,
        onWillPop: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
          return null;
        },
        child: WebviewScaffold(
          url: _url,
          headers: {'Authorization' : 'Bearer '+ _token,},
          appBar: new AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*new Text(_title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontFamily: "Quicksand",
                  ),
                ),*/
                new Text(_addr,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            leading: IconButton(
                icon: Icon(CupertinoIcons.xmark, color: Colors.red,),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
                }
            ),
            actions: [
              Center(
                child: new Text('RM'+_nett,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,),
                  ),
                ),
              ),
              SizedBox(width: 16,),
            ],
          ),
          allowFileURLs: true,
          withJavascript: true,
          withLocalUrl: true,
          withZoom: true,
          withLocalStorage: true,
          hidden: true,
          clearCache: false,
          clearCookies: false,
          initialChild: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                ),
                Text(
                  'Loading...please wait!',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }

}