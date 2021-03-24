import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_home.dart';
import 'package:edagang/screens/biz/biz_vr_list.dart';
import 'package:edagang/screens/biz/search.dart';
import 'package:edagang/settings.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:edagang/widgets/webview.dart';
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
import 'package:url_launcher/url_launcher.dart';


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

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() => _currentIndex = _pageController.page.round());
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    quick_menu = getBizQxcess();
    tabs_menu = getBizTabs();
    super.initState();
    loadPhoto();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));*/

    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model) {
        return WillPopScope(
          key: _scaffoldKey,
          onWillPop: () {
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
                      _logType == '0' ?
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.fill, height: 27, width: 27),
                      )
                          : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(_photo ?? '', fit: BoxFit.fill, height: 27, width: 27,),
                          )
                      )
                          : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.power,
                            color: Color(0xff084B8C),
                          ),
                          onPressed: () {Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));},
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
                              onPressed: () {Navigator.push(context, SlideRightRoute(page: NotificationPage()));},
                            ),
                          ),
                          SizedBox(width: 2,),
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Color(0xff084B8C),),
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(child: ListTile(
                                  title: Text('Quotation'),
                                ), value: "1"),
                                PopupMenuItem(child: ListTile(
                                  title: Text('Join Us'),
                                ), value: "2"),
                                PopupMenuItem(child: ListTile(
                                  title: Text('Settings'),
                                ), value: "3"),
                                PopupMenuItem(child: model.isAuthenticated ? ListTile(
                                  title: Text('Logout'),
                                ) : ListTile(
                                  title: Text('Login'),
                                ), value: model.isAuthenticated ? "4" : "5"),
                              ],

                              onSelected: (value) {
                                setState(() {
                                  _selectedItem = value;
                                  print("Selected context menu: $_selectedItem");
                                  if(_selectedItem == '1'){
                                    if(model.isAuthenticated) {
                                      Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/quot/' + model.getId().toString() + '/0', 'Quotation')));
                                    }else{
                                      Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                    }
                                  }
                                  if(_selectedItem == '2'){
                                    Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));
                                  }
                                  if(_selectedItem == '3'){
                                    Navigator.push(context, SlideRightRoute(page: SettingPage()));
                                  }
                                  if(_selectedItem == '4'){
                                    logoutUser(context, model);
                                  }
                                  if(_selectedItem == '5'){
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
                /*SliverAppBar(
                  elevation: 0.0,
                  expandedHeight: 210.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(
                    color: Color(0xff084B8C),
                  ),
                  leading: model.isAuthenticated ? Padding(
                    padding: EdgeInsets.all(13),
                    child:  _logType == '0' ? Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown) : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(_photo ?? '', fit: BoxFit.fill,),
                    )
                  ) : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.power,
                        color: Color(0xff084B8C),
                      ),
                      onPressed: () {Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));},
                    ),
                  ),
                  centerTitle: true,
                  title: Image.asset('assets/icons/ic_smartbiz.png', height: 24, width: 107,),
                  actions: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.search,
                          color: Color(0xff084B8C),
                        ),
                        onPressed: () { Navigator.push(context, SlideRightRoute(page: SearchList()));},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2,),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.bell_fill,
                            color: Color(0xff084B8C),
                          ),
                          onPressed: () {Navigator.push(context, SlideRightRoute(page: NotificationPage()));},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: 10,),
                      child: CircleAvatar(
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
                                Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));
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
                      ),
                    ),

                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(bottom: 5, top: 90),
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
                                        height: 150.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
                                        child: Swiper(
                                          autoplay: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: () {
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
                                                      height: 150,
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
                  ),
                ),*/
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
                          height: 150.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Swiper(
                            autoplay: true,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
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
                                      height: 150,
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
                      /*Icon(
                        Icons.more_horiz,
                        color: Colors.grey[800],
                      ),*/
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
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: Color(0xff357FEB),
                            ),
                            onPressed: () {Navigator.push(context,SlideRightRoute(page: BizVrListPage()));},
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
                      /*Padding(
                        padding: EdgeInsets.only(left: 0,),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: Color(0xff357FEB),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),

              topList(),

            ]),
          )

          /*Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(45.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title: searchBar(context),
                  actions: model.isAuthenticated ? [
                    Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.centerRight,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: _logType == '0' ? Icon(CupertinoIcons.person_crop_circle, size: 36, color: Colors.grey.shade700,) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(image: NetworkImage(_photo ?? '',))
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
            )*/
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
                  //padding: EdgeInsets.only(left: 3.6, top: 8, right: 3.6,),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      print("category name : " + data.cat_name);
                      //sharedPref.save("cat_id", data.cat_id.toString());
                      //sharedPref.save("cat_title", data.cat_name);
                      Navigator.push(context, SlideRightRoute(page: BizCategoryPage(data.cat_id.toString(),data.cat_name)));
                    },
                    child: Container(
                      height: 145,
                      width: 100,
                      alignment: Alignment.bottomCenter,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        image: new DecorationImage(
                          image: new NetworkImage('http://bizapp.e-dagang.asia' + data.cat_image ?? '',),
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


                        /*Text(
                          data.cat_name ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(backgroundColor: Colors.black38, color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),*/
                      )
                    ),
                      /*child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              height: 135,
                              width: 100,
                              alignment: Alignment.bottomCenter,
                              padding: new EdgeInsets.only(bottom: 8.0),
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new NetworkImage('http://bizapp.e-dagang.asia' + data.cat_image ?? ''),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                          ),
                          Container(
                            width: 100.0,
                            padding: EdgeInsets.only(top: 5, right: 5),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                data.cat_name ?? '',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600,),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )*/
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
          /*return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: numbers.length, itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  color: Colors.blue,
                  child: Container(
                    child: Center(child: Text(numbers[index].toString(), style: TextStyle(color: Colors.white, fontSize: 36.0),)),
                  ),
                ),
              );
            }),
          );*/
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
                      onTap: () async {
                        final String url = data.vr_list[index].vr_url ?? '';
                        if (await canLaunch(url)) await launch(
                          url,
                          forceSafariVC: false,
                          forceWebView: false,
                        );
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 155,
                              width: MediaQuery.of(context).size.width * 0.6,
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
                                  height: 155,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              padding: EdgeInsets.only(left: 7.0,right: 7.0,top: 7.0),
                              alignment: Alignment.bottomLeft,
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
                                  /*SizedBox(
                                    height: 1.5,
                                  ),
                                  Text(
                                    data.vr_desc ?? '',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.blue.shade600, fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                    ),
                                  ),*/
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
