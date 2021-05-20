import 'package:edagang/utils/constant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChangePaswd extends StatefulWidget {
  ChangePaswd();

  @override
  ChangePaswdState createState() => new ChangePaswdState();
}

class ChangePaswdState extends State<ChangePaswd> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map<String, dynamic> _formData = {'oldpaswd': null, 'newpaswd': null, 'renewpaswd': null};
  int _id;
  String _value;
  bool _isLoader = false;
  DateTime selectedDate = DateTime.now();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordTextControllerO = new TextEditingController();


  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Change_Password',parameters:null);
  }

  void showCartSnak(BuildContext context,String msg,bool flag){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(msg,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: (flag) ? Colors.green : Colors.red[500] ,
          duration: Duration(seconds: 3),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xff084B8C),
        ),
        title: Text(
          "Change Password",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      backgroundColor: Color(0xffEEEEEE),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: new Form(
                  key: _formKey,
                  autovalidate: false,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(
                          labelText: "Old Password",
                          enabled: true,
                          filled: false,
                        ),
                        keyboardType: TextInputType.text,
                        controller: _passwordTextControllerO,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Password invalid';
                          }
                        },
                        onSaved: (String value) {
                          _formData['oldpaswd'] = value;
                        },
                      ),

                      TextFormField(
                        obscureText: true,
                        decoration: new InputDecoration(
                          labelText: "New Password",
                          enabled: true,
                          filled: false,
                        ),
                        keyboardType: TextInputType.text,
                        controller: _passwordTextController,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Password invalid';
                          }
                        },
                        onSaved: (String value) {
                          _formData['newpaswd'] = value;
                        },
                      ),

                      TextFormField(
                        obscureText: true,
                        //controller: re_password_controller,
                        decoration: new InputDecoration(
                          labelText: "Confirm New Password*",
                          enabled: true,
                          filled: false,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (_passwordTextController.text != value) {
                            return 'Passwords do not match.';
                          }
                        },
                      ),


                      new Padding(
                        padding: EdgeInsets.only(
                            left: 0.0, top: 40.0, bottom: 20.0),
                        child: new RaisedButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () => _submitForm(),
                          child: new Text(
                            "CHANGE PASSWORD ",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontWeight: FontWeight.bold,),
                            ),
                          ),
                          color: Colors.deepOrange,
                          textColor: Colors.white,
                          elevation: 5.0,
                          padding: EdgeInsets.only(
                              left: 90.0,
                              right: 90.0,
                              top: 12.0,
                              bottom: 12.0),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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


    final Map<String, dynamic> userData = {
      'password': _formData['oldpaswd'],
      'new_password': _formData['newpaswd'],
    };

    print(_formData['oldpaswd']);
    print(_formData['newpaswd']);

    final http.Response response = await http.post(
      Constants.shopAPI+'/account/password',
      body: json.encode(userData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    String message = 'Something went wrong.';
    bool hasError = true;
    print(responseData);
    if (responseData['message'] == 'success') {
      print('>>> '+responseData["message"] );
      message = 'Password successfuly changed.';
      hasError = false;
    } else if (responseData['message'] == 'failed') {
      message = "Failed : " + responseData["data"]["reason"];
      print('failed >>> ' + message);
    }

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };
    if (successInformation['success']) {
      //final SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setInt('id', responseData['id']);
      //prefs.setString('name', responseData['data']['name']);
      //prefs.setString('email', responseData['data']['email']);
      //prefs.setString('token', responseData['data']['token']);
      //model.fetchCurrentOrder();
      //model.loggedInUser();
      Navigator.of(context).pop();
      //showSuccessFlushbar(context);
      showCartSnak(context,"Password successfuly changed.",true);
      /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return _alertDialog('Success!', successInformation['message']);
          });*/
    } else {
      //showFailedFlushbar(context);
      showCartSnak(context,"Failed to change password.",false);
      /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return _alertDialog(
                'An Error Occurred!', successInformation['message']);
          });*/
    }
    setState(() {
      _isLoader = false;
    });
  }
}
