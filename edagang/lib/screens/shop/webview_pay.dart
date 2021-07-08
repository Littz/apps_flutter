import 'dart:async';
import 'dart:io';
import 'package:edagang/screens/shop/payment_status.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPayment extends StatefulWidget {
  final token;
  final url;
  final title, nett, addrs;
  WebViewPayment(this.url, this.token, this.title, this.nett, this.addrs);
  @override
  createState() => _WebViewPaymentState(this.url);
}

class _WebViewPaymentState extends State<WebViewPayment> {
  var _url, _token;
  _WebViewPaymentState(this._url);
  final _scaffoldKeyFpx = GlobalKey<ScaffoldState>();
  String _title, _nett, _addr;
  String selectedUrl = '';

  SharedPref sharedPref = SharedPref();
  bool _isLoading;
  final _key = UniqueKey();
  Completer<WebViewController> _controller = Completer<WebViewController>();

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    print('WEBVIEW url state change ################################');
    print(request.url.toString());
    if (request.url.contains("/order/success")) {
      print('WEBVIEW Payment //////////////////////////////////');
      print(request.url.toString());

      //String mid = request.url.toString().split('/')[4];
      //print(mid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'success')),);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListMerchant(mid,'')));
      return NavigationDecision.prevent;
    }
    if (request.url.contains("/order/failed")) {
      print('WEBVIEW Payment //////////////////////////////////');
      print(request.url.toString());

      //String pid = request.url.toString().split('/')[4];
      //print(pid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
      //sharedPref.save("prd_id", pid);
      //sharedPref.save("prd_title", '');
      //Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
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
    _addr = widget.addrs;
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
          body: Stack(
            children: <Widget>[
              new WebView(
                key: _key,
                initialUrl: _url,
                //headers: {'Authorization' : 'Bearer '+ _token,},
                javascriptMode: JavascriptMode.unrestricted,
                /*onWebViewCreated: (webViewCreate) {
                  _controller.complete(webViewCreate);
                },*/
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
              _isLoading ? Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator(strokeWidth: 1.5,),
              ) : Stack(),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.xmark,
                      color: Color(0xff084B8C),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new FpxStatus(status: 'failed')),);
                      //Navigator.of(context,rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        )

    );
  }

}