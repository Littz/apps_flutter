import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalPage extends StatefulWidget {
  @override
  _DigitalPageState createState() => _DigitalPageState();
}

class _DigitalPageState extends State<DigitalPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('Digital',
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white,),
            ),
          ),
          //backgroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color(0xffF45432),
                  Colors.deepOrangeAccent.shade100,
                ],
              ),
            ),
          ),
          bottom: TabBar(
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("eBook",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Photo",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
        body: TabBarView(
          children: [
            Center( child: Text("Page 1")),
            Center( child: Text("Page 2")),
          ],
        ),
      ),
    );
  }
}