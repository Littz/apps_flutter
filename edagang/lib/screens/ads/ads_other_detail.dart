import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';


class OtherDetailPage extends StatefulWidget {
  String jobId, jobName;
  OtherDetailPage(this.jobId, this.jobName);

  @override
  _OtherDetailPageState createState() => _OtherDetailPageState();
}

const xpandedHeight = 195.0;

class _OtherDetailPageState extends State<OtherDetailPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;

  bool isEnabled = true ;
  bool isLoading = false;
  Color color = Color(0xff2877EA);

  int _id,bizid;
  String title,descr,company,logo;
  List images = List();

  Widget currentTab;
  int currentValue = 0;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  getDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      setState(() {
        print("job ID : "+widget.jobId);

        http.post(
          'https://blurbapp.e-dagang.asia/api/blurb/others/v2/details?others_id='+widget.jobId,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          print('OTHERS RESPONSE CODE /////////////////');
          print(response.statusCode.toString());

          var resBody = json.decode(response.body);
          print('OTHERS COMPANY NAME >>>>>>>>>>>>>>'+resBody['data']['other'][0]['product_name']);
          print('OTHERS DETAIL RESPONSE ===============');
          print(resBody);

          setState(() {

            List<Images> imagesOther = [];
            resBody['data']['other'][0]['images'].forEach((newImage) {
              imagesOther.add(
                new Images(
                  id: newImage["id"],
                  property_id: newImage["product_id"],
                  file_path: newImage["file_path"],
                ),
              );
            });

            var data = JobsCat(
              id: resBody['data']['other'][0]['id'],
              company_id: resBody['data']['other'][0]['business_id'],
              title: resBody['data']['other'][0]['product_name'],
              descr: resBody['data']['other'][0]['product_desc'],
              company_name: resBody['data']['other'][0]['company']['company_name'],
              company_logo: resBody['data']['other'][0]['company']['logo'],
              image: imagesOther,
            );

            _id = data.id;
            bizid = data.company_id;
            title = data.title;
            descr = data.descr;
            company = data.company_name;
            logo = data.company_logo;
            images = data.image;
          });
          isLoading = false;
        });
      });
    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Blurb_Others_'+widget.jobName,parameters:null);
    getDetails();
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
          parent: _animationController
      )
    );
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > xpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model)
    {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: isLoading ? buildCircularProgressIndicator() : CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
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
              title: SABTs(
                child: Container(
                    child: Text(title ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
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
                            'assets/bgblurb.png', fit: BoxFit.fill,
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
                                  //fit: BoxFit.fitHeight,
                                  imageUrl: logo ?? '',
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
                                    child: Image.asset('assets/images/ed_logo_greys.png', width: 60,
                                      height: 60,),
                                  ),
                                  errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                ),


                                /*CachedNetworkImage(
                                  imageUrl: logo ?? "",
                                  //fit: BoxFit.cover,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                ),*/
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
                    padding: EdgeInsets.only(
                        left: 8.0, top: 1.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(widget.jobName ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontStyle: FontStyle.normal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(company ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontStyle: FontStyle.normal,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 1, bottom: 5),
                          child: _reqBtn(),
                        ),
                        _propertyDescription(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        ),
      ); // Here you direct access using widget
    });
  }

  Widget _propertyDescription() {
    return new SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: htmlText(descr),
          ),
          SizedBox(height: 10,),

        ],
      ),
    );
  }

  Widget _reqBtn() {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model){
      return Container(
        padding: EdgeInsets.only(left: 2, top: 5, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await FlutterShare.share(
                          title: 'Blurb',
                          text: '',
                          linkUrl: 'https://edagang.page.link/?link=https://blurbapp.e-dagang.asia/others/'+_id.toString(),
                          chooserTitle: title ?? '',
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
                  ]
              ),
            ),
            RaisedButton(
              shape: StadiumBorder(),
              color: color,
              child: Text('REQUEST',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
                ),
              ),
              onPressed: () {
                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(
                    page: WebviewWidget('https://blurb.e-dagang.asia/wv/reqform_others/'+model.getId().toString()+'/'+_id.toString(), title))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
              },
            ),
          ],
        ),
      );

    });

  }

  Future launchForm(String url) async {
    if (await canLaunch(url)) await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

}
