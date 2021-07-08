import 'package:badges/badges.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/order_details.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class CartsiniAccount extends StatefulWidget {
  @override
  _CartsiniAccountState createState() => _CartsiniAccountState();
}

class _CartsiniAccountState extends State<CartsiniAccount> {
  BuildContext context;
  int pageIndex = 1;

  final Color color1 = Colors.grey;
  final Color color2 = Colors.white;
  final Color color3 = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    //FirebaseAnalytics().logEvent(name: 'Cartsini_Koperasi_product',parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text("My Account",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _getSeparator(10),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Orders',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkResponse(
                              onTap: () {
                                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: MyOrders(0))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                //Navigator.push(context, SlideRightRoute(page: MyDashboard(0)));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  model.getTotalPay() == 0 ? Icon(LineAwesomeIcons.credit_card, size: 28,) : Badge(
                                    padding: model.getTotalPay().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                                    badgeColor: Colors.red,
                                    shape: BadgeShape.circle,
                                    //borderRadius: BorderRadius.circular(5),
                                    child: Icon(LineAwesomeIcons.credit_card,
                                      color: Colors.black87,
                                    ),
                                    badgeContent: Text(
                                      model.getTotalPay().toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ), // icon
                                  Text("To Pay",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkResponse(
                              onTap: () {
                                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: MyOrders(1))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  model.getTotalShip() == 0 ? Icon(LineAwesomeIcons.archive, size: 28,) : Badge(
                                    padding: model.getTotalShip().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                                    badgeColor: Colors.red,
                                    shape: BadgeShape.circle,
                                    //borderRadius: BorderRadius.circular(5),
                                    child: Icon(LineAwesomeIcons.archive,
                                      color: Colors.black87,
                                    ),
                                    badgeContent: Text(
                                      model.getTotalShip().toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ), // icon
                                  Text("To Ship",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkResponse(
                              onTap: () {
                                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: MyOrders(2))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  model.getTotalReceive() == 0 ? Icon(LineAwesomeIcons.truck, size: 28,) : Badge(
                                    padding: model.getTotalReceive().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                                    badgeColor: Colors.red,
                                    shape: BadgeShape.circle,
                                    //borderRadius: BorderRadius.circular(5),
                                    child: Icon(LineAwesomeIcons.truck,
                                      color: Colors.black87,
                                    ),
                                    badgeContent: Text(
                                      model.getTotalReceive().toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ), // icon
                                  Text("To Receive",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkResponse(
                              onTap: () {
                                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: MyOrders(3))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  model.getTotalReview() == 0 ? Icon(LineAwesomeIcons.comment, size: 28,) : Badge(
                                    padding: model.getTotalReview().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                                    badgeColor: Colors.red,
                                    shape: BadgeShape.circle,
                                    //borderRadius: BorderRadius.circular(5),
                                    child: Icon(LineAwesomeIcons.comment,
                                      color: Colors.black87,
                                    ),
                                    badgeContent: Text(
                                      model.getTotalReview().toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ), // icon
                                  Text("To Review",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkResponse(
                              onTap: () {
                                model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: MyOrders(4))) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  model.getTotalCancel() == 0 ? Icon(LineAwesomeIcons.calendar_times_o, size: 28,) : Badge(
                                    padding: model.getTotalCancel().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                                    badgeColor: Colors.red,
                                    shape: BadgeShape.circle,
                                    //borderRadius: BorderRadius.circular(5),
                                    child: Icon(LineAwesomeIcons.calendar_times_o,
                                      color: Colors.black87,
                                    ),
                                    badgeContent: Text(
                                      model.getTotalCancel().toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ), // icon
                                  Text("Cancellations",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
              SliverToBoxAdapter(
                child: _getSeparator(10),
              ),
              //SliverFillRemaining(
              //  child: new Container(color: Colors.grey[200]),
              //),
            ],
          )
      );

  });
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

}






