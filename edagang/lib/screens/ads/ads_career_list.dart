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

class CareerListPage extends StatefulWidget {
  int jobId;
  String jobName;
  CareerListPage(this.jobId, this.jobName);

  @override
  _CareerListPageState createState() => _CareerListPageState();
}

class _CareerListPageState extends State<CareerListPage> {
  final key = GlobalKey<ScaffoldState>();
  List<JobList> _results = List();
  String _error;

  void fetchData(int jobid) async {
    setState(() {
      _error = null;
      _results = List();
    });

    final repos = await Api.getCareerList(jobid);
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
    fetchData(widget.jobId);
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
            title: new Text(widget.jobName,
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
          return CareerList(_results[index]);
        }
    );
  }

}

class CareerList extends StatelessWidget {
  final JobList repo;
  CareerList(this.repo);
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            sharedPref.save("prod_id", repo.jobId.toString());
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
                      imageUrl: 'https://blurbapp.e-dagang.asia'+repo.imgLogo,
                      fit: BoxFit.cover,
                      height: 60,
                    ),
                  ),
                  Text((repo.jobName != null) ? repo.jobName : '-',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text((repo.company != null) ? repo.company : '-',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      ),
                ]),
          )),
    );
  }

}

class Api {
  static final HttpClient _httpClient = HttpClient();
  static final String _url = "blurbapp.e-dagang.asia";

  static Future<List<JobList>> getCareerList(int catid) async {
    final uri = Uri.https(_url, '/api/career/job/listing', {
      'job_id': catid.toString()
    });

    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['data']['jobs'] == null) {
      return List();
    }

    return JobList.mapJSONStringToList(jsonResponse['data']['jobs']);
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

class JobList {
  final int jobId;
  final int companyId;
  final String jobName;
  final String jobCity;
  final String jobState;
  final String company;
  final String imgLogo;

  JobList(this.jobId, this.companyId, this.jobName, this.jobCity, this.jobState, this.company, this.imgLogo);

  static List<JobList> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((r) =>JobList(
        r['id'],
        r['company_id'],
        r['title'],
        r['city']['city_name'],
        r['state']['state_name'],
        r['company']['company_name'],
        r['company']['logo'])
    ).toList();
  }
}