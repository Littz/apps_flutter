import 'dart:developer';
import 'package:flutter/material.dart';


class BankListPage extends StatefulWidget {
  @override
  _BankListPageState createState() => _BankListPageState();
}

class _BankListPageState extends State<BankListPage> {
  double padValue = 0;
  int selectedIndex;

  List<Paint> paints = <Paint>[
    Paint(1, 'Red', Colors.red),
    Paint(2, 'Blue', Colors.blue),
    Paint(3, 'Green', Colors.green),
    Paint(4, 'Lime', Colors.lime),
    Paint(5, 'Indigo', Colors.indigo),
    Paint(6, 'Yellow', Colors.yellow)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Selectable ListView Example"),
        ),
        body: ListView(
          children: List.generate(paints.length, (index) {
            return ListTile(
              //selected: paints[index].selected,
              leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    //paints[index].selected = !paints[index].selected;
                    //log(paints[index].selected.toString());
                    print(paints[index].id.toString());
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: paints[index].colorpicture,
                  ),
                ),
              ),
              title: Text('ID: ' + paints[index].id.toString()),
              subtitle: Text(paints[index].title),
              trailing: selectedIndex == index
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
            );
          }),
        ),
      ),
    );
  }
}

class Paint {
  final int id;
  final String title;
  final Color colorpicture;
  bool selected = false;

  Paint(this.id, this.title, this.colorpicture);
}