import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

List<Menus> getBizQxcess() {
  List<Menus> quickMenu = new List();
  Menus menuModel = new Menus();

  menuModel.id = 1;
  menuModel.imgPath = "assets/icons/biz_company.png";
  menuModel.title = "Company";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 2;
  menuModel.imgPath = "assets/icons/biz_prod.png";
  menuModel.title = "Products";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 3;
  menuModel.imgPath = "assets/icons/biz_svc.png";
  menuModel.title = "Services";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 4;
  menuModel.imgPath = "assets/icons/biz_quotation.png";
  menuModel.title = "Quotation";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 5;
  menuModel.imgPath = "assets/icons/biz_joinus.png";
  menuModel.title = "Join Us";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  return quickMenu;
}


List<Menus> getBizTabs() {
  List<Menus> tabMenu = new List();
  Menus menuTab = new Menus();

  menuTab.id = 1;
  menuTab.imgPath = "assets/images/marketplace.png";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 0;
  menuTab.imgPath = "assets/images/financing.png";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 3;
  menuTab.imgPath = "assets/images/upskilling.png";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 4;
  menuTab.imgPath = "assets/images/business.png";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  return tabMenu;
}


List<Menus> getFinInsurans() {
  List<Menus> tabMenu = new List();
  Menus menuTab = new Menus();

  menuTab.id = 0;
  menuTab.imgPath = "assets/images/fin_personal_director.png";
  menuTab.title = "Personal Director's & Officer's Liabilty Insurance";
  menuTab.webviewUrl = "https://fintools.e-dagang.asia/insPackage1";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 1;
  menuTab.imgPath = "assets/images/fin_accident.png";
  menuTab.title = "Individual Personal Insurance";
  menuTab.webviewUrl = "https://fintools.e-dagang.asia/insPackage2";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 2;
  menuTab.imgPath = "assets/images/fin_home.png";
  menuTab.title = "SMARTHOME All-Risk Insurance";
  menuTab.webviewUrl = "https://fintools.e-dagang.asia/insPackage3";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 3;
  menuTab.imgPath = "assets/images/fin_health.png";
  menuTab.title = "Top-up Medical Scheme A Health Maximiser";
  menuTab.webviewUrl = "https://fintools.e-dagang.asia/insPackage4";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 4;
  menuTab.imgPath = "assets/images/fin_car.png";
  menuTab.title = "Car Insurance";
  menuTab.webviewUrl = "https://fintools.e-dagang.asia/insPackage5";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  menuTab.id = 5;
  menuTab.imgPath = "assets/images/fin_fire.png";
  menuTab.title = "Fire Insurance";
  menuTab.webviewUrl = "https://fintools.e-dagang.asia/insPackage6";
  tabMenu.add(menuTab);
  menuTab = new Menus();

  return tabMenu;
}


class Menus {
  int id;
  String imgPath;
  IconData iconx;
  String title;
  String webviewUrl;

  Menus({
    this.id,
    this.imgPath,
    this.iconx,
    this.title,
    this.webviewUrl,
  });
}


List<Menus> getAdsCategory() {
  List<Menus> quickMenu = new List();
  Menus menuModel = new Menus();

  menuModel.id = 1;
  menuModel.imgPath = "assets/icons/ads_jobs.png";
  menuModel.title = "Career";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 2;
  menuModel.imgPath = "assets/icons/ads_property.png";
  menuModel.title = "Property";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 3;
  menuModel.imgPath = "assets/icons/ads_auto.png";
  menuModel.title = "Vehicle";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 4;
  menuModel.imgPath = "assets/icons/biz_svc.png";
  menuModel.title = "Services";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 5;
  menuModel.imgPath = "assets/icons/ads_rate.png";
  menuModel.title = "Rate";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  return quickMenu;
}

List<Menus> getUpskillCategory() {
  List<Menus> quickMenu = new List();
  Menus menuModel = new Menus();

  menuModel.id = 1;
  menuModel.imgPath = "assets/icons/gopro.png";
  menuModel.title = "Professional";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 2;
  menuModel.imgPath = "assets/icons/gotech.png";
  menuModel.title = "Technical";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 3;
  menuModel.imgPath = "assets/icons/gosafe.png";
  menuModel.title = "Safety";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 4;
  menuModel.imgPath = "assets/icons/goskill.png";
  menuModel.title = "Skill";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  return quickMenu;
}

List<Menus> getShopNewContent() {
  List<Menus> quickMenu = new List();
  Menus menuModel = new Menus();

  menuModel.id = 1;
  menuModel.imgPath = "assets/icons/shop_koop.png";
  menuModel.title = "Koperasi";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 2;
  menuModel.imgPath = "assets/icons/shop_wholesale.png";
  menuModel.title = "NGO";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 3;
  menuModel.imgPath = "assets/icons/shop_digital.png";
  menuModel.title = "Digital";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 4;
  menuModel.imgPath = "assets/icons/shop_join.png";
  menuModel.title = "Join Us";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  return quickMenu;
}