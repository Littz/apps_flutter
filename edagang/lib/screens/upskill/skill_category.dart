import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/upskill/skill_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class SkillProfessionalPage extends StatefulWidget {
  final String name;
  SkillProfessionalPage(this.name);

  @override
  _SkillProfessionalPageState createState() => _SkillProfessionalPageState();
}

class _SkillProfessionalPageState extends State<SkillProfessionalPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.name);
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.skillProfessional.length,
                              itemBuilder: (context, index) {
                                var data = model.skillProfessional[index];
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
                                                    flex: 3,
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 7.0, right: 0.0, bottom: 5.0),
                                                      child: Text(
                                                        data.title,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 7.0, top: 5.0),
                                                      alignment: Alignment.topRight,
                                                      child: Icon(
                                                        CupertinoIcons.chevron_forward,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Text(
                                                  data.descr,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        data.company_name,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          )
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


class SkillTechnicalPage extends StatefulWidget {
  final String name;
  SkillTechnicalPage(this.name);

  @override
  _SkillTechnicalPageState createState() => _SkillTechnicalPageState();
}

class _SkillTechnicalPageState extends State<SkillTechnicalPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.name);
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
                              itemCount: model.skillTechnical.length,
                              itemBuilder: (context, index) {
                                var data = model.skillTechnical[index];
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
                                                    flex: 3,
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 7.0, right: 0.0, bottom: 5.0),
                                                      child: Text(
                                                        data.title,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 7.0, top: 5.0),
                                                      alignment: Alignment.topRight,
                                                      child: Icon(
                                                        CupertinoIcons.chevron_forward,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Text(
                                                  data.descr,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        data.company_name,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          )
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


class SkillSafetyPage extends StatefulWidget {
  final String name;
  SkillSafetyPage(this.name);

  @override
  _SkillSafetyPageState createState() => _SkillSafetyPageState();
}

class _SkillSafetyPageState extends State<SkillSafetyPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.name);
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
                            ListView.builder(
                              /*separatorBuilder: (context, index) => Divider(
                                color: Colors.grey,
                                indent: 0.0,
                              ),*/
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.skillSafety.length,
                              itemBuilder: (context, index) {
                                var data = model.skillSafety[index];
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
                                                    flex: 3,
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 7.0, right: 0.0, bottom: 5.0),
                                                      child: Text(
                                                        data.title,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 7.0, top: 5.0),
                                                      alignment: Alignment.topRight,
                                                      child: Icon(
                                                        CupertinoIcons.chevron_forward,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Text(
                                                  data.descr,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(
                                                      data.company_name,
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                                      ),
                                                    ),
                                                  ]
                                                ),
                                              ),
                                            ],
                                          )
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


class SkillTrainingPage extends StatefulWidget {
  final String name;
  SkillTrainingPage(this.name);

  @override
  _SkillTrainingPageState createState() => _SkillTrainingPageState();
}

class _SkillTrainingPageState extends State<SkillTrainingPage> {
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    print('cat id ========= '+widget.name);
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.skillTraining.length,
                              itemBuilder: (context, index) {
                                var data = model.skillTraining[index];
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
                                                    flex: 3,
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 7.0, right: 0.0, bottom: 5.0),
                                                      child: Text(
                                                        data.title,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: 7.0, top: 5.0),
                                                      alignment: Alignment.topRight,
                                                      child: Icon(
                                                        CupertinoIcons.chevron_forward,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Text(
                                                  data.descr,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        data.company_name,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          )
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


