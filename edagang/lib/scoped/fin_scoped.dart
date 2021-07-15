import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';


mixin FinAppScopedModel on Model {

List<Home_banner> fbanners = [];
List<Home_banner> get _fbanners => fbanners;
void addHomeFinBannerList(Home_banner fbaner) {_fbanners.add(fbaner);}

List<Home_category> fcategory = [];
List<Home_category> get _fcategory => fcategory;
void addHomeFinCategoryList(Home_category category) {_fcategory.add(category);}

List<Home_business> finsurans = [];
List<Home_business> get _finsurans => finsurans;
void addHomeInsuranList(Home_business insuran) {_finsurans.add(insuran);}

List<Home_business> finvests = [];
List<Home_business> get _finvests => finvests;
void addHomeInvestmentList(Home_business invest) {_finvests.add(invest);}

List<Home_business> finances = [];
List<Home_business> get _finances => finances;
void addHomeFinanceList(Home_business finance) {_finances.add(finance);}


Future<dynamic> _getHomeFinJson() async {
  var response = await http.get(
    Uri.parse('https://finapp.e-dagang.asia/api/fintools/v2/home'),
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('FINTOOLS HOME #####################################');
  print('https://finapp.e-dagang.asia/api/fintools/v2/home');
  print(response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}

Future fetchHomeFinResponse() async {
  _fbanners.clear();
  _fcategory.clear();
  _finsurans.clear();
  _finvests.clear();
  _finances.clear();

  notifyListeners();
  var dataFromResponse = await _getHomeFinJson();

  dataFromResponse["data"]["banner"].forEach((fBaner) {
    Home_banner _fbaner = new Home_banner(
      title: fBaner['title'],
      imageUrl: fBaner['image_url'],
      type: fBaner['type'],
      itemId: fBaner['item_id'],
      link_url: fBaner['link_url'],
    );
    addHomeFinBannerList(_fbaner);
  });

  //print('HOME FIN CATEGORYYY #####################################');
  //print(dataFromResponse["data"]["category"]);

  dataFromResponse["data"]["category"].forEach((dataCat) {
    Home_category _cat = new Home_category(
      cat_id: dataCat['id'],
      cat_name: dataCat['desc'] ?? '',
    );
    addHomeFinCategoryList(_cat);
  });

  //print('HOME FIN INSURANCE #####################################');
  //print(dataFromResponse["data"]["insurans"]);

  dataFromResponse["data"]["insurans"].forEach((dataIns) {

    Home_business _insuran = new Home_business(
      id: dataIns['id'],
      ref_type: dataIns['ref_type'],
      company_name: dataIns['company_name'],
      overview: dataIns['overview'],
      address: dataIns['address'],
      office_phone: dataIns['office_phone'],
      office_fax: dataIns['office_fax'],
      email: dataIns['email'],
      website: dataIns['website'],
      logo: dataIns['logo'],
      company_licno: dataIns['company_licno']
    );
    addHomeInsuranList(_insuran);
  });

  //print('HOME FIN INVESTMENT #####################################');
  //print(dataFromResponse["data"]["investment"]);

  dataFromResponse["data"]["investment"].forEach((dataInv) {

    Home_business _invest = new Home_business(
        id: dataInv['id'],
        ref_type: dataInv['ref_type'],
        company_name: dataInv['company_name'],
        overview: dataInv['overview'],
        address: dataInv['address'],
        office_phone: dataInv['office_phone'],
        office_fax: dataInv['office_fax'],
        email: dataInv['email'],
        website: dataInv['website'],
        logo: dataInv['logo'],
        company_licno: dataInv['company_licno']
    );
    addHomeInvestmentList(_invest);
  });

  //print('HOME FIN FINANCIAL #####################################');
  //print(dataFromResponse["data"]["financial"]);

  dataFromResponse["data"]["financial"].forEach((dataFin) {

    Home_business _finance = new Home_business(
        id: dataFin['id'],
        ref_type: dataFin['ref_type'],
        company_name: dataFin['company_name'],
        overview: dataFin['overview'],
        address: dataFin['address'],
        office_phone: dataFin['office_phone'],
        office_fax: dataFin['office_fax'],
        email: dataFin['email'],
        website: dataFin['website'],
        logo: dataFin['logo'],
        company_licno: dataFin['company_licno']
    );
    addHomeFinanceList(_finance);
  });

  notifyListeners();
}

}

