import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/address_model.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';


mixin BizAppScopedModel on Model {

List<BizList> visitedlist = [];
List<Company> companylist = [];

List<BizList> get _visitedlist => visitedlist;
List<Company> get _companylist => companylist;


void addToVisitedList(BizList lsvisited) {
  _visitedlist.add(lsvisited);
}

void addToCompanyList(Company lscompany) {
  _companylist.add(lscompany);
}

bool _isLoadingCo = false;
bool get isLoadingCo => _isLoadingCo;


Future<dynamic> _getVisitlist() async {
  var response = await http.get(
    Uri.parse(Constants.bizAPI+'/biz/v2/latest'),
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('BIZ LATEST ==============================================');
  print(Constants.bizAPI+'/biz/v2/latest');
  print(response.statusCode.toString());
  print(response.body);
  //return json.decode(response.body);
}

Future fetchVisitedList() async {

  visitedlist.clear();
  notifyListeners();
  var dataFromResponse = await _getVisitlist();

  dataFromResponse['data']['businesses'].forEach((bizList) {

    List<Product> _product = [];
    bizList['product'].forEach((produk) {
      _product.add(
          new Product(
            id: produk['id'],
            business_id: produk['business_id'],
            product_name: produk['product_name'],
            product_desc: produk['product_desc'],
          )
      );
    });

    List<Award> _award = [];
    bizList['award'].forEach((awad) {
      _award.add(
          new Award(
            id: awad['id'],
            business_id: awad['business_id'],
            award_desc: awad['award_desc'],
            filename: awad['filename'],
          )
      );
    });

    List<Cert> _cert = [];
    bizList['certificate'].forEach((sijil) {
      _cert.add(
          new Cert(
            id: sijil['id'],
            business_id: sijil['business_id'],
            cert_name: sijil['cert_name'],
            filename: sijil['filename'],
          )
      );
    });

    BizList companies = new BizList(
      id: bizList['id'],
      company_name: bizList['company_name'],
      overview: bizList['overview'],
      address: bizList['address'], // after migration -> int to string
      office_phone: bizList['office_phone'],
      office_fax: bizList['office_fax'], // after migration -> int to string
      email: bizList['email'],
      website: bizList['website'],
      logo: bizList['logo'],
      verify: bizList['verified'],
      product: _product ?? [],
      award: _award ?? [],
      cert: _cert ?? [],
    );
    addToVisitedList(companies);
  },
  );

  notifyListeners();
}

String faqUrl;
String getFaq() {return faqUrl;}
int totCompany;
int getTotalCompany() {return totCompany;}
int totCompanyPlus;
int getTotalCompanyPlus() {return totCompanyPlus;}

Future<dynamic> _getCompanylist() async {
  var response = await http.get(
    Uri.parse(Constants.bizAPI+'/biz/v2/companies'),
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('BIZ COMPANY LIST ==============================================');
  print(Constants.bizAPI+'/biz/v2/companies');
  print(response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}

Future fetchCompanyList() async {
  companylist.clear();
  notifyListeners();
  _isLoadingCo = true;
  var dataFromResponse = await _getCompanylist();

  dataFromResponse['data']['companies'].forEach((comList) {

    Company companies = new Company(
      id: comList['id'],
      company_name: comList['company_name'],
      category: comList['category']
    );
    addToCompanyList(companies);
  },
  );
  _isLoadingCo = false;
  notifyListeners();
}


List<Home_banner> bbanners = [];
List<Home_banner> get _banners => bbanners;
void addHomeBannerList(Home_banner baner) {_banners.add(baner);}

List<Home_category> bcategory = [];
List<Home_category> get _bcategory => bcategory;
void addHomeCategoryList(Home_category category) {_bcategory.add(category);}

List<Home_business> bbusiness = [];
List<Home_business> get _bbusiness => bbusiness;
void addHomeBusinessList(Home_business business) {_bbusiness.add(business);}

List<Home_virtual> bvirtual = [];
List<Home_virtual> get _bvirtual => bvirtual;
void addHomeVirtualList(Home_virtual vr) {_bvirtual.add(vr);}


Future<dynamic> _getHomeBizJson() async {
  var response = await http.get(
    Uri.parse('https://bizapp.e-dagang.asia/api/biz/v2/home'),
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('BIZ HOME #####################################');
  print('https://bizapp.e-dagang.asia/api/biz/v2/home');
  print(response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}

Future fetchHomeBizResponse() async {
  _banners.clear();
  _bcategory.clear();
  _bbusiness.clear();
  _bvirtual.clear();

  notifyListeners();
  var dataFromResponse = await _getHomeBizJson();

  faqUrl = dataFromResponse["data"]["faq"]["url"];
  totCompany = dataFromResponse["data"]["total"];
  totCompanyPlus = dataFromResponse["data"]["total"] - 10;

  dataFromResponse["data"]["banner"].forEach((dataBaner) {
    Home_banner _banner = new Home_banner(
      title: dataBaner['title'],
      imageUrl: dataBaner['image_url'],
      type: dataBaner['type'],
      itemId: dataBaner['item_id'],
      link_url: dataBaner['link_url'],
    );
    addHomeBannerList(_banner);
  });

  dataFromResponse["data"]["category"].forEach((dataCat) {
    Home_category _cat = new Home_category(
      cat_id: dataCat['id'],
      cat_image: dataCat['image'] ?? '',
      cat_name: dataCat['category_name'] ?? '',
    );
    addHomeCategoryList(_cat);
  });

  //print('HOME BIZ BUSINESSSS #####################################');
  //print(dataFromResponse["data"]["businesses"]);

  dataFromResponse["data"]["businesses"].forEach((dataBiz) {
    Home_business _cat = new Home_business(
      id: dataBiz['id'],
      company_name: dataBiz['company_name'],
      overview: dataBiz['overview'],
      address: dataBiz['address'],
      office_phone: dataBiz['office_phone'],
      office_fax: dataBiz['office_fax'],
      email: dataBiz['email'],
      website: dataBiz['website'],
      logo: dataBiz['logo'],
      verify: dataBiz['verified'],
    );
    addHomeBusinessList(_cat);
  });

  //print('HOME BIZ VIRTUALLL #####################################');
  //print(dataFromResponse["data"]["virtual"]);

  dataFromResponse["data"]["virtual"].forEach((dataVr) {

    List<VRList> vrList = [];
    dataVr["vr_list"].forEach((newVr) {
      vrList.add(
        new VRList(
            vr_type: newVr["vr_type"], // after migration -> int to string
            vr_name: newVr["vr_name"], // after migration -> int to string
            vr_url: newVr["vr_url"],
            vr_image: newVr["vr_image"], // after migration -> int to string
        ),
      );
    });

    Home_virtual _vr = new Home_virtual(
      vr_id: dataVr['id'],
      vr_desc: dataVr['desc'],
      vr_list: vrList,
    );
    addHomeVirtualList(_vr);
  });


  notifyListeners();
}


List<Home_virtual> bvirtuals = [];
List<Home_virtual> get _bvirtuals => bvirtuals;
void addVirtualPageList(Home_virtual vrp) {_bvirtuals.add(vrp);}

Future<dynamic> _getVrBizJson() async {
  var response = await http.get(
    Uri.parse('https://bizapp.e-dagang.asia/api/biz/v2/vr'),
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('BIZ VIRTUAL REALITY #####################################');
  print('https://bizapp.e-dagang.asia/api/biz/v2/vr');
  print(response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}

Future fetchVrBizResponse() async {
  _bvirtuals.clear();

  notifyListeners();
  var dataFromResponse = await _getVrBizJson();

  //print('VR BIZ VIRTUALLL #####################################');
  //print(dataFromResponse["data"]["virtual"]);

  dataFromResponse["data"]["virtual"].forEach((dataVr) {

    List<VRList> vrList = [];
    dataVr["vr_list"].forEach((newVr) {
      vrList.add(
        new VRList(
          vr_type: newVr["vr_type"], // after migration -> int to string
          vr_name: newVr["vr_name"], // after migration -> int to string
          vr_url: newVr["vr_url"],
          vr_image: newVr["vr_image"], // after migration -> int to string
        ),
      );
    });

    Home_virtual _vr = new Home_virtual(
      vr_id: dataVr['id'],
      vr_desc: dataVr['desc'],
      vr_list: vrList,
    );
    addVirtualPageList(_vr);
  });
  notifyListeners();
}


List<StateX> stlookup = [];
List<StateX> get _stlookup => stlookup;
void addStateList(StateX ste) {_stlookup.add(ste);}

Future<dynamic> _getStateJson() async {
  var response = await http.get(
    Uri.parse('http://cartsini.my/api/lookup/state'),
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('API STATE LOOKUP #####################################');
  print('http://cartsini.my/api/lookup/state');
  print(response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}

Future fetchStateLokup() async {
  _stlookup.clear();

  notifyListeners();
  var dataFromResponse = await _getStateJson();

  dataFromResponse["data"].forEach((dataVr) {

    List<VRList> vrList = [];
    dataVr["vr_list"].forEach((newVr) {
      vrList.add(
        new VRList(
          vr_type: newVr["vr_type"], // after migration -> int to string
          vr_name: newVr["vr_name"], // after migration -> int to string
          vr_url: newVr["vr_url"],
          vr_image: newVr["vr_image"], // after migration -> int to string
        ),
      );
    });

    Home_virtual _vr = new Home_virtual(
      vr_id: dataVr['id'],
      vr_desc: dataVr['desc'],
      vr_list: vrList,
    );
    addVirtualPageList(_vr);
  });
  notifyListeners();
}

}

