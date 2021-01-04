import 'package:edagang/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Category {
  int id;
  String title;

  Category({ this.id, this.title, });

  static Future<List<Category>> getCategories() async {
    http.Response response = await http.get(Constants.bizAPI+"/biz/category");
    List<Category> list = [];
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        for (var map in map["data"]["category"]) {
          list.add(
            Category(
              id: map['id'],
              title: map['category_name']
            )
          );
        }
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
    return list;
  }
}


class ListCats extends StatefulWidget {
  ListCats({Key key}) : super(key: key);
  @override _ListCatsState createState() => _ListCatsState();
}


class _ListCatsState extends State<ListCats> {
  @override void initState() {
    super.initState();
  }
  @override Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: Category.getCategories(),
        builder: (c, s) {
          if (s.hasData) {
            List<Tab> tabs = new List<Tab>();
            for (int i = 0; i < s.data.length; i++) {
              tabs.add(
                  Tab( child: Text( s.data[i].title, style: TextStyle(color: Colors.white), ), )
              );
            }
            return DefaultTabController(
                length: s.data.length,
                child: Scaffold(
                    appBar: AppBar(
                        title: Image.asset('assets/lg_edagang.png', fit: BoxFit.cover),
                        backgroundColor: Colors.white,
                        bottom: TabBar(
                          isScrollable: true,
                          tabs: tabs,
                        ),
                    ),
                ),
            );
          }
          if (s.hasError)
            print(s.error.toString());
          return Scaffold(
              body: Center(
                  child: Text(s.hasError ? s.error.toString() : "Loading...")
              ),
          );
        },
    );
  }
}



