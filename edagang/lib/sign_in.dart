import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:edagang/forgot_paswd.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> with SingleTickerProviderStateMixin {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoader = false;
  bool _isLoggedInG = false;
  bool _isLoggedInFb = false;
  String _dvcInfo = 'Unknown';
  String deviceId;
  Map userProfile;
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  final RegExp emailRegex = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Login_page',parameters:null);
    super.initState();
    //_getDeviceInfo();
  }

  /*Future _getDeviceInfo() async {
    String deviceInfo;
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      print('$systemName $version, $name $model');
      deviceInfo = '$systemName $version, $name $model'; // iOS 13.1, iPhone 11 Pro Max iPhone
    } else {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      print('Android $release (SDK $sdkInt), $manufacturer $model');
      deviceInfo = 'Android $release (SDK $sdkInt), $manufacturer $model'; // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }

    if (!mounted) return;

    setState(() {
      _dvcInfo = '$deviceInfo';
    });
  }*/

  Future<String> _getDvcId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Container(
      height: 1.0,
      color: Colors.grey.shade500,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
          return Scaffold(
            //key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(55.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
                title: Text(
                  'Sign In',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Center(
                  child: Form(
                      key: _formKeyForLogin,
                      autovalidate: false,
                      child: new SingleChildScrollView(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 58.0,
                                child: Image.asset(
                                  'assets/red_edagang.png',
                                  fit: BoxFit.fill,
                                  height: 69,
                                  width: 165,
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Login with email and password.',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.only(right: 7),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  new Expanded(
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        hintText: 'Enter your email address',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 7),
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (!emailRegex.hasMatch(value)) {
                                          return 'Please enter valid email';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _formData['email'] = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.only(right: 7),
                                    child: Icon(
                                      Icons.vpn_key,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  new Expanded(
                                    child: TextFormField(
                                      obscureText: true,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                          hintText: 'Please enter password',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 7),
                                          isDense: true,
                                          labelText: 'Password'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Password is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _formData['password'] = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              _buildForgotPasswordBtn(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: RaisedButton(
                                  shape: StadiumBorder(),
                                  color: Color(0xff272264),
                                  onPressed: () {
                                    _submitLoginEmail(model);
                                  },
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  alignment: Alignment.center,
                                  child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an account? ",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Sign up',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  color: Color(0xffCE0E27),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Container(
                                width: double.infinity,
                                //margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: horizontalLine(),
                                    ),
                                    Text(
                                      ' Or access with ',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: horizontalLine(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _facebookLogin(model);
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/icons/facebook.jpg',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _googleLogin(model);
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/icons/google.jpg',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.transparent,
                                height: 56,
                              ),
                            ],
                          )
                      )
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, SlideRightRoute(page: ForgotPasswordPage()));
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Color(0xffCE0E27),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _submitLoginEmail(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoader = true;
    });
    if (!_formKeyForLogin.currentState.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }

    deviceId = prefs.getString('player_id').split('"')[1];

    _formKeyForLogin.currentState.save();

    final Map<String, dynamic> authData = {
      'login_type': '0',
      'email': _formData['email'],
      'password': _formData['password'],
      'device_id': deviceId,
    };

    print("Login process data");
    print(_formData['email']);
    print(_formData['password']);
    print(deviceId);
    print(_dvcInfo);

    final http.Response response = await http.post(
        Uri.parse(Constants.apiLogin),
      body: JSON.jsonEncode(authData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("RES BODY >>>> " + response.body);

    final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
    String message = 'Something wrong somewhere.';
    bool hasError = true;
    print(responseData);
    if (responseData["message"] == "success") {
      message = "Successfully logged in.";
      hasError = false;
    } else {
      message = responseData["data"];
    }
    print("MESG >>>> " + message);

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };

    if (successInformation['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['data']['token']);
      prefs.setString('nama', model.getFname());
      prefs.setString('email', responseData['data']['email']);
      prefs.setString('photo', Constants.dummyProfilePic);
      prefs.setString('login_type', '0');

      model.loggedInUser();
      model.fetchProfile();
      model.fetchCartTotal();
      model.fetchCartsFromResponse();
      model.fetchCartReload();
      model.fetchAddressList();
      model.fetchBankList();
      model.fetchOrderStatusResponse();

      Navigator.of(context).pushReplacementNamed("/Main");
      print('Sukses login! => ' + successInformation['message']);
      //showStatusToast(message);

    } else {
      print('An Error Occurred! => ' + successInformation['message']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Unsuccessful login.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoader = false;
    });
  }

  _googleLogin(MainScopedModel model) async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedInG = true;
      });

      if (_isLoggedInG) _submitGoogleLogin(model);
    } catch (err) {
      print('Google login error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print(err);
    }
  }

  _facebookLogin(MainScopedModel model) async {
    final result = await facebookLogin.logIn(['email']);
    print('Facebook Login !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(result.status.toString());

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}'));
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedInFb = true;
        });
        print('Facebook login success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        if (_isLoggedInFb) _submitFbLogin(model);

        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedInFb = false);
        print('Facebook login cancelled!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedInFb = false);
        print('Facebook login error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        print(result.errorMessage);
        break;
    }
  }

  _submitFbLogin(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoader = true;
    });
    //final result = await facebookLogin.logInWithReadPermissions(['email']);
    print('Facebook Login ####################');
    //print(result.status.toString());
    deviceId = prefs.getString('player_id');
    var did = deviceId.split('"')[1];

    final Map<String, dynamic> authData = {
      'login_type': '2',
      'fullname': userProfile["name"],
      'email': userProfile["email"],
      'password': '',
      'social_id': userProfile["id"],
      'device_id': did,
    };

    print("Login Facebook data");
    print(userProfile["name"]);
    print(userProfile["email"]);
    print(userProfile["id"]);
    print(did);
    print(_dvcInfo);

    final http.Response response = await http.post(
        Uri.parse(Constants.apiLogin),
      body: JSON.jsonEncode(authData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("Facebook Login >>>>>>>>>");
    print(Constants.apiLogin +'?'+ authData.toString());
    print("RES BODY >>>> " + response.body);

    final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
    String message = 'Something wrong somewhere.';
    bool hasError = true;
    print(responseData);
    if (responseData["message"] == "success") {
      message = "Successfully logged in.";
      hasError = false;
    } else {
      message = responseData["data"];
    }
    print("MESG >>>> " + message);

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };

    if (successInformation['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['data']['token']);
      prefs.setString('nama', userProfile["name"]);
      prefs.setString('email', userProfile["email"]);
      prefs.setString('login_type', '2');
      prefs.setString('photo', userProfile["picture"]["data"]["url"].toString());

      model.loggedInUser();
      model.fetchProfile();
      model.fetchCartTotal();
      model.fetchCartsFromResponse();
      model.fetchCartReload();
      model.fetchAddressList();
      model.fetchBankList();
      model.fetchOrderStatusResponse();

      Navigator.of(context).pushReplacementNamed("/Main");
      print('Sukses login! => ' + successInformation['message']);
    } else {
      print('An Error Occurred! => ' + successInformation['message']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Unsuccessful login.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoader = false;
    });
  }

  _submitGoogleLogin(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoader = true;
    });
    //final result = await facebookLogin.logInWithReadPermissions(['email']);
    print('Google Login ####################');
    //print(result.status.toString());
    deviceId = prefs.getString('player_id').split('"')[1];

    final Map<String, dynamic> authData = {
      'login_type': '1',
      'fullname': _googleSignIn.currentUser.displayName,
      'email': _googleSignIn.currentUser.email,
      'password': '',
      'social_id': _googleSignIn.currentUser.id,
      'device_id': deviceId,
    };

    print("Login Google data");
    print(_googleSignIn.currentUser.displayName);
    print(_googleSignIn.currentUser.email);
    print(_googleSignIn.currentUser.id);
    print(deviceId);
    print(_dvcInfo);

    final http.Response response = await http.post(
      Uri.parse(Constants.apiLogin),
      body: JSON.jsonEncode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    print("Google SignIn >>>>>>>>>");
    print(Constants.apiLogin +'?'+ authData.toString());
    print("RES BODY >>>> " + response.body);

    final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
    String message = 'Something wrong somewhere.';
    bool hasError = true;
    print(responseData);
    if (responseData["message"] == "success") {
      message = "Successfully logged in.";
      hasError = false;
    } else {
      message = responseData["data"];
    }
    print("MESG >>>> " + message);

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };

    if (successInformation['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['data']['token']);
      prefs.setString('nama', _googleSignIn.currentUser.displayName);
      prefs.setString('email', _googleSignIn.currentUser.email);
      prefs.setString('login_type', '1');
      prefs.setString('photo', _googleSignIn.currentUser.photoUrl.toString());

      model.loggedInUser();
      model.fetchProfile();
      model.fetchCartTotal();
      model.fetchCartsFromResponse();
      model.fetchCartReload();
      model.fetchAddressList();
      model.fetchBankList();
      model.fetchOrderStatusResponse();


      Navigator.of(context).pushReplacementNamed("/Main");
      print('Sukses login! => ' + successInformation['message']);
    } else {
      print('An Error Occurred! => ' + successInformation['message']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Unsuccessful login.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoader = false;
    });
  }

  _logoutFb() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedInFb = false;
    });
  }
}

//==========================================================================================================================

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'name': null,
    'email': null,
    'password': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoader = false;

  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  final RegExp emailRegex = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  void _submitForm(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String dev_id = prefs.getString('player_id');
    setState(() {
      _isLoader = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }
    _formKey.currentState.save();

    final Map<String, dynamic> authData = {
      'fullname': _formData['name'],
      'email': _formData['email'],
      'password': _formData['password'],
      'channel': 0,
      'device_id': dev_id,
    };

    final http.Response response = await http.post(
      Uri.parse(Constants.apiRegister),
      body: JSON.jsonEncode(authData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
    String message = 'Something went wrong.';
    bool hasError = true;
    print(responseData);

    if (responseData["message"] == "success") {
      print('success');
      message = 'Successfully registered.';
      hasError = false;
    } else if (responseData.containsKey('data')) {
      message = responseData["data"];
    }

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };

    if (successInformation['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['data']['token']);
      prefs.setString('nama', _formData['name']);
      prefs.setString('email', responseData['data']['email']);

      model.loggedInUser();
      model.fetchProfile();
      model.fetchCartTotal();
      model.fetchCartsFromResponse();
      model.fetchCartReload();
      model.fetchAddressList();
      model.fetchBankList();
      model.fetchOrderStatusResponse();

      Navigator.of(context).pushReplacementNamed("/Main");
      //Navigator.pushReplacement(context, SlideRightRoute(page: SignInOrRegister()));
      print('Success register! => ' + successInformation['message']);
    } else {
      print('An Error Occurred! => ' + successInformation['message']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Unsuccessful register.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoader = false;
    });
  }

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Register_page',parameters:null);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model)
    {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'Sign Up',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            /*Container(
            height: double.infinity,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(
                        'https://i.pinimg.com/originals/c2/47/e9/c247e913a0214313045a8a5c39f8522b.jpg'))),
            ),*/
            Center(
              child: Form(
                  key: _formKey,
                  autovalidate: false,
                  child: new SingleChildScrollView(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 58.0,
                            child: Image.asset(
                              'assets/red_edagang.png',
                              fit: BoxFit.fill,
                              height: 69,
                              width: 165,
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Create an account.',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.only(right: 7),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              new Expanded(
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'Enter your name',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 7),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _formData['name'] = value;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.only(right: 7),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              new Expanded(
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email address',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 7),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _formData['email'] = value;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.only(right: 7),
                                child: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              new Expanded(
                                child: TextFormField(
                                  obscureText: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                      hintText: 'Please enter password',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 7),
                                      isDense: true,
                                      labelText: 'Password'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _formData['password'] = value;
                                  },
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: RaisedButton(
                              shape: StadiumBorder(),
                              color: Color(0xff272264),
                              onPressed: () {
                                _submitForm(model);
                              },
                              child: Text(
                                'Sign up',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInOrRegister()));
                            },
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account? ",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Sign in',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Color(0xffCE0E27),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            height: 56,
                          ),
                        ],
                      )
                  )
              ),
            ),
          ],
        ),
      );
    });
  }

}
