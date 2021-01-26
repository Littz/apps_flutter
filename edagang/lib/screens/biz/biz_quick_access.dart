import 'dart:async';
import 'dart:io';
import 'dart:convert' show json, utf8;
import 'package:edagang/models/search_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_cat_list.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
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
                            indent: 0.0,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.companylist.length,
                          itemBuilder: (context, index) {
                            var data = model.companylist[index];
                            return InkWell(
                              onTap: () {
                                sharedPref.save("biz_id", data.id.toString());
                                Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.company_name)));
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
                                          flex: 4,
                                          child: Container(
                                            child: Text(
                                              data.company_name.toUpperCase(),
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 5.0, top: 0.0),
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
                                margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: Text(
                                          data.company_name.toUpperCase(),
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5.0, top: 0.0),
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
                            indent: 0.0,
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
                                indent: 0.0,
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





class CompanyListView extends StatefulWidget {
  CompanyListView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CompanyListViewState();
}

class _CompanyListViewState extends State<CompanyListView> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error;
  List<Repo4> _results = List();

  Timer debounceTimer;

  _CompanyListViewState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          //performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
        _results = List();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = List();
    });

    final repos = await Api.getRepositoriesWithSearchQuery(query);
    if (this._searchQuery.text == query && this.mounted) {
      setState(() {
        _isSearching = false;
        if (repos != null) {
          _results = repos;
        } else {
          _error = 'Error searching repos';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        centerTitle: true,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            //border: Border.all(width: 1, color: Color(0xff2877EA),),
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white,
          ),
          child: SizedBox(
              height: 40,
              child: TextField(
                autofocus: false,
                controller:_searchQuery,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.w500,),
                ),
                cursorColor: Color(0xff2877EA),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(end: 10.0),
                        child: Icon(
                          CupertinoIcons.search,
                          color: Colors.grey.shade700,
                        )
                    ),
                    hintText: "Search ...",
                    hintStyle: TextStyle(color: Colors.grey.shade500)
                ),
              )
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
      ),
      backgroundColor: Colors.grey.shade100,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitleProgress('Searching company...');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else if (_searchQuery.text.isEmpty) {
      return ScopedModelDescendant<MainScopedModel>(
          builder: (context, child, model){
            return CustomScrollView(slivers: <Widget>[
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
                                indent: 0.0,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.companylist.length,
                              itemBuilder: (context, index) {
                                var data = model.companylist[index];
                                return InkWell(
                                    onTap: () {
                                      //sharedPref.save("biz_id", data.id.toString());
                                      Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.company_name)));
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
                                                flex: 4,
                                                child: Container(
                                                  child: Text(
                                                    data.company_name.toUpperCase(),
                                                    style: GoogleFonts.lato(
                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 5.0, top: 0.0),
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
                                      margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              child: Text(
                                                data.company_name.toUpperCase(),
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5.0, top: 0.0),
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
            ]);
          }
      );
    } else if (_results.length > 0) {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return SmartbizItem(_results[index]);
          }
      );
    } else {
      return CenterTitle('No result found.');
    }
  }

}

class CenterTitle extends StatelessWidget {
  final String title;

  CenterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ));
  }
}

class CenterTitleProgress extends StatelessWidget {
  final String title;

  CenterTitleProgress(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xff2877EA)),
                strokeWidth: 1.5
            ),
            SizedBox(height: 16,),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}

class SmartbizItem extends StatelessWidget {
  final Repo4 data;
  SmartbizItem(this.data);
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            sharedPref.save("biz_id", data.id.toString());
            Navigator.push(context, SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.name)));
          },
          highlightColor: Colors.lightBlueAccent,
          splashColor: Colors.red,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        sharedPref.save("biz_id", data.id.toString());
                        Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.name)));
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
                                  flex: 4,
                                  child: Container(
                                    child: Text(
                                      data.name.toUpperCase(),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5.0, top: 0.0),
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
                        margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Text(
                                  data.name.toUpperCase(),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 5.0, top: 0.0),
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
                  ),
                ]),
          )),
    );
  }

}

class Api {
  static final HttpClient _httpClient = HttpClient();

  static Future<List<Repo4>> getRepositoriesWithSearchQuery(String query) async {
    final uri = Uri.https(Constants.bizAPI, '/biz/companies', {
      'search_text': query,
    });

    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['data']['companies'] == null) {
      return List();
    }

    return Repo4.mapJSONStringToList(jsonResponse['data']['companies']);
  }

  static Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      //final httpRequest = await _httpClient.postUrl(uri);
      //httpRequest.headers.set(HttpHeaders.authorizationHeader, "Bearer "+Constants.tokenGuest);
      //httpRequest.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

      HttpClientRequest request = await _httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer "+Constants.tokenGuest);

      final httpResponse = await request.close();
      print('HTTPCLIENT RESPONSE CODE >>>>>>> '+httpResponse.statusCode.toString());
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      print('HTTPCLIENT RESPONSE DATA ======= '+responseBody.toString());
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}