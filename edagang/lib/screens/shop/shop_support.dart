import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class CartsiniHelp extends StatefulWidget {
  @override
  _CartsiniHelpState createState() => new _CartsiniHelpState();
}

class _CartsiniHelpState extends State<CartsiniHelp> {

  @override
  void initState() {
    super.initState();
  }


  Widget _showLoginFirst() {
    return Center(
      //title: new Text("Conversation Request"),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              "images/cartsini_logo.png",
              height: 120.0,
              //width: 210.0,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(height: 10,),
            new Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: new RaisedButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => SignInOrRegister()));},
                child: new Text(
                  "SIGN-IN",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.deepOrange,
                textColor: Colors.white,
                elevation: 5.0,
              ),
            ),
            new Column(
              children: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context){return Register();}));
                  },
                  child: new Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: new Text(
                        "SIGN-UP an account",
                        style: TextStyle( decoration: TextDecoration.underline, fontSize: 15.0),
                      )
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),

    );
  }

  List<Panel> panels = [
    Panel(
        'HOW CAN I CHANGE MY SHIPPING ADDRESS?',
        'By default, the last used shipping address will be saved into your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW MANY FREE SAMPLES CAN I REDEEM?',
        'Due to the limited quantity, each member`s account is only entitled to 1 unique free sample. You can check out up to 4 free samples in each checkout.',
        false),
    Panel(
        'HOW CAN I TRACK MY ORDERS & PAYMENT?',
        'By default, the last used shipping address will be saved into your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW LONG WILL IT TAKE FOR MY ORDER TO ARRIVE AFTER I MAKE PAYMENT?',
        'By default, the last used shipping address will be saved into your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW DO YOU SHIP MY ORDERS?',
        'By default, the last used shipping address will be saved into your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW DO I MAKE PAYMENTS USING PAYPAL? HOW DOES IT WORK?',
        'By default, the last used shipping address will be saved into your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false)
  ];

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return Scaffold(
            /*appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: new Text(
                'Cartsini Helpcenter',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Quicksand",
                ),
              ),
            ),*/
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                title: Text(
                  'FAQ & Support',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 18,),
                  ),
                ),
                elevation: 0,
              ),
              backgroundColor: Color(0xffEEEEEE),
              body: model.isAuthenticated ?
              SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListView(
                    children: <Widget>[
                Padding(
                padding: const EdgeInsets.only(left:16.0,right:16.0,bottom: 0.0),
                child: Text(
                  'FAQ',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),
                  ),
                ),
              ),... panels.map((panel)=>ExpansionTile(
              title: Text(
                panel.title,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey[600]),
                ),
              ),

              children: [Container(
                  padding: EdgeInsets.all(18.0),
                  color: Color(0xffFAF1E2),
                  child: Text(
                      panel.content,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ))])).toList(),

          ],
          ),
          ),
          )
              : _showLoginFirst(),
          );
          });
  }

}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}

