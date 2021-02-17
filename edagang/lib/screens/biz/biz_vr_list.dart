import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/custom_tabs.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';



class BizVrListPage extends StatefulWidget {
  //String mercId, mercName;
  //BizVrListPage(this.mercId, this.mercName);

  @override
  _BizVrListPageState createState() {
    return new _BizVrListPageState();
  }
}

const xpandedHeight = 185.0;

class _BizVrListPageState extends State<BizVrListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > xpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0.0,
                expandedHeight: xpandedHeight,
                /*iconTheme: IconThemeData(
                  color: Colors.white,
                ),*/
                leading: Hero(
                  tag: "back",
                  child: InkWell(
                    onTap: () {Navigator.pop(context);},
                    splashColor: Color(0xffA0CCE8),
                    highlightColor: Color(0xffA0CCE8),
                    child: BlurIconLight(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  )
                ),
                pinned: true,
                primary: true,
                title: SABT(
                  child: Container(
                      child: Text('Virtual Trade',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontWeight: FontWeight.w700,),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                    child: Container(
                      height: 150.0,
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: Image.asset(
                        'assets/images/virtual_trade.png', fit: BoxFit.cover,
                        height: 150,
                      ),
                    )
                  )
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.only(left: 8, right: 8, top: 3),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Color(0xff2877EA),
                    unselectedLabelColor: Colors.grey,
                    labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,),
                    ),
                    unselectedLabelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                    ),
                    tabs: [
                      Tab(text: "Company"),
                      Tab(text: "Gallery"),
                      Tab(text: "Exhibition"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(children: [
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
                        width: MediaQuery.of(context).size.width,
                        height: 265,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if(Platform.isAndroid) {
                              CustomTabs.launchURL(context, 'https://smartbiz.e-dagang.asia/vr/mogsc/office/index.htm');
                            }else{
                              final String url = 'https://smartbiz.e-dagang.asia/vr/mogsc/office/index.htm';
                              if (await canLaunch(url)) await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            }
                          },
                          child: VrCardItem(
                            vrimg: Image.asset('assets/vr_mogsc.png'),
                            label: 'MOGSC',
                            sublabel: 'Malaysian Oil & Gas Services Council',
                            footer: 'Virtual Office',
                          ),
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 265,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if(Platform.isAndroid) {
                              CustomTabs.launchURL(context, 'https://smartbiz.e-dagang.asia/vr/shapadu/office/index.htm');
                            }else{
                              final String url = 'https://smartbiz.e-dagang.asia/vr/shapadu/office/index.htm';
                              if (await canLaunch(url)) await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            }
                          },
                          child: VrCardItem(
                            vrimg: Image.asset('assets/vr_shapadu.png'),
                            label: 'SHAPADU Energy Services',
                            sublabel: '',
                            footer: 'Virtual Office',
                          ),
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 265,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if(Platform.isAndroid) {
                              CustomTabs.launchURL(context, 'https://smartbiz.e-dagang.asia/vr/cekap/office/index.htm');
                            }else{
                              final String url = 'https://smartbiz.e-dagang.asia/vr/cekap/office/index.htm';
                              if (await canLaunch(url)) await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            }
                          },
                          child: VrCardItem(
                            vrimg: Image.asset('assets/vr_cekap.png'),
                            label: 'Cekap Technical Services Sdn Bhd',
                            sublabel: '',
                            footer: 'Virtual Office',
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              )
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
                        width: MediaQuery.of(context).size.width,
                        height: 265,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if(Platform.isAndroid) {
                              CustomTabs.launchURL(context, 'https://smartbiz.e-dagang.asia/vr/artgallery/hanimhassan/index.htm');
                            }else{
                              final String url = 'https://smartbiz.e-dagang.asia/vr/artgallery/hanimhassan/index.htm';
                              if (await canLaunch(url)) await launch(
                                url,
                                forceSafariVC: false,
                                forceWebView: false,
                              );
                            }
                          },
                          child: VrCardItem(
                            vrimg: Image.asset('assets/vr_hanim.png'),
                            label: 'Hanim Hassan',
                            sublabel: 'Impressionist Art Gallore',
                            footer: 'Virtual Gallery',
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              )
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
                      Container(),
                    ]
                  ),
                ),
              )
            ]),
          ]),
        ),
      ),
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

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
    context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    bool visible = settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}