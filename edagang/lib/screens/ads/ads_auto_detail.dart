import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/photo_viewer.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:edagang/widgets/webview_f.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_indicator/page_indicator.dart';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';


class AutoShowcase extends StatefulWidget {
  String autoId, autoTitle;
  AutoShowcase(this.autoId, this.autoTitle);

  @override
  _AutoShowcasePageState createState() => _AutoShowcasePageState();
}

const xpandedHeight = 195.0;

class _AutoShowcasePageState extends State<AutoShowcase> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _dl;
  bool isEnabled = true ;
  bool isLoading = false;
  Color color = Color(0xff2877EA);
  String _selectedItem = '';

  int _aid,_bid,sale;
  String atitle,alocation,ayear,amileage,aprice,bname,amodel,avariant,adoors,aseat;

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
        http.post(
            Uri.parse('https://blurbapp.e-dagang.asia/api/blurb/auto/v2/details?auto_id='+widget.autoId),
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          responseBody = json.decode(response.body);
          var resBody = json.decode(response.body);
          print('RESPONSE');
          print(resBody);

          setState(() {

            List<Images> imagesPropertyList = [];
            resBody['data']['auto'][0]['images'].forEach((newImage) {
              imagesPropertyList.add(
                new Images(
                  id: newImage["id"],
                  property_id: newImage["cars_id"],
                  file_path: newImage["file_path"],
                ),
              );
            });

            var data = AutoCat(
              id: resBody['data']['auto'][0]['id'],
              title: resBody['data']['auto'][0]['title'],
              location: resBody['data']['auto'][0]['location'],
              year: resBody['data']['auto'][0]['year'],
              mileage: resBody['data']['auto'][0]['mileage'],
              price: resBody['data']['auto'][0]['price'],
              brand_id: resBody['data']['auto'][0]['brand']['id'],
              brand_name: resBody['data']['auto'][0]['brand']['name'],
              model: resBody['data']['auto'][0]['model'],
              variant: resBody['data']['auto'][0]['variant'],
              doors: resBody['data']['auto'][0]['doors'],
              seat_capacity: resBody['data']['auto'][0]['seat_capacity'],
              sale_status: resBody['data']['auto'][0]['sale_status'],
              images: imagesPropertyList,
            );

            _aid = data.id ?? '';
            atitle = data.title ?? '';
            alocation = data.location;
            ayear = data.year;
            amileage = data.mileage;
            aprice = data.price ?? '';
            _bid = data.brand_id ?? '';
            bname = data.brand_name ?? '';
            amodel = data.model ?? '';
            avariant = data.variant ?? '';
            adoors = data.doors ?? '';
            aseat = data.seat_capacity ?? '';
            sale = data.sale_status;
            images = data.images ?? '';

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
    FirebaseAnalytics().logEvent(name: 'Blurb_Auto_'+widget.autoTitle,parameters:null);
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
                    child: Text(atitle ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                ),
              ),
              flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                background: _propertyImages(),
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
                          padding: EdgeInsets.only(top: 4),
                          child: Text(atitle ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontStyle: FontStyle.normal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(aprice ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: sale == 1 ? Colors.grey : color,
                              ),
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
        //bottomNavigationBar: isLoading ? null : _buildBottomNavigationBar(),
      );
    });
  }

  Widget _propertyImages() {
    if(images.length == 0) {
      return Container();
    }else{
      return Container(
        child: sale == 1 ? Banner(
        message: "SOLD",
        textStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        location: BannerLocation.topStart,
        color: Colors.red.shade400,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: PageIndicatorContainer(
              align: IndicatorAlign.bottom,
              length: images.length,
              indicatorSpace: 8.0,
              padding: EdgeInsets.only(bottom: 10),
              indicatorColor: Colors.grey.shade300,
              indicatorSelectorColor: Colors.deepOrange.shade700,
              shape: IndicatorShape.circle(size: 7),

              child: PageView(
                children: images.map(
                      (image) {
                    return GestureDetector(
                      onTap:  () {
                        Navigator.push(context, SlideRightRoute(page: PhotoViewer(imej: image.file_path,)));
                      },
                      child: Hero(
                        tag: "Cartsini",
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Image.asset('assets/logo_edagang.png', width: 254,
                              height: 100,),
                          ),
                          imageUrl: image.file_path,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            )
        )) : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: PageIndicatorContainer(
              align: IndicatorAlign.bottom,
              length: images.length,
              indicatorSpace: 8.0,
              padding: EdgeInsets.only(bottom: 10),
              indicatorColor: Colors.grey.shade300,
              indicatorSelectorColor: Colors.deepOrange.shade700,
              shape: IndicatorShape.circle(size: 7),

              child: PageView(
                children: images.map(
                      (image) {
                    return GestureDetector(
                      onTap:  () {
                        Navigator.push(context, SlideRightRoute(page: PhotoViewer(imej: image.file_path,)));
                      },
                      child: Hero(
                        tag: "Cartsini",
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Image.asset('assets/logo_edagang.png', width: 254,
                              height: 100,),
                          ),
                          imageUrl: image.file_path,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            )
        ),
      );
    }
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
            child: Text(
              'Location: '+alocation,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Text(
              'Year: '+ayear,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Text(
              'Mileage: '+amileage,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Text(
              'Model: '+bname+' '+amodel,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Text(
              'Variant: '+avariant,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Text(
              'Seat Capacity: '+aseat,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
          return Container(
              padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),

                      ),
                    ),
                  ]
              )

          );
        }
    );
  }

  Widget _reqBtn() {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model){
      return Container(
        padding: EdgeInsets.only(left: 2, top: 5, right: 2),
        child: sale == 1 ? Container(
          alignment: Alignment.center,
            child: Text('SOLD',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: TextStyle(color: Colors.red.shade400, fontSize: 23, fontWeight: FontWeight.w700,),
          ),
        )) : Row(
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
                          linkUrl: 'https://edagang.page.link/?link=https://blurbapp.e-dagang.asia/auto/'+_aid.toString(),
                          chooserTitle: atitle ?? '',
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
            Container(
              child: RaisedButton(
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
                      page: WebViewPage('https://blurb.e-dagang.asia/wv/reqform_auto/'+model.getId().toString()+'/'+_aid.toString(), atitle))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                },
              ),
            ),

          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

}
