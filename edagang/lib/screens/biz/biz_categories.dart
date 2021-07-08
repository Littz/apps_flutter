import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/biz_cat_scoped.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:edagang/screens/biz/search.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';


class MyDashboard extends StatefulWidget {
  int selectedTab, totCat;
  MyDashboard(this.selectedTab, this.totCat);

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> with TickerProviderStateMixin {
  TabController _catController;
  bool isLoading = false;
  Color color = Color(0xff2877EA);

  @override
  void initState() {
    super.initState();
    _catController = new TabController( vsync: this, initialIndex: widget.selectedTab, length: widget.totCat);
  }

  @override
  void dispose() {
    _catController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
    {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Categories",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.search),
              onPressed: () {Navigator.push(context, SlideRightRoute(page: SearchList()));},
            ),
            Padding(padding: EdgeInsets.only(right: 10.0),),
          ],
          bottom: new TabBar(
            controller: _catController,
            indicatorColor: color,
            isScrollable: true,
            labelStyle: GoogleFonts.lato(
              textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 16, fontWeight: FontWeight.w600),
            ),  //For Selected tab
            unselectedLabelStyle: GoogleFonts.lato(
              textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade400),
            ), //For Un-selected Tabs
            tabs: List<Widget>.generate(
              model.bcategory.length,(int index) {
                return Tab(text: model.bcategory[index].cat_name == 'Telecoms' ? 'Telecommunication' : model.bcategory[index].cat_name, );
              },
            ),
          ),
        ),
        body: TabBarView(
          controller: _catController,
          children: List<Widget>.generate(
            model.bcategory.length,(int index) {
              return getWidget(model.bcategory[index].cat_id);
            },
          ),
        ),

      );
    });
  }

  Widget getWidget(int widgetNumber) {
    return BizCatPage(widgetNumber.toString());
  }

}

class BizCatPage extends StatefulWidget {
  String catId;
  BizCatPage(this.catId);

  @override
  _BizCatPageState createState() {return new _BizCatPageState();}
}

class _BizCatPageState extends State<BizCatPage> {
  BuildContext context;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SmartbizScopedModel bizModel = SmartbizScopedModel();
    bizModel.fetchBizCategory(int.parse(widget.catId));

    return ScopedModel<SmartbizScopedModel>(
      model: bizModel,
      child: Scaffold(
        backgroundColor: Color(0xffEEEEEE),
        body: BizCatCompanyList(catId: int.parse(widget.catId)),
      ),
    );
  }
}

class BizCatCompanyList extends StatelessWidget {
  BuildContext context;
  SmartbizScopedModel model;
  final int catId;
  BizCatCompanyList({@required this.catId});
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<SmartbizScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoadingCat ? buildCircularProgressIndicator() : model.bizcat.length > 0 ? CustomScrollView(
          slivers: <Widget>[
            SliverPadding(padding: EdgeInsets.all(10),
              sliver: _buildGridList(),
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        ) : CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/ed_logo_grey.png', height: 150,),
                        Text('No listing at the moment.',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                          ),
                        ),
                      ],
                    ),

                  ),
                )
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        );
      },
    );
  }

  _buildGridList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5,
          childAspectRatio: 0.815,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          var data = model.bizcat[index];
          return InkWell(
            onTap: () {
              Navigator.push(context,SlideRightRoute(page: BizCompanyDetailPage(data.id.toString(),data.name)));
            },
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            color: Colors.white,
                            child: Card(
                              color: Colors.white,
                              elevation: 0.0,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                                        child: data.logo == null ? Image.asset(
                                          'assets/icons/ic_edagang.png',  width: 90,
                                          height: 90,) : CachedNetworkImage(
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
                                                    topLeft: Radius.circular(8.0),
                                                    topRight: Radius.circular(8.0)
                                                )
                                            ),
                                          ),
                                          placeholder: (context, url) => Container(
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child: Image.asset('assets/images/ed_logo_greys.png', width: 90,
                                              height: 90,),
                                          ),
                                          errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(data.name,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 8.0)
                                  ]
                              ),
                            ),
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: data.verify == 1 ? Padding(
                        padding: EdgeInsets.only(top: 5, right: 5),
                        child: Image.asset('assets/icons/verify.png', fit: BoxFit.cover, height: 21,),
                        /*Text('Verified',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                          ),
                        ),*/
                      ) : Container(),
                    ),
                  ]
              ),
            ),
          );
        },
          childCount: model.bizcat.length,
        ),
      ),
    );
  }

}
