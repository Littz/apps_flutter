
class Home_banner {
  String imageUrl;
  String title;
  int type;
  int itemId;
  String link_url;

  Home_banner({this.imageUrl, this.title, this.type, this.itemId, this.link_url});
}

class Home_category {
  int cat_id;
  String cat_name;
  String cat_image;

  Home_category({this.cat_id, this.cat_name, this.cat_image});
}

class Home_business {
  int id;
  int ref_type;
  String company_name;
  String overview;
  String address;
  String office_phone;
  String office_fax;
  String email;
  String website;
  String logo;
  String company_licno;
  List<Product> product;
  List<Award> award;
  List<Cert> cert;

  Home_business({
    this.id,
    this.ref_type,
    this.company_name,
    this.overview,
    this.address,
    this.office_phone,
    this.office_fax,
    this.email,
    this.website,
    this.logo,
    this.company_licno,
    this.product,
    this.award,
    this.cert,
  });
}

class Home_virtual {
  int vr_id;
  String vr_desc;
  List<VRList> vr_list;

  Home_virtual({this.vr_id, this.vr_desc, this.vr_list});
}

class VRList {
  int vr_type;
  String vr_name;
  String vr_url;
  String vr_image;

  VRList({this.vr_type, this.vr_name, this.vr_url, this.vr_image});
}



class BizCat {
  int id;
  String name;
  String logo;
  String website;

  BizCat({this.id, this.name, this.logo, this.website});
}


class BizList {
  int id;
  String company_name;
  String overview;
  String address;
  String office_phone;
  String office_fax;
  String email;
  String website;
  String logo;
  String vr_office;
  String vr_showroom;
  List<Product> product;
  List<Award> award;
  List<Cert> cert;

  BizList(
      {this.id,
        this.company_name,
        this.overview,
        this.address,
        this.office_phone,
        this.office_fax,
        this.email,
        this.website,
        this.logo,
        this.vr_office,
        this.vr_showroom,
        this.product,
        this.award,
        this.cert,
      }
      );
}

class Product {
  final int id;
  final int business_id;
  final String product_name;
  final String product_desc;
  final String company_name;
  final String file_path;
  final String overview;

  Product({
    this.id,
    this.business_id,
    this.product_name,
    this.product_desc,
    this.company_name,
    this.file_path,
    this.overview,
  });
}

class Award {
  final int id;
  final int business_id;
  final String award_desc;
  final String filename;

  Award({
    this.id,
    this.business_id,
    this.award_desc,
    this.filename,
  });
}

class Cert {
  final int id;
  final int business_id;
  final String cert_name;
  final String filename;

  Cert({
    this.id,
    this.business_id,
    this.cert_name,
    this.filename,
  });
}

class MenuCategory {
  final int id;
  final String category_name;
  final String category_desc;

  MenuCategory({
    this.id,
    this.category_name,
    this.category_desc,
  });
}

class Company {
  final int id;
  final String company_name;
  final String category;

  Company({
    this.id,
    this.company_name,
    this.category,
  });
}