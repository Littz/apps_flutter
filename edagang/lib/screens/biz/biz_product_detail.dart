import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ProductDetailPage extends StatefulWidget {

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _prodId;

  int _pid, _bid;
  String prod_name,prod_desc,company,imej;

  getDetails() async {

    try {
      String id = await sharedPref.read("prod_id");

      setState(() {
        _prodId = id;
        print("product ID : "+_prodId);

        http.post(
          Constants.bizAPI+'/product/details?product_id='+_prodId,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          print('PRODUCT RESPONSE CODE /////////////////');
          print(response.statusCode.toString());

          var resBody = json.decode(response.body);
          print('PRODUCT COMPANY NAME >>>>>>>>>>>>>>'+resBody['data']['product']['product_name'].toString());
          print('PRODUCT DETAIL RESPONSE ===============');
          print(resBody);

          setState(() {

            var data = Product(
              id: resBody['data']['product']['id'],
              business_id: resBody['data']['product']['business_id'],
              product_name: resBody['data']['product']['product_name'],
              product_desc: resBody['data']['product']['product_desc'],
              company_name: resBody['data']['product']['business']['company_name'],
              file_path: resBody['data']['product']['images']['file_path'],
            );

            _pid = data.id;
            _bid = data.business_id;
            prod_name = data.product_name;
            prod_desc = data.product_desc;
            company = data.company_name;
            imej = 'https://bizapp.e-dagang.asia'+data.file_path;

          });
        });
      });
    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: new AppBar(
          centerTitle: false,
          elevation: 1.0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(prod_name ?? "Product",
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 200,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            width: 40,
                            height: 40,
                            color: Colors.transparent,
                            child: CupertinoActivityIndicator(
                              radius: 15,
                            ),
                          ),
                          imageUrl: imej ?? "",
                          fit: BoxFit.cover,
                          height: 100,
                          width: 200,
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 1.0),
                              child: Text(company ?? "",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                                  ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(prod_name ?? "",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,),
                                  ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              child: htmlText(prod_desc),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    ); // Here you direct access using widget
  }

  @override
  void dispose() {
    super.dispose();
  }

}

