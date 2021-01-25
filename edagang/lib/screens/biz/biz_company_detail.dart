import 'package:edagang/models/biz_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/custom_dialog.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BizCompanyDetailPage extends StatefulWidget {
  String bizId, bizName;
  BizCompanyDetailPage(this.bizId, this.bizName);

  @override
  _BizCompanyDetailPageState createState() => _BizCompanyDetailPageState();
}

const xpandedHeight = 190.0;

class _BizCompanyDetailPageState extends State<BizCompanyDetailPage> with TickerProviderStateMixin {
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

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  getDetails() async {
    try {
      //String id = await sharedPref.read("biz_id");
      setState(() {
        //_bizId = id;
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
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController)
        );
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > xpandedHeight - kToolbarHeight;
  }

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false);
    } else {
      print("Can't Launch ${url}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
              title: SABT(
                child: Container(
                    child: Text(company_name ?? '',
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
                            'assets/edaganghome1.png', fit: BoxFit.fill,
                            height: 175,
                          ),
                          FractionalTranslation(
                            translation: Offset(0.1, 0.5),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                )],
                                //border: new Border.all(color: Colors.blue, width: 1.5,),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage.assetNetwork(
                                  placeholder: _logo ?? "",
                                  image: _logo ?? "",
                                  fit: BoxFit.fitWidth,
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
                    padding: EdgeInsets.all(8.0),
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
                                            onTap: () async {
                                              await FlutterShare.share(
                                                title: 'SmartBiz',
                                                text: '',
                                                linkUrl: 'https://bizapp.e-dagang.asia/company/'+_id.toString(),
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
                                    )
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
                            0: Text('Overview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                            1: Text('Product', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
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
          color: color,
          child: Text('VR OFFICE',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
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
          color: color,
          child: Text('VR SHOWROOM',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
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
                  color: color,
                  child: Text('VR OFFICE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
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
                  color: color,
                  child: Text('VR SHOWROOM',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
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
