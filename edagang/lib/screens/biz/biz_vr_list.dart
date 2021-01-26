import 'package:edagang/widgets/blur_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            child: InkWell(
                                onTap: () async {
                                  final String url = 'https://smartbiz.e-dagang.asia/vr/mogsc/office/index.htm';
                                  if (await canLaunch(url)) await launch(
                                    url,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    elevation: 0.0,
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade500,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: Image.asset(
                                            'assets/vr_mogsc.png', fit: BoxFit.fill,
                                            height: 175,
                                          ),
                                        )
                                    )
                                )
                            )
                        ),
                        //Divider(),
                        Container(
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            child: InkWell(
                                onTap: () async {
                                  final String url = 'https://smartbiz.e-dagang.asia/vr/shapadu/office/index.htm';
                                  if (await canLaunch(url)) await launch(
                                    url,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    elevation: 0.0,
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade500,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: Image.asset(
                                            'assets/vr_shapadu.png', fit: BoxFit.fill,
                                            height: 175,
                                          ),
                                        )
                                    )
                                )
                            )
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            child: InkWell(
                                onTap: () async {
                                  final String url = 'https://smartbiz.e-dagang.asia/vr/cekap/office/index.htm';
                                  if (await canLaunch(url)) await launch(
                                    url,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    elevation: 0.0,
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade500,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: Image.asset(
                                            'assets/vr_cekap.png', fit: BoxFit.fill,
                                            height: 175,
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
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            child: InkWell(
                                onTap: () async {
                                  final String url = 'https://smartbiz.e-dagang.asia/vr/artgallery/hanimhassan/index.htm';
                                  if (await canLaunch(url)) await launch(
                                    url,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    elevation: 0.0,
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade500,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: Image.asset(
                                            'assets/vr_hanim.png', fit: BoxFit.fill,
                                            height: 175,
                                          ),
                                        )
                                    )
                                )
                            )
                        ),
                        /*Container(
                            width: MediaQuery.of(context).size.width,
                            height: 195,
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
                                            'assets/vrgallery2.png', fit: BoxFit.fill,
                                            height: 195,
                                          ),
                                        )
                                    )
                                )
                            )
                        ),*/

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
                            padding: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            child: InkWell(
                                onTap: () {},
                                child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    elevation: 0.0,
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade500,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                          child: Image.asset(
                                            'assets/vrgallery.png', fit: BoxFit.fill,
                                            height: 175,
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