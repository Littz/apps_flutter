import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CareerDetailPage extends StatefulWidget {
  String jobId, jobName;
  CareerDetailPage(this.jobId, this.jobName);

  @override
  _CareerDetailPageState createState() => _CareerDetailPageState();
}

class _CareerDetailPageState extends State<CareerDetailPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _dl;
  bool isEnabled = true ;
  bool isLoading = false;

  int _id,_compid,_yrxperience;
  String title,city,state,salary,descr,requirement,overview,email,company,logo;

  Widget currentTab;
  int currentValue = 0;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  getDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      //String id = await sharedPref.read("biz_id");

      setState(() {
        //_bizId = id;
        print("job ID : "+widget.jobId);

        http.post(
          'https://blurbapp.e-dagang.asia/api/career/job/details?job_id='+widget.jobId,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          print('JOBBBBB RESPONSE CODE /////////////////');
          print(response.statusCode.toString());

          var resBody = json.decode(response.body);
          print('JOBBBBB COMPANY NAME >>>>>>>>>>>>>>'+resBody['data']['job'][0]['title']);
          print('JOBBBBB DETAIL RESPONSE ===============');
          print(resBody);

          setState(() {

            var data = JobList(
              id: resBody['data']['job'][0]['id'],
              company_id: resBody['data']['job'][0]['company_id'],
              title: resBody['data']['job'][0]['title'],
              company_name: resBody['data']['job'][0]['company']['company_name'],
              logo: resBody['data']['job'][0]['company']['logo'],
              city: resBody['data']['job'][0]['city']['city_name'],
              state: resBody['data']['job'][0]['state']['state_name'],
              salary: resBody['data']['job'][0]['salary'],
              job_description: resBody['data']['job'][0]['job_description'],
              job_requirement: resBody['data']['job'][0]['job_requirement'],
              company_overview: resBody['data']['job'][0]['company_overview'],
              years_experience: resBody['data']['job'][0]['years_experience'],
              contact_email: resBody['data']['job'][0]['contact_email'],
            );

            _id = data.id;
            _compid = data.company_id;
            title = data.title;
            company = data.company_name;
            logo = 'https://blurbapp.e-dagang.asia'+data.logo;
            city = data.city;
            state = data.state;
            salary = data.salary;
            descr = data.job_description;
            requirement = data.job_requirement;
            overview = data.company_overview;
            _yrxperience = data.years_experience;
            email = data.contact_email;

          });
          isLoading = false;
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
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController));
  }

  /*void launchWhatsApp(
      {@required int phone,
        @required String message,
      }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "https://api.whatsapp.com/send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }*/

  Color color = Colors.grey.shade700;

  Future<void> share() async {
    await FlutterShare.share(
    title: 'Blurb',
    text: '',
    linkUrl: 'https://blurbapp.e-dagang.asia/career/'+_id.toString(),
    chooserTitle: widget.jobName,
    );
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
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          leading: InkWell(
            onTap: () {Navigator.pop(context);},
            splashColor: Colors.grey.shade100,
            highlightColor: Colors.deepOrange.shade100,
            child: Icon(
            Icons.arrow_back,
            ),
          ),
          title: new Text('Career Vacancy',
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
                  Colors.grey.shade600,
                  Colors.grey.shade200,
                ]
              ),
            )
          ),
        )
      ),
      backgroundColor: Colors.white,
      body: isLoading ? _buildCircularProgressIndicator() : CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

//                      Container(
//                        margin: EdgeInsets.only(left: 0.0, top: 0.0),
//                        height: 100,
//                        width: 200,
//                        child: CachedNetworkImage(
//                          fit: BoxFit.cover,
//                          imageUrl: logo ?? '',
//                          imageBuilder: (context, imageProvider) => Container(
//                            decoration: BoxDecoration(
//                              image: DecorationImage(
//                                image: imageProvider,
//                                fit: BoxFit.cover,
//                              ),
//                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                            ),
//                          ),
//                          placeholder: (context, url) => Container(
//                            width: 30,
//                            height: 30,
//                            color: Colors.transparent,
//                            child: CupertinoActivityIndicator(radius: 15,),
//                          ),
//                          errorWidget: (context, url, error) => Container(color: Colors.grey.shade200, child: Icon(Icons.image, color: Colors.white, size: 44,),),
//                        ),
//
//                        /*FadeInImage.assetNetwork(
//                          placeholder: cupertinoActivityIndicatorSmall,
//                          image: logo ?? "",
//                        ),*/
//                      ),

                      Container(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(widget.jobName ?? '',
                          style: GoogleFonts.lato(
                          textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w600 ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(company ?? '',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 13, fontWeight: FontWeight.w500 ),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(city ?? '',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                    ),
                                  ),
                                  Text(', ',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Text(state ?? '',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Experience: ',
                                      style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                      ),
                                      ),
                                      Text(_yrxperience.toString() ?? '',
                                      style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 13),
                                      ),
                                      ),
                                      Text('years',
                                      style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                      ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 1.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Salary: ',
                                        style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                        ),
                                      ),
                                      Text(salary ?? '',
                                        style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /*SizedBox(height: 1.0,),
                                  Text("Contact email: "+email ?? "",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                      ),
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 5.0, top: 8.0,  bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                /*InkWell(
                                  onTap: () {launch("tel://"+office_phone, );},
                                  splashColor: Color(0xffA0CCE8),
                                  highlightColor: Color(0xffA0CCE8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone, color: color),
                                      Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        child: Text('CALL',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/

                                //VerticalDivider(),

                                InkWell(
                                  onTap: () {share();},
                                  splashColor: Color(0xffA0CCE8),
                                  highlightColor: Color(0xffA0CCE8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.share, color: color),
                                      Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        child: Text('SHARE',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                              ]
                          )
                      ),
                    ],
                  ),
                ),

                AnimatedBuilder(
                  animation: _animationController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CupertinoSegmentedControl(
                        selectedColor: Colors.grey.shade600,
                        borderColor: Colors.grey.shade600,
                        groupValue: currentValue,
                        children: const <int, Widget>{
                          0: Text('Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                          1: Text('Requirement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                          2: Text('Overview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                        },
                        onValueChanged: (value) {
                          if (value == 0) {
                            currentTab = Padding(
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: htmlText(descr ?? ''),
                            );
                          } else if(value == 1) {
                            currentTab = Padding(
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: htmlText(requirement ?? ''),
                            );
                          } else {
                            currentTab = Padding(
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: htmlText(overview ?? ''),
                            );
                          }
                          setState(() {
                            currentValue = value;
                          });
                        },
                      ),
                      currentTab ??
                          Padding(
                            padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                            child: htmlText(descr ?? ''),
                          )
                    ],
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Opacity(
                      opacity: _animationController.value,
                      child: FractionalTranslation(
                        translation: _movieInformationSlidingAnimation.value,
                        child: child,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ); // Here you direct access using widget
  }

  _buildCircularProgressIndicator() {
    return Center(
      child: Container(
          width: 75,
          height: 75,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xff2877EA)),
                strokeWidth: 1.7,
              ),
              SizedBox(height: 5.0,),
              Text('Loading...',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontSize: 13),
                ),
              ),
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

}

