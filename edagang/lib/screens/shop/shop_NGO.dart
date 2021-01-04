import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/screens/shop/product_ngo.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class NgoPage extends StatefulWidget {

  @override
  _NgoPageState createState() => _NgoPageState();
}

class _NgoPageState extends State<NgoPage> {
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
              elevation: 0.0,
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: new Text('NGO',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xffF45432),
                      Colors.deepOrangeAccent.shade100,
                    ]
                  ),
                )
              ),
            )
          ),
          backgroundColor: Colors.white,
          body: CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(7),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 7.0,
                  crossAxisSpacing: 7.0,
                  childAspectRatio: 0.815,
                ),
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  var data = model.ngo[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, SlideRightRoute(page: ProductNgoPage(data.id.toString(),data.associateName)));
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
                                alignment: Alignment.topCenter,
                                imageUrl: Constants.urlImage + data.associateLogo ?? '',
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
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
                            child: Text(data.associateName,
                              textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                ),
                            ),
                          ),
                          SizedBox(height: 8.0)
                        ]
                      )
                    ),
                  );
                },
                  childCount: model.ngo.length,
                ),
              )
            ),
            /*SliverPadding(
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
                            itemCount: model.ngo.length,
                            itemBuilder: (context, index) {
                              var data = model.ngo[index];
                              return InkWell(
                                  onTap: () {
                                    sharedPref.save("mer_id", data.id.toString());
                                    sharedPref.save("mer_title", data.associateName);
                                    Navigator.push(context, SlideRightRoute(page: ProductNgoPage()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 70.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: SizedBox(
                                              height: 70,
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) => Container(
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.transparent,
                                                  child: CupertinoActivityIndicator(radius: 15,),
                                                ),
                                                imageUrl: Constants.urlImage + data.associateLogo,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0, top: 5.0),
                                          alignment: Alignment.topLeft,
                                          child: htmlText(data.associateName),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 44,
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
                    ),
                  ],
                ),
              ),
            ),*/
          ]),
        );
      }
    );
  }

}