import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';


class BizVrListPage extends StatefulWidget {

  @override
  _BizVrListPageState createState() {
    return new _BizVrListPageState();
  }
}

const xpandedHeight = 155.0;

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
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
    {
      return Scaffold(
        backgroundColor: Color(0xffEEEEEE),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0.0,
                  expandedHeight: xpandedHeight,
                  leading: Hero(
                    tag: "back",
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      splashColor: Color(0xffA0CCE8),
                      highlightColor: Color(0xffA0CCE8),
                      child: BlurIconLight(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xff084B8C),
                        ),
                      ),
                    )
                  ),
                  /*leading: Hero(
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
                ),*/
                  pinned: true,
                  primary: true,
                  title: SABT(
                    child: Container(
                        child: Text('Virtual Trade',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      background: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          child: Container(
                            height: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(0)),
                            ),
                            child: Image.asset(
                              'assets/images/virtual_trade.png',
                              fit: BoxFit.fitHeight,
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
                      indicatorColor: Color(0xff357FEB),
                      labelPadding: EdgeInsets.only(left: 8, right: 8, top: 3),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Color(0xff357FEB),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700,),
                      ),
                      unselectedLabelStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,),
                      ),
                      tabs: [
                        Tab(text: "COMPANY"),
                        Tab(text: "GALLERY"),
                        Tab(text: "EXHIBITION"),
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
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: model.bvirtuals[0].vr_list.length > 0 ? _buildCompanyVr(key: "key1") : _emptyVr(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: model.bvirtuals[1].vr_list.length > 0 ? _buildGalleryVr(key: "key2") : _emptyVr(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: model.bvirtuals[2].vr_list.length > 0 ? _buildExhibitionVr(key: "key3") : _emptyVr(),
                  ),
                ]
              ),
            )
          ),
        ),
      );
    });
  }

  Widget _buildCompanyVr({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.bvirtuals[0].vr_list.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (_, index) {
              var data = model.bvirtuals[0];
              return Card(
                  margin: EdgeInsets.all(5.0),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 225,
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: InkWell(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              //width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.transparent,
                                    child: CupertinoActivityIndicator(radius: 15,),
                                  ),
                                  imageUrl: 'http://bizapp.e-dagang.asia' + data.vr_list[index].vr_image ?? '',
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
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
                                      data.vr_list[index].vr_name,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    /*Text(
                                          '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),*/
                                    SizedBox(height: 2,),
                                    Text(
                                      data.vr_desc,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w600,),
                                      ),
                                    ),

                                  ]
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
              );
            },
          );
        }
    );
  }

  Widget _buildGalleryVr({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.bvirtuals[1].vr_list.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (_, index) {
              var data = model.bvirtuals[1];
              return Card(
                margin: EdgeInsets.all(5.0),
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 225,
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: InkWell(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            //width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.transparent,
                                  child: CupertinoActivityIndicator(radius: 15,),
                                ),
                                imageUrl: 'http://bizapp.e-dagang.asia' + data.vr_list[index].vr_image ?? '',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),

                          Container(
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
                                    data.vr_list[index].vr_name,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  /*Text(
                                          '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),*/
                                  SizedBox(height: 2,),
                                  Text(
                                    data.vr_desc,
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.w600,),
                                    ),
                                  ),

                                ]
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget _buildExhibitionVr({String key}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.bvirtuals[2].vr_list.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (_, index) {
              var data = model.bvirtuals[2];
              return Card(
                margin: EdgeInsets.all(5.0),
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 225,
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: InkWell(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            //width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.transparent,
                                  child: CupertinoActivityIndicator(radius: 15,),
                                ),
                                imageUrl: 'http://bizapp.e-dagang.asia' + data.vr_list[index].vr_image ?? '',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),

                          Container(
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
                                    data.vr_list[index].vr_name,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  /*Text(
                                          '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),*/
                                  SizedBox(height: 2,),
                                  Text(
                                    data.vr_desc,
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.blue.shade600, fontSize: 13, fontWeight: FontWeight.w600,),
                                    ),
                                  ),

                                ]
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget _emptyVr() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/icons/empty.png', height: 120,),
          Text('No listing at the moment.',
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
            ),
          ),
        ],
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