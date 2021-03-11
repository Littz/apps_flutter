import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/acc_address.dart';
import 'package:edagang/screens/shop/acc_profile.dart';
import 'package:edagang/screens/shop/change_paswd.dart';
import 'package:edagang/screens/shop/shop_policy.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class SettingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {return new _SettingPageState();}
}

class _SettingPageState extends State<SettingPage> {
  Orientation orientation;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //NetworkCheck networkCheck = new NetworkCheck();
  String userName,userEmail;
  String _logType,_photo = "";

  loadPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      setState(() {
        _logType = prefs.getString("login_type");
        _photo = prefs.getString("photo");
        print("Sosmed photo : "+_photo);
      });

    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPhoto();
    //networkCheck.checkInternet(fetchPrefrence);
  }

  fetchPrefrence(bool isNetworkPresent) {
    if(!isNetworkPresent){
      print('Internet DOWN!');
      _networkDialog();
    }
  }

  void _networkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Network Error!", textAlign: TextAlign.center,),
          content: new Text("Something wrong.\nPlease check your internet connection and try again.", textAlign: TextAlign.center,),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            Navigator.of(context).pushReplacementNamed("/Main");
            return null;
          },
              child: Scaffold(
                appBar: AppBar(
                  //automaticallyImplyLeading: false,
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    'Settings',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,),
                    ),
                  ),
                  elevation: 0,
                  //bottom: _title(model),
                ),
                backgroundColor: Colors.grey.shade100,
                body: SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0,),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //_title(model),
                            ListTile(
                              title: Text('Profile'),
                              //leading: Image.asset('assets/icons/language.png'),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: AccProfilePage()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                            Divider(color: Colors.grey,),
                            ListTile(
                              title: Text('Address Book'),
                              //leading: Image.asset('assets/icons/country.png'),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: AddressBook()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                            Divider(color: Colors.grey,),
                            ListTile(
                              title: Text('Change Password'),
                              //leading: Image.asset('assets/icons/change_pass.png'),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: ChangePaswd()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                            Divider(color: Colors.grey,),
                            ListTile(
                              title: Text('Legal & Policies'),
                              //leading: Image.asset('assets/icons/legal.png'),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: PolicyPage()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),

                            Divider(color: Colors.grey,),
                            ListTile(
                              title: Text(''),
                            ),

                            //Divider(color: Color(0xffF45432),),
                            logOutButton(),
                            SizedBox(height: 15,),


                          ]
                      ),
                    ),
                  ),
                ),
              )
          );
        }
    );
  }

  Widget logOutButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child,MainScopedModel model) {
        if (model.isAuthenticated) {
          return ListTile(
            title: new Text(
              "Logout",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red.shade600),
              ),
            ),
            onTap: () {
              logoutUser(context, model);
            },
          );
        } else {
          return ListTile(
            title: new Text(
              "Login",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red.shade600),
              ),
            ),
            onTap: () {
              Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
            },
          );
        }
      },
    );
  }

  logoutUser(BuildContext context, MainScopedModel model) async {
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

  Widget _title(MainScopedModel model) {
    if (model.isAuthenticated) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 16,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.centerRight,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 0.5,
                    spreadRadius: 0.0,
                    offset: Offset(0.5, 0.5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: _logType == '0' ? Icon(CupertinoIcons.person_fill, size: 40,  color: Colors.grey.shade600,) : Image.network(_photo ?? '', width: 40, height: 40,),
              ),
            ),

            Text('  '+model.getFname(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,),
              ),
            ),
          ],
        ),
      );
    }else{
      return Container();
    }
  }

}
