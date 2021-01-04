import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
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
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
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
                "Account Information",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Color(0xff202020), fontSize: 17, fontWeight: FontWeight.w500,),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width * 0.03),
                  child: _getEditIcon(model.getFname(), model.getPhone(), model.getGender(), model.getDob()),
                ),
              ],
            ),
            backgroundColor: Colors.grey.shade100,
            body: new ListView(
              shrinkWrap: true,
              reverse: false,
              children: <Widget>[
                new Column(
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
                )
              ],
            ),
          );
        });
  }

  Widget _getEditIcon(String name, String phone, String gender, String dob) {
    return new GestureDetector(
        child: new CircleAvatar(
          backgroundColor: Colors.red,
          radius: 14.0,
          child: new Icon(
            Icons.edit,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new EditAccProfile(nama: name, mobi: phone, gen: gender, dob: dob)),
          );
        }
    );
  }

  Widget _buildDivider(Size screenSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[600],
          width: screenSize.width,
          height: 0.25,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

}


class EditAccProfile extends StatefulWidget {
  String nama, mobi, gen, dob;
  EditAccProfile({this.nama, this.mobi, this.gen, this.dob});

  @override
  _EditAccProfileState createState() => new _EditAccProfileState();
}

class _EditAccProfileState extends State<EditAccProfile> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map<String, dynamic> _formData = {'name': null, 'phone': null, 'dob': null};
  int _id;
  String _value;
  bool _isLoader = false;
  DateTime selectedDate = DateTime.now();

  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerGender = new TextEditingController();
  TextEditingController controllerDob = new TextEditingController();

  @override
  void initState() {
    controllerName = new TextEditingController(text: widget.nama );
    controllerPhone = new TextEditingController(text: widget.mobi );
    controllerDob = new TextEditingController(text: widget.dob );
    super.initState();
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      controllerDob.text = new DateFormat("yyyy-MM-dd").format(result); //new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String sdate) {
    try {
      var d = new DateFormat.yMd().parseStrict(sdate);
      var t = new DateFormat.Hms().parseStrict(sdate);
      return d;
    } catch (e) {
      return null;
    }
  }

  void showCartSnak(BuildContext context,String msg,bool flag){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(msg,style: TextStyle(color: Colors.white),),
          backgroundColor: (flag) ? Colors.green : Colors.red[500] ,
          duration: Duration(seconds: 5),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child,MainScopedModel model)
        {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "Edit Account Information",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Color(0xff202020), fontSize: 17, fontWeight: FontWeight.w500,),
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade100,
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
                              controller: controllerName,
                              decoration: new InputDecoration(
                                labelText: "Full Name",
                                filled: false,
                              ),
                              keyboardType: TextInputType.text,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'enter fullname';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _formData['name'] = value;
                              },
                            ),

                            TextFormField(
                              controller: controllerPhone,
                              decoration: new InputDecoration(
                                labelText: "Mobile No",
                                filled: false,
                              ),
                              keyboardType: TextInputType.text,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'enter mobile no';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _formData['phone'] = value;
                              },
                            ),

                            FormField(
                              builder: (FormFieldState states) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Select gender',
                                  ),
                                  isEmpty: _value == 'Gender',
                                  child: new DropdownButtonHideUnderline(
                                    child: new DropdownButton<String>(
                                      items: [
                                        DropdownMenuItem<String>(
                                          child: Text('select gender'),
                                          value: null,
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text('Male'),
                                          value: 'M',
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text('Female'),
                                          value: 'F',
                                        ),
                                      ],
                                      onChanged: (String value) {
                                        setState(() {
                                          _value = value;
                                        });
                                      },
                                      hint: Text('Select Gender'),
                                      value: _value,
                                    ),
                                  ),
                                );
                              },
                            ),

                            new Row(children: <Widget>[
                              new Expanded(
                                  child: new TextFormField(
                                    decoration: new InputDecoration(
                                      //icon: const Icon(Icons.calendar_today),
                                      hintText: 'Enter your date of birth',
                                      labelText: 'Date of birth',
                                    ),
                                    controller: controllerDob,
                                    keyboardType: TextInputType.datetime,
                                    onSaved: (val) {
                                      _formData['dob'] = val;
                                    },
                                    //validator: (val) => isValidDob(val) ? null : 'Not a valid date',
                                    //onSaved: (val) => newContact.dob = convertToDate(val),
                                  )),
                              new IconButton(
                                icon: new Icon(Icons.calendar_today),
                                tooltip: 'Choose date',
                                onPressed: (() {
                                  _chooseDate(context, controllerDob.text);
                                }),
                              )
                            ]),

                            new Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0, top: 40.0, bottom: 20.0),
                              child: new RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                onPressed: () => _submitForm(model),
                                child: new Text(
                                  "SAVE INFO ",
                                  style: new TextStyle(fontWeight: FontWeight.bold),
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
        });
  }

  void _submitForm(MainScopedModel model) async {
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
      'fullname': _formData['name'],
      'mobile_no': _formData['phone'],
      'gender': _value,
      'dob': _formData['dob'],
    };

    print(_formData['name']);
    print(_formData['phone']);
    print(_value);
    print(_formData['dob']);

    final http.Response response = await http.post(
      Constants.shopAPI+'/account/profile',
      body: json.encode(userData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
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
      _isLoader = false;
    });
  }
}