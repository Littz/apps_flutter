import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/upskill_company.dart';
import 'package:edagang/screens/upskill/skill_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';


class GoilmuCompanyPage extends StatefulWidget {
  String bizId, bizName;
  GoilmuCompanyPage(this.bizId, this.bizName);

  @override
  _GoilmuCompanyPageState createState() {
    return new _GoilmuCompanyPageState();
  }
}

class _GoilmuCompanyPageState extends State<GoilmuCompanyPage> {
  int _selectedIndex = 0;
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Goilmu_Company_'+widget.bizName,parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    Upskill2ScopedModel goilmuModel = Upskill2ScopedModel();
    goilmuModel.fetchCourseList(int.parse(widget.bizId));

    return ScopedModel<Upskill2ScopedModel>(
      model: goilmuModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GoilmuCourseListPage(int.parse(widget.bizId)),
      ),
    );
  }

}


class GoilmuCourseListPage extends StatefulWidget {
  int bizId;
  GoilmuCourseListPage(this.bizId);

  @override
  _GoilmuCourseListBodyState createState() {
    return new _GoilmuCourseListBodyState(bizId: null);
  }
}

const xpandedHeight = 175.0;

class _GoilmuCourseListBodyState extends State<GoilmuCourseListPage> {
  BuildContext context;
  ScrollController _scrollController;
  Upskill2ScopedModel model;
  final int bizId;
  _GoilmuCourseListBodyState({@required this.bizId});
  Color color = Color(0xff2877EA);
  int pageIndex = 1;
  final myr = new NumberFormat("#,##0.00", "en_US");

  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;

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
    this.context = context;

    return ScopedModelDescendant<Upskill2ScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoadingGo ? _buildCircularProgressIndicator() : model.goilmuCourses.length > 0 ? CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: xpandedHeight,
              //backgroundColor: Color(0xffEEEEEE),
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
              title: SABTs(
                child: Container(
                    child: Text(model.getCompanyName().toUpperCase() ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Hero(
                      tag: "share",
                      child: InkWell(
                        onTap: () async {
                          await FlutterShare.share(
                            title: 'GOilmu',
                            text: '',
                            linkUrl: 'https://goilmuapp.e-dagang.asia/business/'+model.cid.toString(),
                            chooserTitle: model.getCompanyName() ?? '',
                          );
                        },
                        splashColor: Color(0xffA0CCE8),
                        highlightColor: Color(0xffA0CCE8),
                        child: BlurIconLight(
                          icon: Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                        ),
                      )
                  ),
                ),

              ],
              flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                background: Column(
                    children: <Widget>[
                      Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          Image.asset(
                            'assets/bggoilmu.png', fit: BoxFit.fill,
                            height: 155,
                          ),
                          FractionalTranslation(
                            translation: Offset(0.1, 0.5),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    blurRadius: 2.5,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.5, 2.5),
                                  )
                                ],
                                //border: new Border.all(color: Colors.blue, width: 1.5,),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: model.getLogo() ?? "",
                                  //fit: BoxFit.cover,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.only(left: 8.0, top: 1.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 2, right: 7, bottom: 3),
                                alignment: Alignment.topLeft,
                                child: Text(model.getCompanyName().toUpperCase() ?? "",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 14, fontWeight: FontWeight.w700 ),
                                  ),
                                ),
                              ),
                              /*Container(
                                padding: EdgeInsets.only(left: 2, right: 7),
                                child: htmlText2(address),
                              ),*/
                            ],
                          ),
                        ),
                        //_reqBtn(),
                        /*InkWell(
                          onTap: () async {
                            await FlutterShare.share(
                              title: 'GOilmu',
                              text: '',
                              linkUrl: 'https://upskillapp.e-dagang.asia/business/'+model.cid.toString(),
                              chooserTitle: model.getCompanyName() ?? '',
                            );
                          },
                          splashColor: Color(0xffA0CCE8),
                          highlightColor: Color(0xffA0CCE8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.share, color: color),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                child: Text('SHARE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(padding: EdgeInsets.all(10),
              sliver: _buildGridList(),
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        ) : CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: xpandedHeight,
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
              title: SABTs(
                child: Container(
                    child: Text(model.getCompanyName() ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                ),
              ),
              flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                background: Column(
                    children: <Widget>[
                      Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          Image.asset(
                            'assets/bggoilmu.png', fit: BoxFit.fill,
                            height: 165,
                          ),
                          FractionalTranslation(
                            translation: Offset(0.1, 0.5),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    blurRadius: 2.5,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.5, 2.5),
                                  )
                                ],
                                //border: new Border.all(color: Colors.blue, width: 1.5,),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: model.getLogo() ?? "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.only(left: 8.0, top: 1.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 2, right: 7, bottom: 5),
                                alignment: Alignment.topLeft,
                                child: Text(model.getCompanyName() ?? "",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 14, fontWeight: FontWeight.w700 ),
                                  ),
                                ),
                              ),
                              /*Container(
                                padding: EdgeInsets.only(left: 2, right: 7),
                                child: htmlText2(address),
                              ),*/
                            ],
                          ),
                        ),
                        //_reqBtn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
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

                  ),
                )
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        );
      },
    );
  }

  _buildGridList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: SliverList(
        /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5,
          childAspectRatio: 0.815,
        ),*/
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var data = model.goilmuCourses[index];

          double price = double.tryParse(data.price.toString()) ?? 0;
          assert(price is double);
          var cost = 'RM'+myr.format(price);

          return Card(
              margin: EdgeInsets.all(4.0),
              elevation: 1.5,
              shadowColor: Colors.grey.shade500,
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
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 7.0, top: 0.0),
                                child: Text(
                                  data.title ?? '',
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
                              left: 5.0, right: 7.0, bottom: 7.0),
                          child: Text(
                            data.descr ?? '',
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  cost,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 12,
                                        color: Colors.red.shade600,
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
          childCount: model.goilmuCourses.length,
        ),
      ),
    );
  }

  _buildCircularProgressIndicator() {
    return Center(
      child: Container(
          width: 75,
          height: 75,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xff2877EA)),
                strokeWidth: 1.7,
              ),
              SizedBox(height: 5.0,),
              Text('Loading...',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontSize: 13),
                ),
              ),
            ],
          )
      ),
    );
  }

}
