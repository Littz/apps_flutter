import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_home.dart';
import 'package:edagang/screens/biz/biz_vr_list.dart';
import 'package:edagang/settings.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:edagang/widgets/webview_bb.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class BizPage extends StatefulWidget {
  final TabController tabcontroler;
  BizPage({this.tabcontroler});

  @override
  _BizIdxPageState createState() => _BizIdxPageState();
}

class _BizIdxPageState extends State<BizPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  String _selectedItem = 'Notification';
  String _logType,_photo = "";

  loadPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _logType = prefs.getString("login_type");
        _photo = prefs.getString("photo");
        print("Sosmed photo : "+_photo);
      });

    } catch (Excepetion ) {
      print("error!");
    }
  }

  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  int _currentIndex = 0;
  PageController _pageController = PageController(
    viewportFraction: 0.92,
    initialPage: 0,
  );

  goToNextPage(BuildContext context, Home_banner item) {
    String imgurl = 'https://bizapp.e-dagang.asia'+item.imageUrl;
    String catname = item.title ?? '';
    String catid = item.itemId.toString();
    String ctype = item.type.toString();
    String vrurl = item.link_url;
    if(ctype == "1") {
      print('PRODUCT #############################################');
    } else if (ctype == "2") {
      print('CATEGORY ############################################');
      print(catid);
      print(catname);
      //Navigator.push(context, SlideRightRoute(page: ProductListCategory(catid, catname)));
    } else if (ctype == "3") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(catid,'')));
      });
    } else if (ctype == "4") {
      FirebaseAnalytics().logEvent(name: 'Blackbixon_form',parameters:null);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, SlideRightRoute(page: WebviewBixon(vrurl ?? '', imgurl ?? '')));
      });
    }
  }

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() => _currentIndex = _pageController.page.round());
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
    loadPhoto();
    FirebaseAnalytics().logEvent(name: 'Smartbiz_Home',parameters:null);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future launchVr(String url) async {
    if (await canLaunch(url)) await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model) {
        return WillPopScope(
          key: _scaffoldKey,
          onWillPop: () {
            //Navigator.of(context,rootNavigator: true).pop();
            //Navigator.of(context).pop();
            SystemNavigator.pop();
            return Future.value(true);
          },
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Image.asset('assets/icons/ic_smartbiz.png', height: 24, width: 107,),
                  pinned: true,
                  floating: true,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: 10,),
                      child: model.isAuthenticated ?
                        _logType == '0' ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.fill, height: 27, width: 27),
                        ) : Container(
                          height: 28.0,
                          width: 28.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              //fit: BoxFit.fill,
                              image: NetworkImage(_photo),
                              //scale: 30,
                            ),
                          ),
                        )
                      : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.power,
                            color: Color(0xff084B8C),
                          ),
                          onPressed: () {
                              Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          },
                        ),
                      ),
                    ),
                  ],
                  bottom: AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: Container(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: searchBar(context),
                          ),
                          SizedBox(width: 8,),
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.bell_fill,
                                color: Color(0xff084B8C),
                              ),
                              onPressed: () {
                                  Navigator.push(context, SlideRightRoute(page: NotificationPage()));
                              },
                            ),
                          ),
                          SizedBox(width: 2,),
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Color(0xff084B8C),),
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(child: ListTile(
                                  title: Text('Join Us'),
                                ), value: "1"),
                                PopupMenuItem(child: ListTile(
                                  title: Text('Settings'),
                                ), value: "2"),
                                PopupMenuItem(child: model.isAuthenticated ? ListTile(
                                  title: Text('Logout'),
                                ) : ListTile(
                                  title: Text('Login'),
                                ), value: model.isAuthenticated ? "3" : "4"),
                              ],

                              onSelected: (value) {
                                setState(() {
                                  _selectedItem = value;
                                  print("Selected context menu: $_selectedItem");
                                  if(_selectedItem == '1'){
                                      FirebaseAnalytics().logEvent(name: 'JoinUs_form',parameters:null);
                                      Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));
                                  }
                                  if(_selectedItem == '2'){
                                      Navigator.push(context, SlideRightRoute(page: SettingPage()));
                                  }
                                  if(_selectedItem == '3'){
                                      FirebaseAnalytics().logEvent(name: 'Logout_app',parameters:null);
                                      logoutUser(context, model);
                                  }
                                  if(_selectedItem == '4'){
                                      FirebaseAnalytics().logEvent(name: 'Login_page',parameters:null);
                                      Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: CustomScrollView(slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      elevation: 1,
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: Container(
                          height: 138.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Swiper(
                            autoplay: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  goToNextPage(context, model.bbanners[index]);
                                },
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  child: Center(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.transparent,
                                        child: CupertinoActivityIndicator(radius: 15,),
                                      ),
                                      imageUrl: 'http://bizapp.e-dagang.asia' + model.bbanners[index].imageUrl,
                                      fit: BoxFit.fill,
                                      height: 138,
                                      width: MediaQuery.of(context).size.width,
                                    )
                                  ),
                                ),
                              );
                            },
                            itemCount: model.bbanners.length,
                            pagination: new SwiperPagination(
                              builder: new DotSwiperPaginationBuilder(
                                activeColor: Colors.deepOrange.shade500,
                                activeSize: 7.0,
                                size: 7.0,
                              )
                            ),
                          )
                        )
                      )
                    )
                  )
                ),
              ])),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Biz Category',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff084B8C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: model.bcategory.length == 0 ? Container() : _fetchCategories(),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Virtual Trade',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff084B8C),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0,),
                        child: InkWell(
                          highlightColor: Colors.blue.shade100,
                          splashColor: Colors.blue.shade100,
                          onTap: () {
                            Navigator.push(context,SlideRightRoute(page: BizVrListPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'More ',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff357FEB)),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.right_chevron,
                                size: 17,
                                color: Color(0xff357FEB),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: model.bvirtual.length == 0 ? Container() : _fetchVirtualList(),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 24, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Highlighted Company',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff084B8C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              topList(),

            ]),
          )
        );
      }
    );
  }

  Widget _fetchCategories() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 0),
            color: Colors.transparent,
            height: 145,
            alignment: Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: model.bcategory.length,
              itemBuilder: (context, index) {
                var data = model.bcategory[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      print("category name : " + data.cat_name);
                      Navigator.push(context, SlideRightRoute(page: BizCategoryPage(data.cat_id.toString(),data.cat_name)));
                    },
                    child: Container(
                      height: 145,
                      width: 100,
                      alignment: Alignment.bottomCenter,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        image: new DecorationImage(
                          image: CachedNetworkImageProvider('http://bizapp.e-dagang.asia' + data.cat_image ?? ''),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        width: 100.0,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.all(2.5),
                        child: Stack(
                          children: <Widget>[
                            Text(data.cat_name ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 12,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 4
                                      ..color = Colors.white70, fontWeight: FontWeight.w600),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            Text(data.cat_name ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        )
                      )
                    ),
                  ),
                );
              },
            ),
          );
        }
    );
  }

  Widget _fetchVirtualList() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            height: MediaQuery.of(context).size.height * 0.25,
            alignment: Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: model.bvirtual[0].vr_list.length,
              itemBuilder: (context, index) {
                var data = model.bvirtual[0];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.6,
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
                        FirebaseAnalytics().logEvent(name: 'Biz_virtual_'+data.vr_list[index].vr_name,parameters:null);
                        launchVr(data.vr_list[index].vr_url);
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //height: 155,
                              //width: MediaQuery.of(context).size.width * 0.6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                child: CachedNetworkImage(
                                  imageUrl: 'https://bizapp.e-dagang.asia'+data.vr_list[index].vr_image ?? '',
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
                                  fit: BoxFit.cover,
                                  //height: 155,
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.6,
                              padding: EdgeInsets.only(left: 7.0,right: 7.0,top: 0.0),
                              alignment: Alignment.centerLeft,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.vr_list[index].vr_name ?? '',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600,),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                );
              }
            ),
          );
        }
    );
  }

  Widget topList() {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model) {
        return SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 1.5,
              crossAxisSpacing: 1.5,
              childAspectRatio: 0.815,
            ),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              var data = model.bbusiness[index];
              return InkWell(
                onTap: () {
                  sharedPref.save("biz_id", data.id.toString());
                  sharedPref.save("biz_name", data.company_name);
                  //FirebaseAnalytics().logEvent(name: 'Biz_company_'+data.company_name,parameters:null);
                  Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.company_name)));

                },
                child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            color: Colors.white,
                            child: Card(
                              color: Colors.white,
                              elevation: 0.0,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(7)
                                      ),
                                      child: data.logo == null ? Image.asset(
                                        'assets/icons/ic_launcher_new.png', height: 80.0, width: 80.0,
                                        fit: BoxFit.cover,)

                                          : CachedNetworkImage(
                                        fit: BoxFit.fitWidth,
                                        imageUrl: 'http://bizapp.e-dagang.asia'+data.logo ?? '',
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0)
                                            )
                                          ),
                                        ),
                                        placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                        errorWidget: (context, url, error) => Icon(Icons.image_rounded, size: 36,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(data.company_name,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 8.0)
                                ]
                              ),
                            ),
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: data.verify == 1 ? Padding(
                          padding: EdgeInsets.only(top: 5, right: 5),
                          child: Image.asset('assets/icons/verify.png', fit: BoxFit.cover, height: 21,),

                          /*Text('Verified',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                          ),*/
                        ) : Container(),
                      ),
                    ]
                  ),
                ),
              );
            },
              childCount: model.bbusiness.length,
            ),
          )
        );
      }
    );
  }

  logoutUser(BuildContext context, MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String logtype = prefs.getString('login_type');

    Map<String, String> headers = await getHeaders();
    http.get(Constants.apiLogout, headers: headers).then((response) {
      prefs.remove('token');
      model.loggedInUser();
    });

    if(logtype == '1') {
      _googleSignIn.signOut();
    }else if(logtype == '2') {
      facebookLogin.logOut();
    }
    Navigator.of(context).pushReplacementNamed("/Main");
  }

  Future<Map<String, String>> getHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token-type': 'Bearer',
      'ng-api': 'true',
      'auth-token': prefs.getString('token') == null ? Constants.tokenGuest : prefs.getString('token'),
      'Guest-Order-Token': Constants.tokenGuest
    };
    return headers;
  }
}

