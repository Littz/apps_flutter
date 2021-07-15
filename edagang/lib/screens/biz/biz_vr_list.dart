import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/emptyList.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/webview_f.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';


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
    FirebaseAnalytics().logEvent(name: 'Smartbiz_Virtual_List',parameters:null);
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
                  pinned: true,
                  primary: true,
                  title: SABTs(
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
                          fontSize: 13, fontWeight: FontWeight.w700,),
                      ),
                      unselectedLabelStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,),
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
                    child: model.bvirtuals[0].vr_list.length > 0 ? _buildCompanyVr(key: "key1") : EmptyList('Virtual company not available yet.',subTitle: 'No listing at the moment.'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: model.bvirtuals[1].vr_list.length > 0 ? _buildGalleryVr(key: "key2") : EmptyList('Virtual gallery not available yet.',subTitle: 'No listing at the moment.'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: model.bvirtuals[2].vr_list.length > 0 ? _buildExhibitionVr(key: "key3") : EmptyList('Virtual exibition not available yet.',subTitle: 'No listing at the moment.'),
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
                      onTap: () {
                        Navigator.push(context, SlideRightRoute(
                            page: VirtualWebView(data.vr_list[index].vr_url,data.vr_list[index].vr_name)));
                      },
                      /*onTap: () async {
                        final String url = data.vr_list[index].vr_url ?? '';
                        if (await canLaunch(url)) await launch(
                          url,
                          forceSafariVC: false,
                          forceWebView: false,
                        );
                      },*/
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              //width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  imageUrl: data.vr_list[index].vr_image ?? '',
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(8.0),)
                                    ),
                                  ),
                                  //placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    child: Image.asset('assets/images/ed_logo_greys.png', width: 120,
                                      height: 120,),
                                  ),
                                  errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                ),


                                /*CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.transparent,
                                    child: CupertinoActivityIndicator(radius: 15,),
                                  ),
                                  imageUrl: 'http://bizapp.e-dagang.asia' + data.vr_list[index].vr_image ?? '',
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),*/
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
                    onTap: () {
                      Navigator.push(context, SlideRightRoute(
                          page: VirtualWebView(data.vr_list[index].vr_url,data.vr_list[index].vr_name)));
                    },
                    /*onTap: () async {
                      final String url = data.vr_list[index].vr_url ?? '';
                      if (await canLaunch(url)) await launch(
                        url,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    },*/
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            //width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                imageUrl: data.vr_list[index].vr_image ?? '',
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(8.0),)
                                  ),
                                ),
                                //placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: Image.asset('assets/images/ed_logo_greys.png', width: 120,
                                    height: 120,),
                                ),
                                errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
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
                    onTap: () {
                      /*Navigator.push(context, SlideRightRoute(
                          page: WebviewWidget(data.vr_list[index].vr_url,data.vr_list[index].vr_name)));*/
                      Navigator.push(context, SlideRightRoute(
                          page: VirtualWebView(data.vr_list[index].vr_url,data.vr_list[index].vr_name)));
                    },

                    /*async {
                      final String url = data.vr_list[index].vr_url ?? '';
                      if (await canLaunch(url)) await launch(
                        url,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    },*/
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            //width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                imageUrl: data.vr_list[index].vr_image ?? '',
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(8.0),)
                                  ),
                                ),
                                //placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child: Image.asset('assets/images/ed_logo_greys.png', width: 120,
                                    height: 120,),
                                ),
                                errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
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
