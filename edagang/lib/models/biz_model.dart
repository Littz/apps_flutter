class BizCat {
  final int id;
  final String name;
  final descr;

  BizCat({this.id, this.name, this.descr});
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

  Product({
    this.id,
    this.business_id,
    this.product_name,
    this.product_desc,
    this.company_name,
    this.file_path
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