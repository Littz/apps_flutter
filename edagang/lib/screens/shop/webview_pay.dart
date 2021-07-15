import 'dart:async';
import 'dart:io';
import 'package:edagang/screens/shop/payment_status.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPayment extends StatefulWidget {
  final url, token, title, nett;
  WebViewPayment(this.url, this.token, this.title, this.nett);
  @override
  createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  final _scaffoldKeyFpx = GlobalKey<ScaffoldState>();
  String _url, _token, _title, _nett, _addr;
  String selectedUrl = '';

  SharedPref sharedPref = SharedPref();
  bool _isLoading;
  final _key = UniqueKey();
  Completer<WebViewController> _controller = Completer<WebViewController>();

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    print('webview url state change ################################');
    print(request.url.toString());
    if (request.url.contains("/order/success")) {
      print('Success Payment ');
      print(request.url.toString());

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'success')),);
      return NavigationDecision.prevent;
    }
    if (request.url.contains("/order/failed")) {
      print('Unsuccesful/cancel Payment');
      print(request.url.toString());

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Cartsini_Online_Payment',parameters:null);
    super.initState();
    _title = widget.title;
    _nett = widget.nett;
    _url = widget.url;
    _token = widget.token;

    _isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        key: _scaffoldKeyFpx,
        onWillPop: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
          return null;
        },
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(_title.toUpperCase(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                    textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),
                  ),
                ),
              ),
              SizedBox(width: 16,),
            ],
          ),
          body: Stack(
            children: <Widget>[
              new WebView(
                key: _key,
                initialUrl: _url,
                //headers: {'Authorization' : 'Bearer '+ _token,},
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  Map<String, String> headers = {"Authorization": "Bearer " + _token};
                  webViewController.loadUrl(_url, headers: headers);
                  _controller.complete(webViewController);
                },

                debuggingEnabled: true,
                navigationDelegate: this._interceptNavigation,
                gestureNavigationEnabled: true,
                onPageFinished: (finish) {
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
              _isLoading ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Color(0xff006FBD)),
                            strokeWidth: 1.7
                        ),
                      ),
                      Text(
                        'Loading..',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff006FBD)),
                        ),
                      ),
                    ],
                  )
              ) : Container(),
            ],
          ),
        )

    );
  }

}