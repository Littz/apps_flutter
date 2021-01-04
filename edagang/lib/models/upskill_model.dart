class SkillCat {
  final int id;
  final String name;

  SkillCat({this.id, this.name});
}

class SkillList {
  int id;
  int business_id;
  String title;
  String descr;
  String overview;
  String attendees;
  String key_modules;
  String price;
  int course_category_id;
  String company_name;
  String logo;
  int cat_id;
  String cat_name;
  List<CourseSchedule> schedule;

  SkillList(
      {this.id,
        this.business_id,
        this.title,
        this.descr,
        this.overview,
        this.attendees,
        this.key_modules,
        this.price,
        this.course_category_id,
        this.company_name,
        this.logo,
        this.cat_id,
        this.cat_name,
        this.schedule,
      }
      );
}

class CourseSchedule {
  final int id;
  final int course_id;
  final String date_start;
  final String date_end;
  final String time_start;
  final String time_end;

  CourseSchedule({
    this.id,
    this.course_id,
    this.date_start,
    this.date_end,
    this.time_start,
    this.time_end,
  });
}