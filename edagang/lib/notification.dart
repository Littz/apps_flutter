import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() => new _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Notification_page',parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            Navigator.of(context).pushReplacementNamed("/Main");
            return null;
          },
              child: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  //automaticallyImplyLeading: false,
                  elevation: 0.0,
                  iconTheme: IconThemeData(
                    color: Color(0xff084B8C),
                  ),
                  centerTitle: true,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Notification',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xff084B8C),),
                          ),
                        ),
                        new Text(
                          '(0)',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                backgroundColor: Color(0xffEEEEEE),
                body: Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(CupertinoIcons.bell, color: Colors.grey.shade500, size: 50,),
                        SizedBox(height: 20,),
                        Text(
                          "You have no message.",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,),
                          ),
                        ),
                      ],
                    )
                ),

              )
          );

        }
    );
  }

  _buildCircularProgressIndicator() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
        child: CupertinoActivityIndicator(
          radius: 22,
        ),
      ),
    );
  }

  _emptyContent() {
    return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 80,),
              Icon(CupertinoIcons.mail ,
                color: Colors.red.shade500, size: 50,),
              //Image.asset('images/ic_qrcode3.png', width: 26, height: 26,),
              SizedBox(height: 20,),
              Text(
                'Empty Message.',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                ),
              ),
              new FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  //Navigator.push(context,MaterialPageRoute(builder: (context){return IndexApp();}));
                },
                child: new Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Text(
                      "START SHOPPING",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.deepOrange.shade600),
                      ),
                    )
                ),
              )
            ],
          ),
        )
    );
  }

}
