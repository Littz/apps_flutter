import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
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
import 'package:photo_view/photo_view.dart';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';


class PropDlShowcase extends StatefulWidget {
  String propId, propTitle;
  PropDlShowcase(this.propId, this.propTitle);

  @override
  _PropDlShowcasePageState createState() => _PropDlShowcasePageState();
}

const xpandedHeight = 195.0;

class _PropDlShowcasePageState extends State<PropDlShowcase> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _dl;
  bool isEnabled = true ;
  bool isLoading = false;
  Color color = Color(0xff2877EA);
  String _selectedItem = '';

  int _pid,_companyId,_propId;
  String ptitle,location,propName,propType,builtUp,price,bedroom,bathroom,developer,overview,companyName,companyLogo;

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
          Uri.parse('https://blurbapp.e-dagang.asia/api/blurb/property/details?property_id='+widget.propId),
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          responseBody = json.decode(response.body);
          var resBody = json.decode(response.body);
          print('RESPONSE');
          print(resBody);

          setState(() {

            List<Images> imagesPropertyList = [];
            resBody['data']['property'][0]['images'].forEach((newImage) {
              imagesPropertyList.add(
                new Images(
                  id: newImage["id"],
                  property_id: newImage["property_id"],
                  file_path: 'https://blurbapp.e-dagang.asia'+newImage["file_path"],
                ),
              );
            });

            var data = PropertyCat(
              id: resBody['data']['property'][0]['id'],
              company_id: resBody['data']['property'][0]['company_id'],
              title: resBody['data']['property'][0]['title'],
              location: resBody['data']['property'][0]['location'],
              prop_id: resBody['data']['property'][0]['prop_type']['id'],
              prop_name: resBody['data']['property'][0]['prop_type']['name'],
              prop_type: resBody['data']['property'][0]['prop_type']['type'],
              built_up_size: resBody['data']['property'][0]['built_up_size'],
              price: resBody['data']['property'][0]['price'],
              bedrooms: resBody['data']['property'][0]['bedrooms'],
              bathrooms: resBody['data']['property'][0]['bathrooms'],
              developer: resBody['data']['property'][0]['developer'],
              overview: resBody['data']['property'][0]['overview'],
              company_name: resBody['data']['property'][0]['company']['company_name'],
              logo: resBody['data']['property'][0]['company']['logo'],
              images: imagesPropertyList,
            );

            _pid = data.id ?? '';
            _companyId = data.company_id ?? '';
            ptitle = data.title ?? '';
            location = data.location;
            _propId = data.prop_id;
            propName = data.prop_name;
            propType = data.prop_type ?? '';
            builtUp = data.built_up_size ?? '';
            price = data.price ?? '';
            bedroom = data.bedrooms ?? '';
            bathroom = data.bathrooms ?? '';
            developer = data.developer ?? '';
            overview = data.overview ?? '';
            companyName = data.company_name ?? '';
            companyLogo = data.logo ?? '';
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
    FirebaseAnalytics().logEvent(name: 'Deeplink_Blurb_property_'+widget.propTitle,parameters:null);
    getDetails();
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController));
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
                    Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(4)));
                    //Navigator.pop(context);
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
                    child: Text(ptitle ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 15, color: Color(0xff084B8C)),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                ),
              ),
              flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                background: _propertyImages(),
              ),
              /*flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
              background: Image.asset(
                'assets/bgblurb.png', fit: BoxFit.fill,
                height: 150,
              ),
            ),*/

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
                          child: Text(ptitle ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontStyle: FontStyle.normal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(price ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: color,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 1),
                          child: _reqBtn(),
                        ),
                      ],
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _animationController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CupertinoSegmentedControl(
                          selectedColor: color,
                          borderColor: color,
                          groupValue: currentValue,
                          children: const <int, Widget>{
                            0: Text('Description', style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),),
                            1: Text('Overview', style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),),
                          },
                          onValueChanged: (value) {
                            if (value == 0) {
                              currentTab = Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: _propertyDescription(),
                              );
                            } else {
                              currentTab = Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: htmlText(overview ?? ''),
                              );
                            }
                            setState(() {
                              currentValue = value;
                            });
                          },
                        ),
                        currentTab ??
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: _propertyDescription(),
                            ),
                      ],
                    ),
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: _animationController.value,
                        child: FractionalTranslation(
                          translation: _movieInformationSlidingAnimation.value,
                          child: child,
                        ),
                      );
                    },
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
      ); // Here you direct access using widget
    });
  }

  Widget _propertyImages() {
    if(images.length == 0) {
      return Container();
    }else{
      return Container(
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
                            child: Image.asset('assets/images/ed_logo_greys.png', width: 60,
                              height: 60,),
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
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Developer: '+developer,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Type: '+propName+' - '+propType,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Location: '+location,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Built up: '+builtUp,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Bedroom: '+bedroom,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
          ),
          SizedBox(height: 10,),
          new Divider(height: 1.0, color: Colors.grey,),
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Bathroom: '+bathroom,
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
                          linkUrl: 'https://edagang.page.link/?link=https://blurbapp.e-dagang.asia/property/'+_pid.toString(),
                          chooserTitle: ptitle ?? '',
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
                    page: WebViewPage('https://blurb.e-dagang.asia/wv/reqform_prop/'+model.getId().toString()+'/'+_pid.toString(), ptitle))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
              },
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
