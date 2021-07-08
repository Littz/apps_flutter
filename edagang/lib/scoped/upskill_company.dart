import 'package:edagang/models/upskill_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;

class Upskill2ScopedModel extends Model {
  List<SkillList> goilmuCourses = [];
  List<SkillList> get _goilmuCourses => goilmuCourses;
  void addToGoilmuCourse(SkillList course) {
    _goilmuCourses.add(course);
  }

  bool _isLoadingGo = false;
  bool get isLoadingGo => _isLoadingGo;

  int cid,ctr;
  int getCount() {return ctr;}
  String company, logo;
  int getCompanyId() {return cid;}
  String getCompanyName() {return company;}
  String getLogo() {return logo;}

  Future<dynamic> _getGoilmuCompany(bizId) async {
    Map<String, dynamic> postData = {
      'business_id': bizId,
    };

    var response = await http.post(
      'https://goilmuapp.e-dagang.asia/api/course/v2/business',
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError((error) {
      print(error.toString());
      return false;
    },
    );
    print('GOILMU COURSE list ==============================================');
    print('https://goilmuapp.e-dagang.asia/api/course/v2/business?business_id='+bizId.toString());
    return json.decode(response.body);

  }

  Future fetchCourseList (int bizId) async {
    goilmuCourses.clear();

    _isLoadingGo = true;
    notifyListeners();

    var dataFromResponse = await _getGoilmuCompany(bizId);


    ctr = dataFromResponse["data"]["course_count"];
    cid = dataFromResponse['data']['business']['id'];
    company = dataFromResponse['data']['business']['company_name'];
    logo = dataFromResponse['data']['business']['logo'];

    //print(ctr.toString());
    //print(company);

    dataFromResponse["data"]["courses"].forEach((dataComp) {
      SkillList _course = new SkillList(
        id: dataComp['id'],
        business_id: dataComp['business_id'], // after migration -> int to string
        title: dataComp['title'],
        descr: dataComp['desc'],
        //overview: dataComp['overview'],
        //attendees: dataComp['attendees'],
        //key_modules: dataComp['key_modules'],
        price: dataComp['price'],
      );
      addToGoilmuCourse(_course);
    });

    _isLoadingGo = false;
    notifyListeners();

  }

}