class Address {
  int id;
  bool isSelected;
  String name;
  String address;
  String postcode;
  String city_id;
  String state_id;
  String user_id;
  String mobile_no;
  String email;
  String default_shipping;
  String default_billing;
  String location_tag;
  String full_address;

  Address({this.id, this.isSelected, this.name, this.address, this.postcode, this.city_id, this.state_id, this.user_id, this.mobile_no, this.email, this.default_shipping, this.default_billing, this.location_tag, this.full_address, full_addres});
}

class CityStates {
  int id;
  String ctname;

  CityStates(this.id, this.ctname);

}