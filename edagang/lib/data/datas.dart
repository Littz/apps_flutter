import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

List<Menus> getShopNewContent() {
  List<Menus> quickMenu = new List();
  Menus menuModel = new Menus();

  menuModel.id = 1;
  menuModel.imgPath = "assets/images/koperasi.png";
  menuModel.title = "Koperasi";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 2;
  menuModel.imgPath = "assets/images/ngo.png";
  menuModel.title = "NGO";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  menuModel.id = 3;
  menuModel.imgPath = "assets/images/join.png";
  menuModel.title = "Join Us";
  quickMenu.add(menuModel);
  menuModel = new Menus();

  return quickMenu;
}