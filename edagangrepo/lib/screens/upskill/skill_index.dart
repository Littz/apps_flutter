import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/upskill/search.dart';
import 'package:edagang/screens/upskill/skill_detail.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/webview_bb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpskillPage extends StatefulWidget {
  final TabController tabcontroler;
  UpskillPage({this.tabcontroler});

  @override
  _UpskillPageState createState() => _UpskillPageState();
}

class _UpskillPageState extends State<UpskillPage> {
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

  goToNextPage(BuildContext context, Home_banner item) {
    String imgurl = 'https://upskillapp.e-dagang.asia'+item.imageUrl;
    String catname = item.title ?? '';
    String catid = item.itemId.toString();
    String ctype = item.type.toString();
    String vrurl = item.link_url;
    if(ctype == "1") {
      print('PRODUCT #############################################');
    } else if (ctype == "2") {
      print('CATEGORY #############################################');
      print(catid);
      print(catname);

      //Navigator.push(context, SlideRightRoute(page: ProductListCategory(catid, catname)));
    } else if (ctype == "3") {

      //Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(catid,'')));
    } else if (ctype == "4") {

      Navigator.push(context, SlideRightRoute(page: WebviewBixon(vrurl ?? '', imgurl ?? '')));
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    quick_menu = getUpskillCategory();
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
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0.0,
                    expandedHeight: 210.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    /*leading: model.isAuthenticated ? Padding(
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
                    ),*/
                    centerTitle: true,
                    title: Image.asset('assets/icons/ic_goilmu.png', height: 24, width: 108,),
                    /*SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/ic_edagang.png', height: 28, width: 30,),
                          Image.asset('assets/icons/ic_goilmu.png', height: 24, width: 108,),
                        ],
                      ),
                    ),*/
                    actions: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.search,
                            color: Color(0xff084B8C),
                          ),
                          onPressed: () {Navigator.push(context, SlideRightRoute(page: SearchList2()));},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2, right: 10,),
                        child: model.isAuthenticated ?
                        _logType == '0' ?
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.fill, height: 27, width: 27),
                        )
                        //Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.fill, height: 20, width: 20)
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
                                                  goToNextPage(context, model.gbanners[index]);
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
                                                        imageUrl: 'http://upskillapp.e-dagang.asia' + model.gbanners[index].imageUrl,
                                                        fit: BoxFit.fill,
                                                        height: 150,
                                                        width: MediaQuery.of(context).size.width,
                                                      )
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: model.gbanners.length,
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
                  SliverPersistentHeader(

                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        isScrollable: true,
                        //indicatorPadding: EdgeInsets.only(left: 13, right: 13),
                        indicatorColor: Color(0xff930894),
                        labelPadding: EdgeInsets.only(left: 8, right: 8),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Color(0xff930894),
                        unselectedLabelColor: Colors.grey,
                        labelStyle: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,),
                        ),
                        unselectedLabelStyle: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                        ),
                        tabs: [
                          Tab(text: "PROFESSIONAL"),
                          Tab(text: "TECHNICAL"),
                          Tab(text: "SAFETY"),
                          Tab(text: "SKILL"),
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
                    _buildProfessional(key: "key1"),
                    _buildTechnical(key: "key2"),
                    _buildSafety(key: "key3"),
                    _buildSkill(key: "key4"),
                  ]
                ),
              )

            ),
          ),
        )
      );
    });
  }

  Widget _buildProfessional({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
      return ListView.builder(
        key: PageStorageKey(key),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.skillProfessional.length,
        padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
        itemBuilder: (_, index) {
          var data = model.skillProfessional[index];
          return Card(
              margin: EdgeInsets.all(4.0),
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: InkWell(
                    onTap: () {
                      sharedPref.save("skil_id", data.id.toString());
                      Navigator.push(
                          context, SlideRightRoute(page: UpskillDetailPage(data.id.toString(),data.title)));
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
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: 7.0, top: 0.0),
                                child: Text(
                                  data.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.w600,),
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 0.0, top: 0.0),
                                alignment: Alignment.topRight,
                                child: Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0.0, right: 7.0, bottom: 7.0),
                          child: Text(
                            data.company_name,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0.0, right: 7.0, bottom: 7.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  data.cat_name,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ],
                    )
                ),
              )
          );
        },
      );
    });
  }

  Widget _buildTechnical({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.skillTechnical.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (context, index) {
              var data = model.skillTechnical[index];
              return Card(
                  margin: EdgeInsets.all(4.0),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: InkWell(
                        onTap: () {
                          sharedPref.save("skil_id", data.id.toString());
                          Navigator.push(context, SlideRightRoute(page: UpskillDetailPage(data.id.toString(),data.title)));
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
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 0.0, right: 7.0, top: 0.0),
                                    child: Text(
                                      data.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 0.0, top: 0.0),
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      CupertinoIcons.chevron_forward,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left:0.0, right: 7.0, bottom: 7.0),
                              child: Text(
                                data.company_name,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 0.0, right: 7.0, bottom: 7.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      data.cat_name,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        )
                    ),
                  )
              );
            },
          );
        });
  }

  Widget _buildSafety({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.skillSafety.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (context, index) {
              var data = model.skillSafety[index];
              return Card(
                  margin: EdgeInsets.all(4.0),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: InkWell(
                        onTap: () {
                          sharedPref.save("skil_id", data.id.toString());
                          Navigator.push(context, SlideRightRoute(page: UpskillDetailPage(data.id.toString(),data.title)));
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
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 0.0, right: 7.0, top: 0.0),
                                    child: Text(
                                      data.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 0.0, top: 0.0),
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      CupertinoIcons.chevron_forward,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0.0, right: 7.0, bottom: 7.0),
                              child: Text(
                                data.company_name,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 0.0, right: 7.0, bottom: 7.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      data.cat_name,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        )
                    ),
                  )
              );
            },
          );
        });
  }

  Widget _buildSkill({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.skillTraining.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (context, index) {
              var data = model.skillTraining[index];
              return Card(
                  margin: EdgeInsets.all(4.0),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: InkWell(
                        onTap: () {
                          sharedPref.save("skil_id", data.id.toString());
                          Navigator.push(context, SlideRightRoute(page: UpskillDetailPage(data.id.toString(),data.title)));
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
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 0.0, right: 7.0, top: 0.0),
                                    child: Text(
                                      data.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 0.0, top: 0.0),
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      CupertinoIcons.chevron_forward,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 05.0, right: 7.0, bottom: 7.0),
                              child: Text(
                                data.company_name,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 0.0, right: 7.0, bottom: 7.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      data.cat_name,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        )
                    ),
                  )
              );
            },
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