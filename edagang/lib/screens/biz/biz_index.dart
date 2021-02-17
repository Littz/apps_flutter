import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_quick_access.dart';
import 'package:edagang/screens/biz/biz_vr_list.dart';
import 'package:edagang/screens/biz/webview_quot.dart';
import 'package:edagang/settings.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class BizPage extends StatefulWidget {
  final TabController tabcontroler;
  BizPage({this.tabcontroler});

  @override
  _BizIdxPageState createState() => _BizIdxPageState();
}

class _BizIdxPageState extends State<BizPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  BuildContext context;
  List<Menus> quick_menu = new List();
  List<Menus> tabs_menu = new List();
  String _selectedItem = 'Notification';
  List _options = ['Notification', 'Setting', 'About Us', 'Logout'];
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

  @override
  void initState() {
    quick_menu = getBizQxcess();
    tabs_menu = getBizTabs();
    super.initState();
    loadPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model) {
        return WillPopScope(key: _scaffoldKey, onWillPop: () {
          SystemNavigator.pop();
          return Future.value(true); },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(45.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title: searchBar(context),
                  /*flexibleSpace: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: searchBar(context),
                          ),
                          IconButton(
                            icon: Icon(CupertinoIcons.bars, color: Colors.grey.shade700,),
                            tooltip: 'Menu',
                            onPressed: () {myPopMenu();},
                          ),
                        ],
                      ),
                    ),
                  ),*/
                  actions: model.isAuthenticated ? [
                    Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.centerRight,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 0.5,
                            spreadRadius: 0.0,
                            offset: Offset(0.5, 0.5),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: _logType == '0' ? Icon(CupertinoIcons.person_fill, size: 36,  color: Colors.grey.shade600,) :
                        CachedNetworkImage(
                          imageUrl: _photo ?? '',
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        //Image.network(_photo ?? '', width: 36, height: 36,),
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (BuildContext bc) => [
                        PopupMenuItem(child: ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Notification'),
                        ), value: "1"),
                        PopupMenuItem(child: ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ), value: "2"),
                        PopupMenuItem(child: model.isAuthenticated ? ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                        ) : ListTile(
                          leading: Icon(Icons.login),
                          title: Text('Login'),
                        ), value: model.isAuthenticated ? "3" : "4"),
                      ],

                      onSelected: (value) {
                        setState(() {
                          _selectedItem = value;
                          print("Selected context menu: $_selectedItem");
                          if(_selectedItem == '1'){
                            Navigator.push(context, SlideRightRoute(page: NotificationPage()));
                          }
                          if(_selectedItem == '2'){
                            Navigator.push(context, SlideRightRoute(page: SettingPage()));
                          }
                          if(_selectedItem == '3'){
                            logoutUser(context, model);
                          }
                          if(_selectedItem == '4'){
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          }
                        });
                      },
                    ),
                  ] : [
                    PopupMenuButton(
                      itemBuilder: (BuildContext bc) => [
                        PopupMenuItem(child: ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Notification'),
                        ), value: "1"),
                        PopupMenuItem(child: ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ), value: "2"),
                        PopupMenuItem(child: model.isAuthenticated ? ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                        ) : ListTile(
                          leading: Icon(Icons.login),
                          title: Text('Login'),
                        ), value: model.isAuthenticated ? "3" : "4"),
                      ],

                      onSelected: (value) {
                        setState(() {
                          _selectedItem = value;
                          print("Selected context menu: $_selectedItem");
                          if(_selectedItem == '1'){
                            Navigator.push(context, SlideRightRoute(page: NotificationPage()));
                          }
                          if(_selectedItem == '2'){
                            Navigator.push(context, SlideRightRoute(page: SettingPage()));
                          }
                          if(_selectedItem == '3'){
                            logoutUser(context, model);
                          }
                          if(_selectedItem == '4'){
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.grey.shade100,
              body: CustomScrollView(slivers: <Widget>[
                SliverList(delegate: SliverChildListDelegate([
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 5),
                    child: Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        elevation: 1,
                        child: ClipPath(
                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: Container(
                            height: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Swiper.children(
                              autoplay: true,
                              pagination: new SwiperPagination(
                                margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                                builder: new DotSwiperPaginationBuilder(
                                    color: Colors.white30,
                                    activeColor: Colors.redAccent.shade400,
                                    size: 7.0,
                                    activeSize: 7.0
                                )
                              ),
                              children: <Widget>[
                                Image.asset(
                                  'assets/edagangcekap.png', height: 150.0,
                                  fit: BoxFit.fill,),
                                Image.asset(
                                  'assets/cartsinibiz1.png', height: 150.0,
                                  fit: BoxFit.fill,),

                              ],
                            ),
                          )
                        )
                      )
                    )
                  ),
                ])),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                    child: Text('Quick Access',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
                  sliver: quickLink(context),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 20),
                    height: 115,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,SlideRightRoute(page: BizVrListPage()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        elevation: 0.0,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ClipPath(
                            clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            child: Image.asset(
                              'assets/images/virtual_trade.png', fit: BoxFit.cover,
                              height: 115,
                            ),
                          )
                        )
                      )
                    )
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  sliver: gridMenu(context, widget.tabcontroler),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
                    child: Text('Most Visited',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
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

  Widget quickLink(BuildContext context) {
    if(quick_menu.length == 0) {
      return Container();
    }else{
      return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model){
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            var data = quick_menu[index];
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /*Container(
                    height: 32.0,
                    width: 32.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffA0CCE8),
                      border: new Border.all(color: Colors.grey, width: 1.0,),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(data.imgPath, height: 32, width: 32,),
                    ),
                  ),*/
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(1),
                      onPressed: () {
                        if (data.id == 1) {
                          Navigator.push(context,SlideRightRoute(page: BizCompanyPage()));
                        } else if (data.id == 2) {
                          Navigator.push(context, SlideRightRoute(page: BizProductPage('2', 'Product')));
                        } else if (data.id == 3) {
                          Navigator.push(context, SlideRightRoute(page: BizServicesPage('3', 'Services')));
                        } else if (data.id == 4) {
                          if(model.isAuthenticated) {
                            Navigator.push(context, SlideRightRoute(page: WebviewQuot('https://smartbiz.e-dagang.asia/biz/quot/' + model.getId().toString() + '/0', 'Quotation')));
                          }else{
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          }
                        } else if (data.id == 5) {
                          Navigator.push(context, SlideRightRoute(page: WebviewQuot('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));
                        }
                      },
                      //color: Color(0xffA0CCE8),
                      child: Image.asset(data.imgPath, height: 36, width: 36,),
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    height: 20.0,
                    child: Center(
                      child: Text(data.title,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        //style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
            childCount: quick_menu.length,
          ),
        );
      });
    }
  }

  Widget gridMenu(BuildContext context, TabController tabcontroler) {
    if(tabs_menu.length == 0) {
      return Container();
    }else{
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4),
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var data = tabs_menu[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
              child: InkWell(
                onTap: () {
                  widget.tabcontroler.animateTo(data.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: AssetImage(data.imgPath),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
              ),
            )
          );
        }, childCount: tabs_menu.length,
        ),
      );
    }
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
                  var data = model.visitedlist[index];
                  return InkWell(
                    onTap: () {
                      sharedPref.save("biz_id", data.id.toString());
                      sharedPref.save("biz_name", data.company_name);
                      Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.company_name)));
                    },
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Center(
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
                                                imageUrl: data.logo ?? '',
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
                                                errorWidget: (context, url, error) => Icon(Icons.image, size: 32,),
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
                                                //style: TextStyle(fontSize: 14.0)
                                            ),
                                          ),
                                          SizedBox(height: 8.0)
                                        ]
                                    ),
                                  ),
                                )
                            )
                        ),
                      ),
                    ),
                  );
                },
                  childCount: model.visitedlist.length,
                ),
              )
          );
        }
    );
  }

  Widget myPopMenu() {
    return PopupMenuButton(
        onSelected: (value) {
          print("You have selected " + value.toString());
          /*Fluttertoast.showToast(
              msg: "You have selected " + value.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );*/
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.print),
                  ),
                  Text('Print')
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.share),
                  ),
                  Text('Share')
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.add_circle),
                  ),
                  Text('Add')
                ],
              )),
        ]);
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
