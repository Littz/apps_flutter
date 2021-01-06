import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:edagang/screens/biz/biz_quick_access.dart';
import 'package:edagang/screens/biz/webview_quot.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:edagang/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BizPage extends StatefulWidget {
  final TabController tabcontroler;
  BizPage({this.tabcontroler});
  
  @override
  _BizPageState createState() => _BizPageState();
}

class _BizPageState extends State<BizPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  SharedPref sharedPref = SharedPref();
  BuildContext context;
  List<Menus> quick_menu = new List();
  List<Menus> tabs_menu = new List();

  @override
  void initState() {
    quick_menu = getBizQxcess();
    tabs_menu = getBizTabs();
    super.initState();
  }

  launchURL() async {
    const url = 'https://smartbiz.e-dagang.asia/vr/paceup/office/index.htm';
    if (await canLaunch(url)) {
      await launch(url,  );
    } else {
      print("Can't Launch ${url}");
    }
  }

  _launchURL() async {
    const url = 'https://smartbiz.e-dagang.asia/vr/paceup/office/index.htm';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> doLaunch(BuildContext context) async {
    final String url = 'https://smartbiz.e-dagang.asia/vr/paceup/office/index.htm';
    if (await canLaunch(url))
    await launch(url, forceWebView: false, );
  }

  @override
  Widget build(BuildContext context) {
    double scr_width = MediaQuery.of(context).size.width;
    double scr_height = MediaQuery.of(context).size.height;
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model)
    {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: //searchBar(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: searchBar(context),
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.bell, color: Colors.grey.shade700,),
                      tooltip: 'Nortification',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverList(delegate: SliverChildListDelegate([
            Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    elevation: 1,
                    child: ClipPath(
                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Container(
                          height: 150.0,
                          decoration: new BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Swiper.children(
                            autoplay: true,
                            pagination: new SwiperPagination(
                              margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                              builder: new DotSwiperPaginationBuilder(
                                color: Colors.white30,
                                activeColor: Colors.redAccent.shade400,
                                size: 7.0,
                                activeSize: 7.0)
                            ),
                            children: <Widget>[
                              Image.asset(
                                'assets/cartsinibiz1.png', height: 150.0,
                                fit: BoxFit.cover,),
                              Image.asset(
                                'assets/cartsinibiz3.png', height: 150.0,
                                fit: BoxFit.cover,),
                              Image.asset(
                                'assets/edaganghome3.png', height: 150.0,
                                fit: BoxFit.cover,),
                            ],
                          ),
                        )
                    )
                )
            ),
          ])),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              child: Text('Quick Access',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
              ),
            ),
          ),

          /*SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _quickList(context),
            ),
          ),*/

          SliverPadding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            sliver: _quickList(context),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              height: 115,
              child: InkWell(
                onTap: () {
                  doLaunch(context);
                  //_launchInWebViewWithJavaScript(context, 'https://smartbiz.e-dagang.asia/vr/paceup/office/index.htm');
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  elevation: 0.0,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: Image.asset(
                        'assets/images/virtual_trade.png', fit: BoxFit.cover,
                        height: 115,
                      ),
                    )
                  )
                )
              )
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            sliver: _tabList(context, widget.tabcontroler),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
              child: Text('Most Visited',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          _topCompany(),

        ]),
      );
    });
  }

  Widget _quickList(BuildContext context) {
    if(quick_menu.length == 0) {
      return Container();
    }else{
      return ScopedModelDescendant(builder: (BuildContext context, Widget child,MainScopedModel model){
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 2.5,
          crossAxisSpacing: 2.5,
          //childAspectRatio: MediaQuery
          //    .of(context)
          //    .size
          //    .width / (MediaQuery
          //    .of(context)
          //    .size
          //    .height / 1.45),
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context,int index) {
            var data = quick_menu[index];
            return Container(
            //color: Colors.grey.shade300,
            alignment: Alignment.topCenter,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 34,
                height: 34,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(8.0),
                  onPressed: () {
                    if (data.id == 1) {
                      Navigator.push(context,SlideRightRoute(page: BizCompanyPage()));
                    } else if (data.id == 2) {
                      Navigator.push(context, SlideRightRoute(page: BizProductPage('2', 'Product')));
                    } else if (data.id == 3) {
                      Navigator.push(context, SlideRightRoute(page: BizServicesPage('3', 'Services')));
                    } else if (data.id == 4) {
                      if(model.isAuthenticated) {
                        Navigator.push(context, SlideRightRoute(page: WebviewQuot('https://smartbiz.e-dagang.asia/biz/quot/' +
                        model.getId().toString() + '/0',
                        'Quotation')));
                      }else{
                        Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                      }
                    } else if (data.id == 5) {
                      Navigator.push(context, SlideRightRoute(page: WebviewQuot('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));
                    }
                  },
                  color: Colors.transparent,
                  child: Image.asset(data.imgPath,),
                ),
              ),
              SizedBox(height: 8.0,),
              Container(
                height: 20.0,
                child: Center(
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ],
            ),
            );
          },
          childCount: quick_menu.length,
          ),
        );
        /*return Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {Navigator.push(context,SlideRightRoute(page: BizCompanyPage()));},
                    child: SquareButton(
                    icon: Image.asset('assets/icons/biz_cat.png',),
                    label: 'Company',
                    lebar: 34,
                    tinggi: 34,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: InkWell(
                  onTap: () {Navigator.push(context, SlideRightRoute(page: BizProductPage('2', 'Product')));},
                  child: SquareButton(
                  icon: Image.asset('assets/icons/biz_prod.png',),
                  label: 'Products',
                  lebar: 34,
                  tinggi: 34,
                  ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  ),
                  child: InkWell(
                  onTap: () {Navigator.push(context, SlideRightRoute(page: BizServicesPage('3', 'Services')));},
                  child: SquareButton(
                  icon: Image.asset('assets/icons/biz_svc.png',),
                  label: 'Services',
                  lebar: 34,
                  tinggi: 34,
                  ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  ),
                  child: InkWell(
                  onTap: () {
                    if(model.isAuthenticated) {
                      Navigator.push(context, SlideRightRoute(
                      page: WebviewQuot('https://smartbiz.e-dagang.asia/biz/quot/' + model.getId().toString() + '/0','Quotation')));
                    }else{
                      Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                    }
                  },
                  child: SquareButton(
                    icon: Image.asset('assets/icons/biz_quotation.png',),
                    label: 'Quotation',
                    lebar: 34,
                    tinggi: 34,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  ),
                  child: InkWell(
                  onTap: () {Navigator.push(context, SlideRightRoute(page: WebviewQuot('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));},
                  child: SquareButton(
                  icon: Image.asset('assets/icons/biz_joinus.png',),
                  label: 'Join Us',
                  lebar: 34,
                  tinggi: 34,
                  ),
                  ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );*/
      });
    }
  }

  Widget _tabList(BuildContext context, TabController tabcontroler) {
    if(tabs_menu.length == 0) {
      return Container();
    }else{

      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4),
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var data = tabs_menu[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Card(
              //margin: EdgeInsets.all(1),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: InkWell(
                onTap: () {
                  widget.tabcontroler.animateTo(data.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: AssetImage(data.imgPath),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            )
          );
        }, childCount: tabs_menu.length,
        ),
      );
    }
  }

  Widget _topCompany() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
    {
      return SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 7.0,
              crossAxisSpacing: 7.0,
              childAspectRatio: 0.815,
            ),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              var data = model.visitedlist[index];
              return InkWell(
                onTap: () {
                  sharedPref.save("biz_id", data.id.toString());
                  sharedPref.save("biz_name", data.company_name);
                  Navigator.push(context,SlideRightRoute(page: CompanyDetailPage(data.id.toString(),data.company_name)));
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600]),
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl: data.logo ?? '',
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7.0),
                                      topRight: Radius.circular(7.0)
                                    )
                                  ),
                                ),
                                placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                errorWidget: (context, url, error) => Icon(Icons.image, size: 32,),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(data.company_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.0)
                            ),
                          ),
                          SizedBox(height: 8.0)
                        ]
                    )
                ),
              );
            },
              childCount: model.visitedlist.length,
            ),
          )
      );
    });
  }

}

