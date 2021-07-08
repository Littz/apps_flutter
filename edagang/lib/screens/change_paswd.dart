import 'package:edagang/helper/constant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChangePaswd extends StatefulWidget {

  @override
  ChangePaswdState createState() => new ChangePaswdState();
}

class ChangePaswdState extends State<ChangePaswd> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
  TextEditingController();
  bool _isLoader = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Change_Password',parameters:null);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildCurrentPasswordFormField(),
                SizedBox(height: 16),
                buildNewPasswordFormField(),
                SizedBox(height: 16),
                buildConfirmNewPasswordFormField(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: new RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                    onPressed: () => _submitForm(),
                    child: new Text("CHANGE PASSWORD",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontWeight: FontWeight.bold,),
                      ),
                    ),
                    color: Color(0xff006FBD),
                    textColor: Colors.white,
                    elevation: 5.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    /*return Scaffold(
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
            textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
          ),
        ),
      ),
      backgroundColor: Color(0xffEEEEEE),
      body: ,
    );*/
  }

  Widget buildCurrentPasswordFormField() {
    return TextFormField(
      controller: currentPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter Current Password",
        labelText: "Current Password",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (currentPasswordController.text.isEmpty) {
          return "Old Password cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter New password",
        labelText: "New Password",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (newPasswordController.text.isEmpty) {
          return "New Password cannot be empty";
        } else if (newPasswordController.text.length < 6) {
          return "Password too short(minimum 6 characters)";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildConfirmNewPasswordFormField() {
    return TextFormField(
      controller: confirmNewPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        labelText: "Confirm New Password",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (confirmNewPasswordController.text != newPasswordController.text) {
          return "Not matching with Password";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      'password': currentPasswordController.text,
      'new_password': newPasswordController.text,
    };

    print(currentPasswordController.text);
    print(newPasswordController.text);

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
      Navigator.pop(context,true);
      print("New password successfuly updated.");
    } else {
      print("Failed to update new password.");
    }
    setState(() {
      _isLoader = false;
    });
  }

}
