import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _email;
  final Map<String, dynamic> _formData = {'email': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoader = false;

  @override
  void initState() {
    super.initState();
  }

  void _submitRequest() async {
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

    Map<dynamic, dynamic> reqData = Map();
    reqData = {
      'email': _formData['email'],
    };

    http.post('https://shopapp.e-dagang.asia/api/account/reset',
        //headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
        body: JSON.jsonEncode(reqData)
    ).then((response) {
      print('REQUEST FORGOT PASSWORD >>>>>');
      print(_formData['email']);
      print(response.statusCode.toString());
      print(response.body);
      Navigator.pushReplacement(context, SlideRightRoute(page: SignInOrRegister()));
      //Navigator.of(context).pop();
    });

    setState(() {
      _isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: Color(0xff084B8C),
        ),
        title: Text(
          'Forgot Password',
          style: GoogleFonts.lato(
            textStyle: TextStyle(color: Color(0xff084B8C), fontSize: 18,),
          ),
        ),
      ),
      backgroundColor: Color(0xffEEEEEE),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: Text(
                  'Enter your email address used in edagang.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'A link will be emailed to your email address to reset your password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child:
                //============================================= Email Box
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: ((String email) {
                      setState(() {
                        _email = email;
                        print(_email);
                      });
                    }),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    textAlign: TextAlign.start,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['email'] = value;
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0),
                child: RaisedButton(
                  color: Color(0xffC41E34),
                  shape: StadiumBorder(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: Text(
                      "Submit Request",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _submitRequest();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}