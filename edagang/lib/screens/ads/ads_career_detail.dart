import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/ads/webview.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';


class CareerDetailPage extends StatefulWidget {
  String jobId, jobName;
  CareerDetailPage(this.jobId, this.jobName);

  @override
  _CareerDetailPageState createState() => _CareerDetailPageState();
}

const xpandedHeight = 195.0;

class _CareerDetailPageState extends State<CareerDetailPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  String _dl;
  bool isEnabled = true ;
  bool isLoading = false;
  Color color = Color(0xff2877EA);
  String _selectedItem = '';

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

  Future share() async {
    await FlutterShare.share(
    title: 'Blurb',
    text: '',
    linkUrl: 'https://blurbapp.e-dagang.asia/career/'+_id.toString(),
    chooserTitle: widget.jobName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model)
    {
      return Scaffold(
        key: _scaffoldKey,
        /*appBar: new PreferredSize(
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
      ),*/
        backgroundColor: Colors.white,
        body: isLoading ? _buildCircularProgressIndicator() : CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: xpandedHeight,
              leading: Hero(
                  tag: "back",
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    splashColor: Color(0xffA0CCE8),
                    highlightColor: Color(0xffA0CCE8),
                    child: BlurIconLight(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  )
              ),
              title: SABT(
                child: Container(
                    child: Text(title ?? '',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,),
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
                          page: WebviewBlurb(
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
                                child: FadeInImage.assetNetwork(
                                  placeholder: logo ?? "",
                                  image: logo ?? "",
                                  fit: BoxFit.cover,
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
                          child: Text(widget.jobName ?? '',
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
                          selectedColor: Colors.grey.shade600,
                          borderColor: Colors.grey.shade600,
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
                          title: 'GOilmu',
                          text: '',
                          linkUrl: 'https://blurbapp.e-dagang.asia/career/'+_id.toString(),
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
                page: WebviewBlurb(
                'https://blurb.e-dagang.asia/wv/job/apply/'+model.getId().toString()+'/'+_id.toString(), title))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
              },
            ),
          ],
        ),
      );

    });

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

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
    context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    bool visible = settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}
