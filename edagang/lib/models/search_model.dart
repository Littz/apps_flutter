
import 'package:edagang/widgets/html2text.dart';

class Search {
  int id;
  int business_id;
  String product_name;
  String product_desc;
  String company_name;
  String company_logo;

  Search({
    this.id,
    this.business_id,
    this.product_name,
    this.product_desc,
    this.company_name,
    this.company_logo,
  });
}


class Repo {
  final int prodId;
  final int bizId;
  final String prodName;
  final String prodDesc;
  final String company;
  final String imgLogo;

  Repo(this.prodId, this.bizId, this.prodName, this.prodDesc, this.company, this.imgLogo);

  static List<Repo> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((r) =>Repo(
        r['id'],
        r['business_id'],
        r['product_name'],
        r['product_desc'],
        r['business']['company_name'],
        r['images']['file_path'])
    ).toList();
  }
}

class Repo2 {
  final int prodId;
  final int bizId;
  final String prodName;
  final String prodDesc;
  final String company;
  final String imgLogo;

  Repo2(this.prodId, this.bizId, this.prodName, this.prodDesc, this.company, this.imgLogo);

  static List<Repo2> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((r) =>Repo2(
        r['id'],
        r['business_id'],
        r['title'],
        r['desc'],
        r['business']['company_name'],
        r['business']['logo'])
    ).toList();
  }
}

class Repo3 {
  final int prodId;
  final String bizId;
  final String prodName;
  final String prodDesc;
  final String company;
  final String imgLogo;

  Repo3(this.prodId, this.bizId, this.prodName, this.prodDesc, this.company, this.imgLogo);

  static List<Repo3> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((r) =>Repo3(
        r['id'],
        r['merchant_id'],
        r['name'],
        r['summary'],
        r['merchant']['company_name'],
        r['main_image'])
    ).toList();
  }
}



class Repo4 {
  final int id;
  final String name;
  final String category;

  Repo4(this.id, this.name, this.category);

  static List<Repo4> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList.map((r) =>Repo4(
        r['id'],
        r['company_name'],
        r['category'])
    ).toList();
  }
}