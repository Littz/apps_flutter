import 'package:edagang/data/datas.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/upskill/skill_category.dart';
import 'package:edagang/screens/upskill/skill_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class UpskillPage extends StatefulWidget {
  final TabController tabcontroler;
  UpskillPage({this.tabcontroler});

  @override
  _UpskillPageState createState() => _UpskillPageState();
}

class _UpskillPageState extends State<UpskillPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  BuildContext context;
  List<Menus> quick_menu = new List();

  @override
  void initState() {
    quick_menu = getUpskillCategory();
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
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0.0,
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: searchBar2(context),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade200,
            body: CustomScrollView(slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate([
                Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 5),
                child: Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        elevation: 1,
                        child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
                                    'assets/cartsiniupskill1.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/cartsiniupskill2.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                  Image.asset(
                                    'assets/cartsiniupskill3.png', height: 150.0,
                                    fit: BoxFit.cover,),
                                ],
                              ),
                            )
                        )
                    )
                )),
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
                padding: EdgeInsets.fromLTRB(10, 16, 10, 0),
                sliver: _quickList(context),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
                  child: Text('Latest Training',
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
                                itemCount: model.skillist.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = model.skillist[index];

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
                                              sharedPref.save("skil_id", data.id.toString());
                                              Navigator.push(context, SlideRightRoute(page: UpskillDetailPage()));
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
                                                    data.company_name,
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                  child: Text(
                                                    data.descr,
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
      return ScopedModelDescendant<MainScopedModel>(
          builder: (context, child, model)
      {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: MediaQuery
                .of(context)
                .size
                .width / (MediaQuery
                .of(context)
                .size
                .height / 1.40),
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            var data = quick_menu[index];
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //padding: EdgeInsets.only(top: 10),
                    height: 80.0,
                    width: 80.0,
                    child: Material(
                        type: MaterialType.transparency,
                        child: Ink(
                          decoration: BoxDecoration(
                            //border: Border.all(color: Color(0xff2877EA), width: 2.0),
                            //color: Color(0xff2877EA),
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
                            onTap: () {
                              if(model.skillcat[index].id == 1) {
                                Navigator.push(context, SlideRightRoute(
                                    page: SkillProfessionalPage(model.skillcat[index].name)));
                              }else if(model.skillcat[index].id == 2) {
                                Navigator.push(context, SlideRightRoute(
                                    page: SkillTechnicalPage(model.skillcat[index].name)));
                              }else if(model.skillcat[index].id == 3) {
                                Navigator.push(context, SlideRightRoute(
                                    page: SkillSafetyPage(model.skillcat[index].name)));
                              }else if(model.skillcat[index].id == 4) {
                                Navigator.push(context, SlideRightRoute(
                                    page: SkillTrainingPage(model.skillcat[index].name)));
                              }
                            },
                            child: Center(child: Image.asset(
                              data.imgPath, height: 44,
                              width: 44,
                              fit: BoxFit.cover,)),
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
                            model.skillcat[index].name,
                            //data.title,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
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
      });
    }
  }

}