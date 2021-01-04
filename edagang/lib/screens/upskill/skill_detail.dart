import 'package:edagang/models/upskill_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'dart:convert';

import 'package:loading_gifs/loading_gifs.dart';

class UpskillDetailPage extends StatefulWidget {

  @override
  _UpskillDetailPageState createState() => _UpskillDetailPageState();
}

class _UpskillDetailPageState extends State<UpskillDetailPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _skillId;

  int _id,course_id,business_id,cat_id,course_category_id;
  String title,descr,overview,attendees,key_modules,price,company_name,logo,cat_name;
  String date_start,date_end,time_start,time_end;
  List<CourseSchedule> schedule = [];

  Widget currentTab;
  int currentValue = 0;

  AnimationController _animationController;
  Animation<Offset> _movieInformationSlidingAnimation;

  getDetails() async {

    try {
      String id = await sharedPref.read("skil_id");

      setState(() {
        _skillId = id;
        print("product ID : "+_skillId);

        http.post(
          Constants.tuneupAPI+'/course/details?course_id='+_skillId,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          print('UPSKILLLLL RESPONSE CODE /////////////////');
          print(response.statusCode.toString());

          var resBody = json.decode(response.body);
          print('UPSKILLLLL COMPANY NAME >>>>>>>>>>>>>>'+resBody['data']['courses']['title'].toString());
          print('UPSKILLLLL DETAIL RESPONSE ===============');
          print(resBody);

          setState(() {

            List<CourseSchedule> _schedule = [];
            resBody['data']['courses']['schedule'].forEach((schedule) {
              _schedule.add(
                  new CourseSchedule(
                    id: schedule['id'],
                    course_id: schedule['course_id'],
                    date_start: schedule['date_start']+' to '+schedule['date_end'],
                    date_end: schedule['date_end'],
                    time_start: schedule['time_start']+' to '+schedule['time_end'],
                    time_end: schedule['time_end'],
                  )
              );
            });

            var data = SkillList(
              id: resBody['data']['courses']['id'],
              business_id: resBody['data']['courses']['business_id'], // after migration -> int to string
              title: resBody['data']['courses']['title'],
              descr: resBody['data']['courses']['desc'], // after migration -> int to string
              overview: resBody['data']['courses']['overview'],
              attendees: resBody['data']['courses']['attendees'],
              key_modules: resBody['data']['courses']['key_modules'],
              price: resBody['data']['courses']['price'],
              course_category_id: resBody['data']['courses']['course_category_id'],
              company_name: resBody['data']['courses']['business']['company_name'],
              logo: resBody['data']['courses']['business']['logo'],
              cat_id: resBody['data']['courses']['category']['id'],
              cat_name: resBody['data']['courses']['category']['name'],
              schedule: _schedule,
            );

            _id = data.id;
            title = data.title;
            descr = data.descr;
            overview = data.overview;
            attendees = data.attendees;
            key_modules = data.key_modules;
            price = data.price;
            course_category_id = data.course_category_id;
            company_name = data.company_name;
            logo = 'https://bizapp.e-dagang.asia'+data.logo;
            cat_name = data.cat_name;
            schedule = data.schedule;

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
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2)) ..forward();
    _movieInformationSlidingAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                curve: Interval(0.25, 1.0, curve: Curves.fastOutSlowIn),
                parent: _animationController));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: new AppBar(
            centerTitle: false,
            elevation: 1.0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: new Text(cat_name ?? "",
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(title ?? "",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,),
                                  ),
                              ),
                            ),
                            Text(company_name ?? "",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontStyle: FontStyle.italic,),
                                ),
                            ),
                            _scheduleList(),
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
                        selectedColor: Color(0xff2877EA),
                        borderColor: Color(0xff2877EA),
                        groupValue: currentValue,
                        children: const <int, Widget>{
                          0: Text('Overview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                          1: Text('Modules', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                          2: Text('Attendees', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                        },
                        onValueChanged: (value) {
                          if (value == 0) {
                            currentTab = Padding(
                              padding: EdgeInsets.only(left: 13, top: 10, right: 13),
                              child: htmlText(overview),
                            );
                          } else if(value == 1) {
                            currentTab = Padding(
                              padding: EdgeInsets.only(left: 13, top: 10, right: 13),
                              child: htmlText(key_modules),
                            );
                          } else {
                            currentTab = Padding(
                              padding: EdgeInsets.only(left: 13, top: 10, right: 13),
                              child: htmlText(attendees),
                            );
                          }
                          setState(() {
                            currentValue = value;
                          });
                        },
                      ),
                      currentTab ??
                          Padding(
                            padding: EdgeInsets.only(left: 13, top: 10, right: 13),
                            child: htmlText(overview),
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

  Widget _scheduleList() {
    if(schedule.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Text(
            "",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: new SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: schedule.length,
                    itemBuilder: (context, index) {
                      var data = schedule[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(data.date_start ?? "",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                              ),
                          ),
                          SizedBox(height: 3.0,),
                          Text(data.time_start ?? "",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                              ),
                          ),
                        ],
                      );
                    },
                  )
                ]
            )
        ),
      );

    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
