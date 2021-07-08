import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/scoped/ads_company.dart';
import 'package:edagang/screens/ads/ads_prop_detail.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';


class BlurbCompanyPropertyDlPage extends StatefulWidget {
  String bizId, bizName;
  BlurbCompanyPropertyDlPage(this.bizId, this.bizName);

  @override
  _BlurbCompanyPropertyDlPageState createState() {
    return new _BlurbCompanyPropertyDlPageState();
  }
}

class _BlurbCompanyPropertyDlPageState extends State<BlurbCompanyPropertyDlPage> {
  int _selectedIndex = 0;
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Deeplink_Blurb_company_'+widget.bizName,parameters:null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlurbScopedModel propertyModel = BlurbScopedModel();
    propertyModel.fetchBlurbCompany(int.parse(widget.bizId));

    return ScopedModel<BlurbScopedModel>(
      model: propertyModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlurbPropertyListDlPage(int.parse(widget.bizId)),
      ),
    );
  }
}

class BlurbPropertyListDlPage extends StatefulWidget {
  int bizId;
  BlurbPropertyListDlPage(this.bizId);

  @override
  _BlurbPropertyListDlState createState() {
    return new _BlurbPropertyListDlState(bizId: null);
  }
}

const xpandedHeight = 185.0;

class _BlurbPropertyListDlState extends State<BlurbPropertyListDlPage> {
  BuildContext context;
  ScrollController _scrollController;
  BlurbScopedModel model;
  final int bizId;
  _BlurbPropertyListDlState({@required this.bizId});
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

    return ScopedModelDescendant<BlurbScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoadingBl ? buildCircularProgressIndicator() : model.blurbProp.length > 0 ? CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: xpandedHeight,
              //backgroundColor: Color(0xffEEEEEE),
              leading: Hero(
                  tag: "back",
                  child: InkWell(
                    onTap: () {Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(4)));},
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
                            title: 'BlurbProperty',
                            text: '',
                            linkUrl: 'https://edagang.page.link/?link=https://blurbapp.e-dagang.asia/company/'+model.cid.toString(),
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
                            'assets/blurbpromo.png', fit: BoxFit.fill,
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
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    child: Image.asset('assets/images/ed_logo_greys.png', width: 60,
                                      height: 60,),
                                  ),
                                  errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                ),
                              ),
                            ),
                          ),
                          /*Positioned(
                            bottom: -40.0,
                            right: 16.0,
                            child: Container(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () async {
                                    await FlutterShare.share(
                                      title: 'GOilmu',
                                      text: '',
                                      linkUrl: 'https://upskillapp.e-dagang.asia/business/'+model.getCompanyId().toString(),
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
                                ),
                            ),
                          ),*/
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
                    onTap: () {Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(4)));},
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
                                  errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
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
                        Image.asset('assets/images/ed_logo_grey.png', height: 150,),
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
          var data = model.blurbProp[index];

          double price = double.tryParse(data.price.toString()) ?? 0;
          assert(price is double);
          var cost = 'RM'+myr.format(price);

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
                      sharedPref.save("blurb_id", data.id.toString());
                      Navigator.push(context, SlideRightRoute(page: PropShowcase(data.id.toString(),data.title)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Image.asset('assets/images/ed_logo_greys.png', width: 60,
                                height: 60,),
                            ),
                            imageUrl: data.images[0].file_path,
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
                                      data.prop_type,
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
        },
          childCount: model.blurbProp.length,
        ),
      ),
    );
  }

}
