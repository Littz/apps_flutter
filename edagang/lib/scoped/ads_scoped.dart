import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';


mixin AdvertAppScopedModel on Model {

List<JobsCat> jobcat = [];
List<JobsCat> get _jobcat => jobcat;
void addToJobCategory(JobsCat cat) {
  _jobcat.add(cat);
}

bool _isLoading = true;
bool get isLoading => _isLoading;

Future<dynamic> _getJobcat() async {
  var response = await http.get(
    'https://blurbapp.e-dagang.asia/api/career/job/listing',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('JOB Category==============================================');
  print('https://blurbapp.e-dagang.asia/api/blurb/job/v2/listing');
  return json.decode(response.body);
}

Future fetchJobsCat() async {
  jobcat.clear();
  notifyListeners();

  var dataFromResponse = await _getJobcat();
  //print(dataFromResponse);

  dataFromResponse["data"]["jobs"].forEach((dataJob) {
    JobsCat _job = new JobsCat(
      id: dataJob['id'],
      title: dataJob['title'],
      company_name: dataJob['company']['company_name'],
      company_logo: dataJob['company']['logo'],
      state_name: dataJob['state']['state_name'],
    );
    addToJobCategory(_job);
  });

  notifyListeners();
}

List<Home_banner> blb_banners = [];
List<Home_banner> get _blbbanners => blb_banners;
void addHomeBlurbBannerList(Home_banner blb_baner) {_blbbanners.add(blb_baner);}

List<Home_category> blb_category = [];
List<Home_category> get _blbcategory => blb_category;
void addHomeBlurbCategoryList(Home_category category) {_blbcategory.add(category);}

List<JobsCat> blbcareer = [];
List<JobsCat> get _blbcareers => blbcareer;
void addHomeCareerList(JobsCat career) {_blbcareers.add(career);}

List<PropertyCat> blbproperty = [];
List<PropertyCat> get _blbpropertys => blbproperty;
void addHomePropertyList(PropertyCat property) {_blbpropertys.add(property);}

List<AutoCat> blbautomobile = [];
List<AutoCat> get _blbautomobiles => blbautomobile;
void addHomeAutomobileList(AutoCat auto) {_blbautomobiles.add(auto);}

List<JobsCat> blbother = [];
List<JobsCat> get _blbothers => blbother;
void addHomeOtherList(JobsCat other) {_blbothers.add(other);}

Future<dynamic> _getBlurbOtherJson() async {
  var response = await http.get(
    'https://blurbapp.e-dagang.asia/api/blurb/others/v2/listing',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('BLURB OTHERS LIST #####################################');
  print('https://blurbapp.e-dagang.asia/api/blurb/others/v2/listing');
  return json.decode(response.body);
}

Future fetchBlurbOtherResponse() async {
  _blbothers.clear();

  notifyListeners();
  var dataFromResponse = await _getBlurbOtherJson();
  //print(dataFromResponse["data"]["other"]);

  dataFromResponse["data"]["other"].forEach((dataJobs) {

    List<Images> imageOther = [];
    dataJobs["images"].forEach((otherData) {
      imageOther.add(
        new Images(
            id: otherData["id"], // after migration -> int to string
            property_id: otherData["product_id"], // after migration -> int to string
            file_path: otherData["file_path"]
        ),
      );
    },
    );

    JobsCat _other = new JobsCat(
      id: dataJobs['id'],
      company_id: dataJobs['business_id'],
      title: dataJobs['product_name'],
      descr: dataJobs['product_desc'],
      company_name: dataJobs['company']['company_name'],
      company_logo: dataJobs['company']['logo'],
      city_name: dataJobs['company']['city']['city_name'],
      state_name: dataJobs['company']['state']['state_name'],
      image: imageOther,
    );
    addHomeOtherList(_other);
  });

  notifyListeners();
}


Future<dynamic> _getHomeBlurbJson() async {
  var response = await http.get(
    'https://blurbapp.e-dagang.asia/api/blurb/v2/home',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('BLURB HOME #####################################');
  print('https://blurbapp.e-dagang.asia/api/blurb/v2/home');
  return json.decode(response.body);
}

Future fetchHomeBlurbResponse() async {
  _blbbanners.clear();
  _blbcategory.clear();
  _blbcareers.clear();
  _blbpropertys.clear();
  _blbautomobiles.clear();

  notifyListeners();
  var dataFromResponse = await _getHomeBlurbJson();
  //print(dataFromResponse["data"]["banner"]);

  dataFromResponse["data"]["banner"].forEach((fBaner) {
    Home_banner _fbaner = new Home_banner(
      title: fBaner['title'],
      imageUrl: fBaner['image_url'],
      type: fBaner['type'],
      itemId: fBaner['item_id'],
      link_url: fBaner['link_url'],
    );
    addHomeBlurbBannerList(_fbaner);
  });

  //print('BLURB CATEGORYYY #####################################');
  //print(dataFromResponse["data"]["category"]);

  dataFromResponse["data"]["category"].forEach((dataCat) {
    Home_category _cat = new Home_category(
      cat_id: dataCat['id'],
      cat_name: dataCat['desc'] ?? '',
    );
    addHomeBlurbCategoryList(_cat);
  });

  //print('BLURB CAREER #####################################');
  //print(dataFromResponse["data"]["career"]);

  dataFromResponse["data"]["career"].forEach((dataJobs) {

    JobsCat _career = new JobsCat(
      id: dataJobs['id'],
      company_id: dataJobs['company_id'],
      title: dataJobs['title'],
      city_id: dataJobs['city_id'],
      state_id: dataJobs['state_id'],
      company_name: dataJobs['company']['company_name'],
      company_logo: dataJobs['company']['logo'],
      city_name: dataJobs['city']['city_name'],
      state_name: dataJobs['state']['state_name'],
    );
    addHomeCareerList(_career);
  });

  //print('BLURB PROPERTY #####################################');
  //print(dataFromResponse["data"]["property"]);

  dataFromResponse["data"]["property"].forEach((dataInv) {

    List<Images> imageList = [];
    dataInv["images"].forEach((newRview) {
      imageList.add(
        new Images(
            id: newRview["id"], // after migration -> int to string
            property_id: newRview["property_id"], // after migration -> int to string
            file_path: newRview["file_path"]
        ),
      );
    },
    );

    PropertyCat _invest = new PropertyCat(
      id: dataInv['id'],
      company_id: dataInv['company_id'],
      title: dataInv['title'],
      location: dataInv['location'],
      proptype: dataInv['prop_type'],
      built_up_size: dataInv['built_up_size'],
      price: dataInv['price'],
      bedrooms: dataInv['bedrooms'],
      bathrooms: dataInv['bathrooms'],
      developer: dataInv['developer'],
      company_name: dataInv['company']['company_name'],
      logo: dataInv['company']['logo'],
      images: imageList,

    );
    addHomePropertyList(_invest);
  });

  //print('BLURB AUTOMOBILE #####################################');
  //print(dataFromResponse["data"]["auto"]);

  dataFromResponse["data"]["auto"].forEach((dataCar) {

    List<Images> imageAuto = [];
    dataCar["images"].forEach((autoData) {
      imageAuto.add(
        new Images(
            id: autoData["id"], // after migration -> int to string
            property_id: autoData["cars_id"], // after migration -> int to string
            file_path: autoData["file_path"]
        ),
      );
    },
    );

    AutoCat _auto = new AutoCat(
      id: dataCar['id'],
      title: dataCar['title'],
      location: dataCar['location'],
      year: dataCar['year'],
      mileage: dataCar['mileage'],
      price: dataCar['price'],
      brand_id: dataCar['brand']['id'],
      brand_name: dataCar['brand']['name'],
      model: dataCar['model'],
      variant: dataCar['variant'],
      doors: dataCar['doors'],
      seat_capacity: dataCar['seat_capacity'],
      images: imageAuto,
    );
    addHomeAutomobileList(_auto);
  });

  notifyListeners();
}

}

