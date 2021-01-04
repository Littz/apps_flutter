import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/ads/ads_career_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class AdsCareerPage extends StatefulWidget {
  @override
  _AdsCareerPageState createState() => _AdsCareerPageState();
}

class _AdsCareerPageState extends State<AdsCareerPage> {
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
              //automaticallyImplyLeading: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: new Text('Careers',
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
                      Colors.grey.shade600,
                      Colors.grey.shade200,
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
                          itemCount: model.jobcat.length,
                          itemBuilder: (context, index) {
                            var data = model.jobcat[index];
                            return InkWell(
                              onTap: () {
                                sharedPref.save("job_id", data.id.toString());
                                Navigator.push(context,SlideRightRoute(page: CareerDetailPage(data.id.toString(),data.title)));
                              },
                              child: Column(
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
                                              data.title,
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
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 7.0, right: 7.0,),
                                    child: Text(
                                      data.company,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 7.0, right: 7.0,),
                                    child: Text(
                                      data.state,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,),
                                      ),
                                    ),
                                  ),
                                ],
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



class AdsPropertyPage extends StatefulWidget {
  final String id,name;
  AdsPropertyPage(this.id, this.name);

  @override
  _AdsPropertyPageState createState() => _AdsPropertyPageState();
}

class _AdsPropertyPageState extends State<AdsPropertyPage> {
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
                      Colors.grey,
                      Colors.grey.shade200,
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
                        Container(),
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


class AdsVehiclePage extends StatefulWidget {
  final String id,name;
  AdsVehiclePage(this.id, this.name);

  @override
  _AdsVehiclePageState createState() => _AdsVehiclePageState();
}

class _AdsVehiclePageState extends State<AdsVehiclePage> {
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
                              Colors.grey,
                              Colors.grey.shade200,
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
                            Container(),
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


class AdsServicePage extends StatefulWidget {
  final String id,name;
  AdsServicePage(this.id, this.name);

  @override
  _AdsServicePageState createState() => _AdsServicePageState();
}

class _AdsServicePageState extends State<AdsServicePage> {
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
                              Colors.grey,
                              Colors.grey.shade200,
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


class AdsRatePage extends StatefulWidget {
  final String id,name;
  AdsRatePage(this.id, this.name);

  @override
  _AdsRatePageState createState() => _AdsRatePageState();
}

class _AdsRatePageState extends State<AdsRatePage> {
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
                              Colors.grey,
                              Colors.grey.shade200,
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
