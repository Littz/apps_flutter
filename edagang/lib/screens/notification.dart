import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/emptyList.dart';
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
                  /*iconTheme: IconThemeData(
                    color: Color(0xff084B8C),
                  ),*/
                  centerTitle: false,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Notification',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
                          ),
                        ),
                        new Text(
                          '',
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
                backgroundColor: Colors.grey[200],
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: EmptyList(
                    'No Notification available yet.',
                    subTitle: 'The system will notify you when new notifiction found.',
                  ),
                ),

              )
          );

        }
    );
  }

}
