import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/product_koop.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class KooperasiPage extends StatefulWidget {

  @override
  _KooperasiPageState createState() => _KooperasiPageState();
}

class _KooperasiPageState extends State<KooperasiPage> {
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
              title: new Text('Koperasi',
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
          backgroundColor: Colors.grey.shade100,
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
                  var data = model.kooperasi[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, SlideRightRoute(page: ProductKoopPage(data.id.toString(),data.associateName)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.grey[600]),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)
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
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)
                                    )
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade200,
                                  //child: CupertinoActivityIndicator(radius: 15,),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.image, size: 36,),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(data.associateName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                ),
                            ),
                          ),
                          SizedBox(height: 8.0)
                        ]
                      )
                    ),
                  );
                },
                  childCount: model.kooperasi.length,
                ),
              )
            ),
          ]),
        );
      }
    );
  }

}