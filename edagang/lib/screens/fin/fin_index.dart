import 'package:edagang/data/datas.dart';
import 'package:edagang/main.dart';
import 'package:edagang/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/fin/webview.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinancePage extends StatefulWidget {
  final TabController tabcontroler;
  FinancePage({this.tabcontroler});

  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  List<Menus> tabs_menu = new List();
  ScrollController _scrollController;
  bool lastStatus = true;
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

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    tabs_menu = getFinInsurans();
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
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            Navigator.of(context).pushReplacementNamed("/Main");
            return Future.value(true);
          },
              child: Scaffold(
                backgroundColor: Color(0xffEEEEEE),
                body: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            elevation: 0.0,
                            expandedHeight: 210.0,
                            floating: false,
                            pinned: true,
                            backgroundColor: Colors.white,
                            leading: model.isAuthenticated ? Padding(
                                padding: EdgeInsets.all(13),
                                child:  _logType == '0' ? Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown) : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(_photo ?? '', fit: BoxFit.fill,),
                                )
                            ) : Container(),
                            centerTitle: true,
                            title: SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Image.asset('assets/icons/ic_edagang.png', height: 28, width: 30,),
                                  Image.asset('assets/icons/ic_fintool.png', height: 24, width: 107,),
                                ],
                              ),
                            ),
                            /*actions: [
                              Padding(
                                padding: EdgeInsets.only(left: 2, right: 10,),
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
                            ],*/
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(bottom: 5, top: 90),
                                  child: Container(
                                      margin: EdgeInsets.only(left: 8, right: 8),
                                      child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                          elevation: 1,
                                          child: ClipPath(
                                              clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                              child: Container(
                                                height: 150.0,
                                                decoration: new BoxDecoration(
                                                  color: Colors.transparent,
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
                                                          activeSize: 7.0)
                                                  ),
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/cartsinifinance1.png', height: 150.0,
                                                      fit: BoxFit.fill,),
                                                    Image.asset(
                                                      'assets/cartsinifinance2.png', height: 150.0,
                                                      fit: BoxFit.fill,),
                                                    Image.asset(
                                                      'assets/cartsinifinance3.png', height: 150.0,
                                                      fit: BoxFit.fill,),
                                                  ],
                                                ),
                                              )
                                          )
                                      )
                                  )
                              ),
                            ),
                          ),
                          SliverPersistentHeader(

                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                isScrollable: true,
                                //indicatorPadding: EdgeInsets.only(left: 13, right: 13),
                                indicatorColor: Color(0xffD91B3E),
                                labelPadding: EdgeInsets.only(left: 8, right: 8),
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: Color(0xffD91B3E),
                                unselectedLabelColor: Colors.grey,
                                labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,),
                                ),
                                unselectedLabelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                ),
                                tabs: [
                                  Tab(text: "INSURANCE"),
                                  Tab(text: "INVESTMENT"),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: Padding(
                        padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 16),
                        child: TabBarView(
                            children: [
                              _buildInsurance(key: "key1"),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        //padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                                          width: MediaQuery.of(context).size.width,
                                          height: 145,
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(context, SlideRightRoute(
                                                    page: Webview(
                                                        'http://ktpb.org/application-form/',
                                                        'KTP Membership')));
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
                                                          'assets/fintool_ktp.png', fit: BoxFit.fitWidth,
                                                          height: 145,
                                                        ),
                                                      )
                                                  )
                                              )
                                          )
                                      ),
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 145,
                                          child: InkWell(
                                              onTap: () {},
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
                                                          'assets/fintool_dd.png', fit: BoxFit.fitWidth,
                                                          height: 145,
                                                        ),
                                                      )
                                                  )
                                              )
                                          )
                                      ),
                                    ]
                                ),
                              ),
                            ]
                        ),
                      )
                  ),
                ),
              )
          );
        }
    );
  }



  /*Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return WillPopScope(key: _scaffoldKey, onWillPop: () {
          Navigator.of(context).pushReplacementNamed("/Main");
          return Future.value(true);
          },
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0.0,
                  expandedHeight: 210.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  leading: Padding(
                    padding: EdgeInsets.all(13),
                    child: model.isAuthenticated ? _logType == '0' ? Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown) : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(_photo ?? '', fit: BoxFit.fill,),
                    ) : Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown),
                  ),
                  centerTitle: true,
                  title: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Image.asset('assets/icons/ic_edagang.png', height: 28, width: 30,),
                        Image.asset('assets/icons/ic_fintool.png', height: 24, width: 107,),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 10,),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.bell_fill,
                            color: Colors.black,
                          ),
                          onPressed: () {Navigator.push(context, SlideRightRoute(page: NotificationPage()));},
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                elevation: 1,
                                child: ClipPath(
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                    child: Container(
                                      height: 150.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.transparent,
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
                                                activeSize: 7.0)
                                        ),
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/cartsinifinance1.png', height: 150.0,
                                            fit: BoxFit.fill,),
                                          Image.asset(
                                            'assets/cartsinifinance2.png', height: 150.0,
                                            fit: BoxFit.fill,),
                                          Image.asset(
                                            'assets/cartsinifinance3.png', height: 150.0,
                                            fit: BoxFit.fill,),
                                        ],
                                      ),
                                    )
                                )
                            )
                        )
                    ),
                  ),
                ),
              ];
            },
            body: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          isScrollable: true,
                          //indicatorPadding: EdgeInsets.only(left: 13, right: 13),
                          indicatorColor: Color(0xffCC0E27),
                          labelPadding: EdgeInsets.only(left: 8, right: 8),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Color(0xffCC0E27),
                          unselectedLabelColor: Colors.grey,
                          labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,),
                          ),
                          unselectedLabelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                          ),
                          tabs: [
                            Tab(text: "INSURANCE"),
                            Tab(text: "INVESTMENT"),
                            //Tab(text: "Finance"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(children: [
                  CustomScrollView(slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      sliver: _tabList(context, widget.tabcontroler),
                    ),
                  ]),
                  CustomScrollView(slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                //padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                                width: MediaQuery.of(context).size.width,
                                height: 145,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, SlideRightRoute(
                                          page: Webview(
                                              'http://ktpb.org/application-form/',
                                              'KTP Membership')));
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
                                                'assets/fintool_ktp.png', fit: BoxFit.fitWidth,
                                                height: 145,
                                              ),
                                            )
                                        )
                                    )
                                )
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 145,
                                child: InkWell(
                                    onTap: () {},
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
                                                'assets/fintool_dd.png', fit: BoxFit.fitWidth,
                                                height: 145,
                                              ),
                                            )
                                        )
                                    )
                                )
                            ),
                          ]
                        ),
                      ),
                    )
                  ]),
                  //Container(),
                ]),
              ),
            ),
          )
        );
      }
    );
  }*/

  Widget _buildInsurance({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.815,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5),
              key: PageStorageKey(key),
              itemCount: tabs_menu.length,
              itemBuilder: (ctx, index) {
                var data = tabs_menu[index];
                return Container(
                  alignment: Alignment.center,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightRoute(page: Webview(data.webviewUrl, data.title)));
                        //Navigator.push(context, SlideRightRoute(page: WebviewGeneral(data.webviewUrl, data.title)));
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: new EdgeInsets.only(bottom: 8.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage(data.imgPath),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.0, right: 7.0),
                          child: Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700,),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ),
                    ),
                  )
                );
              }
            )
          );
        }
    );
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 3),
        color: Colors.white,
        child: _tabBar,
      )
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}