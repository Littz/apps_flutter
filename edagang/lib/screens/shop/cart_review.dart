import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class MyReview extends StatefulWidget {
  @override
  _MyReviewState createState() => new _MyReviewState();
}

class _MyReviewState extends State<MyReview> {

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
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontWeight: FontWeight.w700,),
                  ),
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
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 15, decoration: TextDecoration.underline),
                        ),
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

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: new Text(
                'My Reviews',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff202020),),
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            body: model.isAuthenticated ?
            Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.mood_bad, color: Colors.grey, size: 50,),
                    SizedBox(height: 20,),
                    Text(
                      'You don\'t have any purchases to review',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 0.8),),
                      ),
                    ),
                  ],
                )
            )
                : _showLoginFirst(),
          );
        });
  }

}
