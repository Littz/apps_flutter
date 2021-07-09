import 'dart:convert';
import 'package:edagang/models/address_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/helper/constant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBook extends StatefulWidget {
  @override
  _AddressBookState createState() => new _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  Map<dynamic, dynamic> responseBody;
  List<Address> listAddrs = [];
  Size _deviceSize;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Address_Book',parameters:null);
  }

  /*void _moveToAccountScreen(BuildContext context) => Navigator.pushReplacementNamed(context, '/Account');*/

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model){
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          //backgroundColor: Color(0xFF54C5F8),
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color(0xff084B8C),
          ),
          title: Text(
            "My Address",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => AddAddress(frm: 'acc')));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 16),
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                          color: Color(0xff006FBD),
                          width: 1.0,
                          style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: new Text(
                        '+ Add address',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Color(0xff006FBD), fontSize: 15, fontWeight: FontWeight.w700,),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  child: ListView.builder(
                    physics: ScrollPhysics(), ///
                    shrinkWrap: true, ///
                    scrollDirection: Axis.vertical, ///
                    itemCount: model.addrList.length,
                    itemBuilder: (context, index) {
                      var data = model.addrList[index];
                      //listAddrs = data as List<Address>;
                      //listAddrs[index], onDelete: () => removeItem(index);
                      return Padding(
                          padding: new EdgeInsets.only(left: 10, top: 5, right: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(left: 5, right: 5,),
                                        child: Icon(LineAwesomeIcons.user, color: Color(0xff006FBD), size: 18,),
                                      ),
                                      Expanded(
                                        child: new Container(
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          child: new Text(
                                            data.name.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600,),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          child: Text('Edit',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(decoration: TextDecoration.underline, fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff006FBD)),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          onTap: () {
                                            Navigator.push(context,MaterialPageRoute(builder: (context) => EditAddress(addrid: data.id, nama: data.name, fuladdr: data.address, state: data.state_id, city: data.city_id, zipcode: data.postcode, phone: data.mobile_no)));
                                          },
                                        ),
                                      ),
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                                        child: Icon(LineAwesomeIcons.phone, color: Color(0xff006FBD), size: 18,),
                                      ),
                                      Expanded(
                                        child: new Container(
                                          padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                                          child:  new Text(
                                            data.mobile_no,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                                        child:  Icon(LineAwesomeIcons.map_marker, color: Color(0xff006FBD), size: 18,),
                                      ),
                                      Expanded(
                                        child: new Container(
                                          padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                                          child:  new Text(
                                            data.full_address,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400,),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                                SizedBox(height: 10.0),
                                _getSeparator(1),
                                SizedBox(height: 5.0),
                                /*new ButtonTheme(
                                  child: new ButtonBar(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                        child: OutlineButton(
                                          shape: StadiumBorder(),
                                          color: Colors.transparent,
                                          borderSide: BorderSide(color: Colors.orangeAccent.shade700),
                                          //icon: Icon(CupertinoIcons.add, size: 24, color: Colors.orangeAccent.shade700,),
                                          child: Text('Edit',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.orangeAccent.shade700, fontSize: 13, fontWeight: FontWeight.w700,),
                                            ),
                                          ), //`Text` to display
                                          onPressed: () {
                                            //Navigator.push(context,MaterialPageRoute(builder: (context) => EditAddress()));
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => new EditAddress(addrid: data.id, nama: data.name, fuladdr: data.address, state: data.state_id, city: data.city_id, zipcode: data.postcode, phone: data.mobile_no)),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15.0),
                                      SizedBox(
                                        height: 20,
                                        child: OutlineButton(
                                          shape: StadiumBorder(),
                                          color: Colors.transparent,
                                          borderSide: BorderSide(color: Colors.redAccent.shade400),
                                          //icon: Icon(CupertinoIcons.add, size: 24, color: Colors.orangeAccent.shade700,),
                                          child: Text('Delete',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.redAccent.shade400, fontSize: 13, fontWeight: FontWeight.w700,),
                                            ),
                                          ), //`Text` to display
                                          onPressed: () async {
                                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                                            Map<dynamic, dynamic> orderParams = Map();
                                            orderParams = {'_method': 'DELETE'};
                                            http.post(Constants.addressAPI +'/'+data.id.toString()+"?_method=DELETE",
                                              headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                                              //body: json.encode(orderParams)
                                            ).then((response) {
                                              print('Deleting Address.. >>>>');
                                              print(response.body);
                                              print('Address Deleted >>>>');

                                              setState((){
                                                //removeAddr(index,model);
                                                listAddrs.removeWhere((item) => item == data);

                                                model.fetchAddressList();
                                                model.fetchCartReload();
                                                Navigator.popAndPushNamed(context, '/Address');
                                                //listAddrs.remove(data.id);
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                              ]
                          )
                      );
                    },
                  ),
                ),

              ]
          )
        )
      );
    });
  }

  /*void removeAddr(int index, MainScopedModel model) {
    setState(() {
      model.addrList = List.from(model.addrList)
        ..removeAt(index);
    });
  }*/

  void showAlert(int aid) {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          if(Theme.of(context).platform == TargetPlatform.iOS)
          {
            return new CupertinoAlertDialog(
              title: new Text("Delete Address", style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),),
              content: new Text("Are you sure to delete this address?", style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Yes", style: GoogleFonts.lato(
                      textStyle: TextStyle(fontWeight: FontWeight.w500,),
                    ),),
                    onPressed: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      Map<dynamic, dynamic> orderParams = Map();
                      orderParams = {'_method': 'DELETE'};
                      http.post(Uri.parse(Constants.addressAPI +'/'+aid.toString()),
                          headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                          body: json.encode(orderParams)
                      ).then((response) {
                        print('Deleting Address.. >>>>');
                        print(response.body);
                        print('Address Deleted >>>>');
                        //var resp = json.decode(response.body);
                        //print(resp);
                        Navigator.popAndPushNamed(context, '/Address');
                      });
                    }
                ),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("No", style: GoogleFonts.lato(
                      textStyle: TextStyle(fontWeight: FontWeight.w500,),
                    ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    }
                )
              ],
            );
          }
          else
          {
            return AlertDialog(
              title: new Text("Delete Address", style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
              ),),
              content: new Text("Are you sure to delete this address?", style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),
              ),),
              actions: <Widget>[
                FlatButton(
                  child: new Text("No", style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w600,),
                  ),),
                  onPressed: (){
                    Navigator.pop(context, 'Cancel');
                  },
                ),
                FlatButton(
                  child: new Text("Yes", style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600,),
                  ),),
                  onPressed: () async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    Map<dynamic, dynamic> orderParams = Map();
                    orderParams = {'_method': 'DELETE'};
                    http.post(Uri.parse(Constants.addressAPI +'/'+aid.toString()),
                        headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                        body: json.encode(orderParams)
                    ).then((response) {
                      print('Deleting Address.. >>>>');
                      print(response.body);
                      print('Address Deleted >>>>');
                      //var resp = json.decode(response.body);
                      //print(resp);
                      Navigator.popAndPushNamed(context, '/Address');
                    });
                  },
                ),
              ],
            );
          }
        }
    );
  }

}


class AddAddress extends StatefulWidget {
  final String frm;
  AddAddress({this.frm});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController recipientFieldController = TextEditingController();
  final TextEditingController phoneFieldController = TextEditingController();
  final TextEditingController streetaddrFieldController = TextEditingController();
  final TextEditingController pincodeFieldController = TextEditingController();
  bool _isLoader = false;

  List statesList = List();
  List citiesList = List();
  String _state;
  String _city;

  String stateInfoUrl = 'http://cartsini.my/api/lookup/state';
  String cityInfoUrl = 'http://cartsini.my/api/lookup/city/';

  Future<String> _getStateList() async {
    await http.get(Uri.parse(stateInfoUrl), headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',}).then((response) {
      var data = json.decode(response.body);
      //print('STATE LOOKUP ####################################################################################');
      //print(data);
      setState(() {
        statesList = data;
      });
    });
  }

  Future<String> _getCitiesList() async {
    await http.get(Uri.parse(cityInfoUrl+_state), headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',}).then((response) {
      var data = json.decode(response.body);
      //print('CITY LOOKUP ####################################################################################');
      //print(data);
      setState(() {
        citiesList = data;
      });
    });
  }

  @override
  void initState() {
    _getStateList();
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Add_New_Address',parameters:null);
  }

  @override
  void dispose() {
    recipientFieldController.dispose();
    phoneFieldController.dispose();
    streetaddrFieldController.dispose();
    pincodeFieldController.dispose();
    super.dispose();
  }

  void showStatusToast(String mesej) {
    Fluttertoast.showToast(
        msg: mesej,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER
    );
  }

  void _moveToAddressScreen(BuildContext context) => Navigator.pushReplacementNamed(context, '/Address');
  void _moveToCheckoutScreen(BuildContext context) => Navigator.pushReplacementNamed(context, '/Checkout');

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child,MainScopedModel model)
    {
      return new WillPopScope(
          onWillPop: () {
        if(widget.frm == "acc") _moveToAddressScreen(context); else _moveToCheckoutScreen(context);
        return null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            "Add New Address",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600,),
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          buildRecipientField(),
                          buildPhoneField(),
                          buildStreetAddrField(),
                          buildStateField(),
                          buildCityField(),
                          buildPincodeField(),

                          /*Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: new RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                              onPressed: () => _submitNewAddr(model),
                              child: new Text("SAVE",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontWeight: FontWeight.bold,),
                                ),
                              ),
                              color: Color(0xff006FBD),
                              textColor: Colors.white,
                              elevation: 5.0,
                            ),
                          ),*/
                        ],
                      ),
                    )
                  ]
                )
              ),
              _btnSave(model),
            ]
          )
        )
      )
      );
    });
  }

  Positioned _btnSave(MainScopedModel model) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 16, bottom: 5, right: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: new RaisedButton(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
            onPressed: () => _submitNewAddr(model),
            child: new Text("SAVE",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.bold,),
              ),
            ),
            color: Color(0xff006FBD),
            textColor: Colors.white,
            elevation: 5.0,
          ),
        )
      ),
    );
  }

  Widget buildRecipientField() {
    return TextFormField(
      controller: recipientFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter recipient name",
        labelText: "Recipient Name",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (recipientFieldController.text.isEmpty) {
          return "Recipient name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Add mobile no",
        labelText: "Mobile No",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (phoneFieldController.text.isEmpty) {
          return "Add your contact number";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStreetAddrField() {
    return TextFormField(
      controller: streetaddrFieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter street address",
        labelText: "Street Address",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (streetaddrFieldController.text.isEmpty) {
          return "Street address cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 12),
          child: new Text(
            "State:",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ),
        Container(
          child: ButtonTheme(
            alignedDropdown: true,
            child: new DropdownButtonFormField(
              isExpanded: true,
              icon: Icon(LineAwesomeIcons.chevron_circle_down,),
              items: statesList.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item['state_name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _city = null;
                  _state = newVal;
                  _getCitiesList();
                });
                print('State: '+_state.toString());
              },
              value: _state,
              hint: Text('Select a state'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCityField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 12),
          child: new Text(
            "City:",
            style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ),
        Container(
          child: ButtonTheme(
            alignedDropdown: true,
            child: new DropdownButtonFormField(
              isExpanded: true,
              icon: Icon(LineAwesomeIcons.chevron_circle_down,),
              items: citiesList.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item['city_name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _city = newVal;
                });
                print('City: '+_city.toString());
              },
              value: _city,
              hint: Text('Select a city'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPincodeField() {
    return TextFormField(
      controller: pincodeFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter Postcode",
        labelText: "Postcode",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500,),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (pincodeFieldController.text.isEmpty) {
          return "Please enter postcode.";
        } else if (pincodeFieldController.text.length != 5) {
          return "POSTCODE must be of 5 Digits only.";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  void _submitNewAddr(MainScopedModel model) async {
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

    final Map<String, dynamic> addrData = {
      'fullname': recipientFieldController.text,
      'address': streetaddrFieldController.text,
      'state': _state.toString(),
      'city': _city.toString(),
      'postcode': pincodeFieldController.text,
      'mobile_no': phoneFieldController.text,
      'default_shipping': 'Y',
      'default_billing': 'Y',
      'location_tag': 'home'
    };

    print('fullname: '+ recipientFieldController.text);
    print('address: '+ streetaddrFieldController.text);
    print('state: '+ _state.toString());
    print('city: '+ _city.toString());
    print('postcode: '+ pincodeFieldController.text);
    print('mobile_no: '+ phoneFieldController.text);

    final http.Response response = await http.post(
        Uri.parse(Constants.addressAPI),
      body: json.encode(addrData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
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
        print('success >>>' + responseData['data']["addresses"][0]['address']);
        message = 'Update adsress successfuly.';
        hasError = false;
      } else {
        print('failed >>> ' + responseData["message"]);

        if(responseData['data'].containsKey('fullname')) {
          showStatusToast(responseData['data']['fullname'][0]);
        }
        if(responseData['data'].containsKey('address')) {
          showStatusToast(responseData['data']['address'][0]);
        }
        if(responseData['data'].containsKey('state')) {
          showStatusToast(responseData['data']['state'][0]);
        }
        if(responseData['data'].containsKey('city')) {
          showStatusToast(responseData['data']['city'][0]);
        }
        if(responseData['data'].containsKey('postcode')) {
          showStatusToast(responseData['data']['postcode'][0]);
        }
        if(responseData['data'].containsKey('mobile_no')) {
          showStatusToast(responseData['data']['mobile_no'][0]);
        }
      }

      final Map<String, dynamic> successInformation = {
        'success': !hasError,
        'message': message
      };
      if (successInformation['success']) {
        model.fetchAddressList();
        model.fetchCartReload();
        Navigator.pop(context, true);
        print("Address successfuly updated.");
      } else {
        print("Failed to update.");
      }
    } else {
      print('Server error code >>> ' + response.statusCode.toString());
    }

    setState(() {
      _isLoader = false;
    });
  }

}


class EditAddress extends StatefulWidget {
  String nama, fuladdr, zipcode, phone, state, city;
  int addrid;
  EditAddress({this.addrid, this.nama, this.fuladdr, this.state, this.city, this.zipcode, this.phone});

  @override
  _EditAddressState createState() => new _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final MainScopedModel xmodel = MainScopedModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController recipientController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  bool _isLoader = false;
  List<Address> listAddrs = [];

  List statesList = List();
  List citiesList = List();
  String _state;
  String _city;
  String ctname;

  String stateInfoUrl = 'http://cartsini.my/api/lookup/state';
  String cityInfoUrl = 'http://cartsini.my/api/lookup/city/';

  Future<String> _getStateList() async {
    await http.get(Uri.parse(stateInfoUrl), headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',}).then((response) {
      var data = json.decode(response.body);
      //print('STATE LOOKUP ####################################################################################');
      //print(data);
      setState(() {
        statesList = data;
      });
    });
  }

  Future<String> _getCitiesList() async {
    await http.get(Uri.parse(cityInfoUrl+_state), headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',}).then((response) {
      var data = json.decode(response.body);
      //print('CITY LOOKUP ####################################################################################');
      //print(data);
      setState(() {
        citiesList = data;
      });
    });
  }

  @override
  void initState() {
    _getStateList();
    super.initState();
    recipientController = new TextEditingController(text: widget.nama);
    phoneController = new TextEditingController(text: widget.phone);
    addressController = new TextEditingController(text: widget.fuladdr);
    zipcodeController = new TextEditingController(text: widget.zipcode);
    _state = widget.state;
    _city = widget.city;

    _getCitiesList();
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
                "Edit My Address",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(left: 2, right: 0,),
                  child: FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Are you sure you want to delete this Address ?"),
                            actions: [
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  Map<dynamic, dynamic> orderParams = Map();
                                  orderParams = {'_method': 'DELETE'};
                                  http.post(Uri.parse(Constants.addressAPI +'/'+widget.addrid.toString()+"?_method=DELETE"),
                                    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                                  ).then((response) {
                                    print('Deleting Address.. >>>>');
                                    print(response.body);
                                    print('Address Deleted >>>>');

                                    setState((){
                                      listAddrs.removeWhere((item) => item == model.addrList);

                                      model.fetchAddressList();
                                      model.fetchCartReload();
                                      Navigator.popAndPushNamed(context, '/Address');
                                      //Navigator.pop(context, true);
                                    });
                                  });
                                },
                              ),
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    /*onPressed: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      Map<dynamic, dynamic> orderParams = Map();
                      orderParams = {'_method': 'DELETE'};
                      http.post(Constants.addressAPI +'/'+widget.addrid.toString()+"?_method=DELETE",
                        headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                      ).then((response) {
                        print('Deleting Address.. >>>>');
                        print(response.body);
                        print('Address Deleted >>>>');

                        setState((){
                          listAddrs.removeWhere((item) => item == widget.data);

                          model.fetchAddressList();
                          model.fetchCartReload();
                          Navigator.popAndPushNamed(context, '/Address');
                        });
                      });
                    },*/
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      'DELETE',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  /*InkWell(
                    child: Text('DELETE',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(decoration: TextDecoration.underline, fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff006FBD)),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      Map<dynamic, dynamic> orderParams = Map();
                      orderParams = {'_method': 'DELETE'};
                      http.post(Constants.addressAPI +'/'+widget.addrid.toString()+"?_method=DELETE",
                        headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                      ).then((response) {
                        print('Deleting Address.. >>>>');
                        print(response.body);
                        print('Address Deleted >>>>');

                        setState((){
                          listAddrs.removeWhere((item) => item == model.addrList);

                          model.fetchAddressList();
                          model.fetchCartReload();
                          Navigator.popAndPushNamed(context, '/Address');
                        });
                      });
                    },
                  ),*/
                ),
              ],
            ),
            backgroundColor: Colors.white,
              body: SafeArea(
                  child: Stack(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [

                                        buildRecipientField(),
                                        buildPhoneField(),
                                        buildStreetAddrField(),
                                        buildStateField(),
                                        buildCityField(),
                                        buildPincodeField(),

                                        /*Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: new RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                              onPressed: () => _submitNewAddr(model),
                              child: new Text("SAVE",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontWeight: FontWeight.bold,),
                                ),
                              ),
                              color: Color(0xff006FBD),
                              textColor: Colors.white,
                              elevation: 5.0,
                            ),
                          ),*/
                                      ],
                                    ),
                                  )
                                ]
                            )
                        ),
                        _btnSave(model),
                      ]
                  )
              )
            /*body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(left: 16.0, top: 5, right: 16, bottom: 16),
                children: <Widget>[

                  buildRecipientField(),
                  buildPhoneField(),
                  buildStreetAddrField(),
                  buildStateField(),
                  buildCityField(),
                  buildPincodeField(),

                  new Padding(
                      padding: EdgeInsets.only(left: 0.0, top: 40.0, bottom: 20.0),
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          _submitUpdateAddr(model);
                        },
                        child: new Text(
                          "SAVE", style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xff006FBD),
                        textColor: Colors.white,
                        elevation: 5.0,
                        padding: EdgeInsets.only(
                            left: 90.0,
                            right: 90.0,
                            top: 12.0,
                            bottom: 12.0
                        ),
                      )
                  )
                ],
              ),

            ),*/
            /*body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: new Form(
                  key: _formKeyE,
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
                        },
                        onSaved: (String value) {
                          _formData['name'] = value;
                        },
                      ),

                      TextFormField(
                        controller: controllerAddress,
                        decoration: new InputDecoration(
                          labelText: "Full Address",
                          filled: false,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter full address';
                          }
                        },
                        onSaved: (String value) {
                          _formData['fuladdr'] = value;
                        },
                      ),

                      FormField(
                        validator: (value) {
                          if (value == null) {
                            return "Select state";
                          }
                        },
                        onSaved: (value) {
                          _formData['state'] = value;
                        },
                        builder: (FormFieldState states) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Select state*',
                            ),
                            isEmpty: _selectedNegeri == 1,
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton(
                                value: _selectedNegeri ,
                                items: _dropdownMenuStates,
                                onChanged: onChangeDropdownItem,
                              ),
                            ),
                          );
                        },
                      ),

                      FormField(
                        validator: (value) {
                          if (value == null) {
                            return "Select city";
                          }
                        },
                        onSaved: (value) {
                          _formData['city'] = value;
                        },
                        builder: (FormFieldState states) {
                          return InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Select city*',
                              ),
                              isEmpty: _selectedCity == 1,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: _selectedCity,
                                  items: _dropDownMenuCity,
                                  onChanged: changedDropDownCity,
                                ),
                              )
                          );
                        },
                      ),


                      TextFormField(
                        controller: controllerZipcode,
                        decoration: new InputDecoration(
                          labelText: "Postcode",
                          filled: false,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter postcode';
                          }
                        },
                        onSaved: (String value) {
                          _formData['zipcode'] = value;
                        },
                      ),

                      TextFormField(
                        controller: controllerPhone,
                        decoration: new InputDecoration(
                          labelText: "Mobile No",
                          filled: false,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'enter mobile no';
                          }
                        },
                        onSaved: (String value) {
                          _formData['phone'] = value;
                        },
                      ),

                      new Padding(
                        padding: EdgeInsets.only(
                            left: 0.0, top: 40.0, bottom: 20.0),
                        child: new RaisedButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () => _saving ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                            ),
                          ) : _submitEditAddr(),
                          child: new Text(
                            "SAVE ADDRESS ",
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
      ),*/
          );
        });
  }

  Positioned _btnSave(MainScopedModel model) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 16, bottom: 5, right: 16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: new RaisedButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
              onPressed: () => _submitUpdateAddr(model),
              child: new Text("SAVE",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontWeight: FontWeight.bold,),
                ),
              ),
              color: Color(0xff006FBD),
              textColor: Colors.white,
              elevation: 5.0,
            ),
          )
      ),
    );
  }

  Widget buildRecipientField() {
    return TextFormField(
      controller: recipientController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter recipient name",
        labelText: "Recipient Name",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (recipientController.text.isEmpty) {
          return "Recipient name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Add mobile no",
        labelText: "Mobile No",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (phoneController.text.isEmpty) {
          return "Add your contact number";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStreetAddrField() {
    return TextFormField(
      controller: addressController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter street address",
        labelText: "Street Address",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (addressController.text.isEmpty) {
          return "Street address cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 12),
          child: new Text(
            "State:",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ),
        Container(
          child: ButtonTheme(
            alignedDropdown: true,
            child: new DropdownButtonFormField(
              isExpanded: true,
              icon: Icon(LineAwesomeIcons.chevron_circle_down,),
              items: statesList.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item['state_name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _city = null;
                  _state = newVal;
                  _getCitiesList();
                });
                print('State: '+_state.toString());
              },
              value: _state,
              hint: Text('Select a state'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCityField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 12),
          child: new Text(
            "City:",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ),
        Container(
          child: ButtonTheme(
            alignedDropdown: true,
            child: new DropdownButtonFormField(
              isExpanded: true,
              icon: Icon(LineAwesomeIcons.chevron_circle_down,),
              items: citiesList.map((item) {
                ctname = item['city_name'];
                return new DropdownMenuItem(
                  child: new Text(item['city_name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _city = newVal;
                });
                print('City: '+_city.toString());
              },
              value: _city,
              hint: Text(ctname ?? 'Select a city'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPincodeField() {
    return TextFormField(
      controller: zipcodeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter Postcode",
        labelText: "Postcode",
        labelStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500,),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (zipcodeController.text.isEmpty) {
          return "Please enter postcode.";
        } else if (zipcodeController.text.length != 5) {
          return "POSTCODE must be of 5 Digits only.";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  void _submitUpdateAddr(MainScopedModel model) async {
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

    final Map<String, dynamic> addrData = {
      '_method': "PUT",
      'fullname': recipientController.text,
      'address': addressController.text,
      'state': _state.toString(),
      'city': _city.toString(),
      'postcode': zipcodeController.text,
      'mobile_no': phoneController.text,
      'default_billing': "y",
      'default_shipping': "y",
      'location_tag': "home"
    };

    final http.Response response = await http.post(
        Uri.parse(Constants.addressAPI + '/' + widget.addrid.toString()),
      body: json.encode(addrData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
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
        print('success >>>' + responseData['data']["addresses"][0]['address']);
        message = 'Update adsress successfuly.';
        hasError = false;
      } else {
        print('failed >>> ' + responseData["message"]);

      }

      final Map<String, dynamic> successInformation = {
        'success': !hasError,
        'message': message
      };
      if (successInformation['success']) {
        model.fetchAddressList();
        model.fetchCartReload();
        Navigator.pop(context, true);
        print("Address successfuly updated.");
      } else {
        print("Failed to update.");
      }
    } else {
      print('Server error code >>> ' + response.statusCode.toString());
    }

    setState(() {
      _isLoader = false;
    });
  }

}