import 'package:edagang/data/datas.dart';
import 'package:edagang/main.dart';
import 'package:edagang/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/ads/ads_career_detail.dart';
import 'package:edagang/screens/ads/ads_quick_access.dart';
import 'package:edagang/screens/ads/webview.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertPage extends StatefulWidget {
  final TabController tabcontroler;
  AdvertPage({this.tabcontroler});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  BuildContext context;
  List<Menus> quick_menu = new List();
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

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    quick_menu = getAdsCategory();
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
                                Image.asset('assets/icons/ic_blurb.png', height: 24, width: 70,),
                              ],
                            ),
                          ),
                          actions: [
                            /*CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.doc_person,
                                  color: Color(0xff084B8C),
                                ),
                                onPressed: () {Navigator.push(context, SlideRightRoute(
                                    page: WebviewBlurb(
                                        'https://blurb.e-dagang.asia/wv/career/profile/' +
                                            model.getId().toString(), 'Career Profile')));
                                },
                              ),
                            ),*/
                            Padding(
                              padding: EdgeInsets.only(left: 2, right: 10,),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: IconButton(
                                  icon: Icon(
                                    CupertinoIcons.doc_person,
                                    color: Color(0xff084B8C),
                                  ),
                                  onPressed: () {Navigator.push(context, SlideRightRoute(
                                      page: WebviewBlurb(
                                          'https://blurb.e-dagang.asia/wv/career/profile/' +
                                              model.getId().toString(), 'Career Profile')));
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
                                                autoplay: false,
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
                                                    'assets/edagangblurb.png', height: 150.0,
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
                              indicatorColor: Color(0xff57585A),
                              labelPadding: EdgeInsets.only(left: 8, right: 8),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: Color(0xff57585A),
                              unselectedLabelColor: Colors.grey,
                              labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,),
                              ),
                              unselectedLabelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                              ),
                              tabs: [
                                Tab(text: "CAREER"),
                                Tab(text: "PROPERTY"),
                              ],
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TabBarView(
                          children: [
                            _buildCareer(key: "key1"),
                            AdsPropertyPage('2', 'Property'),
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

  Widget _buildCareer({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
              key: PageStorageKey(key),
              itemCount: model.jobcat.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
              itemBuilder: (BuildContext context, int index) {
                var data = model.jobcat[index];
                return Card(
                    margin: EdgeInsets.all(5.0),
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: InkWell(
                          onTap: () {
                            sharedPref.save("job_id", data.id.toString());
                            Navigator.push(context,SlideRightRoute(page: CareerDetailPage(data.id.toString(),data.title)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 8.0),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        data.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,),
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5, right: 7.0, top: 8.0),
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        CupertinoIcons.chevron_forward,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                child: Text(
                                  data.company,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                child: Text(
                                  data.state,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                );
              }
          );
        });
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
          //padding: EdgeInsets.only(bottom: 3),
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
