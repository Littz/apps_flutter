import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      /*onProgress: (int progress) {
        print("Loading (progress : $progress%)");
      },*/

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


class WebViewPage extends StatefulWidget {
  final url,title;
  WebViewPage(this.url, this.title);

  @override
  _WebViewPageState createState() => _WebViewPageState(this.url, this.title);
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  var _url, _title;
  _WebViewPageState(this._url, this._title);
  bool _isLoading;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        elevation: 1.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Color(0xff084B8C),
        ),
        title: new Text(_title,
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
      ),
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Stack(
          children: <Widget>[
            new WebView(
              key: _key,
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
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


class WebViewBb extends StatefulWidget {
  final url,image;
  WebViewBb(this.url, this.image);

  @override
  _WebViewBbPageState createState() => _WebViewBbPageState(this.url, this.image);
}

class _WebViewBbPageState extends State<WebViewBb> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  var _url, _image;
  _WebViewBbPageState(this._url, this._image);
  bool _isLoading;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(_image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
      ),
      body: Stack(
        children: <Widget>[
          new WebView(
            key: _key,
            initialUrl: _url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
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
    );
  }
}