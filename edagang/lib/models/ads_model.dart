class JobsCat {
  final int id;
  final int company_id;
  final String title;
  final String descr;
  final int city_id;
  final int state_id;
  final String company_name;
  final String company_logo;
  final String city_name;
  final String state_name;
  final List<Images> image;

  JobsCat({this.id, this.company_id, this.title, this.descr, this.city_id, this.state_id, this.company_name, this.company_logo, this.city_name, this.state_name, this.image});
}

class JobList {
  int id;
  int company_id;
  String title;
  String company_name;
  String logo;
  String city;
  String state;
  String salary;
  String job_description;
  String job_requirement;
  String company_overview;
  int years_experience;
  String contact_email;

  JobList(
      {this.id,
        this.company_id,
        this.title,
        this.company_name,
        this.logo,
        this.city,
        this.state,
        this.salary,
        this.job_description,
        this.job_requirement,
        this.company_overview,
        this.years_experience,
        this.contact_email,
      }
  );
}


class PropertyCat {
  final int id;
  final int company_id;
  final String title;
  final String location;
  final int proptype;
  final int prop_id;
  final String prop_name;
  final String prop_type;
  final String built_up_size;
  final String price;
  final String bedrooms;
  final String bathrooms;
  final String developer;
  final String overview;
  final String company_name;
  final String logo;
  final List<Images> images;


  PropertyCat({this.id, this.company_id, this.title, this.location, this.proptype, this.prop_id, this.prop_name, this.prop_type, this.built_up_size, this.price, this.bedrooms, this.bathrooms, this.developer, this.overview, this.company_name, this.logo, this.images});
}


class AutoCat {
  final int id;
  final String title;
  final String location;
  final String year;
  final String mileage;
  final String price;
  final int brand_id;
  final String brand_name;
  final String model;
  final String variant;
  final String doors;
  final String seat_capacity;
  final List<Images> images;

  AutoCat({this.id, this.title, this.location, this.year, this.mileage, this.price, this.brand_id, this.brand_name, this.model, this.variant, this.doors, this.seat_capacity, this.images});
}


class Images {
  final int id;
  final int property_id;
  final String file_path;

  Images({
    this.id,
    this.property_id,
    this.file_path,
  });
}