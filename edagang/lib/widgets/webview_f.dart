import 'dart:async';
import 'dart:io';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class VirtualWebView extends StatefulWidget {
  final url, title;
  VirtualWebView(this.url, this.title);
  @override
  _VirtualWebViewState createState() => _VirtualWebViewState(this.url, this.title);
}

class _VirtualWebViewState extends State<VirtualWebView> {
  var _url, _title;
  _VirtualWebViewState(this._url, this._title);
  String selectedUrl = '';
  num pos = 1;
  SharedPref sharedPref = SharedPref();
  bool _isLoading;
  final _key = UniqueKey();
  Completer<WebViewController> _controller = Completer<WebViewController>();

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    print('WEBVIEW url state change ################################');
    print(request.url.toString());
    if (request.url.contains("shopapp.e-dagang.asia/merchant")) {
      print('WEBVIEW url merchant //////////////////////////////////');
      print(request.url.toString());

      String mid = request.url.toString().split('/')[4];
      print(mid);

      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListMerchant(mid,'')));
      return NavigationDecision.prevent;
    }
    if (request.url.contains("shopapp.e-dagang.asia/product")) {
      print('WEBVIEW url product //////////////////////////////////');
      print(request.url.toString());

      String pid = request.url.toString().split('/')[4];
      print(pid);

      sharedPref.save("prd_id", pid);
      sharedPref.save("prd_title", '');
      Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  _buildWebview() {
    return WebView(
      initialUrl: _url,
      javascriptMode: JavascriptMode.unrestricted,
      onProgress: (int progress) {
        print("Loading (progress : $progress%)");
      },
      navigationDelegate: this._interceptNavigation,
      gestureNavigationEnabled: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title),
      ),
      body: _buildWebview(),
    );*/

    /*return Scaffold(
      body: IndexedStack(
        index: pos,
        children: <Widget>[
          WebView(
            initialUrl: _url,
            javascriptMode: JavascriptMode.unrestricted,
            onProgress: (int progress) {
              print("Loading (progress : $progress%)");
            },
            navigationDelegate: this._interceptNavigation,
            gestureNavigationEnabled: true,
            onPageStarted: (value) {
              setState(() {
                pos = 1;
              });
            },
            onPageFinished: (value) {
              setState(() {
                pos = 0;
              });
            },
          ),
          Container(
            child: Center(child: CircularProgressIndicator(strokeWidth: 1.5,)),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context,rootNavigator: true).pop();
          //Navigator.of(context).pop();
        },
        icon: Icon(Icons.close),
        label: Text("Close",
          style: GoogleFonts.lato(
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),
          ),
        ),
      ),

    );*/

    return Scaffold(
      body: Stack(
        children: <Widget>[
          new WebView(
            key: _key,
            initialUrl: _url,
            //headers: {'Authorization' : 'Bearer '+ _token,},
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewCreate) {
              _controller.complete(webViewCreate);
            },
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
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.xmark,
                  color: Color(0xff084B8C),
                ),
                onPressed: () {
                  Navigator.of(context,rootNavigator: true).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}