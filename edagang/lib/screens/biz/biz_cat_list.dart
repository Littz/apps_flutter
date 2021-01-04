import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/screens/biz/biz_product_detail.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';

class CatListPage extends StatefulWidget {
  int catId;
  String catName;
  CatListPage(this.catId, this.catName);

  @override
  _CatListPageState createState() => _CatListPageState();
}

class _CatListPageState extends State<CatListPage> {
  final key = GlobalKey<ScaffoldState>();
  List<CatList> _results = List();
  String _error;

  void fetchData(int catid) async {
    setState(() {
      _error = null;
      _results = List();
    });

    final repos = await Api.getCompanyByCategory(catid);
    setState(() {
      if (repos != null) {
        _results = repos;
      } else {
        _error = 'Error repos';
      }
    });
  }

  @override
  void initState() {
    fetchData(widget.catId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: new AppBar(
            centerTitle: false,
            elevation: 1.0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: new Text(widget.catName,
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
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        itemCount: _results.length,
        itemBuilder: (BuildContext context, int index) {
          return CompanyList(_results[index]);
        }
    );
  }

}

class CompanyList extends StatelessWidget {
  final CatList repo;
  CompanyList(this.repo);
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            sharedPref.save("prod_id", repo.prodId.toString());
            Navigator.push(context, SlideRightRoute(page: ProductDetailPage()));
          },
          highlightColor: Colors.lightBlueAccent,
          splashColor: Colors.red,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.transparent,
                        child: CupertinoActivityIndicator(
                          radius: 15,
                        ),
                      ),
                      imageUrl: 'https://bizapp.e-dagang.asia'+repo.imgLogo,
                      fit: BoxFit.cover,
                      height: 60,
                    ),
                  ),
                  Text((repo.company != null) ? repo.company : '-',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      ),
                  Text((repo.prodName != null) ? repo.prodName : '-',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      ),
                ]),
          )),
    );
  }

}

class Api {
  static final HttpClient _httpClient = HttpClient();
  static final String _url = "bizapp.e-dagang.asia";

  static Future<List<CatList>> getCompanyByCategory(int catid) async {
    final uri = Uri.https(_url, '/api/product/category', {
      'category_id': catid.toString()
    });

    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['data']['products'] == null) {
      return List();
    }

    return CatList.mapJSONStringToList(jsonResponse['data']['products']);
  }

  static Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      HttpClientRequest request = await _httpClient.postUrl(uri);
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

class CatList {
  final int prodId;
  final int bizId;
  final String prodName;
  final String prodDesc;
  final String company;
  final String imgLogo;

  CatList(this.prodId, this.bizId, this.prodName, this.prodDesc, this.company, this.imgLogo);

  static List<CatList> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((r) =>CatList(
        r['id'],
        r['business_id'],
        r['product_name'],
        r['product_desc'],
        r['business']['company_name'],
        r['images']['file_path'])
    ).toList();
  }
}