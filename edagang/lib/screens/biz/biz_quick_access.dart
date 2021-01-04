import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_cat_list.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class BizCompanyPage extends StatefulWidget {
  @override
  _BizCompanyPageState createState() => _BizCompanyPageState();
}

class _BizCompanyPageState extends State<BizCompanyPage> {
  int _selectedIndex = 0;
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: new AppBar(
              centerTitle: false,
              elevation: 1.0,
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: new Text('Companies',
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
          body: CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: <Widget>[
                        ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                            indent: 10.0,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.companylist.length,
                          itemBuilder: (context, index) {
                            var data = model.companylist[index];
                            return InkWell(
                              onTap: () {
                                sharedPref.save("biz_id", data.id.toString());
                                Navigator.push(context,SlideRightRoute(page: CompanyDetailPage(data.id.toString(),data.company_name)));
                              },
                              child: data.category.length > 0 ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Text(
                                              data.company_name,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.0, top: 7.0),
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              CupertinoIcons.chevron_forward,
                                              size: 18,
                                              color: Color(0xff2877EA),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 7.0, right: 7.0,),
                                    child: Text(
                                      data.category,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,),
                                      ),
                                    ),
                                  ),
                                ],
                              ) : Container(
                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Text(
                                          data.company_name,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 7.0, top: 7.0),
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          CupertinoIcons.chevron_forward,
                                          size: 18,
                                          color: Color(0xff2877EA),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            );
                          },
                        )
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      }
    );
  }

}







class BizProductPage extends StatefulWidget {
  final String id,name;
  BizProductPage(this.id, this.name);

  @override
  _BizProductPageState createState() => _BizProductPageState();
}

class _BizProductPageState extends State<BizProductPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: new AppBar(
              centerTitle: false,
              elevation: 1.0,
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: new Text(widget.name,
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
          body: CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: <Widget>[
                        ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                            indent: 10.0,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.bizcat2.length,
                          itemBuilder: (context, index) {
                            var data = model.bizcat2[index];
                            return InkWell(
                              onTap: () {
                                sharedPref.save("cat_id", data.id.toString());
                                Navigator.push(context,SlideRightRoute(page: CatListPage(data.id, data.name)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Text(
                                          data.name,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 7.0, top: 7.0),
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          CupertinoIcons.chevron_forward,
                                          size: 18,
                                          color: Color(0xff2877EA),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      }
    );
  }

}


class BizServicesPage extends StatefulWidget {
  final String id,name;
  BizServicesPage(this.id, this.name);

  @override
  _BizServicesPageState createState() => _BizServicesPageState();
}

class _BizServicesPageState extends State<BizServicesPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Scaffold(
            appBar: new PreferredSize(
                preferredSize: Size.fromHeight(56.0),
                child: new AppBar(
                  centerTitle: false,
                  elevation: 1.0,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  title: new Text(widget.name,
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
            body: CustomScrollView(slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                          children: <Widget>[
                            ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey,
                                indent: 10.0,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.bizcat3.length,
                              itemBuilder: (context, index) {
                                var data = model.bizcat3[index];
                                return InkWell(
                                  onTap: () {
                                    sharedPref.save("cat_id", data.id.toString());
                                    Navigator.push(context,SlideRightRoute(page: CatListPage(data.id, data.name)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Text(
                                              data.name,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.0, top: 7.0),
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              CupertinoIcons.chevron_forward,
                                              size: 18,
                                              color: Color(0xff2877EA),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        }
    );
  }
}


class BizReqQuotationPage extends StatefulWidget {
  final String id,name;
  BizReqQuotationPage(this.id, this.name);

  @override
  _BizReqQuotationPageState createState() => _BizReqQuotationPageState();
}

class _BizReqQuotationPageState extends State<BizReqQuotationPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Scaffold(
            appBar: new PreferredSize(
                preferredSize: Size.fromHeight(56.0),
                child: new AppBar(
                  centerTitle: false,
                  elevation: 1.0,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  title: new Text(widget.name,
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
            body: CustomScrollView(slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                    ],
                  ),
                ),
              ),
            ]),
          );
        }
    );
  }
}


class BizJoinUsPage extends StatefulWidget {
  final String id,name;
  BizJoinUsPage(this.id, this.name);

  @override
  _BizJoinUsPageState createState() => _BizJoinUsPageState();
}

class _BizJoinUsPageState extends State<BizJoinUsPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Scaffold(
            appBar: new PreferredSize(
                preferredSize: Size.fromHeight(56.0),
                child: new AppBar(
                  centerTitle: false,
                  elevation: 1.0,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  title: new Text(widget.name,
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
            body: CustomScrollView(slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                    ],
                  ),
                ),
              ),
            ]),
          );
        }
    );
  }
}
