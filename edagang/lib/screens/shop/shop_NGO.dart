import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/product_ngo.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
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
          backgroundColor: Colors.grey.shade100,
          body: CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  childAspectRatio: 0.815,
                ),
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  var data = model.ngo[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, SlideRightRoute(page: ProductNgoPage(data.id.toString(),data.associateName)));
                    },
                    child: Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Center(
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
                                                  borderRadius: BorderRadius.circular(8)
                                              ),
                                              child: data.associateLogo == null ? Image.asset(
                                                'assets/icons/ic_launcher_new.png', height: 80.0, width: 80.0,
                                                fit: BoxFit.cover,)
                                                  : CachedNetworkImage(
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
                                                          topLeft: Radius.circular(8.0),
                                                          topRight: Radius.circular(8.0)
                                                      )
                                                  ),
                                                ),
                                                placeholder: (context, url) => Container(
                                                  color: Colors.grey.shade200,
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.image, size: 36,),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(7.0),
                                            child: Text(data.associateName,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                              ),
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                )
                            )
                        ),
                      ),
                    ),
                  );
                },
                  childCount: model.ngo.length,
                ),
              )
            ),
          ]),
        );
      }
    );
  }

}