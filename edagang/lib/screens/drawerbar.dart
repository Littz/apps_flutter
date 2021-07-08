import 'package:edagang/screens/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/address_book.dart';
import 'package:edagang/screens/change_paswd.dart';
import 'package:edagang/screens/profile_user.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:flutter/material.dart';
import 'package:edagang/helper/constant.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:edagang/screens/theme/theme.dart';
import 'package:edagang/widgets/customWidgets.dart';
import 'package:edagang/widgets/newWidget/circular_image.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerBarMenu extends StatefulWidget {
  const DrawerBarMenu({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _DrawerBarMenuState createState() => _DrawerBarMenuState();
}

class _DrawerBarMenuState extends State<DrawerBarMenu> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();
  String _name,_email,_photo,_authType;

  loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _photo = prefs.getString("photo");
        _name = prefs.getString("nama") != null ? prefs.getString("nama") : 'Anonymous';
        _email = prefs.getString("email") != null ? prefs.getString("email") : 'email';
        _authType = prefs.getString("login_type");
        print("Sosmed photo : "+_photo);
      });

    } catch (Excepetion ) {
      print("Load profile error!");
    }
  }

  Widget _menuHeader(MainScopedModel model) {
    if (!model.isAuthenticated) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200, minHeight: 150),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: TwitterColor.ceriseRed,
                shape: StadiumBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "LOGIN/SIGNUP",
                    style: GoogleFonts.sourceSansPro(
                      textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));},
              ),
              Container(
                child: Text(
                  'Login to discover new experience!',
                  style: GoogleFonts.sourceSansPro(
                    textStyle: TextStyle(color: Colors.grey[200], fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  //style: TextStyles.onPrimaryTitleText,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 56,
              width: 56,
              margin: EdgeInsets.only(left: 17, top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    _photo ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) => new AccProfilePage()));
              },
              title: Text(_name ?? "", style: TextStyle(color: Colors.white),),
              subtitle: Text(_email ?? "", style: TextStyle(color: Colors.grey.shade200, fontSize: 12, fontStyle: FontStyle.italic),),
              trailing: Icon(LineAwesomeIcons.edit, color: Colors.white),
            ),
            /*Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 17,
                  ),
                  _tappbleText(context, '${state.userModel.getFollower}',
                      ' Followers', 'FollowerListPage'),
                  SizedBox(width: 10),
                  _tappbleText(context, '${state.userModel.getFollowing}',
                      ' Following', 'FollowingListPage'),
                ],
              ),
            ),*/
          ],
        ),
      );
    }
  }

  /*Widget _tappbleText(BuildContext context, String count, String text, String navigateTo) {
    return InkWell(
      onTap: () {
        var authstate = Provider.of<AuthState>(context, listen: false);
        // authstate.profileFollowingList = [];
        authstate.getProfileUser();
        _navigateTo(navigateTo);
      },
      child: Row(
        children: <Widget>[
          customText(
            '$count ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          customText(
            '$text',
            style: TextStyle(color: AppColor.darkGrey, fontSize: 17),
          ),
        ],
      ),
    );
  }*/

  ListTile _menuListRowButton(String title, {Function onPressed, IconData icon, bool isEnable = false}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null ? null : Icon(icon, color: isEnable ? AppColor.darkGrey : AppColor.lightGrey,),
      title: customText(
        title,
        style: GoogleFonts.sourceSansPro(
          textStyle: TextStyle(fontSize: 16, color: isEnable ? AppColor.secondary : AppColor.lightGrey,),
        ),
      ),
    );
  }

  Positioned _footer() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 16, bottom: 5),
        child: Text(
          'Version: 1.1.17',
          style: GoogleFonts.sourceSansPro(
            textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey.shade600,),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  logoutUser(context, MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String logtype = prefs.getString('login_type');

    Map<String, String> headers = await getHeaders();
    http.get(Constants.apiLogout, headers: headers).then((response) {
      prefs.remove('token');
      model.loggedInUser();
    });

    if(logtype == '1') {
      _googleSignIn.signOut();
    }else if(logtype == '2') {
      facebookLogin.logOut();
    }
    Navigator.of(context).pushReplacementNamed("/Main");
  }

  Future<Map<String, String>> getHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token-type': 'Bearer',
      'ng-api': 'true',
      'auth-token': prefs.getString('token') == null ? Constants.tokenGuest : prefs.getString('token'),
      'Guest-Order-Token': Constants.tokenGuest
    };
    return headers;
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
    {
      return Drawer(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 45),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.blue,
                            Colors.blue.shade900,
                          ],
                        ),
                      ),
                      child: _menuHeader(model),
                    ),
                    model.isAuthenticated ? _menuListRowButton('Notification', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, SlideRightRoute(page: NotificationPage()));}) : _menuListRowButton('Notification', icon: null, isEnable: false, onPressed: null),
                    model.isAuthenticated ? _menuListRowButton('Address Book', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, SlideRightRoute(page: AddressBook()));}) : _menuListRowButton('Address Book', icon: null, isEnable: false, onPressed: null),
                    _authType == '0' ? model.isAuthenticated ? _menuListRowButton('Change Password', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      _viewChangePaswd('Change Password');
                      //Navigator.push(context, SlideRightRoute(page: ChangePaswd()));
                      }) : _menuListRowButton('Change Password', icon: null, isEnable: false, onPressed: null) : _menuListRowButton('Change Password', icon: null, isEnable: false, onPressed: null),
                    _getSeparator(1),
                    _menuListRowButton('Join Us', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/joinwebv','Join Us')));
                    }),
                    _menuListRowButton('Invite Friends', icon: null, isEnable: true, onPressed: () async {
                      await FlutterShare.share(
                        title: 'Apps',
                        text: '',
                        linkUrl: 'https://play.google.com/store/apps/details?id=com.digital.dagang.asia.edagang',
                        chooserTitle: 'edagang',
                      );
                      Navigator.pop(context);
                    }),
                    _menuListRowButton('Privacy & Policy', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://e-dagang.asia/policy', 'Privacy Policy')));
                    }),
                    _menuListRowButton('Terms & Services', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://e-dagang.asia/tnc', 'Terms & Services')));
                    }),
                    _getSeparator(1),
                    _menuListRowButton('Help/FAQ', icon: null, isEnable: false, onPressed: null),
                    _menuListRowButton('Feedback', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      model.isAuthenticated ?
                      Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/feedback/'+model.getId().toString(),'Feedback')))
                          : Navigator.push(context, SlideRightRoute(page: WebviewWidget('https://smartbiz.e-dagang.asia/biz/feedback/0','Feedback')));
                    }),
                    _menuListRowButton('Contact Us', icon: null, isEnable: true, onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 119,
                                  margin: EdgeInsets.only(top: 16, bottom: 16),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/red_edagang.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: new Icon(LineAwesomeIcons.map_marker),
                                  title: new Text('D-0-9, Setiawangsa Business Suite,\nJalan Setiawangsa 11, Taman Setiawangsa,\n54200 Kuala Lumpur'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(LineAwesomeIcons.phone),
                                  title: new Text('03-4256 2286'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(LineAwesomeIcons.envelope),
                                  title: new Text('customercare@digitaldagang.com'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),

                              ],
                            );
                          }
                      );
                    }),
                    _getSeparator(1),
                    //_menuListRowButton('Logout',icon: null, onPressed: logoutUser(context, model), isEnable: true),
                    model.isAuthenticated ? ListTile(
                      onTap: () {
                        logoutUser(context, model);
                      },
                      leading: Icon(LineAwesomeIcons.power_off, color: Colors.red.shade600,),
                      title: customText(
                        'Logout',
                        style: GoogleFonts.sourceSansPro(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red.shade600,),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
              _footer()
            ],
          ),
        ),
      );
    });
  }

  _viewChangePaswd(String title){
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {Navigator.pop(context);},
            child: DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.25,
              maxChildSize: 0.85,
              builder: (_, controller) {
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                    child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(24),
                                  child: ChangePaswd(),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              alignment: Alignment.centerRight,
                              //padding: EdgeInsets.only(left: 16, bottom: 5),
                              child: Icon(
                                LineAwesomeIcons.close,
                                color: Colors.red[600],
                              ),
                            ),
                          )
                        ]
                    )
                );
              },
            ),
          ),
        );
      },
    );
  }

}
