import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/photo_viewer.dart';
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


class CompanyDeeplinkPage extends StatefulWidget {
  String bizId, bizName;
  CompanyDeeplinkPage(this.bizId, this.bizName);

  @override
  _CompanyDeeplinkPageState createState() => _CompanyDeeplinkPageState();
}

const xpandedHeight = 195.0;

class _CompanyDeeplinkPageState extends State<CompanyDeeplinkPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;

  bool isEnabled = true;
  Color color = Color(0xff2877EA);

  int _id;
  String company_name,overview,address,office_phone,office_fax,email,website,_logo,vr_ofis,vr_room;
  List<Product> products = [];
  List<Award> awards = [];
  List<Cert> certs = [];

  Widget currentTab;
  int currentValue = 0;
  bool isLoading = false;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  getDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      setState(() {
        print("product ID : "+widget.bizId);

        http.post(
          Constants.bizAPI+'/biz/details?business_id='+widget.bizId,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          print('BIZZZZZZZZZ RESPONSE CODE /////////////////');
          print(response.statusCode.toString());

          var resBody = json.decode(response.body);
          print('BIZZZZZZZZZ VR OFFICE >>>>>>>>>>>>>>'+resBody['data']['businesses']['vr_office'].toString());
          print('BIZZZZZZZZZ VR SHOWROOM >>>>>>>>>>>>>>'+resBody['data']['businesses']['vr_showroom'].toString());
          print('BIZZZZZZZZZ DETAIL RESPONSE ===============');
          print(resBody);

          setState(() {

            List<Product> _product = [];
            resBody['data']['businesses']['product'].forEach((produk) {
              _product.add(
                  new Product(
                    id: produk['id'],
                    business_id: produk['business_id'],
                    product_name: produk['product_name'],
                    product_desc: produk['product_desc'],
                  )
              );
            });

            List<Award> _award = [];
            resBody['data']['businesses']['award'].forEach((awad) {
              _award.add(
                  new Award(
                    id: awad['id'],
                    business_id: awad['business_id'],
                    award_desc: awad['award_desc'],
                    filename: awad['filename'] == null ? 'null' : 'https://bizapp.e-dagang.asia'+awad['filename'],
                  )
              );
            });

            List<Cert> _cert = [];
            resBody['data']['businesses']['certificate'].forEach((sijil) {
              _cert.add(
                  new Cert(
                    id: sijil['id'],
                    business_id: sijil['business_id'],
                    cert_name: sijil['cert_name'],
                    filename: sijil['filename'],
                  )
              );
            });

            var data = BizList(
              id: resBody['data']['businesses']['id'],
              company_name: resBody['data']['businesses']['company_name'].toString(),
              overview: resBody['data']['businesses']['overview'].toString(),
              address: resBody['data']['businesses']['address'].toString(),
              office_phone: resBody['data']['businesses']['office_phone'].toString(),
              office_fax: resBody['data']['businesses']['office_fax'].toString(),
              email: resBody['data']['businesses']['email'].toString(),
              website: resBody['data']['businesses']['website'].toString(),
              logo: 'https://bizapp.e-dagang.asia'+resBody['data']['businesses']['logo'],
              vr_office: resBody['data']['businesses']['vr_office'].toString(),
              vr_showroom: resBody['data']['businesses']['vr_showroom'].toString(),
              product: _product,
              award: _award,
              cert: _cert,
            );

            _id = data.id;
            company_name = data.company_name.toUpperCase();
            overview = data.overview;
            address = data.address;
            office_phone = data.office_phone;
            office_fax = data.office_fax;
            email = data.email;
            website = data.website;
            _logo = data.logo;
            vr_ofis = data.vr_office;
            vr_room = data.vr_showroom;
            products = data.product;
            awards = data.award;
            certs = data.cert;

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
    FirebaseAnalytics().logEvent(name: 'Deeplink_Smartbiz_Company_'+widget.bizName,parameters:null);
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

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      print("Can't Launch ${url}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? buildCircularProgressIndicator() : CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: xpandedHeight,
              iconTheme: IconThemeData(
                color: Color(0xff084B8C),
              ),
              leading: Hero(
                  tag: "back",
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(2)));
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
                    child: Text(company_name ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, color: Color(0xff084B8C)),
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
                            'assets/edaganghome1.png', fit: BoxFit.fill,
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
                                  imageUrl: _logo ?? "",
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
                          Positioned(
                            bottom: -16.0,
                            right: 16.0,
                            child: vr_ofis == 'null' && vr_room == 'null' ? Container() : Container(
                                alignment: Alignment.topRight,
                                child: virtualBtn(context, vr_ofis, vr_room)
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
                                child: Text(company_name ?? "",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 14, fontWeight: FontWeight.w700 ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 2, right: 7),
                                child: htmlText2(address),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 2, right: 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(website ?? "",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                      ),
                                    ),
                                    SizedBox(height: 1.0,),
                                    Text(office_phone ?? "",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                      ),
                                    ),
                                    SizedBox(height: 1.0,),
                                    Text(email ?? "",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _reqBtn(),

                      ],
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _animationController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CupertinoSegmentedControl(
                          selectedColor: Color(0xff2877EA),
                          borderColor: Color(0xff2877EA),
                          groupValue: currentValue,
                          children: const <int, Widget>{
                            0: Text('Overview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                            1: Text('Services', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                            2: Text('Award', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                            3: Text('Registration', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                          },
                          onValueChanged: (value) {
                            if (value == 0) {
                              currentTab = Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: htmlText(overview),
                              );
                            } else if(value == 1) {
                              currentTab = Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: _productList(),
                              );
                            } else if(value == 2) {
                              currentTab = Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: _awardList(),
                              );
                            } else {
                              currentTab = Padding(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: _certList(),
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
                              child: htmlText(overview),
                            )
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
          ]
      ),
    );
  }

  virtualBtn(BuildContext context, String vr1, String vr2) {
    if(vr1 == 'null' && vr2 == 'null') {
      return Container();
    } else if(vr1 != 'null' && vr2 == 'null') {
      return SizedBox(
        height: 32,
        child: RaisedButton(
          shape: StadiumBorder(),
          color: Colors.white,
          child: Text('VR OFFICE',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
            ),
          ),
          onPressed: () {launchURL(vr1);},
        ),
      );
    } else if(vr1 == 'null' && vr2 != 'null') {
      return SizedBox(
        height: 32,
        child: RaisedButton(
          shape: StadiumBorder(),
          color: Colors.white,
          child: Text('VR SHOWROOM',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
            ),
          ),
          onPressed: () {launchURL(vr2);},
        ),
      );
    } else if(vr1 != 'null' && vr2 != 'null') {
      return Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 32,
                child: RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.white,
                  child: Text('VR OFFICE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
                    ),
                  ),
                  onPressed: () {launchURL(vr1);},
                ),
              ),

              SizedBox(width: 5,),

              SizedBox(
                height: 32,
                child: RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.white,
                  child: Text('VR SHOWROOM',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
                    ),
                  ),
                  onPressed: () {launchURL(vr2);},
                ),
              )
            ],
          )
      );
    } else {
      return Container();
    }
  }

  Widget _reqBtn() {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model){
      //if(model.isAuthenticated){
      return Container(
        padding: EdgeInsets.only(left: 8.0, top: 3.0, right: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {launch("tel://"+office_phone, );},
                      splashColor: Color(0xffA0CCE8),
                      highlightColor: Color(0xffA0CCE8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: color),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text('CALL',
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

                    VerticalDivider(),

                    InkWell(
                      onTap: () async {
                        await FlutterShare.share(
                          title: 'SmartBiz',
                          text: '',
                          linkUrl: 'https://edagang.page.link/?link=https://bizapp.e-dagang.asia/company/'+_id.toString(),
                          chooserTitle: widget.bizName,
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
              child: Text('QUOTATION',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
                ),
              ),
              onPressed: () {
                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/quot/' + model.getId().toString() + '/' + widget.bizId, widget.bizName))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
              },
            ),
          ],
        ),
      );
      //}else{
      //  return Container();
      //}

    });

  }

  Widget _productList() {
    if(products.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Text(
            "Not available.",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                  indent: 10.0,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var data = products[index];
                  return InkWell(
                    onTap: () {
                      _viewSvcProduct(data.file_path, data.product_name, data.product_desc, widget.bizName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.only(left: 5.0, top: 5.0),
                            alignment: Alignment.topLeft,
                            child: htmlText(data.product_name),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 5.0, top: 5.0),
                            alignment: Alignment.topRight,
                            child: Icon(
                              CupertinoIcons.right_chevron,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  );
                },
              )
            ]
          )
        ),
      );
    }
  }

  Widget _awardList() {
    if(awards.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Text(
            "Not available.",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: awards.length,
                itemBuilder: (context, index) {
                  var data = awards[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60,
                          child: data.filename == 'null' ? Image.asset('assets/icons/ic_launcher_new.png', height: 28, width: 28, fit: BoxFit.cover,) : GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PhotoViewer(imej: data.filename,),)
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: data.filename ?? "",
                            fit: BoxFit.cover,
                            //placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                            )
                          ),
                        /*FadeInImage.assetNetwork(
                            placeholder: cupertinoActivityIndicatorSmall,
                            image: data.filename ?? '',
                            fit: BoxFit.cover,
                          ),*/
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: htmlText(data.award_desc),
                      ),
                    ],
                  );
                },
              )
            ]
          )
        ),
      );
    }
  }

  Widget _certList() {
    if(certs.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Text(
            "Not available.",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: certs.length,
                itemBuilder: (context, index) {
                  var data = certs[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, top: 5.0),
                          alignment: Alignment.topLeft,
                          child: htmlText(data.cert_name),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 5.0, top: 5.0),
                          alignment: Alignment.topRight,
                          child: Icon(
                            CupertinoIcons.right_chevron,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            ]
          )
        ),
      );

    }
  }

  _viewSvcProduct(String image, String title, String oview, String biz) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {Navigator.pop(context);},
            child: DraggableScrollableSheet(
              initialChildSize: 0.90,
              minChildSize: 0.2,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(16),
                        child: Icon(
                          LineAwesomeIcons.close,
                          color: Colors.red[600],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: Constants.padding,top: 0, right: Constants.padding,bottom: Constants.padding),
                                  //margin: EdgeInsets.only(top: Constants.padding),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      //SizedBox(height: 15,),
                                      Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: image == 'null' ? Container() : Container(
                                            decoration: new BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) => Container(
                                                  alignment: Alignment.center,
                                                  color: Colors.transparent,
                                                  child: Image.asset('assets/images/ed_logo_greys.png', width: 90,
                                                    height: 90,),
                                                ),
                                                imageUrl: image,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      biz.toLowerCase().contains('ta investment') ? SizedBox(height: 0,) : Text(title, style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600, color: Color(0xff2877EA)),),
                                      biz.toLowerCase().contains('ta investment') ? SizedBox(height: 0,) : SizedBox(height: 15,),
                                      htmlText(oview),
                                      SizedBox(height: 22,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
