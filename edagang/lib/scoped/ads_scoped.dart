import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/ads_model.dart';
import 'package:edagang/models/biz_model.dart';
import 'package:edagang/utils/constant.dart';
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
  return json.decode(response.body);
}

Future fetchJobsCat() async {
  jobcat.clear();
  notifyListeners();

  var dataFromResponse = await _getJobcat();
  print('JOB Category==============================================');
  print(dataFromResponse);

  dataFromResponse["data"]["jobs"].forEach((dataJob) {
    JobsCat _job = new JobsCat(
      id: dataJob['id'],
      title: dataJob['title'],
      company: dataJob['company']['company_name'],
      logo: dataJob['company']['logo'],
      state: dataJob['state']['state_name'],
    );
    addToJobCategory(_job);
  });

  notifyListeners();
}


}

