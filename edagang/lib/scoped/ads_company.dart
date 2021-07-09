import 'package:edagang/models/ads_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:edagang/helper/constant.dart';
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
  String company, address, ofis_phone, ofis_fax, emel, website, logo;
  int getCompanyId() {return cid;}
  String getCompanyName() {return company;}
  String getCompanyAddr() {return address;}
  String getCompanyTel() {return ofis_phone;}
  String getCompanyEmel() {return emel;}
  String getCompanyWeb() {return website;}
  String getLogo() {return logo;}

  Future<dynamic> _getPropertyCompany(bizId) async {
    Map<String, dynamic> postData = {
      'business_id': bizId,
    };

    var response = await http.post(Uri.parse('https://blurbapp.e-dagang.asia/api/blurb/property/v2/company'),
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError((error) {
      print(error.toString());
      return false;
    },
    );
    print('BLURB PROPERTY COMPANY DETAIL ==============================================');
    print('https://blurbapp.e-dagang.asia/api/blurb/property/v2/company?business_id='+bizId.toString());
    return json.decode(response.body);

  }

  Future fetchBlurbCompany (int bizId) async {
    blurbProp.clear();

    _isLoadingBl = true;
    notifyListeners();

    var dataFromResponse = await _getPropertyCompany(bizId);
    //print('BLURB PROPERTY ==============================================');
    //print(dataFromResponse);

    //ctr = dataFromResponse["data"]["course_count"];
    cid = dataFromResponse['data']['company'][0]['id'];
    company = dataFromResponse['data']['company'][0]['company_name'];
    address = dataFromResponse['data']['company'][0]['address'];
    ofis_phone = dataFromResponse['data']['company'][0]['office_phone'];
    ofis_fax = dataFromResponse['data']['company'][0]['office_fax'];
    emel = dataFromResponse['data']['company'][0]['email'];
    website = dataFromResponse['data']['company'][0]['website'];
    logo = dataFromResponse['data']['company'][0]['logo'];

    print(ctr.toString());
    print(company);

    dataFromResponse["data"]["company"][0]["property"].forEach((dataProp) {

      List<Images> imagesPropertyList = [];
      dataProp['images'].forEach((propImage) {
        imagesPropertyList.add(
          new Images(
            id: propImage["id"],
            property_id: propImage["property_id"],
            file_path: propImage["file_path"],
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