import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/fin/fin_prod_list.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/emptyList.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/webview_f.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
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

  goToNextPage(BuildContext context, Home_banner item) {
    String imgurl = item.imageUrl;
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, SlideRightRoute(page: WebViewBb(vrurl ?? '', imgurl ?? '')));
      });

    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    loadPhoto();
    FirebaseAnalytics().logEvent(name: 'Fintools_Home',parameters:null);
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
                            centerTitle: true,
                            title: Image.asset('assets/icons/ic_fintool.png', height: 24, width: 107,),
                            /*actions: [
                              Padding(
                                padding: EdgeInsets.only(left: 2, right: 10,),
                                child: model.isAuthenticated ?
                                _logType == '0' ?
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.fill, height: 27, width: 27),
                                )
                                    : Container(
                                  height: 28.0,
                                  width: 28.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      //fit: BoxFit.fill,
                                      image: NetworkImage(_photo),
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
                                    onPressed: () {Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));},
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
                                                  child: Swiper(
                                                    autoplay: true,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          goToNextPage(context, model.fbanners[index]);
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
                                                              imageUrl: model.fbanners[index].imageUrl,
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
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,),
                                ),
                                unselectedLabelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                ),
                                tabs: [
                                  Tab(text: "INSURANCE"),
                                  Tab(text: "INVESTMENT"),
                                  Tab(text: "FINANCIAL"),
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
                              model.finsurans.length > 0 ? _buildInsurance(key: "key1") : EmptyList('No Insurance activity at the moment.',subTitle: 'Please come back later.'),
                              model.finvests.length > 0 ? _buildInvestment(key: "key2") : EmptyList('No Investment activity at the moment.',subTitle: 'Please come back later.'),
                              model.finances.length > 0 ? _buildFinancial(key: "key3") : EmptyList('No Financial activity at the moment.',subTitle: 'Please come back later.'),
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

  Widget _buildInsurance({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.5,
                    crossAxisSpacing: 1.5,
                    childAspectRatio: 0.820,),
                  key: PageStorageKey(key),
                  itemCount: model.finsurans.length,
                  itemBuilder: (ctx, index) {
                    var data = model.finsurans[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightRoute(page: FinDetailPage(data.id.toString(),data.company_name)));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 0.0,
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
                                          'assets/icons/ic_launcher_new.png',
                                          fit: BoxFit.cover,)
                                            : CachedNetworkImage(
                                          //fit: BoxFit.fitHeight,
                                          imageUrl: data.logo ?? '',
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  alignment: Alignment.center,
                                                  image: imageProvider,
                                                  //fit: BoxFit.fitHeight, //data.company_name.toUpperCase() == 'KELANA MOTOR' ? BoxFit.fitWidth : BoxFit.fitHeight,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                    //topRight: Radius.circular(8.0)
                                                )
                                            ),
                                          ),
                                          placeholder: (context, url) => Container(
                                            alignment: Alignment.center,
                                            width: 90,
                                            height: 90,
                                            color: Colors.transparent,
                                            child: Image.asset('assets/images/ed_logo_greys.png'),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(data.pic_name == null ? data.company_name.toUpperCase() : data.pic_name.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        /*Text(data.company_licno.toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ),*/
                                      ]
                                    ),
                                    SizedBox(height: 5.0)
                                  ]
                              ),
                            ),
                          )
                      ),
                    );
                  }
              )
          );
        }
    );
  }

  Widget _buildInvestment({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.820,
                      crossAxisSpacing: 1.5,
                      mainAxisSpacing: 1.5),
                  key: PageStorageKey(key),
                  itemCount: model.finvests.length,
                  itemBuilder: (ctx, index) {
                    var data = model.finvests[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightRoute(page: FinDetailPage(data.id.toString(),data.company_name)));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: data.logo == null ? Image.asset(
                                          'assets/icons/ic_launcher_new.png',
                                          fit: BoxFit.cover,)
                                            : CachedNetworkImage(
                                          //fit: BoxFit.fitHeight,
                                          imageUrl: data.logo ?? '',
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  alignment: Alignment.center,
                                                  image: imageProvider,
                                                  //fit: BoxFit.fitHeight,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),)
                                            ),
                                          ),
                                          //placeholder: (context, url) => Container(color: Colors.grey.shade200,),
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
                                    SizedBox(height: 5.0),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(data.company_name.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          /*Text(data.company_licno.toLowerCase() == 'na' ? '' : data.company_licno,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ),*/
                                        ]
                                    ),
                                    SizedBox(height: 5.0)
                                  ]
                              ),
                            ),
                          )
                      ),
                    );
                  }
              )
          );
        }
    );
  }

  Widget _buildFinancial({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.705,
                      crossAxisSpacing: 1.5,
                      mainAxisSpacing: 1.5),
                  key: PageStorageKey(key),
                  itemCount: model.finances.length,
                  itemBuilder: (ctx, index) {
                    var data = model.finances[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightRoute(page: FinDetailPage(data.id.toString(),data.company_name)));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 0.0,
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
                                          'assets/icons/ic_launcher_new.png',
                                          fit: BoxFit.cover,)
                                            : CachedNetworkImage(
                                          fit: BoxFit.fitHeight,
                                          imageUrl: data.logo ?? '',
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  alignment: Alignment.center,
                                                  image: imageProvider,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),)
                                            ),
                                          ),
                                          placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                          errorWidget: (context, url, error) => Icon(Icons.image_rounded, size: 36,),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(data.company_name.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          /*Text(data.company_licno.toLowerCase() == 'na' ? '' : data.company_licno,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ),*/
                                        ]
                                    ),
                                    SizedBox(height: 5.0)
                                  ]
                              ),
                            ),
                          )
                      ),
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