import 'package:edagang/data/datas.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/ads/ads_career_detail.dart';
import 'package:edagang/screens/ads/ads_quick_access.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class AdvertPage extends StatefulWidget {
  final TabController tabcontroler;
  AdvertPage({this.tabcontroler});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  BuildContext context;
  List<Menus> quick_menu = new List();

  @override
  void initState() {
    quick_menu = getAdsCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
        {
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            widget.tabcontroler.animateTo(2);
            return null;
          },
          child: Scaffold(
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
                                color: Colors.transparent,
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
                                    'assets/edaganghome1.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/edaganghome2.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/edaganghome3.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/cartsinishop1.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/cartsinishop2.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/cartsinishop3.png', height: 150.0,
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
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
                  child: Text('Category',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                      ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                sliver: _quickList(context),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
                  child: Text('Latest Career Vacancy',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: new EdgeInsets.only(bottom: 7.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListView.builder(
                                itemCount: model.jobcat.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = model.jobcat[index];

                                  return Card(
                                      margin: EdgeInsets.all(5.0),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      shadowColor: Color(0xff2877EA),
                                      child: Container(
                                        child: InkWell(
                                            onTap: () {
                                              sharedPref.save("job_id", data.id.toString());
                                              Navigator.push(context,SlideRightRoute(page: CareerDetailPage(data.id.toString(),data.title)));
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
                                                      flex: 4,
                                                      child: Container(
                                                        margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 10.0),
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          data.title,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.lato(
                                                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,),
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        margin: EdgeInsets.only(left: 5, right: 7.0, top: 10.0),
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
                                                    data.company,
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                  child: Text(
                                                    data.state,
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      )
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ));
        });
  }

  Widget _quickList(BuildContext context) {
    if(quick_menu.length == 0) {
      return Container();
    }else{
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 2.5,
          crossAxisSpacing: 2.5,
          childAspectRatio: MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height / 1.25),
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var data = quick_menu[index];
          return Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  height: 70.0,
                  width: 70.0,
                  child: Material(
                      type: MaterialType.transparency,
                      child: Ink(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Color(0xff2877EA), width: 2.0),
                          //color:  Color(0xff2877EA),
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color(0xff2877EA),
                                Color(0xffA0CCE8),
                              ]
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000.0),
                          onTap: (){
                            if (data.id == 1) {
                              Navigator.push(context,SlideRightRoute(page: AdsCareerPage()));
                            } else if (data.id == 2) {
                              Navigator.push(context, SlideRightRoute(
                                  page: AdsPropertyPage('2', 'Property')));
                            } else if (data.id == 3) {
                              Navigator.push(context, SlideRightRoute(
                                  page: AdsVehiclePage('3', 'Vehicle')));
                            } else if (data.id == 4) {
                              Navigator.push(context, SlideRightRoute(
                                  page: AdsServicePage('4', 'Services')));
                            } else if (data.id == 5) {
                              Navigator.push(context, SlideRightRoute(
                                  page: AdsRatePage('5', 'Rate')));
                            }
                          },
                          child: Center(child: Image.asset(data.imgPath, height: 34, width: 34, fit: BoxFit.fill,)),
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2.5, 5.0, 2.5, 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          data.title,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
          childCount: quick_menu.length,
        ),
      );
    }
  }

}
