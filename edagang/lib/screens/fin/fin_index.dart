import 'package:edagang/data/datas.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/fin/webview.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

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

  @override
  void initState() {
    tabs_menu = getFinInsurans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return WillPopScope(key: _scaffoldKey, onWillPop: () {
          widget.tabcontroler.animateTo(2);
          return null;
          },
          child: Scaffold(
            body: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 150.0,
                      floating: false,
                      pinned: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
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
                            Tab(text: "Insurance"),
                            Tab(text: "Investment"),
                            Tab(text: "Finance"),
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
                  Container(),
                ]),
              ),
            ),
          )
        );
      }
    );
  }

  Widget _tabList(BuildContext context, TabController tabcontroler) {
    if(tabs_menu.length == 0) {
      return Container();
    }else{

      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var data = tabs_menu[index];
          return Container(
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                        overflow: TextOverflow.ellipsis,),
                    )
                  ),
                ),
              )
          );
        },
          childCount: tabs_menu.length,
        ),
      );
    }
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