import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';


class CareerDlPage extends StatefulWidget {
  String jobId, jobName;
  CareerDlPage(this.jobId, this.jobName);

  @override
  _CareerDlPageState createState() => _CareerDlPageState();
}

const xpandedHeight = 195.0;

class _CareerDlPageState extends State<CareerDlPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;

  bool isEnabled = true ;
  bool isLoading = false;
  Color color = Color(0xff2877EA);

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
          Uri.parse('https://blurbapp.e-dagang.asia/api/blurb/job/details?job_id='+widget.jobId),
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
    FirebaseAnalytics().logEvent(name: 'Deeplink_Blurb_career_'+widget.jobName,parameters:null);
    getDetails();
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController));
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > xpandedHeight - kToolbarHeight;
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model)
    {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: isLoading ? buildCircularProgressIndicator() : CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: xpandedHeight,
              leading: Hero(
                  tag: "back",
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(4)));
                    },
                    splashColor: Color(0xffA0CCE8),
                    highlightColor: Color(0xffA0CCE8),
                    child: BlurIconLight(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xff084B8C),
                      ),
                    ),
                  )
              ),
              title: SABTs(
                child: Container(
                    child: Text(title ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 18, color: Color(0xff084B8C)),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                ),
              ),
              /*actions: [
                PopupMenuButton(
                  itemBuilder: (BuildContext bc) =>
                  [
                    PopupMenuItem(child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Career Profile'),
                    ), value: "1"),
                  ],
                  onSelected: (value) {
                    setState(() {
                      _selectedItem = value;
                      print("Selected context menu: $_selectedItem");
                      Navigator.push(context, SlideRightRoute(
                          page: WebviewWidget(
                              'https://blurb.e-dagang.asia/wv/career/profile/' +
                                  model.getId().toString(), 'Career Profile')));
                    });
                  },
                  child: BlurIconLight(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],*/
              flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                background: Column(
                    children: <Widget>[
                      Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          Image.asset(
                            'assets/bgblurb.png', fit: BoxFit.fill,
                            height: 165,
                          ),
                          FractionalTranslation(
                            translation: Offset(0.1, 0.5),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    blurRadius: 2.5,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.5, 2.5),
                                  )
                                ],
                                //border: new Border.all(color: Colors.blue, width: 1.5,),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  //fit: BoxFit.fitHeight,
                                  imageUrl: logo ?? '',
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: imageProvider,
                                          //fit: BoxFit.fitHeight,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(8.0),)
                                    ),
                                  ),
                                  //placeholder: (context, url) => Container(color: Colors.grey.shade200,),
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    child: Image.asset('assets/images/ed_logo_greys.png', width: 60,
                                      height: 60,),
                                  ),
                                  errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                                ),
                              ),
                            ),
                          ),
                          /*Positioned(
                          bottom: -16.0,
                          right: 16.0,
                          child: vr_ofis == 'null' && vr_room == 'null' ? Container() : Container(
                              alignment: Alignment.topRight,
                              child: virtualBtn(context, vr_ofis, vr_room)
                          ),
                        ),*/
                        ],
                      ),
                    ]
                ),
              ),
              /*flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
              background: Image.asset(
                'assets/bgblurb.png', fit: BoxFit.fill,
                height: 150,
              ),
            ),*/

            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.only(
                        left: 8.0, top: 1.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(title ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontStyle: FontStyle.normal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(company ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontStyle: FontStyle.normal,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
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
                                        textStyle: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Text(', ',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Text(state ?? '',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, top: 0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text('Experience: ',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Text(_yrxperience.toString() ?? '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        Text('years',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 1.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text('Salary: ',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Text(salary ?? '',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13),
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
                                    _reqBtn(),

                                  ],
                                ),
                              ),
                            ],
                          ),
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
                          selectedColor: color,
                          borderColor: color,
                          groupValue: currentValue,
                          children: const <int, Widget>{
                            0: Text('Description', style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),),
                            1: Text('Requirement', style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),),
                            2: Text('Overview', style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),),
                          },
                          onValueChanged: (value) {
                            if (value == 0) {
                              currentTab = Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: htmlText(descr ?? ''),
                              );
                            } else if (value == 1) {
                              currentTab = Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: htmlText(requirement ?? ''),
                              );
                            } else {
                              currentTab = Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
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
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, right: 10),
                              child: htmlText(descr ?? ''),
                            ),
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
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        ),
      ); // Here you direct access using widget
    });
  }

  Widget _reqBtn() {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model){
      return Container(
        padding: EdgeInsets.only(left: 2, top: 5, right: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await FlutterShare.share(
                          title: 'Blurb',
                          text: '',
                          linkUrl: 'https://edagang.page.link/?link=https://blurbapp.e-dagang.asia/career/'+_id.toString(),
                          chooserTitle: title ?? '',
                        );
                      },
                      splashColor: Color(0xffA0CCE8),
                      highlightColor: Color(0xffA0CCE8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
            RaisedButton(
              shape: StadiumBorder(),
              color: color,
              child: Text('APPLY',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,),
                ),
              ),
              onPressed: () {
                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(
                    page: WebviewWidget(
                        'https://blurb.e-dagang.asia/wv/reqform_jobs/'+model.getId().toString()+'/'+_id.toString(), title))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
              },
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

}
