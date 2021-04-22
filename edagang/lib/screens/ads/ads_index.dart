import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/ads/ads_auto_detail.dart';
import 'package:edagang/screens/ads/ads_career_detail.dart';
import 'package:edagang/screens/ads/ads_prop_detail.dart';
import 'package:edagang/screens/biz/biz_index.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:edagang/widgets/webview_bb.dart';
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
  var listImgUrl = new List<String>();

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
    String imgurl = 'https://blurbapp.e-dagang.asia'+item.imageUrl;
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

      //Navigator.push(context, SlideRightRoute(page: ProductListCategory(catid, catname))); https://upskillapp.e-dagang.asia/file/banner/6/bb_banner4.jpg
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
    quick_menu = getAdsCategory();
    super.initState();
    loadPhoto();
    listImgUrl = List();
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
                  length: 3,
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
                          title: Image.asset('assets/icons/ic_blurb.png', height: 24, width: 70,),
                          actions: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.doc_person,
                                  color: Color(0xff084B8C),
                                ),
                                onPressed: () {Navigator.push(context, SlideRightRoute(
                                    page: WebviewWidget(
                                        'https://blurb.e-dagang.asia/wv/career/profile/' +
                                            model.getId().toString(), 'Career Profile')));
                                },
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
                                                        goToNextPage(context, model.blb_banners[index]);
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
                                                              imageUrl: 'https://blurbapp.e-dagang.asia' + model.blb_banners[index].imageUrl,
                                                              fit: BoxFit.fill,
                                                              height: 150,
                                                              width: MediaQuery.of(context).size.width,
                                                            )
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: model.blb_banners.length,
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
                              indicatorColor: Color(0xff57585A),
                              labelPadding: EdgeInsets.only(left: 8, right: 8),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: Color(0xff57585A),
                              unselectedLabelColor: Colors.grey,
                              labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,),
                              ),
                              unselectedLabelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                              ),
                              tabs: [
                                Tab(text: "CAREER"),
                                Tab(text: "PROPERTY"),
                                Tab(text: "AUTOMOBILE"),
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
                            _buildProperty(key: "key2"),
                            _buildAuto(key: "key3"),
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
              itemCount: model.blbcareer.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
              itemBuilder: (BuildContext context, int index) {
                var data = model.blbcareer[index];
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
                            sharedPref.save("job_id", data.id.toString());
                            Navigator.push(context,SlideRightRoute(page: CareerDetailPage(data.id.toString(),data.title)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.transparent,
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                  ),
                                  imageUrl: 'https://blurbapp.e-dagang.asia'+data.company_logo,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                                margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 0.0),
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
                                                margin: EdgeInsets.only(left: 0, right: 0.0, top: 0.0),
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
                                            data.company_name,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                          child: Text(
                                            data.city_name + ', ' + data.state_name,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ],
                          )

                          /**/
                      ),
                    )
                );
              }
          );
        });
  }

  Widget _buildProperty({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
              key: PageStorageKey(key),
              itemCount: model.blbproperty.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
              itemBuilder: (BuildContext context, int index) {
                var data = model.blbproperty[index];
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
                            Navigator.push(context,SlideRightRoute(page: PropShowcase(data.id.toString(),data.title)));
                            //saveData();
                            //Navigator.push(context,SlideRightRoute(page: CareerDetailPage(data.id.toString(),data.title)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.transparent,
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                  ),
                                  imageUrl: 'https://blurbapp.e-dagang.asia'+data.images[0].file_path,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                                margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 0.0),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  data.title,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,),
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: EdgeInsets.only(left: 0, right: 0.0, top: 0.0),
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
                                            data.company_name,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                          child: Text(
                                            data.price,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
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

  Widget _buildAuto({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
              key: PageStorageKey(key),
              itemCount: model.blbautomobile.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
              itemBuilder: (BuildContext context, int index) {
                var data = model.blbautomobile[index];
                listImgUrl.add(data.images.toString());
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
                            //saveData();
                            Navigator.push(context,SlideRightRoute(page: AutoShowcase(data.id.toString(),data.title)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.transparent,
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                  ),
                                  imageUrl: 'https://blurbapp.e-dagang.asia'+data.images[0].file_path,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                              margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 0.0),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                data.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,),
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 0, right: 0.0, top: 0.0),
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
                                        margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 0.0),
                                        child: Text(
                                          data.location,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                        child: Text(
                                          data.price+'\n('+data.year+')',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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


class AdsPropertyPage extends StatefulWidget {
  final String id,name;
  AdsPropertyPage(this.id, this.name);

  @override
  _AdsPropertyPageState createState() => _AdsPropertyPageState();
}

class _AdsPropertyPageState extends State<AdsPropertyPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Scaffold(
            backgroundColor: Color(0xffEEEEEE),
            body: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    margin: EdgeInsets.all(5.0),
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 205,
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, SlideRightRoute(
                              page: WebviewWidget(
                                  'https://blurb.e-dagang.asia/property/pip',
                                  'Pengerang Industrial Park')));
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                //width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                  child: Image.asset('assets/pip.png', fit: BoxFit.fill,),
                                ),
                              ),

                              Container(
                                //height: 56,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10.0),
                                alignment: Alignment.bottomLeft,
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Pengerang Industrial Park',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Land for sale.',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      /*SizedBox(height: 2,),
                                        Text(
                                          data.vr_desc,
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w600,),
                                          ),
                                        ),*/
                                    ]
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                ),



                /*Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 255,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, SlideRightRoute(
                                  page: WebviewWidget(
                                      'https://blurb.e-dagang.asia/property/pip',
                                      'Pengerang Industrial Park')));
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    //width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      child: Image.asset('assets/pip.png'),
                                    ),
                                  ),
                                  Container(
                                    //height: 56,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10.0),
                                    alignment: Alignment.bottomLeft,
                                    decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Pengerang Industrial Park',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                        'Land for sale.',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                        *//*SizedBox(height: 2,),
                                        Text(
                                          data.vr_desc,
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w600,),
                                          ),
                                        ),*//*
                                      ]
                                    ),
                                  ),
                                ]
                            ),
                            *//*child: VrCardItem(
                              vrimg: Image.asset('assets/pip.png'),
                              label: 'Pengerang Industrial Park',
                              sublabel: 'Land for sale.',
                              footer: '',
                            ),*//*
                          ),
                        ),
                      ]
                  ),
                ),*/
              ),
              /*SliverFillRemaining(
                child: new Container(color: Colors.transparent),
              ),*/
            ]),
          );
        }
    );
  }

}
