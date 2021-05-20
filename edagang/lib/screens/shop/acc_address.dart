import 'dart:convert';
import 'package:edagang/models/address_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/utils/constant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBook extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _AddressBookState();
  }

}

class _AddressBookState extends State<AddressBook> {
  Map<dynamic, dynamic> responseBody;
  List<Address> listAddrs = [];
  Size _deviceSize;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Address_Book_add',parameters:null);
  }

  /*void _moveToAccountScreen(BuildContext context) => Navigator.pushReplacementNamed(context, '/Account');*/

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
            "Address Book",
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.black, fontSize: 18,),
            ),
          ),
          /*leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.popAndPushNamed(context, '/Account'), // POPPING globalContext
          ),*/
        ),
        backgroundColor: Color(0xffEEEEEE),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 16, top: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => AddNewAddress(frm: 'acc')));},
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: new Border.all(
                                color: Colors.orangeAccent.shade400,
                                width: 1.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.orangeAccent.shade100,
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 5.0),
                            ],
                          ),
                          child: Center(
                            child: new Text(
                              '+ New Address',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.orangeAccent.shade700, fontSize: 16, fontWeight: FontWeight.w700,),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: model.addrList.length,
                        itemBuilder: (context, index) {
                          var data = model.addrList[index];
                          //listAddrs[index], onDelete: () => removeItem(index);
                          return Padding(
                              padding: new EdgeInsets.only(left: 10, top: 5, right: 10),
                              child: new Card(
                                  elevation: 5,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Container(
                                          width: 215,
                                          //padding: const EdgeInsets.all(7),
                                          margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5.0),
                                          child: new Text(
                                            data.name,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700,),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        new Container(
                                            width: 215,
                                            //padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7.0),
                                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              //mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  CupertinoIcons.location,
                                                  color: Colors.deepOrange.shade600,
                                                  size: 18,
                                                ),
                                                Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child:  new Text(
                                                        data.full_address,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400,),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                      ),
                                                    )
                                                ),
                                              ],
                                            )
                                        ),
                                        new Container(
                                          width: 215,
                                          //padding: const EdgeInsets.all(7),
                                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      //mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          CupertinoIcons.mail,
                                                          color: Colors.deepOrange.shade600,
                                                          size: 18,
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: new Text(
                                                                data.email ?? 'na',
                                                                style: GoogleFonts.lato(
                                                                  textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400,),
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                SizedBox(height: 3,),
                                                new Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      //mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          CupertinoIcons.phone,
                                                          color: Colors.deepOrange.shade600,
                                                          size: 18,
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: new Text(
                                                                data.mobile_no ?? 'na',
                                                                style: GoogleFonts.lato(
                                                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,),
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                ),

                                              ]
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        new ButtonTheme(
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
                                        ),
                                      ]
                                  )
                              )
                          );
                        },
                      ),
                    ]
                )

            )),
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
                      http.post(Constants.addressAPI +'/'+aid.toString(),
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
                    http.post(Constants.addressAPI +'/'+aid.toString(),
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


class EditAddress extends StatefulWidget {
  String nama, fuladdr, zipcode, phone, state, city;
  int addrid;
  EditAddress({this.addrid, this.nama, this.fuladdr, this.state, this.city, this.zipcode, this.phone});

  @override
  _EditAddressState createState() => new _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final GlobalKey<FormState> _formKeyE = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map<String, dynamic> _formData = {'nama': null, 'fuladdr': null, 'state': null, 'city': null, 'zipcode': null, 'phone': null, };
  int _id;
  bool _saving = false;
  bool _isLoader = false;
  List<StateMsia> _negeri = StateMsia.getStates();
  List<DropdownMenuItem<StateMsia>> _dropdownMenuStates;
  StateMsia _selectedNegeri;
  List<DropdownMenuItem<CityStates>> _dropDownMenuCity;
  CityStates _selectedCity;

  TextEditingController controllerName, controllerPhone, controllerAddress, controllerZipcode;

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Address_Book_edit',parameters:null);
    print(widget.addrid);
    print(widget.nama);
    print(widget.fuladdr);
    print(widget.state);
    print(widget.city);
    print(widget.zipcode);
    print(widget.phone);

    _dropdownMenuStates = buildDropdownMenuItems(_negeri);
    _selectedNegeri = _dropdownMenuStates[0].value;
    _dropDownMenuCity = [];

    print(_selectedNegeri);

    super.initState();
    controllerName = new TextEditingController(text: widget.nama );
    controllerPhone = new TextEditingController(text: widget.phone );
    controllerAddress = new TextEditingController(text: widget.fuladdr );
    controllerZipcode = new TextEditingController(text: widget.zipcode );
  }

  List<DropdownMenuItem<StateMsia>> buildDropdownMenuItems(List negeri) {
    List<DropdownMenuItem<StateMsia>> items = List();
    items.add(DropdownMenuItem(child: Text('select state'), value: null,),);
    for (StateMsia state in negeri) {
      items.add(DropdownMenuItem(child: Text(state.name), value: state,),);
    }
    return items;
  }

  onChangeDropdownItem(StateMsia selectedNegeri) {
    setState(() {
      _selectedCity = null;
      _dropDownMenuCity.clear();

      _selectedNegeri = selectedNegeri;

      print(_selectedNegeri.id);
      if (_selectedNegeri.id == 1) {
        _dropDownMenuCity = getDropDownCity_1();
      } else if (_selectedNegeri.id == 2) {
        _dropDownMenuCity = getDropDownCity_2();
      } else if (_selectedNegeri.id == 3) {
        _dropDownMenuCity = getDropDownCity_3();
      } else if (_selectedNegeri.id == 4) {
        _dropDownMenuCity = getDropDownCity_4();
      } else if (_selectedNegeri.id == 5) {
        _dropDownMenuCity = getDropDownCity_5();
      } else if (_selectedNegeri.id == 6) {
        _dropDownMenuCity = getDropDownCity_6();
      } else if (_selectedNegeri.id == 7) {
        _dropDownMenuCity = getDropDownCity_7();
      } else if (_selectedNegeri.id == 8) {
        _dropDownMenuCity = getDropDownCity_8();
      } else if (_selectedNegeri.id == 9) {
        _dropDownMenuCity = getDropDownCity_9();
      } else if (_selectedNegeri.id == 10) {
        _dropDownMenuCity = getDropDownCity_10();
      } else if (_selectedNegeri.id == 11) {
        _dropDownMenuCity = getDropDownCity_11();
      } else if (_selectedNegeri.id == 12) {
        _dropDownMenuCity = getDropDownCity_12();
      } else if (_selectedNegeri.id == 13) {
        _dropDownMenuCity = getDropDownCity_13();
      } else if (_selectedNegeri.id == 14) {
        _dropDownMenuCity = getDropDownCity_14();
      } else if (_selectedNegeri.id == 15) {
        _dropDownMenuCity = getDropDownCity_15();
      } else if (_selectedNegeri.id == 16) {
        _dropDownMenuCity = getDropDownCity_16();
      }
      _selectedCity = _dropDownMenuCity[0].value;
    });
  }

  void changedDropDownCity(CityStates selectedCity) {
    setState(() {
      _selectedCity = selectedCity;
    });
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
                "Edit Address",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Color(0xff202020), fontSize: 17, fontWeight: FontWeight.w500,),
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            body: Form(
              key: _formKeyE,
              child: ListView(
                padding: EdgeInsets.only(left: 16.0, top: 5, right: 16, bottom: 16),
                children: <Widget>[
                  TextFormField(
                    controller: controllerName,
                    onSaved: (String value) {
                      _formData['nama'] = value;
                    },
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'enter fullname';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controllerAddress,
                    onSaved: (String value) {
                      _formData['fuladdr'] = value;
                    },
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'enter address';
                      }
                      return null;
                    },
                  ),

                  FormField(
                    validator: (value) {
                      if (value == null) {
                        return "Select your state";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['state'] = value;
                    },
                    builder: (FormFieldState states) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Select state*',
                              ),
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: _selectedNegeri,
                                  items: _dropdownMenuStates,
                                  onChanged: onChangeDropdownItem,
                                ),
                              ),
                            ),
                            Text(
                              states.hasError ? states.errorText : '',
                              style: TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
                            ),
                          ]
                      );
                    },
                  ),

                  FormField (
                    validator: (value) {
                      if (value == null) {
                        return "Select your city";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['city'] = value;
                    },
                    builder: (FormFieldState states,) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Select city*',
                              ),
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: _selectedCity,
                                  items: _dropDownMenuCity,
                                  onChanged: changedDropDownCity,
                                ),
                              ),
                            ),
                            Text(
                              states.hasError ? states.errorText : '',
                              style: TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
                            ),
                          ]
                      );
                    },
                  ),


                  TextFormField(
                    controller: controllerZipcode,
                    onSaved: (String value) {
                      _formData['zipcode'] = value;
                    },
                    decoration: InputDecoration(labelText: 'Postcode'),
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'enter postcode';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controllerPhone,
                    onSaved: (String value) {
                      _formData['phone'] = value;
                    },
                    decoration: InputDecoration(labelText: 'Mobile no'),
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'enter mobile no';
                      }
                      return null;
                    },
                  ),

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
                        color: Colors.deepOrange,
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

            ),
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


  void _submitUpdateAddr(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _formKeyE.currentState.save();

    print('Updated...');
    print(_formData['nama']);
    print(_formData['fuladdr']);
    if(_selectedNegeri != null) {
      print(_selectedNegeri.name);
      print(_selectedCity.ctname);
    }
    print(_formData['zipcode']);
    print(_formData['phone']);

    final Map<String, dynamic> addrData = {
      '_method': "PUT",
      'fullname': _formData['nama'],
      'address': _formData['fuladdr'],
      'state': _selectedNegeri == null ? '' : _selectedNegeri.id.toString(),
      'city': _selectedNegeri == null ? '' : _selectedCity.id.toString(),
      'postcode': _formData['zipcode'],
      'mobile_no': _formData['phone'],
      'default_billing': "n",
      'default_shipping': "n",
      'location_tag': "home"
    };

    final http.Response response = await http.post(
      Constants.addressAPI + '/' + widget.addrid.toString(),
      body: json.encode(addrData), //{'fullname': 'Cartsini Sana', 'email': _formData['email'], 'password': _formData['password'], 'channel': 0},
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    );

    /*final http.Response response = await http.post(
      Constants.addressAPI + widget.addrid.toString(),
      body: {
        '_method': "PUT",
        'fullname': _formData['nama'],
        'address': _formData['fuladdr'],
        'state': _selectedNegeri == null ? '' : _selectedNegeri.id.toString(),
        'city': _selectedNegeri == null ? '' : _selectedCity.id.toString(),
        'postcode': _formData['zipcode'],
        'mobile_no': _formData['phone'],
        'default_billing': "n",
        'default_shipping': "n",
        'location_tag': "home"
      },
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token'),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );*/

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
  }


  List<DropdownMenuItem<CityStates>> getDropDownCity_1() {
    List<DropdownMenuItem<CityStates>> ct1 = List();
    ct1.add(DropdownMenuItem(value: null, child: Text('select city')));
    for (CityStates ctlist in _perlis) {
      ct1.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));
    }
    return ct1;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_2() {
    List<DropdownMenuItem<CityStates>> ct2 = List();
    for (CityStates ctlist in _kedah) {ct2.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct2;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_3() {
    List<DropdownMenuItem<CityStates>> ct3 = List();
    for (CityStates ctlist in _penang) {ct3.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct3;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_4() {
    List<DropdownMenuItem<CityStates>> ct4 = List();
    for (CityStates ctlist in _kelantan) {ct4.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct4;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_5() {
    List<DropdownMenuItem<CityStates>> ct5 = List();
    for (CityStates ctlist in _terenganu) {ct5.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct5;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_6() {
    List<DropdownMenuItem<CityStates>> ct6 = List();
    for (CityStates ctlist in _pahang) {ct6.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct6;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_7() {
    List<DropdownMenuItem<CityStates>> ct7 = List();
    for (CityStates ctlist in _perak) {ct7.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct7;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_8() {
    List<DropdownMenuItem<CityStates>> ct8 = List();
    for (CityStates ctlist in _selangor) {ct8.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct8;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_9() {
    List<DropdownMenuItem<CityStates>> ct9 = List();
    for (CityStates ctlist in _kl) {ct9.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct9;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_10() {
    List<DropdownMenuItem<CityStates>> ct10 = List();
    for (CityStates ctlist in _putrajaya) {ct10.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct10;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_11() {
    List<DropdownMenuItem<CityStates>> ct11 = List();
    for (CityStates ctlist in _n9) {ct11.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct11;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_12() {
    List<DropdownMenuItem<CityStates>> ct12 = List();
    for (CityStates ctlist in _melaka) {ct12.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct12;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_13() {
    List<DropdownMenuItem<CityStates>> ct13 = List();
    for (CityStates ctlist in _johor) {ct13.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct13;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_14() {
    List<DropdownMenuItem<CityStates>> ct14 = List();
    for (CityStates ctlist in _labuan) {ct14.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct14;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_15() {
    List<DropdownMenuItem<CityStates>> ct15 = List();
    for (CityStates ctlist in _sabah) {ct15.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct15;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_16() {
    List<DropdownMenuItem<CityStates>> ct16 = List();
    for (CityStates ctlist in _sarawak) {ct16.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct16;
  }

}


class AddNewAddress extends StatefulWidget {
  final String frm;
  AddNewAddress({this.frm});

  @override
  State<StatefulWidget> createState() {
    return new _AddNewAddressState();
  }
}

class _AddNewAddressState extends State<AddNewAddress> with SingleTickerProviderStateMixin {
  final Map<String, dynamic> _formData = {'fullname': null, 'fulladdr': null, 'state': null, 'city': null, 'poscode': null, 'phone': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoader = false;
  Map<dynamic, dynamic> responseBody;
  List<StateMsia> _negeri = StateMsia.getStates();
  List<DropdownMenuItem<StateMsia>> _dropdownMenuStates;
  StateMsia _selectedNegeri;
  List<DropdownMenuItem<CityStates>> _dropDownMenuCity;
  CityStates _selectedCity;

  @override
  void initState() {
    _dropdownMenuStates = buildDropdownMenuItems(_negeri);
    _selectedNegeri = _dropdownMenuStates[0].value;
    _dropDownMenuCity = [];

    super.initState();
    FirebaseAnalytics().logEvent(name: 'Address_New',parameters:null);
  }

  List<DropdownMenuItem<StateMsia>> buildDropdownMenuItems(List negeri) {
    List<DropdownMenuItem<StateMsia>> items = List();
    items.add(DropdownMenuItem(child: Text('select state'), value: null,),);
    for (StateMsia state in negeri) {
      items.add(DropdownMenuItem(child: Text(state.name), value: state,),);
    }
    return items;
  }

  onChangeDropdownItem(StateMsia selectedNegeri) {
    setState(() {
      _selectedCity = null;
      _dropDownMenuCity.clear();

      _selectedNegeri = selectedNegeri;

      print(_selectedNegeri.id);
      if (_selectedNegeri.id == 1) {
        _dropDownMenuCity = getDropDownCity_1();
      } else if (_selectedNegeri.id == 2) {
        _dropDownMenuCity = getDropDownCity_2();
      } else if (_selectedNegeri.id == 3) {
        _dropDownMenuCity = getDropDownCity_3();
      } else if (_selectedNegeri.id == 4) {
        _dropDownMenuCity = getDropDownCity_4();
      } else if (_selectedNegeri.id == 5) {
        _dropDownMenuCity = getDropDownCity_5();
      } else if (_selectedNegeri.id == 6) {
        _dropDownMenuCity = getDropDownCity_6();
      } else if (_selectedNegeri.id == 7) {
        _dropDownMenuCity = getDropDownCity_7();
      } else if (_selectedNegeri.id == 8) {
        _dropDownMenuCity = getDropDownCity_8();
      } else if (_selectedNegeri.id == 9) {
        _dropDownMenuCity = getDropDownCity_9();
      } else if (_selectedNegeri.id == 10) {
        _dropDownMenuCity = getDropDownCity_10();
      } else if (_selectedNegeri.id == 11) {
        _dropDownMenuCity = getDropDownCity_11();
      } else if (_selectedNegeri.id == 12) {
        _dropDownMenuCity = getDropDownCity_12();
      } else if (_selectedNegeri.id == 13) {
        _dropDownMenuCity = getDropDownCity_13();
      } else if (_selectedNegeri.id == 14) {
        _dropDownMenuCity = getDropDownCity_14();
      } else if (_selectedNegeri.id == 15) {
        _dropDownMenuCity = getDropDownCity_15();
      } else if (_selectedNegeri.id == 16) {
        _dropDownMenuCity = getDropDownCity_16();
      }
      _selectedCity = _dropDownMenuCity[0].value;
    });
  }

  void changedDropDownCity(CityStates selectedCity) {
    setState(() {
      _selectedCity = selectedCity;
    });
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
    return new WillPopScope(
        onWillPop: () {
          if(widget.frm == "acc") _moveToAddressScreen(context); else _moveToCheckoutScreen(context);
          return null;
        },
        child: new Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "Add New Address",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Color(0xff202020), fontSize: 17, fontWeight: FontWeight.w500,),
                ),
              ),
              automaticallyImplyLeading: true,
              /*leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.popAndPushNamed(context, '/Address'), // POPPING globalContext
              ),*/
            ),
            backgroundColor: Colors.grey.shade100,
            body: new ListView(
              shrinkWrap: true,
              reverse: false,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _renderFormAddr(),

                  ],
                )
              ],
            )
        )
    );
  }

  Widget _renderFormAddr() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child,MainScopedModel model)
        {
          return new Center(
              child: new Center(
                child: new Stack(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: new Form(
                          key: _formKey,
                          autovalidate: false,
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              _fullNameTextField(),
                              _fullAddrTextField(),
                              _stateListField(),
                              _cityListField(),
                              _poscodeTextField(),
                              _phoneTextField(),

                              new Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, top: 40.0, bottom: 20.0),
                                child: new RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                          30.0)),
                                  onPressed: () => _submitNewAddr(model),
                                  /*onPressed: () {
                              print(_selectedNegeri.id);
                              print(_selectedCity.id);
                            },*/
                                  child: new Text(
                                    "SAVE ADDRESS",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Colors.deepOrange,
                                  textColor: Colors.white,
                                  elevation: 5.0,
                                  padding: EdgeInsets.only(left: 90.0,
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
              )
          );
        });
  }

  Widget _fullNameTextField() {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: new TextFormField(
        //controller: name_controller,
        decoration: new InputDecoration(
          labelText: "Full Name*",
          filled: false,
          /*prefixIcon: Padding(
                padding:
                EdgeInsets.only(right: 7.0),
                child: new Image.asset(
                  "icons/ic_user_grey.png",
                  height: 25.0,
                  width: 25.0,
                  fit: BoxFit.scaleDown,
                )
            )*/
        ),
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter full name';
          }
        },
        onSaved: (String value) {
          _formData['fullname'] = value;
        },
      ),
    );
  }

  Widget _fullAddrTextField() {
    return new Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        child: new TextFormField(
          obscureText: false,
          //controller: email_controller,
          decoration: new InputDecoration(
            labelText: "Full Address*",
            enabled: true,
            filled: false,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter full address';
            }
          },
          onSaved: (String value) {
            _formData['fulladdr'] = value;
          },
        ));
  }

  Widget _stateListField() {
    return new Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        child: new FormField(
          builder: (FormFieldState states) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: 'Select state*',
              ),
              isEmpty: _selectedNegeri == 'State',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  value: _selectedNegeri,
                  items: _dropdownMenuStates,
                  onChanged: onChangeDropdownItem,
                ),
              ),
            );
          },
        ));
  }

  Widget _cityListField() {

    return new Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        child: new FormField(
          builder: (FormFieldState states) {
            return InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select city*',
                ),
                isEmpty: _selectedCity == 'City',
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    value: _selectedCity,
                    items: _dropDownMenuCity,
                    onChanged: changedDropDownCity,
                  ),
                )
            );
          },
        )
    );
  }

  Widget _poscodeTextField() {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: new TextFormField(
        //controller: name_controller,
        decoration: new InputDecoration(
          labelText: "Postcode*",
          filled: false,
        ),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter poscode';
          }
          //return null;
        },
        onSaved: (String value) {
          _formData['poscode'] = value;
        },
      ),
    );
  }

  Widget _phoneTextField() {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: new TextFormField(
        //controller: name_controller,
        decoration: new InputDecoration(
          labelText: "Phone*",
          filled: false,
        ),
        keyboardType: TextInputType.phone,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter phone number.';
          }
        },
        onSaved: (String value) {
          _formData['phone'] = value;
        },
      ),
    );
  }

  void _submitNewAddr(MainScopedModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _formKey.currentState.save();

    final Map<String, dynamic> addrData = {
      'fullname': _formData['fullname'],
      'address': _formData['fulladdr'],
      'state': _selectedNegeri == null ? '' : _selectedNegeri.id.toString(),
      'city': _selectedNegeri == null ? '' : _selectedCity.id.toString(),
      'postcode': _formData['poscode'],
      'mobile_no': _formData['phone'],
      'default_shipping': 'Y',
      'default_billing': 'Y',
      'location_tag': 'home'
    };

    final http.Response response = await http.post(
      Constants.addressAPI,
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

  }

  Widget _alertDialog(String boxTitle, String message) {
    return AlertDialog(
      title: Text(boxTitle),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade400)),
          onPressed: () {Navigator.of(context).dispose();},
        )
      ],
    );
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_1() {
    List<DropdownMenuItem<CityStates>> ct1 = List();
    for (CityStates ctlist in _perlis) {ct1.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct1;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_2() {
    List<DropdownMenuItem<CityStates>> ct2 = List();
    for (CityStates ctlist in _kedah) {ct2.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct2;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_3() {
    List<DropdownMenuItem<CityStates>> ct3 = List();
    for (CityStates ctlist in _penang) {ct3.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct3;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_4() {
    List<DropdownMenuItem<CityStates>> ct4 = List();
    for (CityStates ctlist in _kelantan) {ct4.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct4;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_5() {
    List<DropdownMenuItem<CityStates>> ct5 = List();
    for (CityStates ctlist in _terenganu) {ct5.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct5;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_6() {
    List<DropdownMenuItem<CityStates>> ct6 = List();
    for (CityStates ctlist in _pahang) {ct6.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct6;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_7() {
    List<DropdownMenuItem<CityStates>> ct7 = List();
    for (CityStates ctlist in _perak) {ct7.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct7;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_8() {
    List<DropdownMenuItem<CityStates>> ct8 = List();
    for (CityStates ctlist in _selangor) {ct8.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct8;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_9() {
    List<DropdownMenuItem<CityStates>> ct9 = List();
    for (CityStates ctlist in _kl) {ct9.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct9;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_10() {
    List<DropdownMenuItem<CityStates>> ct10 = List();
    for (CityStates ctlist in _putrajaya) {ct10.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct10;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_11() {
    List<DropdownMenuItem<CityStates>> ct11 = List();
    for (CityStates ctlist in _n9) {ct11.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct11;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_12() {
    List<DropdownMenuItem<CityStates>> ct12 = List();
    for (CityStates ctlist in _melaka) {ct12.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct12;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_13() {
    List<DropdownMenuItem<CityStates>> ct13 = List();
    for (CityStates ctlist in _johor) {ct13.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct13;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_14() {
    List<DropdownMenuItem<CityStates>> ct14 = List();
    for (CityStates ctlist in _labuan) {ct14.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct14;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_15() {
    List<DropdownMenuItem<CityStates>> ct15 = List();
    for (CityStates ctlist in _sabah) {ct15.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct15;
  }

  List<DropdownMenuItem<CityStates>> getDropDownCity_16() {
    List<DropdownMenuItem<CityStates>> ct16 = List();
    for (CityStates ctlist in _sarawak) {ct16.add(DropdownMenuItem(value: ctlist, child: Text(ctlist.ctname)));}
    return ct16;
  }

  @override
  void dispose() {
    super.dispose();
    //email_controller.dispose();
    //password_controller.dispose();
  }

}


class StateMsia {
  int id;
  String name;

  StateMsia(this.id, this.name);

  static List<StateMsia> getStates() {
    return <StateMsia>[
      StateMsia(13, 'Johor'),
      StateMsia(2, 'Kedah'),
      StateMsia(4, 'Kelantan'),
      StateMsia(12, 'Melaka'),
      StateMsia(11, 'Negeri Sembilan'),
      StateMsia(6, 'Pahang'),
      StateMsia(7, 'Perak'),
      StateMsia(1, 'Perlis'),
      StateMsia(3, 'Pulau Pinang'),
      StateMsia(15, 'Sabah'),
      StateMsia(16, 'Sarawak'),
      StateMsia(8, 'Selangor'),
      StateMsia(5, 'Terengganu'),
      StateMsia(9, 'WP kuala Lumpur'),
      StateMsia(14, 'WP Labuan'),
      StateMsia(10, 'WP Putrajaya'),
    ];
  }
}

List<CityStates> _perlis = [
  CityStates(1,"Arau"),
  CityStates(2,"Kaki Bukit"),
  CityStates(3,"Kangar"),
  CityStates(4,"Kuala Perlis"),
  CityStates(5,"Padang Besar"),
  CityStates(6,"Simpang Ampat"),
];

List<CityStates> _kedah = [
  CityStates(7,"Alor Setar"),
  CityStates(8,"Ayer Hitam"),
  CityStates(9,"Baling"),
  CityStates(10,"Bandar Baharu"),
  CityStates(11,"Bedong"),
  CityStates(12,"Bukit Kayu Hitam"),
  CityStates(13,"Changloon"),
  CityStates(14,"Gurun"),
  CityStates(15,"Jeniang"),
  CityStates(16,"Jitra"),
  CityStates(17,"Karangan"),
  CityStates(18,"Kepala Batas"),
  CityStates(19,"Kodiang"),
  CityStates(20,"Kota Kuala Muda"),
  CityStates(21,"Kota Sarang Semut"),
  CityStates(22,"Kuala Kedah"),
  CityStates(23,"Kuala Ketil"),
  CityStates(24,"Kuala Nerang"),
  CityStates(25,"Kuala Pegang"),
  CityStates(27,"Kupang"),
  CityStates(28,"Langgar"),
  CityStates(29,"Langkawi"),
  CityStates(30,"Lunas"),
  CityStates(31,"Merbok"),
  CityStates(32,"Padang Serai"),
  CityStates(33,"Pendang"),
  CityStates(34,"Pokok Sena"),
  CityStates(35,"Serdang"),
  CityStates(36,"Sik"),
  CityStates(37,"Simpang Empat"),
  CityStates(38,"Sungai Petani"),
  CityStates(39,"Universiti Utara Malaysia"),
  CityStates(40,"Yan"),
];

List<CityStates> _penang = [
  CityStates(41,"Ayer Itam"),
  CityStates(42,"Balik Pulau"),
  CityStates(43,"Batu Feringghi"),
  CityStates(44,"Batu Maung"),
  CityStates(45,"Bayan Lepas"),
  CityStates(46,"Bukit Mertajam"),
  CityStates(47,"Butterworth"),
  CityStates(48,"Gelugor"),
  CityStates(49,"Georgetown"),
  CityStates(50,"Jelutong"),
  CityStates(51,"Kepala Batas"),
  CityStates(52,"Kubang Semang"),
  CityStates(53,"Nibong Tebal"),
  CityStates(54,"Penaga"),
  CityStates(55,"Penang Hill"),
  CityStates(56,"Perai"),
  CityStates(57,"Permatang pauh"),
  CityStates(58,"Simpang Ampat"),
  CityStates(59,"Sungai Jawi"),
  CityStates(60,"Tanjong Bungah"),
  CityStates(61,"Tasek Gelugor"),
  CityStates(62,"Universiti Sains Malaysia"),
];

List<CityStates> _kelantan = [
  CityStates(63,"Ayer Lanas"),
  CityStates(64,"Bachok"),
  CityStates(65,"Cherang Ruku"),
  CityStates(66,"Dabong"),
  CityStates(67,"Gua Musang"),
  CityStates(68,"Jeli"),
  CityStates(69,"Kem Desa Pahlawan"),
  CityStates(70,"Ketereh"),
  CityStates(71,"Kota Bharu"),
  CityStates(72,"Kuala Balah"),
  CityStates(73,"Kuala Krai"),
  CityStates(74,"Machang"),
  CityStates(75,"Melor"),
  CityStates(76,"Pasir Mas"),
  CityStates(77,"Pasir Puteh"),
  CityStates(78,"Pulai Chondong"),
  CityStates(79,"Rantau Panjang"),
  CityStates(80,"Selising"),
  CityStates(81,"Tanah Merah"),
  CityStates(82,"Temangan"),
  CityStates(83,"Tumpat"),
  CityStates(84,"Wakaf Bharu"),
];

List<CityStates> _terenganu = [
  CityStates(85,"Ajil"),
  CityStates(86,"Al Muktatfi Billah Shah"),
  CityStates(87,"Ayer Puteh"),
  CityStates(88,"Bukit Besi"),
  CityStates(89,"Bukit Payong"),
  CityStates(90,"Ceneh"),
  CityStates(91,"Chalok"),
  CityStates(92,"Cukai"),
  CityStates(93,"Dungun"),
  CityStates(94,"Jerteh"),
  CityStates(95,"Kampung Raja"),
  CityStates(96,"Kemasek"),
  CityStates(97,"Kerteh"),
  CityStates(98,"Ketengah Jaya"),
  CityStates(99,"Kijal"),
  CityStates(100,"Kuala Berang"),
  CityStates(101,"Kuala Besut"),
  CityStates(102,"Kuala Terengganu"),
  CityStates(103,"Marang"),
  CityStates(104,"Paka"),
  CityStates(105,"Permaisuri"),
  CityStates(106,"Sungai Tong"),
];

List<CityStates> _pahang = [
  CityStates(118,"Chini"),
  CityStates(107,"Balok"),
  CityStates(108,"Bandar Bera"),
  CityStates(109,"Bandar Pusat Jengka"),
  CityStates(110,"Bandar Tun Abdul Razak"),
  CityStates(111,"Benta"),
  CityStates(112,"Bentong"),
  CityStates(113,"Brinchang"),
  CityStates(114,"Bukit Fraser"),
  CityStates(115,"Bukit Goh"),
  CityStates(116,"Cameron Highland"),
  CityStates(117,"Chenor"),
  CityStates(119,"Damak"),
  CityStates(120,"Dong"),
  CityStates(121,"Gambang"),
  CityStates(122,"Genting Highland"),
  CityStates(123,"Jerantut"),
  CityStates(124,"Karak"),
  CityStates(125,"Kemayan"),
  CityStates(126,"Kuala Krau"),
  CityStates(127,"Kuala Lipis"),
  CityStates(128,"Kuala Rompin"),
  CityStates(129,"Kuantan"),
  CityStates(130,"Lanchang"),
  CityStates(132,"Maran"),
  CityStates(133,"Mentakab"),
  CityStates(134,"Muadzam Shah"),
  CityStates(135,"Padang Tengku"),
  CityStates(136,"Pekan"),
  CityStates(137,"Raub"),
  CityStates(138,"Ringlet"),
  CityStates(139,"Sega"),
  CityStates(140,"Sungai Koyan"),
  CityStates(141,"Sungai Lembing"),
  CityStates(142,"Temerloh"),
  CityStates(143,"Triang"),
];

List<CityStates> _perak = [
  CityStates(144,"Ayer Tawar"),
  CityStates(145,"Bagan Datoh"),
  CityStates(146,"Bagan Serai"),
  CityStates(147,"Bandar Seri Iskandar"),
  CityStates(148,"Batu Gajah"),
  CityStates(149,"Batu Kurau"),
  CityStates(150,"Behrang Stesen"),
  CityStates(151,"Bidor"),
  CityStates(152,"Bota"),
  CityStates(153,"Bruas"),
  CityStates(154,"Changkat Jering"),
  CityStates(155,"Changkat Keruing"),
  CityStates(156,"Chemor"),
  CityStates(157,"Chenderiang"),
  CityStates(158,"Chenderong Balai"),
  CityStates(159,"Chikus"),
  CityStates(160,"Enggor"),
  CityStates(161,"Gerik"),
  CityStates(162,"Gopeng"),
  CityStates(163,"Hutan Melintang"),
  CityStates(164,"Intan"),
  CityStates(165,"Ipoh"),
  CityStates(166,"Jeram"),
  CityStates(167,"Kampar"),
  CityStates(168,"Kampung Gajah"),
  CityStates(169,"Kampung Kepayang"),
  CityStates(170,"Kamunting"),
  CityStates(171,"Kinta"),
  CityStates(172,"Kuala Kangsar"),
  CityStates(173,"Kuala Kurau"),
  CityStates(174,"Kuala Sepetang"),
  CityStates(176,"Langkap"),
  CityStates(177,"Lenggong"),
  CityStates(178,"Lumut"),
  CityStates(179,"Malim Nawar"),
  CityStates(180,"Manong"),
  CityStates(181,"Matang"),
  CityStates(182,"Padang Rengas"),
  CityStates(183,"Pangkor"),
  CityStates(184,"Pantai Remis"),
  CityStates(185,"Parit"),
  CityStates(186,"Parit Buntar"),
  CityStates(187,"Pengkalan Hulu"),
  CityStates(188,"Pusing"),
  CityStates(189,"Rantau Panjang"),
  CityStates(190,"Sauk"),
  CityStates(191,"Selama"),
  CityStates(192,"Selekoh"),
  CityStates(193,"Seri Manjung"),
  CityStates(194,"Simpang"),
  CityStates(195,"Simpang Ampat Semanggol"),
  CityStates(196,"Sitiawan"),
  CityStates(197,"Slim River"),
  CityStates(198,"Sungai Siput"),
  CityStates(199,"Sungai Sumun"),
  CityStates(200,"Sungkai"),
  CityStates(202,"Taiping"),
  CityStates(203,"Tanjong Malim"),
  CityStates(204,"Tanjong Piandang"),
  CityStates(205,"Tanjong Rambutan"),
  CityStates(206,"Tanjong Tualang"),
  CityStates(207,"Tapah"),
  CityStates(208,"Tapah Road"),
  CityStates(209,"Teluk Intan"),
  CityStates(210,"Temoh"),
  CityStates(201,"TLDM Lumut"),
  CityStates(211,"Trolak"),
  CityStates(212,"Trong"),
  CityStates(213,"Tronoh"),
  CityStates(214,"Ulu Bernam"),
  CityStates(215,"Ulu Kinta"),
];

List<CityStates> _selangor = [
  CityStates(216,"Ampang"),
  CityStates(217,"Bandar Baru Bangi"),
  CityStates(218,"Bandar Puncak Alam"),
  CityStates(219,"Banting"),
  CityStates(220,"Batang Berjuntai"),
  CityStates(221,"Batang Kali"),
  CityStates(222,"Batu Arang"),
  CityStates(223,"Batu Cave"),
  CityStates(224,"Beranang"),
  CityStates(225,"Bukit Rotan"),
  CityStates(226,"Cheras"),
  CityStates(227,"Cyberjaya"),
  CityStates(228,"Dengkil"),
  CityStates(229,"Hulu Langat"),
  CityStates(230,"Jenjarom"),
  CityStates(231,"Jeram"),
  CityStates(233,"Kajang"),
  CityStates(234,"Kapar"),
  CityStates(235,"Kerling"),
  CityStates(236,"Klang"),
  CityStates(232,"KLIA"),
  CityStates(237,"Kuala Kubu Baru"),
  CityStates(238,"Kuala Selangor"),
  CityStates(239,"Pelabuhan Klang"),
  CityStates(240,"Petaling Jaya"),
  CityStates(241,"Puchong"),
  CityStates(242,"Pulau Carey"),
  CityStates(243,"Pulau Indah"),
  CityStates(244,"Pulau Ketam"),
  CityStates(245,"Rasa"),
  CityStates(246,"Rawang"),
  CityStates(247,"Sabak Bernam"),
  CityStates(248,"Sekinchan"),
  CityStates(249,"Semenyih"),
  CityStates(250,"Sepang"),
  CityStates(251,"Serdang"),
  CityStates(252,"Serendah"),
  CityStates(253,"Seri Kembangan"),
  CityStates(254,"Shah Alam"),
  CityStates(255,"Subang Jaya"),
  CityStates(256,"Sungai Ayer Tawar"),
  CityStates(257,"Sungai Besar"),
  CityStates(258,"Sungai Buloh"),
  CityStates(259,"Sungai Pelek"),
  CityStates(260,"Tanjong Karang"),
  CityStates(261,"Tanjong Sepat"),
  CityStates(262,"Teluk Panglima Garang"),
];

List<CityStates> _kl = [
  CityStates(263,"Kuala Lumpur"),
  CityStates(264,"Sungai Besi"),
];

List<CityStates> _putrajaya = [
  CityStates(265,"Putrajaya"),
];

List<CityStates> _n9 = [
  CityStates(266,"Bahau"),
  CityStates(267,"Bandar Enstek"),
  CityStates(268,"Bandar Seri jempol"),
  CityStates(269,"Batu Kikir"),
  CityStates(270,"Gemas"),
  CityStates(271,"Gemencheh"),
  CityStates(272,"Johol"),
  CityStates(273,"Kota"),
  CityStates(274,"Kuala Klawang"),
  CityStates(275,"Kuala Pilah"),
  CityStates(276,"Labu"),
  CityStates(277,"Linggi"),
  CityStates(278,"Mantin"),
  CityStates(279,"Nilai"),
  CityStates(280,"Port Dickson"),
  CityStates(281,"Pusat Bandar Palong"),
  CityStates(282,"Rantau"),
  CityStates(283,"Rembau"),
  CityStates(284,"Rompin"),
  CityStates(285,"Seremban"),
  CityStates(286,"Si Rusa"),
  CityStates(287,"Simpang Durian"),
  CityStates(288,"Simpang Pertang"),
  CityStates(289,"Tamoin"),
  CityStates(290,"Tanjong Ipoh"),
];

List<CityStates> _melaka = [
  CityStates(291,"Alor Gajah"),
  CityStates(292,"Asahan"),
  CityStates(293,"Ayer Keroh"),
  CityStates(294,"Bemban"),
  CityStates(295,"Durian Tunggal"),
  CityStates(296,"Jasih"),
  CityStates(297,"Kem Trendak"),
  CityStates(298,"Kuala Sungai Baru"),
  CityStates(299,"Lubok Cina"),
  CityStates(300,"Masjid Tanah"),
  CityStates(301,"Melaka"),
  CityStates(302,"Merlimau"),
  CityStates(303,"Selandar"),
  CityStates(304,"Sungai Rambai"),
  CityStates(305,"Sungai Udang",),
  CityStates(306,"Tanjong Kling"),
];

List<CityStates> _johor = [
  CityStates(307,"Ayer Baloi"),
  CityStates(308,"Ayer Hitam"),
  CityStates(309,"Ayer Tawar 2"),
  CityStates(310,"Ayer Tawar 3"),
  CityStates(311,"Ayer Tawar 4"),
  CityStates(312,"Ayer Tawar 5"),
  CityStates(313,"Bandar Penawar"),
  CityStates(314,"Bandar Tenggara"),
  CityStates(315,"Batu Anam"),
  CityStates(316,"Batu Pahat"),
  CityStates(317,"Bekok"),
  CityStates(318,"Benut"),
  CityStates(319,"Bukit Gambir"),
  CityStates(320,"Bukit Pasir"),
  CityStates(321,"Chaah"),
  CityStates(322,"Endau"),
  CityStates(323,"Gelang Patah"),
  CityStates(324,"Grisek"),
  CityStates(325,"Gugusan Taib Andak"),
  CityStates(326,"Jementah"),
  CityStates(327,"Johor Bahru"),
  CityStates(328,"Kahang"),
  CityStates(329,"Kluang"),
  CityStates(330,"Kota Tinggi"),
  CityStates(331,"Kukup"),
  CityStates(332,"Kulai"),
  CityStates(333,"Labis"),
  CityStates(334,"Layang-layang"),
  CityStates(335,"Masai"),
  CityStates(336,"Mersing"),
  CityStates(337,"Muar"),
  CityStates(338,"Nusajaya"),
  CityStates(339,"Pagoh"),
  CityStates(340,"Paloh"),
  CityStates(341,"Panchor"),
  CityStates(342,"Parit jawa"),
  CityStates(343,"Parit Raja"),
  CityStates(344,"Parit Sulong"),
  CityStates(345,"Pasir Gudang"),
  CityStates(346,"Pekan Nenas"),
  CityStates(347,"Pengerang"),
  CityStates(348,"Pontian"),
  CityStates(349,"Rengam"),
  CityStates(350,"Rengit"),
  CityStates(351,"Segamat"),
  CityStates(352,"Semerah"),
  CityStates(353,"Senai"),
  CityStates(354,"Senggarang"),
  CityStates(355,"Seri Gading"),
  CityStates(356,"Seri Medan"),
  CityStates(357,"Simpang Renggam"),
  CityStates(358,"Skudai"),
  CityStates(359,"Sungai Mati"),
  CityStates(360,"Tangkak"),
  CityStates(361,"Ulu Tiram"),
  CityStates(362,"Yong Peng"),
];

List<CityStates> _labuan = [
  CityStates(363,"Labuan"),
];

List<CityStates> _sabah = [
  CityStates(364,"Beaufort"),
  CityStates(365,"Beluran"),
  CityStates(366,"Beverly"),
  CityStates(367,"Bongawan"),
  CityStates(368,"Inanam"),
  CityStates(369,"Keningau"),
  CityStates(370,"Kota Belud"),
  CityStates(371,"Kota Kinabalu"),
  CityStates(372,"Kota Kinabatangan"),
  CityStates(373,"Kota Marudu"),
  CityStates(374,"Kuala Penyu"),
  CityStates(375,"Kudat"),
  CityStates(376,"Kunak"),
  CityStates(377,"Lahad Datu"),
  CityStates(378,"Likas"),
  CityStates(379,"Membakut"),
  CityStates(380,"Menumbok"),
  CityStates(381,"Nabawan"),
  CityStates(382,"Pamol"),
  CityStates(384,"Penampang"),
  CityStates(385,"Putatan"),
  CityStates(386,"Ranau"),
  CityStates(387,"Sandakan"),
  CityStates(388,"Semporna"),
  CityStates(389,"Sipitang"),
  CityStates(390,"Tambunan"),
  CityStates(391,"Tamparuli"),
  CityStates(392,"Tanjung Aru"),
  CityStates(393,"Tawau"),
  CityStates(394,"Telupid"),
  CityStates(395,"Tenghilan"),
  CityStates(396,"Tenom"),
  CityStates(397,"Tuaran"),
];

List<CityStates> _sarawak = [
  CityStates(398,"Asajaya"),
  CityStates(399,"Balingian"),
  CityStates(400,"Baram"),
  CityStates(401,"Bau"),
  CityStates(402,"Bekenu"),
  CityStates(403,"Belaga"),
  CityStates(404,"Belawai"),
  CityStates(405,"Betong"),
  CityStates(406,"Bintagor"),
  CityStates(407,"Bintulu"),
  CityStates(408,"Dalat"),
  CityStates(409,"Daro"),
  CityStates(410,"Debak"),
  CityStates(411,"Engkilii"),
  CityStates(412,"Julau"),
  CityStates(413,"Kabong"),
  CityStates(414,"Kanowit"),
  CityStates(415,"Kapit"),
  CityStates(416,"Kota Samarahan"),
  CityStates(417,"Kuching"),
  CityStates(418,"Lawas"),
  CityStates(419,"Limbang"),
  CityStates(420,"Lingga"),
  CityStates(421,"Long Lama"),
  CityStates(422,"Lubok Antu"),
  CityStates(423,"Lundu"),
  CityStates(424,"Lutong"),
  CityStates(425,"Matu"),
  CityStates(426,"Miri"),
  CityStates(427,"Mukah"),
  CityStates(428,"anga Medamit"),
  CityStates(429,"Niah"),
  CityStates(430,"Pusa"),
  CityStates(431,"Roban"),
  CityStates(432,"Saratok"),
  CityStates(433,"Sarikei"),
  CityStates(434,"Sebauh"),
  CityStates(435,"Sebuyau"),
  CityStates(436,"Serian"),
  CityStates(437,"Sibu"),
  CityStates(438,"Siburan"),
  CityStates(439,"Simunjan"),
  CityStates(440,"Song"),
  CityStates(441,"Spaoh"),
  CityStates(442,"Sri Aman"),
  CityStates(443,"Sundar"),
  CityStates(444,"Tatau"),
];
