import 'dart:ui';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> with SingleTickerProviderStateMixin {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoader = false;

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      //key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            'assets/lg_edagang.png',
            fit: BoxFit.fill,
            height: 50,
            width: 127,
          ),
        ),
      ),
      body: Stack(
          children: <Widget>[
            Builder(
                builder: (BuildContext context) {
                  return Center(
                    child: infoCard(context),
                  );
                }
            )
          ],
        ),

    );
  }


  Widget frostedEdged(Widget child) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: child));
  }

  Widget infoCard(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model)
    {
      return new Container(
          //key: ValueKey<String>(title),
          height: double.infinity,
          width: double.infinity,
            child: new Form(
              key: _formKeyForLogin,
              autovalidate: false,
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 19, fontWeight: FontWeight.w700,),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Login with email and password.',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w600,),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade600),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            height: 22,
                                            width: 22,
                                            child: Icon(
                                              Icons.email, color: Colors.grey.shade600,
                                              size: 20,),
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: _emailTextController,
                                        textAlignVertical: TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration.collapsed(
                                          fillColor: Colors.grey.shade300,
                                          focusColor: Colors.white,
                                          hintText: 'Email',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Colors.grey.shade500),
                                        ).copyWith(isDense: true),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black, fontSize: 15,),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (String value) {
                                          if (value.isEmpty ||
                                              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                  .hasMatch(value)) {
                                            return '               Please enter a valid email';
                                          }
                                        },
                                        onSaved: (String value) {
                                          _formData['email'] = value;
                                        },
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade600),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            height: 22,
                                            width: 22,
                                            child: Icon(Icons.vpn_key,
                                              color: Colors.grey.shade600, size: 20,),
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                      child: TextFormField(
                                        obscureText: true,
                                        autofocus: false,
                                        controller: _passwordTextController,
                                        textAlignVertical: TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration.collapsed(
                                          fillColor: Colors.grey.shade300,
                                          focusColor: Colors.white,
                                          hintText: 'Password',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Colors.grey.shade500),
                                        ).copyWith(isDense: true),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black, fontSize: 15,),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (String value) {
                                          if (value.isEmpty || value.length < 6) {
                                            return '               Password invalid';
                                          }
                                        },
                                        onSaved: (String value) {
                                          _formData['password'] = value;
                                        },
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  _submitLogin(model);
                                },
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: Color(0xffCE0E27),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                  child: Center(
                                      child: Text('Login',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => Register()));
                                },
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
                                  child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an account? ",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15,),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: 'Sign up',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(color: Color(0xffCE0E27), fontSize: 16, fontWeight: FontWeight.w700,),
                                                ),
                                            ),
                                          ],
                                        ),
                                      )

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),

                  /*Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: horizontalLine(),
                        ),
                        Text(' Or access with ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.normal,),
                            ),
                        ),
                        Expanded(
                          flex: 2,
                          child: horizontalLine(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xff3B5998),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  height: 22,
                                  width: 22,
                                  child: Image.asset(
                                      'assets/facebook_logo.png'),
                                ),
                              ],
                            )
                        ),
                        Container(
                          height: 40,
                          child: Center(
                              child: Text('Sign in with Facebook',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(color: Colors.white, fontSize: 14,),
                                  ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  InkWell(
                    onTap: () {},
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey[600],
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  height: 22,
                                  width: 22,
                                  child: Image.asset('assets/google_logo.png'),
                                ),
                              ],
                            )
                        ),
                        Container(
                          height: 40,
                          child: Center(
                              child: Text('Sign in with Google',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14,),
                                  ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),

      );
    });
  }

  void showStatusToast(String mesej) {
    Fluttertoast.showToast(
        msg: mesej,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER
    );
  }

  void _submitLogin(MainScopedModel model) async {
    setState(() {
      _isLoader = true;
    });
    if (!_formKeyForLogin.currentState.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }
    _formKeyForLogin.currentState.save();

    final Map<String, dynamic> authData = {
      'email': _formData['email'],
      'password': _formData['password']
    };

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final http.Response response = await http.post(
      Constants.apiLogin,
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json',},
    );

    print("RES BODY >>>> "+response.body);

    final Map<String, dynamic> responseData = json.decode(response.body);
    String message = 'Something wrong somewhere.';
    bool hasError = true;
    print(responseData);
    if (responseData["message"] == "success") {
      message = "Successfully logged in.";
      hasError = false;
    } else {
      message = responseData["data"];
    }
    print("MESG >>>> "+message);
    //print("MESG >>>> "+responseData["data"]);

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };

    if (successInformation['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['data']['token']);
      prefs.setString('email', responseData['data']['email']);

      model.loggedInUser();
      model.fetchProfile();
      model.fetchCartTotal();
      model.fetchCartsFromResponse();
      model.fetchAddressList();
      model.fetchBankList();
      model.fetchOrderHistoryResponse();

      Navigator.of(context).pushReplacementNamed("/ShopIndex");
      print('Sukses login! => '+successInformation['message']);
      //showStatusToast(message);

    } else {
      print('An Error Occurred! => '+successInformation['message']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unsuccessful login.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700,),
              ),
            ),
            content: Text(message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600,),
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

}

//==========================================================================================================================

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  final Map<String, dynamic> _formData = {'name': null, 'email': null, 'password': null};
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isLoader = false;

  void showStatusToast(String mesej) {
    Fluttertoast.showToast(
        msg: mesej,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER
    );
  }

  void _submitForm() async {
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
    };

    final http.Response response = await http.post(
      Constants.apiRegister,
      body: json.encode(authData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
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

      //showStatusToast(message);
      Navigator.pushReplacement(context, SlideRightRoute(page: SignInOrRegister()));
      print('Success register! => '+successInformation['message']);

    } else {
      print('An Error Occurred! => '+successInformation['message']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unsuccessful register.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700,),
              ),
            ),
            content: Text(message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600,),
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
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            'assets/lg_edagang.png',
            fit: BoxFit.fill,
            height: 50,
            width: 127,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[

          Container(
            height: double.infinity,
            width: double.infinity,
            child: new Form(
              key: _formKey,
              autovalidate: false,
              child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create an account.',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 17, fontWeight: FontWeight.w700,),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 22,
                              width: 22,
                              child: Icon(Icons.person,color: Colors.grey.shade600,size: 20,),
                            ),
                          ],
                        )
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration.collapsed(
                            fillColor: Colors.grey.shade300,
                            focusColor: Colors.white,
                            hintText: 'Full Name',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                          ).copyWith(isDense: true),
                          //style: TextStyle(fontFamily: 'Quicksand', fontSize: 15,color: Colors.black),
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black, fontSize: 15,),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (String value) {
                            if (value.isEmpty) {return 'Please enter your name';}
                          },
                          onSaved: (String value) {
                            _formData['name'] = value;
                          },
                        )
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                height: 22,
                                width: 22,
                                child: Icon(Icons.email,color: Colors.grey.shade600,size: 20,),
                              ),
                            ],
                          )
                      ),
                      Container(
                          height: 40,
                          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: TextFormField(
                            obscureText: false,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration.collapsed(
                              fillColor: Colors.grey.shade300,
                              focusColor: Colors.white,
                              hintText: 'Email',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                            ).copyWith(isDense: true),
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black, fontSize: 15,),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (String value) {
                              if (value.isEmpty ||
                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                            },
                            onSaved: (String value) {
                              _formData['email'] = value;
                            },
                          )
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                height: 22,
                                width: 22,
                                child: Icon(Icons.vpn_key,color: Colors.grey.shade600,size: 20,),
                              ),
                            ],
                          )
                      ),
                      Container(
                          height: 40,
                          margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: TextFormField(
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration.collapsed(
                              fillColor: Colors.grey.shade300,
                              focusColor: Colors.white,
                              hintText: 'Password',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                            ).copyWith(isDense: true),
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black, fontSize: 15,),
                            ),
                            keyboardType: TextInputType.text,
                            controller: _passwordTextController,
                            validator: (String value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Password invalid';
                              }
                            },
                            onSaved: (String value) {
                              _formData['password'] = value;
                            },
                          )
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      _submitForm();
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                          color: Color(0xffCE0E27),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Center(
                          child: Text('Sign up',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,),
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignInOrRegister()));
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontWeight: FontWeight.w600,),
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Sign in',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Color(0xffCE0E27), fontSize: 16, fontWeight: FontWeight.w700,),
                                    ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

}

