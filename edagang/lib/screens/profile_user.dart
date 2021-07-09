import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/helper/constant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AccProfilePage extends StatefulWidget {
  @override
  _AccProfilePageState createState() => new _AccProfilePageState();
}

class _AccProfilePageState extends State<AccProfilePage> {

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  int selectedRadioTile;
  int selectedRadio;
  Size _deviceSize;

  @override
  void initState() {
    //this.getProfile();
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Account_Profile',parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    //Navigator.pop(context,true);
    Size screenSize = MediaQuery.of(context).size;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child,MainScopedModel model)
        {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "My Profile",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: new ListView(
              shrinkWrap: true,
              reverse: false,
              children: <Widget>[
                //_getSeparator(10),
                ListTile(
                  onTap: () {
                    _viewForm(1,'Change Fullname', model);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => new EditAccProfile(nama: model.getFname(), mobi: model.getPhone(), gen: model.getGender(), dob: model.getDob())),);
                  },
                  title: Text('Fullname:', style: TextStyle(color: Colors.black87),),
                  subtitle: Text( model.getFname() ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 14,),),
                  trailing: Icon(LineAwesomeIcons.edit, color: Colors.grey.shade600),
                ),
                ListTile(
                  onTap: () {
                    _viewForm(2,'Change Mobile No', model);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => new EditAccProfile(nama: model.getFname(), mobi: model.getPhone(), gen: model.getGender(), dob: model.getDob())),);
                  },
                  title: Text('Mobile No:', style: TextStyle(color: Colors.black87),),
                  subtitle: Text( model.getPhone() ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 14,),),
                  trailing: Icon(LineAwesomeIcons.edit, color: Colors.grey.shade600),
                ),
                ListTile(
                  onTap: () {
                    _viewForm(3,'Change Email', model);
                  },
                  title: Text('E-mail:', style: TextStyle(color: Colors.black87),),
                  subtitle: Text( model.getEmail() ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 14,),),
                  trailing: Icon(LineAwesomeIcons.edit, color: Colors.grey.shade600),
                ),
                ListTile(
                  onTap: () {
                    _viewForm(4,'Change Gender', model);
                  },
                  title: Text('Gender:', style: TextStyle(color: Colors.black87),),
                  subtitle: Text( model.getGender() ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 14,),),
                  trailing: Icon(LineAwesomeIcons.edit, color: Colors.grey.shade600),
                ),
                ListTile(
                  onTap: () {
                    _viewForm(5,'Change Birthdate', model);
                  },
                  title: Text('Birthdate:', style: TextStyle(color: Colors.black87),),
                  subtitle: Text( model.getDob() ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 14,),),
                  trailing: Icon(LineAwesomeIcons.edit, color: Colors.grey.shade600),
                ),
                //_getSeparator(10),
                /*new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Name :',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                        child: new Text(model.getFname() != null ? model.getFname() : 'Unknown',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,),
                            ),
                        )
                    ),
                    SizedBox(height: 6.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: _buildDivider(screenSize),
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'E-mail :',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                        child: new Text(model.getEmail() != null ? model.getEmail() : 'Unknown',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Color(0xff202020), fontSize: 15, fontWeight: FontWeight.w400,),
                            ),
                        )
                    ),
                    SizedBox(height: 6.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: _buildDivider(screenSize),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Mobile No :',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                        child: new Text(model.getPhone() != null ? model.getPhone() : 'Unknown',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,),
                            ),
                        )
                    ),
                    SizedBox(height: 6.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: _buildDivider(screenSize),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Gender :',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                        child:

                        new Text(model.getGender() != null ? model.getGender() : 'Unknown',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,),
                            ),
                        )
                    ),
                    SizedBox(height: 6.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: _buildDivider(screenSize),
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Date of Birth :',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                        child: new Text(model.getDob() != null ? model.getDob() : 'Unknown',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,),
                            ),
                        )
                    ),
                    SizedBox(height: 6.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: _buildDivider(screenSize),
                    ),

                  ],
                )*/
              ],
            ),
          );
        }
    );
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  _viewForm(int type, String title, MainScopedModel model) {
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
              initialChildSize: 0.55,
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
                                  child: SingleChildScrollView(
                                    child: MyCustomForm(type, model.getFname(), model.getPhone(), model.getEmail(), model.getGender(), model.getDob()),
                                  )
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

}


class MyCustomForm extends StatefulWidget {
  int ftype;
  String fname,phone,email,gender,dob;
  MyCustomForm(this.ftype,this.fname, this.phone, this.email, this.gender, this.dob,);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final MainScopedModel xmodel = MainScopedModel();
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  bool isLoading = false;
  bool _displayNameValid = true;
  bool _displayMobileValid = true;
  bool _displayEmailValid = true;
  bool _displayGenderValid = true;
  bool _displayDobValid = true;
  String genType;


  @override
  void initState() {
    super.initState();
    fullNameController = new TextEditingController(text: widget.fname);
    mobileNoController = new TextEditingController(text: widget.phone);
    emailController = new TextEditingController(text: widget.email);
    genderController = new TextEditingController(text: widget.gender);
    dobController = new TextEditingController(text: widget.dob);
    genType = widget.gender.substring(0,1);
  }

  void _submitForm(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();

    final Map<String, dynamic> userData = {
      'fullname': fullNameController.text,
      'mobile_no': mobileNoController.text,
      //'email': emailController.text,
      'gender': genType,
      'dob': dobController.text,
    };

    print('Profile data ==================================================');
    print(userData);
    final http.Response response = await http.post(
        Uri.parse(Constants.shopAPI+'/account/profile'),
      body: json.encode(userData),
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    );

    print(response.body);
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String message = 'Something went wrong.';
      bool hasError = true;
      print(responseData);

      if (responseData['message'] == 'success') {
        print('success >>>'+responseData['data']["user"]['fullname'] );
        message = 'Update profile successfuly.';
        hasError = false;
      } else {
        message = responseData["message"];
        print('failed >>> ' + responseData["message"]);
      }

      final Map<String, dynamic> successInformation = {
        'success': !hasError,
        'message': message
      };
      if (successInformation['success']) {
        model.fetchProfile();
        Navigator.pop(context,true);
        print("Profile info successfuly updated.");
      } else {
        print("Failed to update profile info.");
      }
    } else {
      print('Server error code >>> ' + response.statusCode.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child,MainScopedModel model)
        {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                widget.ftype == 1 ? buildFullNameField() : widget.ftype == 2
                    ? buildMobileNoField()
                    : widget.ftype == 3 ? buildEmailField() : widget.ftype == 4
                    ? buildGenderField()
                    : buildDobField(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: new RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0)),
                    onPressed: () => _submitForm(model),
                    child: new Text(
                      "SUBMIT",
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
          );
        });
  }

  TextFormField buildFullNameField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter new full name.';
        }
        return null;
      },
      controller: fullNameController,
      decoration: InputDecoration(
        labelText: "Full Name",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        errorText: _displayNameValid ? null : "Full Name missing.",

      ),
    );
  }

  TextFormField buildMobileNoField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter new mobile no.';
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      controller: mobileNoController,
      decoration: InputDecoration(
        labelText: "Mobile No",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        errorText: _displayMobileValid ? null : "Mobile no missing.",

      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email address.';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
        labelText: "E-mail",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        errorText: _displayEmailValid ? null : "Email address missing.",

      ),
    );
  }

  Column buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Radio(
            value: 'M',
            groupValue: genType,
            onChanged: (value) {
              setState(() {
                genType = value;
              });
            },
          ),
          title: Text('MALE'),
        ),
        ListTile(
          leading: Radio(
            value: 'F',
            groupValue: genType,
            onChanged: (value) {
              setState(() {
                genType = value;
              });
            },
          ),
          title: Text('FEMALE'),

        ),
        SizedBox(height: 5),
      ],
    );
  }

  TextFormField buildDobField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date of birth.';
        }
        return null;
      },
      keyboardType: TextInputType.datetime,
      controller: dobController,
      decoration: InputDecoration(
        labelText: "Date of birth",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        errorText: _displayDobValid ? null : "Birthdate missing.",

      ),
    );
  }


}