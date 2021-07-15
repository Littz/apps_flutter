import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FpxStatus extends StatefulWidget {
  final String status;
  FpxStatus({this.status});

  @override
  FpxStatusState createState() => FpxStatusState();
}

class FpxStatusState extends State<FpxStatus> {
  SharedPref sharedPref = SharedPref();
  String _amount = "";

  loadPrefs() async {
    try {
      String amount = await sharedPref.read("paid_amount");

      setState(() {
        _amount = amount;
        print("total PAID : "+_amount);
      });

    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
    FirebaseAnalytics().logEvent(name: 'Cartsini_Payment_status',parameters:null);
  }

  circularProgress() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model)
    {
      return WillPopScope(
          onWillPop: () {

            model.loggedInUser();
            model.fetchCartTotal();
            model.fetchCartsFromResponse();
            model.fetchCartReload();
            model.fetchOrderStatusResponse();

            widget.status == 'failed' ? _moveToPayScreen(context) : _moveToIndexScreen(context);
            return null;
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "Payment Status",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
                ),
              ),
            ),
            body: Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(widget.status == 'failed' ? CupertinoIcons.clear : CupertinoIcons.check_mark, color: widget.status == 'failed' ? Colors.red.shade500 : Colors.green.shade600, size: 50,),
                    Text(widget.status == 'failed' ? 'Order Failed' : 'Successfully Ordered',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: widget.status == 'failed' ? Colors.red.shade500 : Colors.green.shade600,),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      widget.status == 'failed' ?
                      "Ohh sorry..! We couldn\'t made your order. If your money has been deducted, don\'t worry we shall update your order status within 24 hours."
                          : "Nice! we have received "+ _amount +" for your order.",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    new FlatButton(
                      shape: StadiumBorder(),
                      color: Colors.deepOrange.shade600,
                      onPressed: () {
                        model.loggedInUser();
                        model.fetchCartTotal();
                        model.fetchCartsFromResponse();
                        model.fetchCartReload();
                        model.fetchOrderStatusResponse();

                        widget.status == 'failed' ? _moveToPayScreen(context) : _moveToIndexScreen(context);

                      },
                      child: new Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                          child: new Text(
                            " CLOSE ",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          )
                      ),
                    )
                  ],
                )),
            backgroundColor: Color(0xFFf4f4f4),
          )
      );
    });
  }

  getPaid(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(key);
  }

  void _moveToIndexScreen(BuildContext context) => Navigator.of(context).pushReplacementNamed("/ShopIndex");
  void _moveToPayScreen(BuildContext context) => Navigator.of(context).pushReplacementNamed("/ToPay");

  @override
  void dispose() {
    //streamController.close();
    super.dispose();
  }
}