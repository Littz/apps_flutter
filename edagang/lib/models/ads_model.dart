class JobsCat {
  final int id;
  final String title;
  final company;
  final logo;
  final state;

  JobsCat({this.id, this.title, this.company, this.logo, this.state});
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