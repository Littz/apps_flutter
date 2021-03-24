import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/custom_dialog.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDeeplinkPage extends StatefulWidget {
  String bizId, bizName;
  CompanyDeeplinkPage(this.bizId, this.bizName);

  @override
  _CompanyDeeplinkPageState createState() => _CompanyDeeplinkPageState();
}

class _CompanyDeeplinkPageState extends State<CompanyDeeplinkPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _dl;
  bool isEnabled = true;
  Color color = Color(0xff2877EA);

  int _id;
  String company_name,overview,address,office_phone,office_fax,email,website,_logo,vr_ofis,vr_room;
  List<Product> products = [];
  List<Award> awards = [];
  List<Cert> certs = [];

  Widget currentTab;
  int currentValue = 0;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  getDetails() async {
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
                    filename: 'https://bizapp.e-dagang.asia'+awad['filename'],
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
            company_name = data.company_name;
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
        });
      });
    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    getDetails();
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController));
  }

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      print("Can't Launch ${url}");
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
    title: 'SmartBiz',
    text: '',
    linkUrl: 'https://bizapp.e-dagang.asia/company/'+_id.toString(),
    chooserTitle: widget.bizName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: new AppBar(
          centerTitle: false,
          elevation: 0.0,
          //automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          leading: InkWell(
            onTap: () {Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(2)));},
            splashColor: Colors.deepOrange.shade100,
            child: Icon(Icons.arrow_back,),
          ),
          title: new Text(company_name ?? "Company Name",
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white,),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xff2877EA),
                  Color(0xffA0CCE8),
                ]
              ),
            )
          ),
        )
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
                          child: Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomLeft,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: new BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                ),
                                child: ClipPath(
                                  clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                                  child: Image.asset(
                                    'assets/edaganghome1.png', fit: BoxFit.cover,
                                    height: 150,
                                  ),
                                )
                              ),

                              FractionalTranslation(
                                translation: Offset(0.0, 0.5),
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: new Border.all(color: Colors.blue, width: 1.5,),
                                  ),
                                  child: _logoImage(_logo),
                                ),
                              ),

                              /*Positioned(
                                bottom: -47.0,
                                right: 0.0,
                                child: _virtualBtn(vr_ofis, vr_room),
                              ),*/

                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 49),
                        child: Text(company_name ?? "",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w700 ),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: htmlText2(address),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0, top: 0.0),
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

                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 5.0, top: 8.0,  bottom: 5),
                          child: Row(
                            children: <Widget>[
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
                            onTap: () {share();},
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
                            )
                            ),
                            Container(
                            alignment: Alignment.centerRight,
                            child:_virtualBtn(vr_ofis, vr_room)
                            ),
                            ],
                          )
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
                        selectedColor: Color(0xff2877EA),
                        borderColor: Color(0xff2877EA),
                        groupValue: currentValue,
                        children: const <int, Widget>{
                          0: Text('Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                          1: Text('Product', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                          2: Text('Award', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                          3: Text('Certificate', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
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
        ],
      ),
    ); // Here you direct access using widget
  }

  Widget _logoImage(String imgPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.grey), strokeWidth: 1.5),
        imageUrl: imgPath ?? '',
      ),
    );
  }

  Widget _virtualBtn(String vr1, String vr2) {
    if(vr1 != 'null' && vr2 != 'null') {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            OutlineButton(
            shape: StadiumBorder(),
            color: Colors.transparent,
            borderSide: BorderSide(color: color),
            child: Text('VR OFFICE',
              textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
                ),
              ),
              onPressed: () {launchURL(vr1);},
            ),

            VerticalDivider(),

            OutlineButton(
            shape: StadiumBorder(),
            color: Colors.transparent,
            borderSide: BorderSide(color: color),
            child: Text('VR SHOWROOM',
              textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
                ),
              ),
              onPressed: () {launchURL(vr2);},
            ),
          ],
        )
      );
    } else if(vr1 != 'null' && vr2 == 'null') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: OutlineButton(
          shape: StadiumBorder(),
          color: Colors.transparent,
          borderSide: BorderSide(color: color),
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
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: OutlineButton(
        shape: StadiumBorder(),
        color: Colors.transparent,
        borderSide: BorderSide(color: color),
        child: Text('VR SHOWROOM',
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
        textStyle: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600,),
        ),
        ),
        onPressed: () {launchURL(vr2);},
        ),
      );
    } else { return Container();}
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
                      //Navigator.of(context).push(TutorialOverlay());
                      showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomDialogBox(
                            title: data.product_name,
                            descriptions: data.product_desc,
                            text: "Close",
                          );
                        }
                      );
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
                          child: FadeInImage.assetNetwork(
                            placeholder: cupertinoActivityIndicatorSmall,
                            image: data.filename ?? '',
                            fit: BoxFit.cover,
                          ),
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

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}

