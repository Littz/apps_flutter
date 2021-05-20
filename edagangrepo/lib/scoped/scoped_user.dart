import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

mixin UserScopedModel on Model {
  bool _isAuthenticated = false;
  MainScopedModel model;

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  loggedInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String xsToken = prefs.getString('token');
    if (xsToken != null) {
      print("XS TOKEN >>>> "+xsToken);
      _isAuthenticated = true;
      notifyListeners();
    } else {
      print("GUEST TOKEN >>>> "+Constants.tokenGuest);
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  bool _isLoading = true;
  //String fName = "Cartsini guest";
  int _id;
  String _name, _email, _phone, _gender, _dob;

  bool get isLoading => _isLoading;

  int getId() {return _id;}
  String getFname() {return _name;}
  String getEmail() {return _email;}
  String getPhone() {return _phone;}
  String getGender() {return _gender;}
  String getDob() {return _dob;}

  Future<dynamic> _getProfileJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
      Constants.shopAPI+'/account/profile',
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    ).catchError((error) {
      print(error.toString());
      return false;
    },
    );
    return json.decode(response.body);
  }

  Future fetchProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();

    var dataFromResponse = prefs.getString('token') != null ? await _getProfileJson() : null;

    _id = dataFromResponse['data']['user']['id'];
    _name = dataFromResponse['data']['user']['fullname'];
    _email = dataFromResponse['data']['user']['email'];
    _phone = dataFromResponse['data']['user']['mobile_no'];
    _gender = dataFromResponse['data']['user']['gender'];
    _dob = dataFromResponse['data']['user']['dob'];

    _isLoading = false;
    notifyListeners();
  }

}
