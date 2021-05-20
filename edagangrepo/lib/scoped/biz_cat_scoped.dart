import 'package:edagang/models/biz_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:edagang/utils/constant.dart';
import 'package:http/http.dart' as http;

class SmartbizScopedModel extends Model {
  List<BizCat> bizcat = [];
  List<BizCat> get _bizcat => bizcat;
  void addToBizCategory(BizCat cat) {
    _bizcat.add(cat);
  }

  bool _isLoadingCat = false;
  bool get isLoadingCat => _isLoadingCat;

  int ctr;
  int getCount() {return ctr;}
  String category_name;
  String getCategoryName() {return category_name;}

  Future<dynamic> _getBizcat(catId) async {
    Map<String, dynamic> postData = {
      'category_id': catId,
    };

    var response = await http.post(
      Constants.bizAPI+'/biz/category',
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError((error) {
      print(error.toString());
      return false;
    },
    );
    return json.decode(response.body);
  }

  Future fetchBizCategory (int catId) async {
    bizcat.clear();

    _isLoadingCat = true;
    notifyListeners();

    var dataFromResponse = await _getBizcat(catId);
    print('BIZ Category==============================================');
    print(dataFromResponse);

    ctr = dataFromResponse["data"]["businesses"].length;
    category_name = dataFromResponse['data']['category']['category_name'];

    print(ctr.toString());
    print(category_name);

    dataFromResponse["data"]["businesses"].forEach((dataCat) {
      BizCat _cat = new BizCat(
        id: dataCat['id'],
        name: dataCat['company_name'],
        logo: dataCat['logo'],
        website: dataCat['website'],
        verify: dataCat['verified'],

      );
      addToBizCategory(_cat);
    });

    _isLoadingCat = false;
    notifyListeners();

  }

}