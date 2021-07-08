import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_categories.dart';
import 'package:edagang/screens/biz/biz_vr_list.dart';
import 'package:edagang/screens/biz/search.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/webview_bb.dart';
import 'package:edagang/widgets/webview_f.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        builder: (context, child, model){
          return WillPopScope(
              key: _scaffoldKey,
              onWillPop: () {
                SystemNavigator.pop();
                return Future.value(true);
              },
              child: Scaffold(
                backgroundColor: Color(0xffEEEEEE),
                body: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          elevation: 0.0,
                          expandedHeight: 210.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: Colors.white,
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: Image.asset('assets/icons/ic_smartbiz.png', height: 24, width: 107,),
                          actions: [
                            Padding(
                              padding: EdgeInsets.only(left: 2, right: 10,),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: IconButton(
                                  icon: Icon(
                                    LineAwesomeIcons.search,
                                    color: Colors.black87,
                                  ),
                                  onPressed: () {Navigator.push(context, SlideRightRoute(page: SearchList()));},
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
                                                                alignment: Alignment.center,
                                                                color: Colors.transparent,
                                                                child: Image.asset('assets/logo_edagang.png', height: 90,),
                                                              ),
                                                              imageUrl: model.bbanners[index].imageUrl,
                                                              fit: BoxFit.fill,
                                                              height: 150,
                                                              width: MediaQuery.of(context).size.width,
                                                            )
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: model.fbanners.length,
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
                        ),
                      ];
                    },
                  body: CustomScrollView(slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Biz Category',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: model.bcategory.length == 0 ? Container(
                        height: 135,
                        width: 100,
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: CupertinoActivityIndicator(radius: 15,),
                      ) : _fetchCategories(),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Virtual Trade',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                                        textStyle: TextStyle(fontStyle: FontStyle.italic ,fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff357FEB)),
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
                      child: model.bvirtual.length == 0 ? Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.6,
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: CupertinoActivityIndicator(radius: 15,),
                      ) : _fetchVirtualList(),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 24, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Highlighted Company',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0,),
                              child: InkWell(
                                highlightColor: Colors.blue.shade100,
                                splashColor: Colors.blue.shade100,
                                onTap: () {
                                  Navigator.push(context, SlideRightRoute(page: MyDashboard(0, model.bcategory.length)));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'All ('+model.getTotalCompany().toString()+') ',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic ,fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff357FEB)),
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

                    topList(),

                    SliverToBoxAdapter(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(context, SlideRightRoute(page: MyDashboard(0, model.bcategory.length)));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                                  elevation: 1,
                                  child: ClipPath(
                                      clipper: ShapeBorderClipper(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                      ),
                                      child: Container(
                                          height: 70.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('+'+model.getTotalCompanyPlus().toString()+' more companies.',
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff084B8C)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 10.0, left: 5.0),
                                                    alignment: Alignment.centerRight,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.grey[200],
                                                      child: Icon(
                                                        CupertinoIcons.arrow_right,
                                                        size: 20,
                                                        color: Color(0xff084B8C),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      )
                                  )
                              )
                          )
                      ),
                    ),

                  ]),
                ),
              )
          );
        }
    );
  }
  /*Widget build(BuildContext context) {
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
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          icon: Icon(
                            LineAwesomeIcons.search,
                            color: Colors.black87,
                          ),
                          onPressed: () {Navigator.push(context, SlideRightRoute(page: SearchList()));},
                        ),
                      ),
                    ),
                  ],
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
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: Image.asset('assets/logo_edagang.png', height: 90,),
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
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: model.bcategory.length == 0 ? Container(
                  height: 135,
                  width: 100,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: CupertinoActivityIndicator(radius: 15,),
                ) : _fetchCategories(),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Virtual Trade',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                                  textStyle: TextStyle(fontStyle: FontStyle.italic ,fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff357FEB)),
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
                child: model.bvirtual.length == 0 ? Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: CupertinoActivityIndicator(radius: 15,),
                ) : _fetchVirtualList(),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 24, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Highlighted Company',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0,),
                        child: InkWell(
                          highlightColor: Colors.blue.shade100,
                          splashColor: Colors.blue.shade100,
                          onTap: () {
                            Navigator.push(context, SlideRightRoute(page: MyDashboard(0, model.bcategory.length)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'All ('+model.getTotalCompany().toString()+') ',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontStyle: FontStyle.italic ,fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff357FEB)),
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

              topList(),

              SliverToBoxAdapter(
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightRoute(page: MyDashboard(0, model.bcategory.length)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                        elevation: 1,
                        child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            child: Container(
                                height: 70.0,
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text('+'+model.getTotalCompanyPlus().toString()+' more companies.',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff084B8C)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10.0, left: 5.0),
                                          alignment: Alignment.centerRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[200],
                                            child: Icon(
                                              CupertinoIcons.arrow_right,
                                              size: 20,
                                              color: Color(0xff084B8C),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            )
                        )
                      )
                    )
                ),
              ),

            ]),
          )
        );
      }
    );
  }*/

  Widget _fetchCategories() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
            color: Colors.transparent,
            height: 125,
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
                      Navigator.push(context, SlideRightRoute(page: MyDashboard(index, model.bcategory.length)));
                      //Navigator.push(context, SlideRightRoute(page: BizCategoryPage(data.cat_id.toString(),data.cat_name)));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 80,
                          width: 81,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          decoration: new BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 1.5,
                                spreadRadius: 0.0,
                                offset: Offset(1.5, 1.5),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              imageUrl: data.cat_image ?? '',
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffcecece),
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0), //topRight: Radius.circular(8.0)
                                    )
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: Image.asset('assets/images/ed_logo_white.png',width: 50,
                                  height: 50,),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.image_rounded,size: 36,),
                            ),
                          ),
                        ),
                        Container(
                          width: 81,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 3.5),
                          child: Text(data.cat_name ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        ),
                      ],
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
                        Navigator.push(context, SlideRightRoute(
                            page: VirtualWebView(data.vr_list[index].vr_url,data.vr_list[index].vr_name)));
                      },
                      /*onTap: () {
                        FirebaseAnalytics().logEvent(name: 'Biz_virtual_'+data.vr_list[index].vr_name,parameters:null);
                        launchVr(data.vr_list[index].vr_url);
                      },*/
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //height: 155,
                              //width: MediaQuery.of(context).size.width * 0.6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                child: CachedNetworkImage(
                                  imageUrl: data.vr_list[index].vr_image ?? '',
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    child: Image.asset('assets/images/ed_logo_greys.png', width: 110,
                                      height: 110,),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/icons/ic_image_error.png',
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
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
          padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
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
                    Navigator.push(context, SlideRightRoute(
                        page: BizCompanyDetailPage(
                            data.id.toString(), data.company_name)));
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
                                            borderRadius: BorderRadius
                                                .circular(7)
                                        ),
                                        child: data.logo == null ? Image.asset(
                                            'assets/icons/ic_edagang.png',
                                            height: 80.0, width: 80.0,
                                            fit: BoxFit.cover,
                                          ) : CachedNetworkImage(
                                            //fit: BoxFit.fitWidth,
                                            imageUrl: data.logo ?? '',
                                            imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    alignment: Alignment.center,
                                                    image: imageProvider,
                                                    //fit: BoxFit.fitWidth,
                                                  ),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(8.0),
                                                      topRight: Radius.circular(8.0)
                                                  )
                                                ),
                                            ),
                                            placeholder: (context, url) => Container(
                                              alignment: Alignment.center,
                                              color: Colors.transparent,
                                              child: Image.asset('assets/images/ed_logo_greys.png', width: 110,
                                                height: 110,),
                                            ),
                                            errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(data.company_name,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
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
                            child: Image.asset(
                              'assets/icons/verify.png', fit: BoxFit.cover,
                              height: 21,),
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

}

