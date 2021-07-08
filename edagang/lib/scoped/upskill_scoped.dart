import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/models/upskill_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

mixin UpskillScopedModel on Model {
List<SkillCat> skillcat = [];
List<SkillList> skillist = [];
List<SkillList> skillProfessional = [];
List<SkillList> skillTechnical = [];
List<SkillList> skillSafety = [];
List<SkillList> skillTraining = [];

List<SkillCat> get _skillcat => skillcat;
List<SkillList> get _skillist => skillist;

List<SkillList> get _skillPro => skillProfessional;
List<SkillList> get _skillTech => skillTechnical;
List<SkillList> get _skillSafety => skillSafety;
List<SkillList> get _skillTraining => skillTraining;

void addToSkillCatList(SkillCat cat) {
  _skillcat.add(cat);
}

void addToCourseList(SkillList lis) {
  _skillist.add(lis);
}

void addToProfessionalList(SkillList coursePro) {
  _skillPro.add(coursePro);
}

void addToTechnicalList(SkillList courseTech) {
  _skillTech.add(courseTech);
}

void addToSafetyList(SkillList courseSafe) {
  _skillSafety.add(courseSafe);
}

void addToTrainingList(SkillList courseTrain) {
  _skillTraining.add(courseTrain);
}

bool _isLoading = true;
bool get isLoading => _isLoading;

int _id;
String _name;

int getId() {return _id;}
String getCatName() {return _name;}



Future<dynamic> _getSkillcat() async {
  var response = await http.get(
    Constants.tuneupAPI+'/course/category',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  return json.decode(response.body);
}

Future<dynamic> _getSkillist() async {
  var response = await http.get(
    Constants.tuneupAPI+'/course/v2/latest',
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('GOILMU COURSE LATEST ==============================================');
  print(Constants.tuneupAPI+'/course/v2/latest');
  return json.decode(response.body);
}

Future fetchSkillCat() async {
  skillcat.clear();
  notifyListeners();

  var dataFromResponse = await _getSkillcat();


  dataFromResponse["data"]["category"].forEach((dataCat) {
    SkillCat _cat = new SkillCat(
      id: dataCat['id'],
      name: dataCat['name'],
    );
    addToSkillCatList(_cat);
  });

  //_id = dataFromResponse['data']['user']['id'];
  //_name = dataFromResponse['data']['user']['fullname'];

  notifyListeners();
}

Future fetchCourseList() async {

  skillist.clear();
  notifyListeners();
  var dataFromResponse = await _getSkillist();
  //print('COURSE LIST==============================================');
  //print(dataFromResponse);

  dataFromResponse['data']['courses'].forEach((courseList) {

    List<CourseSchedule> _schedule = [];
    courseList['schedule'].forEach((schedule) {
      _schedule.add(
          new CourseSchedule(
            id: schedule['id'],
            course_id: schedule['course_id'],
            date_start: schedule['date_start'],
            date_end: schedule['date_end'],
            time_start: schedule['time_start'],
            time_end: schedule['time_end'],
          )
      );
    });

    SkillList courses = new SkillList(
      id: courseList['id'],
      business_id: courseList['business_id'], // after migration -> int to string
      title: courseList['title'],
      descr: courseList['desc'], // after migration -> int to string
      overview: courseList['overview'],
      attendees: courseList['attendees'],
      key_modules: courseList['key_modules'],
      price: courseList['price'],
      course_category_id: courseList['course_category_id'],
      company_name: courseList['business']['company_name'],
      logo: courseList['business']['logo'],
      cat_id: courseList['category']['id'],
      cat_name: courseList['category']['name'],
      schedule: _schedule,
    );
    addToCourseList(courses);
  },
  );

  notifyListeners();
}


Future<dynamic> _getSkillProfessional() async {
  var response = await http.post(
    Constants.tuneupAPI+'/course/v2/category?category_id=1',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('GOILMU COURSE CATEGORY 1 ==============================================');
  print(Constants.tuneupAPI+'/course/v2/category?category_id=1');
  return json.decode(response.body);
}

Future fetchCourseProfessional() async {

  skillProfessional.clear();
  notifyListeners();
  var dataFromResponse = await _getSkillProfessional();


  _id = dataFromResponse['data']['category']['id'];
  _name = dataFromResponse['data']['category']['name'];

  dataFromResponse['data']['courses'].forEach((courseList) {

    List<CourseSchedule> _schedule = [];
    courseList['schedule'].forEach((schedule) {
      _schedule.add(
          new CourseSchedule(
            id: schedule['id'],
            course_id: schedule['course_id'],
            date_start: schedule['date_start'],
            date_end: schedule['date_end'],
            time_start: schedule['time_start'],
            time_end: schedule['time_end'],
          )
      );
    });

    SkillList courses = new SkillList(
      id: courseList['id'],
      business_id: courseList['business_id'], // after migration -> int to string
      title: courseList['title'],
      descr: courseList['desc'], // after migration -> int to string
      overview: courseList['overview'],
      attendees: courseList['attendees'],
      key_modules: courseList['key_modules'],
      price: courseList['price'],
      course_category_id: courseList['course_category_id'],
      company_name: courseList['business']['company_name'],
      logo: courseList['business']['logo'],
      cat_id: _id,
      cat_name: _name,
      schedule: _schedule,
    );
    addToProfessionalList(courses);
  },
  );

  notifyListeners();
}


Future<dynamic> _getSkillTechnical() async {
  var response = await http.post(
    Constants.tuneupAPI+'/course/v2/category?category_id=2',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('GOILMU COURSE CATEGORY 2 ==============================================');
  print(Constants.tuneupAPI+'/course/v2/category?category_id=2');
  return json.decode(response.body);
}

Future fetchCourseTechnical() async {

  skillTechnical.clear();
  notifyListeners();
  var dataFromResponse = await _getSkillTechnical();


  _id = dataFromResponse['data']['category']['id'];
  _name = dataFromResponse['data']['category']['name'];

  dataFromResponse['data']['courses'].forEach((courseList) {

    List<CourseSchedule> _schedule = [];
    courseList['schedule'].forEach((schedule) {
      _schedule.add(
          new CourseSchedule(
            id: schedule['id'],
            course_id: schedule['course_id'],
            date_start: schedule['date_start'],
            date_end: schedule['date_end'],
            time_start: schedule['time_start'],
            time_end: schedule['time_end'],
          )
      );
    });

    SkillList courses = new SkillList(
      id: courseList['id'],
      business_id: courseList['business_id'], // after migration -> int to string
      title: courseList['title'],
      descr: courseList['desc'], // after migration -> int to string
      overview: courseList['overview'],
      attendees: courseList['attendees'],
      key_modules: courseList['key_modules'],
      price: courseList['price'],
      course_category_id: courseList['course_category_id'],
      company_name: courseList['business']['company_name'],
      logo: courseList['business']['logo'],
      cat_id: _id,
      cat_name: _name,
      schedule: _schedule,
    );
    addToTechnicalList(courses);
  },
  );

  notifyListeners();
}


Future<dynamic> _getSkillSafety() async {
  var response = await http.post(
    Constants.tuneupAPI+'/course/v2/category?category_id=3',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('GOILMU COURSE CATEGORY 3 ==============================================');
  print(Constants.tuneupAPI+'/course/v2/category?category_id=3');
  return json.decode(response.body);
}

Future fetchCourseSafety() async {

  skillSafety.clear();
  notifyListeners();
  var dataFromResponse = await _getSkillSafety();

  _id = dataFromResponse['data']['category']['id'];
  _name = dataFromResponse['data']['category']['name'];

  dataFromResponse['data']['courses'].forEach((courseList) {

    List<CourseSchedule> _schedule = [];
    courseList['schedule'].forEach((schedule) {
      _schedule.add(
          new CourseSchedule(
            id: schedule['id'],
            course_id: schedule['course_id'],
            date_start: schedule['date_start'],
            date_end: schedule['date_end'],
            time_start: schedule['time_start'],
            time_end: schedule['time_end'],
          )
      );
    });

    SkillList courses = new SkillList(
      id: courseList['id'],
      business_id: courseList['business_id'], // after migration -> int to string
      title: courseList['title'],
      descr: courseList['desc'], // after migration -> int to string
      overview: courseList['overview'],
      attendees: courseList['attendees'],
      key_modules: courseList['key_modules'],
      price: courseList['price'],
      course_category_id: courseList['course_category_id'],
      company_name: courseList['business']['company_name'],
      logo: courseList['business']['logo'],
      cat_id: _id,
      cat_name: _name,
      schedule: _schedule,
    );
    addToSafetyList(courses);
  },
  );

  notifyListeners();
}


Future<dynamic> _getSkillTraining() async {
  var response = await http.post(
    Constants.tuneupAPI+'/course/v2/category?category_id=4',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('GOILMU COURSE CATEGORY 4 ==============================================');
  print(Constants.tuneupAPI+'/course/v2/category?category_id=4');
  return json.decode(response.body);
}

Future fetchCourseTraining() async {

  skillTraining.clear();
  notifyListeners();
  var dataFromResponse = await _getSkillTraining();

  _id = dataFromResponse['data']['category']['id'];
  _name = dataFromResponse['data']['category']['name'];

  dataFromResponse['data']['courses'].forEach((courseList) {

    List<CourseSchedule> _schedule = [];
    courseList['schedule'].forEach((schedule) {
      _schedule.add(
          new CourseSchedule(
            id: schedule['id'],
            course_id: schedule['course_id'],
            date_start: schedule['date_start'],
            date_end: schedule['date_end'],
            time_start: schedule['time_start'],
            time_end: schedule['time_end'],
          )
      );
    });

    SkillList courses = new SkillList(
      id: courseList['id'],
      business_id: courseList['business_id'], // after migration -> int to string
      title: courseList['title'],
      descr: courseList['desc'], // after migration -> int to string
      overview: courseList['overview'],
      attendees: courseList['attendees'],
      key_modules: courseList['key_modules'],
      price: courseList['price'],
      course_category_id: courseList['course_category_id'],
      company_name: courseList['business']['company_name'],
      logo: courseList['business']['logo'],
      cat_id: _id,
      cat_name: _name,
      schedule: _schedule,
    );
    addToTrainingList(courses);
  },
  );

  notifyListeners();
}


List<Home_banner> gbanners = [];
List<Home_banner> get _gbanners => gbanners;
void addGoilmuBannerList(Home_banner gbaner) {_gbanners.add(gbaner);}

Future<dynamic> _getGoilmuJson() async {
  var response = await http.get(
    'https://goilmuapp.e-dagang.asia/api/course/v2/home',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('GOILMU COURSE HOME ==============================================');
  print('https://goilmuapp.e-dagang.asia/api/course/v2/home');
  return json.decode(response.body);
}

Future fetchGoilmuResponse() async {
  _gbanners.clear();

  notifyListeners();
  var dataFromResponse = await _getGoilmuJson();

  dataFromResponse["data"]["banner"].forEach((dataBaner) {
    Home_banner _banner = new Home_banner(
      title: dataBaner['title'],
      imageUrl: dataBaner['image_url'],
      type: dataBaner['type'],
      itemId: dataBaner['item_id'],
      link_url: dataBaner['link_url'],
    );
    addGoilmuBannerList(_banner);
  });

  notifyListeners();
}

}

