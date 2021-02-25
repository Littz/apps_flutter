import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';


mixin BizAppScopedModel on Model {

List<BizCat> bizcat = [];
List<BizCat> bizcat2 = [];
List<BizCat> bizcat3 = [];
List<BizList> visitedlist = [];
List<Company> companylist = [];

List<BizCat> get _bizcat => bizcat;
List<BizCat> get _bizcat2 => bizcat2;
List<BizCat> get _bizcat3 => bizcat3;
List<BizList> get _visitedlist => visitedlist;
List<Company> get _companylist => companylist;

void addToBizCategory(BizCat cat) {
  _bizcat.add(cat);
}

void addToBizCategory2(BizCat cat2) {
  _bizcat2.add(cat2);
}

void addToBizCategory3(BizCat cat3) {
  _bizcat3.add(cat3);
}


void addToVisitedList(BizList lsvisited) {
  _visitedlist.add(lsvisited);
}

void addToCompanyList(Company lscompany) {
  _companylist.add(lscompany);
}


bool _isLoadingCo = false;
bool get isLoadingCo => _isLoadingCo;

Future<dynamic> _getBizcat() async {
  var response = await http.get(
    Constants.bizAPI+'/biz/category',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  return json.decode(response.body);
}

Future fetchBizCat() async {
  bizcat.clear();
  notifyListeners();

  var dataFromResponse = await _getBizcat();
  print('BIZ Category==============================================');
  print(dataFromResponse);

  dataFromResponse["data"]["category"].forEach((dataCat) {
    BizCat _cat = new BizCat(
      id: dataCat['id'],
      name: dataCat['category_name'],
      descr: dataCat['category_desc'],
    );
    addToBizCategory(_cat);
  });

  notifyListeners();
}

Future<dynamic> _getBizprod() async {
  var response = await http.get(
    Constants.bizAPI+'/biz/category_product',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  return json.decode(response.body);
}

Future fetchBizProd() async {
  bizcat2.clear();
  notifyListeners();

  var dataFromResponse = await _getBizprod();
  print('BIZ Category==============================================');
  print(dataFromResponse);

  dataFromResponse["data"]["category"].forEach((dataCat) {
    BizCat _cat = new BizCat(
      id: dataCat['id'],
      name: dataCat['category_name'],
      descr: dataCat['category_desc'],
    );
    addToBizCategory2(_cat);
  });

  notifyListeners();
}

Future<dynamic> _getBizsvc() async {
  var response = await http.get(
    Constants.bizAPI+'/biz/category_services',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  return json.decode(response.body);
}

Future fetchBizSvc() async {
  bizcat3.clear();
  notifyListeners();

  var dataFromResponse = await _getBizsvc();
  print('BIZ Category==============================================');
  print(dataFromResponse);

  dataFromResponse["data"]["category"].forEach((dataCat) {
    BizCat _cat = new BizCat(
      id: dataCat['id'],
      name: dataCat['category_name'],
      descr: dataCat['category_desc'],
    );
    addToBizCategory3(_cat);
  });

  notifyListeners();
}


Future<dynamic> _getVisitlist() async {
  var response = await http.get(
    Constants.bizAPI+'/biz/latest',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  return json.decode(response.body);
}

Future fetchVisitedList() async {

  visitedlist.clear();
  notifyListeners();
  var dataFromResponse = await _getVisitlist();
  print('BIZ COMPANY LIST==============================================');
  print(dataFromResponse);

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
      logo: 'https://bizapp.e-dagang.asia'+bizList['logo'],
      product: _product ?? [],
      award: _award ?? [],
      cert: _cert ?? [],
    );
    addToVisitedList(companies);
  },
  );

  notifyListeners();
}


Future<dynamic> _getCompanylist() async {
  var response = await http.get(
    Constants.bizAPI+'/biz/companies',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  return json.decode(response.body);
}

Future fetchCompanyList() async {
  companylist.clear();
  notifyListeners();
  _isLoadingCo = true;
  var dataFromResponse = await _getCompanylist();
  print('BIZ COMPANY LIST==============================================');
  print(dataFromResponse);

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



List<Banner_biz> bbanners = [];

List<Banner_biz> get _banners => bbanners;
void addToBannerBizList(Banner_biz baner) {
  _banners.add(baner);
}

Future<dynamic> _getHomeBizJson() async {
  var response = await http.get(
    'http://bizapp.e-dagang.asia/api/biz/home',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  },
  );
  return json.decode(response.body);
}

Future fetchHomeBizResponse() async {
  _banners.clear();

  notifyListeners();
  var dataFromResponse = await _getHomeBizJson();


//DATA BANNER =========================================================================================
  print('BIZ BANNERRRRRR #####################################');
  print(dataFromResponse["data"]["banner"]);

  dataFromResponse["data"]["banner"].forEach((dataBaner) {
    Banner_biz _banner = new Banner_biz(
      title: dataBaner['title'],
      imageUrl: dataBaner['image_url'],
      type: dataBaner['type'],
      itemId: dataBaner['item_id'],
      //remark: dataBaner['remark'],
    );
    addToBannerBizList(_banner);
  });

//DATA CATEGORY =========================================================================================
  /*dataFromResponse["data"]["category"].forEach((dataCat) {
    Category _cat = new Category(
      catid: dataCat['id'],
      catimage: dataCat['image'],
      catname: dataCat['name'],
    );
    addToCategoryList(_cat);
  });*/

  //_isLoading2 = false;
  notifyListeners();
}

}

