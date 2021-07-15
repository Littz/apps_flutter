import 'dart:convert' as JSON;

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/scoped/scoped_reorder.dart';
import 'package:edagang/screens/shop/cart_checkout.dart';
import 'package:edagang/screens/shop/cart_checkout_re.dart';
import 'package:edagang/screens/shop/cart_review.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/widgets/newWidget/emptyList.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyOrders extends StatefulWidget {
  int selectedTab;
  MyOrders(this.selectedTab);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  bool isLoading = false;
  Color color = Color(0xff2877EA);
  SharedPref sharedPref = SharedPref();

  List<String> tabOrders = ["To Pay", "To Ship", "To Receive", "To Review", "Cancellations"];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController( vsync: this, initialIndex: widget.selectedTab, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void showStatusToast(String mesej, bool sts) {
    Fluttertoast.showToast(
        msg: mesej,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: sts == false ? Colors.red.shade700 : Colors.green.shade700,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
    {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          title: Text("My Orders",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,),
            ),
          ),
          bottom: new TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepOrange.shade600,
            isScrollable: true,
            //labelColor: Colors.deepOrange.shade600,
            labelStyle: GoogleFonts.lato(
              textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.deepOrange.shade600),
            ),
            unselectedLabelStyle: GoogleFonts.lato(
              textStyle: TextStyle(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
            ),
            tabs: [
              Tab(
                child: model.getTotalPay() == 0 ? Text(
                  'To Pay',
                  style: TextStyle(fontSize: 15),
                ) : Badge(
                  padding: model.getTotalPay().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  position: BadgePosition.topEnd(top: -13, end: -5),
                  child: Text('To Pay',
                    style: TextStyle(fontSize: 15),
                  ),
                  badgeContent: Text(model.getTotalPay().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: model.getTotalShip() == 0 ? Text(
                  'To Ship',
                  style: TextStyle(fontSize: 15),
                ) : Badge(
                  padding: model.getTotalShip().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  position: BadgePosition.topEnd(top: -13, end: -5),
                  child: Text('To Ship',
                    style: TextStyle(fontSize: 15),
                  ),
                  badgeContent: Text(model.getTotalShip().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: model.getTotalReceive() == 0 ? Text(
                  'To Receive',
                  style: TextStyle(fontSize: 15),
                ) : Badge(
                  padding: model.getTotalReceive().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  position: BadgePosition.topEnd(top: -13, end: -5),
                  child: Text('To Receive',
                    style: TextStyle(fontSize: 15),
                  ),
                  badgeContent: Text(model.getTotalReceive().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: model.getTotalReview() == 0 ? Text(
                  'To Review',
                  style: TextStyle(fontSize: 15),
                ) : Badge(
                  padding: model.getTotalReview().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  position: BadgePosition.topEnd(top: -13, end: -5),
                  child: Text('To Review',
                    style: TextStyle(fontSize: 15),
                  ),
                  badgeContent: Text(model.getTotalReview().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: model.getTotalCancel() == 0 ? Text(
                  'Cancellations',
                  style: TextStyle(fontSize: 15),
                ) : Badge(
                  padding: model.getTotalCancel().toString().length == 1 ? EdgeInsets.all(5.5) : EdgeInsets.all(3),
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  //borderRadius: BorderRadius.circular(100),
                  position: BadgePosition.topEnd(top: -13, end: -5),
                  child: Text('Cancellations',
                    style: TextStyle(fontSize: 15),
                  ),
                  badgeContent: Text(model.getTotalCancel().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              height:MediaQuery.of(context).size.height,
              child: model.getTotalPay() == 0 ? EmptyListCartsini('Oops! Sorry..',subTitle: 'There are no purchased items placed yet.') : Column(
                children: <Widget>[
                  Container(),
                  Expanded(child: _buildToPay(key: "key1", ctx: context))
                ]
              ),
            ),
            Container(
              height:MediaQuery.of(context).size.height,
              child: model.getTotalShip() == 0 ? EmptyListCartsini('Oops! Sorry..',subTitle: 'There are no purchased items placed yet.') : Column(
                children: <Widget>[
                  Container(),
                  Expanded(child: _buildToShip(key: "key2", ctx: context))
                ]
              ),
            ),
            Container(
              height:MediaQuery.of(context).size.height,
              child: model.getTotalReceive() == 0 ? EmptyListCartsini('Oops! Sorry..',subTitle: 'There are no purchased items placed yet.') : Column(
                  children: <Widget>[
                    Container(),
                    Expanded(child: _buildToReceive(key: "key3", ctx: context))
                  ]
              ),
            ),
            Container(
              height:MediaQuery.of(context).size.height,
              child: model.getTotalReview() == 0 ? EmptyListCartsini('Oops! Sorry..',subTitle: 'There are no purchased items placed yet.') : Column(
                  children: <Widget>[
                    Container(),
                    Expanded(child: _buildToReview(key: "key4", ctx: context))
                  ]
              ),
            ),
            Container(
              height:MediaQuery.of(context).size.height,
              child: model.getTotalCancel() == 0 ? EmptyListCartsini('Oops! Sorry..',subTitle: 'There are no purchased items placed yet.') : Column(
                  children: <Widget>[
                    Container(),
                    Expanded(child: _buildCancellation(key: "key5", ctx: context))
                  ]
              ),
            ),
          ],
        ),

      );
    });
  }

  Widget _buildToPay({String key, BuildContext ctx}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (ctx, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: model.toPay.length,
            itemBuilder: (_, index) {
              var data = model.toPay[index];
              var odrid = data.id.toString();
              var tot = double.tryParse(data.total_price).toStringAsFixed(2);
              //sharedPref.save('total', tot);
              //var subtotal = double.tryParse(data.total_price);
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getSeparator(10),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //physics: ClampingScrollPhysics(),
                        itemCount: data.order_group.length,
                        itemBuilder: (context, index) {
                          var ogrp = data.order_group[index];
                          var caj = double.tryParse(ogrp.courier_charges).toStringAsFixed(2);
                          //sharedPref.save('ship', caj);
                          //shipfee = double.tryParse(ogrp.courier_charges);
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            ogrp.merchant_name.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 0, right: 0),
                                        child: ListView.separated(
                                            separatorBuilder: (context, index) => Divider(
                                              color: Colors.grey,
                                              indent: 0.0,
                                              thickness: 0.0,
                                            ),
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: ogrp.order_items.length,
                                            itemBuilder: (context, index) {
                                              var item = ogrp.order_items[index];
                                              var hrga = double.tryParse(item.price);

                                              return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              sharedPref.save("prd_id", item.product_id);
                                                              sharedPref.save("prd_title", item.product_name);
                                                              Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(right: 5, top: 0),
                                                              color: Colors.white,
                                                              width: 70,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(5.0),
                                                                  child: CachedNetworkImage(
                                                                    placeholder: (context, url) => Container(
                                                                      color: Colors.transparent,
                                                                      child: Image.asset('assets/images/ed_logo_greys.png',width: 50,
                                                                        height: 50,),
                                                                    ),
                                                                    imageUrl: Constants.urlImage+item.main_image,
                                                                    width: 70,
                                                                    height: 70,
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _viewDetail(odrid);
                                                                },
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    item.product_name,
                                                                                    style: GoogleFonts.lato(
                                                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                                                    ),
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Text(
                                                                                            'RM' + hrga.toStringAsFixed(2),
                                                                                            style: GoogleFonts.lato(
                                                                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: Text(
                                                                                              'Qty: ' + item.quantity,
                                                                                              style: GoogleFonts.lato(
                                                                                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                ]
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                  ]
                                              );
                                            }
                                        )
                                    )
                                  ]
                              )
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data.transaction_date,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Subtotal: ',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' RM'+tot,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,

                              ),
                            ),
                          ]
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.topRight,
                        child: ButtonBar(
                          children: <Widget>[
                            OutlineButton(
                              shape: StadiumBorder(),
                              color: Colors.transparent,
                              borderSide: BorderSide(color: Colors.deepOrange.shade700),
                              child: Text(' Cancel ',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade700),
                                ),
                              ),
                              onPressed: () {
                                _submitCancel(model, odrid);
                              },
                            ),
                            RaisedButton(
                              color: Colors.deepOrange.shade700,
                              shape: StadiumBorder(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Pay Now",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              onPressed: () async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setDouble('total', double.tryParse(data.total_price));
                                prefs.setDouble('ship', double.tryParse(data.order_group[0].courier_charges));

                                Navigator.push(context, SlideRightRoute(page: ReCheckoutActivity(odrid)));
                              },
                            )
                          ],
                        ),

                        /*SizedBox(
                          width: MediaQuery.of(context).size.width/2.35,
                          child: RaisedButton(
                            color: Colors.deepOrange.shade600,
                            shape: StadiumBorder(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Pay Now",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            onPressed: () async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setDouble('total', double.tryParse(data.total_price));
                              prefs.setDouble('ship', double.tryParse(data.order_group[0].courier_charges));

                              Navigator.push(context, SlideRightRoute(page: ReCheckoutActivity(odrid)));
                            },
                          ),
                        )*/
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  Widget _buildToShip({String key, BuildContext ctx}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (ctx, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: model.toShip.length,
            itemBuilder: (_, index) {
              var data = model.toShip[index];
              var odrid = data.id.toString();
              var subtot = double.tryParse(data.total_price);
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getSeparator(10),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: data.order_group.length,
                        itemBuilder: (context, index) {
                          var ogrp = data.order_group[index];
                          var shipfee = double.tryParse(ogrp.courier_charges);
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            ogrp.merchant_name.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 0, right: 0),
                                        child: ListView.separated(
                                            separatorBuilder: (context, index) => Divider(
                                              color: Colors.grey,
                                              indent: 0.0,
                                              thickness: 0.0,
                                            ),
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: ogrp.order_items.length,
                                            itemBuilder: (context, index) {
                                              var item = ogrp.order_items[index];
                                              var hrga = double.tryParse(item.price);
                                              return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              sharedPref.save("prd_id", item.product_id);
                                                              sharedPref.save("prd_title", item.product_name);
                                                              Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(right: 5, top: 0),
                                                              color: Colors.white,
                                                              width: 70,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(5.0),
                                                                  child: CachedNetworkImage(
                                                                    placeholder: (context, url) => Container(
                                                                      color: Colors.transparent,
                                                                      child: Image.asset('assets/images/ed_logo_greys.png',width: 50,
                                                                        height: 50,),
                                                                    ),
                                                                    imageUrl: Constants.urlImage+item.main_image,
                                                                    width: 70,
                                                                    height: 70,
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                            ),
                                                          ),

                                                          Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _viewDetail(odrid);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              item.product_name,
                                                                              style: GoogleFonts.lato(
                                                                                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      'RM' + hrga.toStringAsFixed(2),
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: Text(
                                                                                        'Qty: ' + item.quantity,
                                                                                        style: GoogleFonts.lato(
                                                                                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ]
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                  ]
                                              );
                                            }
                                        )
                                    )
                                  ]
                              )
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(data.transaction_date,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Total Order: ',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' RM'+subtot.toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ]
                      ),
                    ),
                    /*Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/2.35,
                        child: RaisedButton(
                          color: Colors.deepOrange.shade600,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Contact Seller",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      )
                    ),*/
                  ],
                ),
              );
            },
          );
        }
    );
  }

  Widget _buildToReceive({String key, BuildContext ctx}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (ctx, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: model.toReceive.length,
            itemBuilder: (_, index) {
              var data = model.toReceive[index];
              var odrid = data.id.toString();
              var subtot = double.tryParse(data.total_price);
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getSeparator(10),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: data.order_group.length,
                        itemBuilder: (context, index) {
                          var ogrp = data.order_group[index];
                          var shipfee = double.tryParse(ogrp.courier_charges);
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            ogrp.merchant_name.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 0, right: 0),
                                        child: ListView.separated(
                                            separatorBuilder: (context, index) => Divider(
                                              color: Colors.grey,
                                              indent: 0.0,
                                              thickness: 0.0,
                                            ),
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: ogrp.order_items.length,
                                            itemBuilder: (context, index) {
                                              var item = ogrp.order_items[index];
                                              var hrga = double.tryParse(item.price);
                                              return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              sharedPref.save("prd_id", item.product_id);
                                                              sharedPref.save("prd_title", item.product_name);
                                                              Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(right: 5, top: 0),
                                                              color: Colors.white,
                                                              width: 70,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(5.0),
                                                                  child: CachedNetworkImage(
                                                                    placeholder: (context, url) => Container(
                                                                      color: Colors.transparent,
                                                                      child: Image.asset('assets/images/ed_logo_greys.png',width: 50,
                                                                        height: 50,),
                                                                    ),
                                                                    imageUrl: Constants.urlImage+item.main_image,
                                                                    width: 70,
                                                                    height: 70,
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                            ),
                                                          ),

                                                          Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _viewDetail(odrid);
                                                                },
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    item.product_name,
                                                                                    style: GoogleFonts.lato(
                                                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                                                    ),
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(bottom: 10),
                                                                                    child: Text(
                                                                                      ogrp.merchant_name,
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Text(
                                                                                            'RM' + hrga.toStringAsFixed(2),
                                                                                            style: GoogleFonts.lato(
                                                                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: Text(
                                                                                              'Qty: ' + item.quantity,
                                                                                              style: GoogleFonts.lato(
                                                                                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                              ),
                                                                                            ),
                                                                                          ),


                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                ]
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                  ]
                                              );
                                            }
                                        )
                                    )
                                  ]
                              )
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Subtotal: ',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' RM'+subtot.toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  Widget _buildToReview({String key, BuildContext ctx}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (ctx, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: model.toReview.length,
            itemBuilder: (_, index) {
              var data = model.toReview[index];
              var odrid = data.id.toString();
              var subtot = double.tryParse(data.total_price);
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getSeparator(10),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: data.order_group.length,
                        itemBuilder: (context, index) {
                          var ogrp = data.order_group[index];
                          var shipfee = double.tryParse(ogrp.courier_charges);
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            ogrp.merchant_name.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 0, right: 0),
                                        child: ListView.separated(
                                            separatorBuilder: (context, index) => Divider(
                                              color: Colors.grey,
                                              indent: 0.0,
                                              thickness: 0.0,
                                            ),
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: ogrp.order_items.length,
                                            itemBuilder: (context, index) {
                                              var item = ogrp.order_items[index];
                                              var hrga = double.tryParse(item.price);
                                              return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              sharedPref.save("prd_id", item.product_id);
                                                              sharedPref.save("prd_title", item.product_name);
                                                              Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(right: 5, top: 0),
                                                              color: Colors.white,
                                                              width: 70,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(5.0),
                                                                  child: CachedNetworkImage(
                                                                    placeholder: (context, url) => Container(
                                                                      color: Colors.transparent,
                                                                      child: Image.asset('assets/images/ed_logo_greys.png',width: 50,
                                                                        height: 50,),
                                                                    ),
                                                                    imageUrl: Constants.urlImage+item.main_image,
                                                                    width: 70,
                                                                    height: 70,
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                            ),
                                                          ),

                                                          Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _viewDetail(odrid);
                                                                },
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    item.product_name,
                                                                                    style: GoogleFonts.lato(
                                                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                                                    ),
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Text(
                                                                                            'RM' + hrga.toStringAsFixed(2),
                                                                                            style: GoogleFonts.lato(
                                                                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: Text(
                                                                                              'Qty: ' + item.quantity,
                                                                                              style: GoogleFonts.lato(
                                                                                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                  Container(
                                                                                      padding: EdgeInsets.only(top: 15),
                                                                                      alignment: Alignment.topRight,
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.push(context, SlideRightRoute(page: WriteReview(item.product_id,item.main_image,item.product_name,data.id.toString(),ogrp.merchant_name,ogrp.courier_company)));
                                                                                        },
                                                                                        child: Text(
                                                                                          "Rate & Review",
                                                                                          style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(color: Colors.deepOrange.shade600, fontSize: 15, fontWeight: FontWeight.w600, decoration: TextDecoration.underline,),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                  ),

                                                                                ]
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]
                                                                ),
                                                              )
                                                          ),
                                                        ]
                                                    ),
                                                  ]
                                              );
                                            }
                                        )
                                    )
                                  ]
                              )
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Completed on: '+data.transaction_date,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Subtotal: ',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' RM'+subtot.toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ]
                      ),
                    ),

                  ],
                ),
              );
            },
          );
        }
    );
  }

  Widget _buildCancellation({String key, BuildContext ctx}) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (ctx, child, model){
          return ListView.builder(
            key: PageStorageKey(key),
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: model.toCancel.length,
            padding: EdgeInsets.only(left: 2.5, top: 2.5, right: 2.5),
            itemBuilder: (_, index) {
              var data = model.toCancel[index];
              var odrid = data.id.toString();
              var total = "";
              var params = "";
              var prodnm = "";
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getSeparator(10),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: data.order_group.length,
                        itemBuilder: (context, index) {
                          var ogrp = data.order_group[index];
                          var shipfee = double.tryParse(data.order_group[index].courier_charges);
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            ogrp.merchant_name.toUpperCase(),
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 0, right: 0),
                                        child: ListView.separated(
                                            separatorBuilder: (context, index) => Divider(
                                              color: Colors.grey,
                                              indent: 0.0,
                                              thickness: 0.0,
                                            ),
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: ogrp.order_items.length,
                                            itemBuilder: (context, index) {
                                              var item = ogrp.order_items[index];
                                              var hrga = double.tryParse(item.price);
                                              var subtot = double.tryParse(data.total_price);
                                              //int tot = int.parse(data.total_price) + int.parse(ogrp.courier_charges);
                                              //total = total + tot.toString();
                                              prodnm = item.product_name;
                                              params = params + "product_id=" + item.product_id.toString();
                                              params = params + "&quantity=" + item.quantity.toString();
                                              return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              sharedPref.save("prd_id", item.product_id);
                                                              sharedPref.save("prd_title", item.product_name);
                                                              Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(right: 5, top: 0),
                                                              color: Colors.white,
                                                              width: 70,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(5.0),
                                                                  child: CachedNetworkImage(
                                                                    placeholder: (context, url) => Container(
                                                                      color: Colors.transparent,
                                                                      child: Image.asset('assets/images/ed_logo_greys.png',width: 50,
                                                                        height: 50,),
                                                                    ),
                                                                    imageUrl: Constants.urlImage+item.main_image,
                                                                    width: 70,
                                                                    height: 70,
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                            ),
                                                          ),

                                                          Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _viewDetail(odrid);
                                                                },
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    item.product_name,
                                                                                    style: GoogleFonts.lato(
                                                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                                                    ),
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Text(
                                                                                            'RM' + hrga.toStringAsFixed(2),
                                                                                            style: GoogleFonts.lato(
                                                                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: Text(
                                                                                              'Qty: ' + item.quantity,
                                                                                              style: GoogleFonts.lato(
                                                                                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      ]
                                                                                  ),
                                                                                ]
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    ]
                                                                ),
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                  ]
                                              );
                                            }
                                        )
                                    )
                                  ]
                              )
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Cancelled on: '+data.transaction_date,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Subtotal: ',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: ' RM'+double.tryParse(data.total_price).toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ]
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/2.8,
                          child: RaisedButton(
                            color: Colors.deepOrange.shade600,
                            shape: StadiumBorder(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Buy Again",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            onPressed: () {

                              /*if(have_variation == 'Y') {
                                if(_value == 0){
                                  showStatusToast('Please select '+listProdVar[0].variation_name, false);
                                }else {
                                  for (var i = 0; i < listProdVar.length; i++) {
                                    params = params + ("variation[" + i.toString() + "][variation_id]=" + listProdVar[i].id.toString() + "&");
                                    params = params + ("variation[" + i.toString() + "][option_id]=" + _value.toString() + "&");
                                  }

                                  params = params + "product_id=" + int.parse(data.order_group[index].order_items[index].product_id).toString();
                                  params = params + "&quantity=" + data.order_group[index].order_items[index].quantity.toString();

                                  model.addProduct(param: params);
                                  //showStatusToast('Adding '+name+' to cart', true);
                                  Navigator.of(context).pushReplacementNamed("/ShopCart");
                                }
                              }else{*/

                              model.addProduct(param: params);
                              showStatusToast('Added '+prodnm+' to cart.', true);
                              //Navigator.of(context).pushReplacementNamed("/ShopCart");
                              Navigator.push(context, SlideRightRoute(page: ShopCartPage()));
                              //}
                              print(params);
                            },
                          ),
                        )
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      constraints: BoxConstraints(maxHeight: height),
    );
  }
  
  _viewDetail(String odrid) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {Navigator.pop(context);},
            child: DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.25,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                    child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Ordered Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: OrderDetailPage(odrid),
                              )
                            ]
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              alignment: Alignment.centerRight,
                              //padding: EdgeInsets.only(left: 16, bottom: 5),
                              child: Icon(
                                LineAwesomeIcons.close,
                                color: Colors.red[600],
                              ),
                            ),
                          )
                        ]
                    )
                );
              },
            ),
          ),
        );
      },
    );
  }


  _submitCancel(MainScopedModel model, String oid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> postData = {
      'order_id': oid,
    };
    print(oid);

    final http.Response response = await http.post(
      Uri.parse('https://shopapp.e-dagang.asia/api/order/cancel'),
      body: JSON.jsonEncode(postData),
      headers: {
        'Authorization' : 'Bearer '+prefs.getString('token'),
        'Content-Type': 'application/json',
      },
    );

    model.fetchOrderStatusResponse();
    print(response.statusCode.toString());
    /*print("RES BODY >>>> " + response.body);
    if(response.statusCode == 200) {
      model.fetchOrderStatusResponse();
    }*/

    /*final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
    String message = 'Something wrong somewhere.';
    bool hasError = true;
    print(responseData);
    if (responseData["message"] == "success") {
      message = "Successfully.";
      hasError = false;
    } else {
      message = responseData["data"];
    }
    print("MESG >>>> " + message);

    final Map<String, dynamic> successInformation = {
      'success': !hasError,
      'message': message
    };

    if (successInformation['success']) {
      model.fetchOrderStatusResponse();
      //Navigator.of(context).pushReplacementNamed("/Main");
      print('Sukses cancel! => ' + successInformation['message']);
    } else {
      print('An Error Occurred! => ' + successInformation['message']);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cancellation failed.',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Close',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }*/
  }

  Widget _buildList({String key}) {
    return ListView.builder(
      key: PageStorageKey(key),
      itemBuilder: (_, i) => ListTile(title: Text("testing.. ${i}")),
    );
  }


}

class OrderDetailPage extends StatefulWidget {
  String odrId;
  OrderDetailPage(this.odrId);

  @override
  _OrderDetailPageState createState() {
    return new _OrderDetailPageState();
  }
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int _selectedIndex = 0;
  SharedPref sharedPref = SharedPref();
  BuildContext context;

  @override
  void initState() {
    super.initState();
    //FirebaseAnalytics().logEvent(name: 'Goilmu_Company_'+widget.bizName,parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    ReOrderScopedModel odetail = ReOrderScopedModel();
    odetail.fetchCartReorder(int.parse(widget.odrId));

    return ScopedModel<ReOrderScopedModel>(
      model: odetail,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OrderDetailListPage(int.parse(widget.odrId)),
      ),
    );
  }

}

class OrderDetailListPage extends StatefulWidget {
  int odrId;
  OrderDetailListPage(this.odrId);

  @override
  _OrderDetailListBodyState createState() {
    return new _OrderDetailListBodyState(odrId: null);
  }
}

class _OrderDetailListBodyState extends State<OrderDetailListPage> {
  BuildContext context;
  ReOrderScopedModel model;
  final int odrId;
  _OrderDetailListBodyState({@required this.odrId});
  Color color = Color(0xff2877EA);
  int pageIndex = 1;

  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ReOrderScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoadingOd ? buildCircularProgressIndicator() : _fetchOdrDetail();
      },
    );
  }

  _fetchOdrDetail() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.cartOrder.length,
      itemBuilder: (_, index) {
        var data = model.cartOrder[index];
        var shipfee = double.tryParse(data.order_group[index].courier_charges);
        var total = double.tryParse(data.total_price);
        var subtot = total - shipfee;
        //var subtot = double.tryParse(data.order_group[index].order_items[index].price);
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: data.order_group.length,
                  itemBuilder: (context, index) {
                    var ogrp = data.order_group[index];
                    return Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      ogrp.merchant_name.toUpperCase(),
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 0, right: 0),
                                  child: ListView.separated(
                                      separatorBuilder: (context, index) => Divider(
                                        color: Colors.grey,
                                        indent: 0.0,
                                        thickness: 0.0,
                                      ),
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: ogrp.order_items.length,
                                      itemBuilder: (context, index) {
                                        var item = ogrp.order_items[index];
                                        var hrga = double.tryParse(item.price);
                                        return Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(right: 5, top: 0),
                                                      color: Colors.white,
                                                      width: 70,
                                                      height: 70,
                                                      child: ClipRRect(
                                                          borderRadius: new BorderRadius.circular(5.0),
                                                          child: CachedNetworkImage(
                                                            placeholder: (context, url) => Container(
                                                              color: Colors.transparent,
                                                              child: Image.asset('assets/images/ed_logo_greys.png',width: 50,
                                                                height: 50,),
                                                            ),
                                                            imageUrl: Constants.urlImage+item.main_image,
                                                            width: 70,
                                                            height: 70,
                                                            fit: BoxFit.cover,
                                                          )
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    item.product_name,
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                                                    ),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      children: [
                                                                        Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Text(
                                                                            'RM' + hrga.toStringAsFixed(2),
                                                                            style: GoogleFonts.lato(
                                                                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                            alignment: Alignment.centerRight,
                                                                            child: Text(
                                                                              'Qty: ' + item.quantity,
                                                                              style: GoogleFonts.lato(
                                                                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ]
                                                                  ),
                                                                ]
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]
                                              )
                                            ]
                                        );
                                      }
                                  )
                              )
                            ]
                        )
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 16),
                child: Text(
                  'Order  No: '+data.order_no+'#'+data.id.toString(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text('Subtotal',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: RichText(
                            text: TextSpan(
                              text: 'RM',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                              ),
                              children: <TextSpan>[
                                TextSpan(text: subtot.toStringAsFixed(2),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          )
                      ),
                    ]
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text('Shipping Fee',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: RichText(
                            text: TextSpan(
                              text: 'RM',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                              ),
                              children: <TextSpan>[
                                TextSpan(text: shipfee.toStringAsFixed(2),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          )
                      ),
                    ]
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text('Total',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: RichText(
                            text: TextSpan(
                              text: 'RM',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
                              ),
                              children: <TextSpan>[
                                TextSpan(text: total.toStringAsFixed(2),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          )
                      ),
                    ]
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
