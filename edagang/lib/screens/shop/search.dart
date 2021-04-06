import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/search_model.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';


class SearchList3 extends StatefulWidget {
  SearchList3({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchList3> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error;
  List<Repo3> _results = List();

  Timer debounceTimer;

  _SearchState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
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
            child: TextField(
              autofocus: true,
              controller:_searchQuery,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                //border: InputBorder.none,
                border: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.black)
                ),
                suffixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 10.0),
                  child: Icon(
                    CupertinoIcons.search,
                    color:Colors.black,
                  )
                ),
                hintText: "Search ...",
                hintStyle: TextStyle(color: Colors.grey.shade500)
              ),
            ),
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.white
                /*gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xffF45432),
                      Colors.deepOrangeAccent.shade100,
                    ]
                ),*/
              )
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitleProgress('Searching cartsini...');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else if (_searchQuery.text.isEmpty) {
      return CenterTitle('');
    } else if (_results.length == 0) {
      return CenterTitle('No result found.');
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return CartsiniItem(_results[index]);
          }
      );
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
          style: Theme.of(context).textTheme.headline,
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
                valueColor: AlwaysStoppedAnimation(Color(0xffF45432)),
                strokeWidth: 1.5
            ),
            SizedBox(height: 16,),
            Text(
              title,
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}

class CartsiniItem extends StatelessWidget {
  final Repo3 repo;
  CartsiniItem(this.repo);
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            sharedPref.save("prd_id", repo.prodId.toString());
            sharedPref.save("prd_title", repo.prodName);
            Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
          },
          highlightColor: Colors.lightBlueAccent,
          splashColor: Colors.red,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.transparent,
                      child: CupertinoActivityIndicator(
                        radius: 15,
                      ),
                    ),
                    imageUrl: Constants.urlImage+repo.imgLogo,
                    fit: BoxFit.scaleDown,
                    width: 76,
                    height: 76,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          repo.prodName,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 2)),
                        Text(
                          repo.company,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic,),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        /*GestureDetector(
                          onTap: () {
                            Navigator.push(context, SlideRightRoute(page: ProductListMerchant(repo.bizId,repo.company)));
                          },
                          child: Text(
                            repo.company,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline, fontStyle: FontStyle.italic,),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),*/

                        const Padding(padding: EdgeInsets.only(top: 3)),
                        Text(
                          repo.prodDesc != null ? repo.prodDesc : '',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 8)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

}

class Api {
  static final HttpClient _httpClient = HttpClient();
  static final String _url = "shopapp.e-dagang.asia";

  static Future<List<Repo3>> getRepositoriesWithSearchQuery(String query) async {
    final uri = Uri.https(_url, '/api/product/search', {
      'search_str': query,
      'sort': 'asc',
    });

    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['data']['products']['data'] == null) {
      return List();
    }

    return Repo3.mapJSONStringToList(jsonResponse['data']['products']['data']);
  }

  static Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      //final httpRequest = await _httpClient.postUrl(uri);
      //httpRequest.headers.set(HttpHeaders.authorizationHeader, "Bearer "+Constants.tokenGuest);
      //httpRequest.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

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