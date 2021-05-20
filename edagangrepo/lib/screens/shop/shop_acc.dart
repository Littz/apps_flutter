import 'package:edagang/main.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/cart_history.dart';
import 'package:edagang/screens/shop/cart_review.dart';
import 'package:edagang/screens/shop/shop_support.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopAccountPage extends StatefulWidget {
  final int tabcontroler;
  ShopAccountPage({this.tabcontroler});

  @override
  State<StatefulWidget> createState() {return new _StateAccount();}
}

class _StateAccount extends State<ShopAccountPage> {
  Orientation orientation;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //NetworkCheck networkCheck = new NetworkCheck();
  String userName,userEmail;

  @override
  void initState() {
    super.initState();
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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: new Text("Conversation Request"),
          content: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new Image.asset(
                  "assets/cartsini_logo.png",
                  height: 120.0,
                  //width: 210.0,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(height: 10,),
                new Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: new RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => SignInOrRegister()));},
                    child: new Text(
                      "SIGN-IN",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    color: Colors.deepOrange,
                    textColor: Colors.white,
                    elevation: 5.0,
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context){return Register();}));
                      },
                      child: new Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                          child: new Text(
                            "SIGN-UP an account",
                            style: TextStyle( decoration: TextDecoration.underline, fontSize: 15.0),
                          )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            Navigator.of(context).pushReplacementNamed("/ShopIndex");
            return null;
          },
          child: Scaffold(
            /*appBar: AppBar(
              automaticallyImplyLeading: false,
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: _title(),
              elevation: 0,
            ),
            backgroundColor: Colors.grey.shade100,*/
            backgroundColor: Color(0xffEEEEEE),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0,),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('My Orders'),
                        subtitle: Text('Order history list'),
                        trailing: Icon(Icons.chevron_right, color: Color(0xffF45432)),
                        onTap: () {
                          if(model.isAuthenticated) {
                            Navigator.push(context, SlideRightRoute(page: CartHistory()));
                          }else{
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                            //_showDialog();
                          }
                        },
                      ),
                      Divider(color: Color(0xffF45432),),
                      ListTile(
                        title: Text('My Review'),
                        subtitle: Text('Review of puchased item.'),
                        trailing: Icon(Icons.chevron_right,color: Color(0xffF45432)),
                        onTap: () {
                          if(model.isAuthenticated) {
                            Navigator.push(context, SlideRightRoute(page: MyReview()));
                          }else{
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          }
                        }
                      ),
                      Divider(color: Color(0xffF45432),),
                      ListTile(
                        title: Text('Messages'),
                        subtitle: Text('Message inbox'),
                        //leading: Image.asset('assets/icons/faq.png'),
                        trailing: Icon(Icons.chevron_right, color: Color(0xffF45432)),
                        onTap: () {
                          if(model.isAuthenticated) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewHomePage(1)));
                          }else{
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          }
                        }
                      ),
                      Divider(color: Color(0xffF45432),),
                      ListTile(
                        title: Text('Help & Support'),
                        subtitle: Text('Help center and legal support'),
                        //leading: Image.asset('assets/icons/support.png'),
                        trailing: Icon(Icons.chevron_right,color: Color(0xffF45432)),
                        onTap: () {
                          if(model.isAuthenticated) {
                            Navigator.push(context, SlideRightRoute(page: CartsiniHelp()));
                          }else{
                            Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                          }
                        }
                      ),

                      //Divider(color: Color(0xffF45432),),
                      /*Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8.0, bottom: 8.0),
                              child: Text(
                                'Settings:',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text('Profile Info'),
                              //leading: Image.asset('assets/icons/language.png'),
                              trailing: Icon(Icons.chevron_right,color: Color(0xffF45432)),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: AccProfilePage()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                            ListTile(
                              title: Text('Address Book'),
                              //leading: Image.asset('assets/icons/country.png'),
                              trailing: Icon(Icons.chevron_right,color: Color(0xffF45432)),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: AddressBook()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                            ListTile(
                              title: Text('Change Password'),
                              //leading: Image.asset('assets/icons/change_pass.png'),
                              trailing: Icon(Icons.chevron_right,color: Color(0xffF45432)),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: ChangePaswd()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                            ListTile(
                              title: Text('Legal & Policies'),
                              //leading: Image.asset('assets/icons/legal.png'),
                              trailing: Icon(Icons.chevron_right,color: Color(0xffF45432)),
                              onTap: () {
                                if(model.isAuthenticated) {
                                  Navigator.push(context, SlideRightRoute(page: PolicyPage()));
                                }else{
                                  Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                }
                              },
                            ),
                          ]
                      ),*/

                      /*Divider(color: Color(0xffF45432),),
                      logOutButton(),
                      SizedBox(height: 15,),*/
                    ],
                  ),
                ),
              ),
            ),
          ));
        });
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
          return Container();
        }
      },
    );
  }

  logoutUser(BuildContext context, MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = await getHeaders();
    http.get(Constants.apiLogout, headers: headers).then((response) {
      //prefs.clear();
      prefs.remove('token');
      model.loggedInUser();
    });
    Navigator.of(context).pushReplacementNamed("/ShopIndex");
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

  Widget _title() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child,MainScopedModel model) {
        /*if (model.isAuthenticated) {
          return Container(
            margin: EdgeInsets.only(left: 0, right: 10, bottom: 8, top: 8),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      maxRadius: 40,
                      child: Icon(CupertinoIcons.person_fill, size: 36,  color: Colors.grey.shade600,),
                      //backgroundImage: AssetImage('images/ic_launcherVII.png',),
                    ),
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
        }else{*/
          return Container(
            margin: EdgeInsets.only(left: 0, right: 10, bottom: 8, top: 8),
            height: 40,
            child: Text('Account',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff202020),),
              ),
            ),
          );

        //}
      },
    );
  }

}
