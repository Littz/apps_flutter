import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/scoped/biz_cat_scoped.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class BizCategoryPage extends StatefulWidget {
  String catId, catName;
  BizCategoryPage(this.catId, this.catName);

  @override
  _BizCategoryPageState createState() {
    return new _BizCategoryPageState();
  }
}

class _BizCategoryPageState extends State<BizCategoryPage> {
  int _selectedIndex = 0;
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Biz_category_'+widget.catName,parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    SmartbizScopedModel bizModel = SmartbizScopedModel();
    bizModel.fetchBizCategory(int.parse(widget.catId));

    return ScopedModel<SmartbizScopedModel>(
      model: bizModel,
      child: Scaffold(
        backgroundColor: Color(0xffEEEEEE),
        body: BizCategoryListCompanyBody(catId: int.parse(widget.catId)),
      ),
    );
  }

}

class BizCategoryListCompanyBody extends StatelessWidget {
  BuildContext context;
  SmartbizScopedModel model;
  final int catId;
  BizCategoryListCompanyBody({@required this.catId});

  int pageIndex = 1;

  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  BizCat bizCategory;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<SmartbizScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoadingCat ? buildCircularProgressIndicator() : model.bizcat.length > 0 ? CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              //expandedHeight: 100,
              iconTheme: IconThemeData(
                color: Color(0xff084B8C),
              ),
              pinned: true,
              primary: true,
              title: Text(model.getCategoryName() ?? '',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 18, color: Color(0xff084B8C)),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            SliverPadding(padding: EdgeInsets.all(10),
              sliver: _buildGridList(),
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        ) : CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              //expandedHeight: 100,
              iconTheme: IconThemeData(
                color: Color(0xff084B8C),
              ),
              pinned: true,
              primary: true,
              title: Text(model.getCategoryName() ?? '',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 18, color: Color(0xff084B8C)),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/empty.png', height: 120,),
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
              sharedPref.save("biz_id", data.id.toString());
              sharedPref.save("biz_name", data.name);
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
                                          'assets/icons/ic_launcher_new.png', height: 80.0, width: 80.0,
                                          fit: BoxFit.cover,)

                                            : CachedNetworkImage(
                                          fit: BoxFit.fitWidth,
                                          imageUrl: 'http://bizapp.e-dagang.asia'+data.logo ?? '',
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
                                          placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                          errorWidget: (context, url, error) => Icon(Icons.image_rounded, size: 36,),
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
