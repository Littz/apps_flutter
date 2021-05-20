import 'package:edagang/models/ads_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:edagang/utils/constant.dart';
import 'package:http/http.dart' as http;

class BlurbScopedModel extends Model {
  List<PropertyCat> blurbProp = [];
  List<PropertyCat> get _blurbProp => blurbProp;
  void addToBlurbProperty(PropertyCat prop) {
    _blurbProp.add(prop);
  }

  bool _isLoadingBl = false;
  bool get isLoadingBl => _isLoadingBl;

  int cid,ctr;
  int getCount() {return ctr;}
  String company, logo;
  int getCompanyId() {return cid;}
  String getCompanyName() {return company;}
  String getLogo() {return logo;}

  Future<dynamic> _getPropertyCompany(bizId) async {
    Map<String, dynamic> postData = {
      'business_id': bizId,
    };

    var response = await http.post(
      'https://blurbapp.e-dagang.asia/api/blurb/property/company',
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError((error) {
      print(error.toString());
      return false;
    },
    );
    return json.decode(response.body);

  }

  Future fetchCourseList (int bizId) async {
    blurbProp.clear();

    _isLoadingBl = true;
    notifyListeners();

    var dataFromResponse = await _getPropertyCompany(bizId);
    print('BLURB PROPERTY list ==============================================');
    print(dataFromResponse);

    //ctr = dataFromResponse["data"]["course_count"];
    cid = dataFromResponse['data']['company'][0]['id'];
    company = dataFromResponse['data']['company'][0]['company_name'];
    logo = 'https://blurbapp.e-dagang.asia'+dataFromResponse['data']['company'][0]['logo'];

    print(ctr.toString());
    print(company);

    dataFromResponse["data"]["company"][0]["property"].forEach((dataProp) {

      List<Images> imagesPropertyList = [];
      dataProp['images'].forEach((propImage) {
        imagesPropertyList.add(
          new Images(
            id: propImage["id"],
            property_id: propImage["property_id"],
            file_path: 'https://blurbapp.e-dagang.asia'+propImage["file_path"],
          ),
        );
      });

      PropertyCat _props = new PropertyCat(
        id: dataProp['id'],
        company_id: dataProp['company_id'],
        title: dataProp['title'],
        location: dataProp['location'],
        prop_id: dataProp['prop_type']['id'],
        prop_name: dataProp['prop_type']['name'],
        prop_type: dataProp['prop_type']['type'],
        built_up_size: dataProp['built_up_size'],
        price: dataProp['price'],
        bedrooms: dataProp['bedrooms'],
        bathrooms: dataProp['bathrooms'],
        developer: dataProp['developer'],
        overview: dataProp['overview'],
        //company_name: dataProp['company']['company_name'],
        //logo: dataProp['company']['logo'],
        images: imagesPropertyList,
      );
      addToBlurbProperty(_props);
    });

    _isLoadingBl = false;
    notifyListeners();

  }

}