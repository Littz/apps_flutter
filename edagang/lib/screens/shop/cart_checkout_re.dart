import 'dart:convert';

import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/scoped/scoped_reorder.dart';
import 'package:edagang/screens/address_book.dart';
import 'package:edagang/screens/shop/webview_fpx.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ReCheckoutActivity extends StatefulWidget {
  String odrid;
  ReCheckoutActivity(this.odrid);

  @override
  ReCheckoutActivityState createState() => ReCheckoutActivityState();

}

class ReCheckoutActivityState extends State<ReCheckoutActivity> {
  var selectedAddr = new Address();
  var selectedBank = new OnlineBanking();
  String _addr = '';
  int _addrId = 0;
  String _bank = '';
  int _bankId = 0;
  var ship,total,subtot = '';

  bool isLoading = false;
  double shipping, subtotal, xtotal = 0.0;
  SharedPref sharedPref = SharedPref();

  int _id;
  String order_no,total_price,address_id,name,address,postcode,city_id,state_id,full_address,city_name,state_name;
  String cajhantar;

  List<OrderGroup> ordered = [];
  int _payType = 1;

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      shipping = prefs.getDouble('ship');
      xtotal = prefs.getDouble('total');
      subtotal = xtotal - shipping;

      subtot = subtotal.toStringAsFixed(2);
      ship = shipping.toStringAsFixed(2);
      total = xtotal.toStringAsFixed(2);

      print('DATA LOAD xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(shipping.toString());
      print(subtotal.toString());

    });
  }

  getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    try {
      setState(() {
        print("Order ID : "+widget.odrid);
        Map<String, dynamic> postData = {
          'order_id': widget.odrid,
        };

        http.post(
            Uri.parse(Constants.postReorder),
          headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
          body: json.encode(postData),
        ).then((response) {

          var resBody = json.decode(response.body);

          setState(() {

            resBody.forEach((orders) {

              List<OrderGroup> orderGroup = [];
              orders['ordergroup'].forEach((ordergrp) {

                List<OrderItem> orderItems = [];
                ordergrp['orderitems'].forEach((orderitem) {
                  orderItems.add(
                      new OrderItem(
                        id: orderitem['id'],
                        group_id: orderitem['group_id'].toString(), // after migration -> int to string
                        product_id: orderitem['product_id'].toString(), // after migration -> int to string
                        quantity: orderitem['quantity'].toString(), // after migration -> int to string
                        price: orderitem['price'].toString(), // after migration -> int to string
                        //reviewed: orderitem['reviewed'].toString(), // after migration -> int to string
                        product_name: orderitem['product']['name'],
                        main_image: orderitem['product']['main_image'],
                      )
                  );
                });

                orderGroup.add(
                  new OrderGroup(
                    id: ordergrp['id'],
                    order_id: ordergrp['group_id'].toString(), // after migration -> int to string
                    merchant_id: ordergrp['merchant_id'].toString(), // after migration -> int to string
                    courier_charges: ordergrp['courier_charges'].toString(), // after migration -> int to string
                    product_cost: ordergrp['product_cost'].toString(), // after migration -> int to string
                    order_status_id: ordergrp['order_status']['id'],
                    order_status_name: ordergrp['order_status']['name'],
                    //courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
                    //tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
                    merchant_name: ordergrp['merchant']['company_name'],
                    //courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
                    order_items: orderItems,
                  ),
                );
              });

              var data = OdrHistory(
                id: orders['id'],
                order_no: orders['order_no'].toString(), // after migration -> int to string
                total_price: orders['total_price'].toString(), // after migration -> int to string
                address_id: orders['address_id'],
                order_group: orderGroup,
                name: orders['address']['name'],
                address: orders['address']['address'],
                postcode: orders['address']['postcode'],
                city_id: orders['address']['city_id'],
                state_id: orders['address']['state_id'],
                full_address: orders['address']['full_address'],
                city_name: orders['address']['city']['city_name'],
                state_name: orders['address']['state']['state_name'],
              );

              _id = data.id;
              order_no = data.order_no;
              total_price = data.total_price;
              address_id = data.address_id;
              ordered = data.order_group;
              name = data.name;
              address = data.address;
              postcode = data.postcode;
              city_id = data.city_id;
              state_id = data.state_id;
              full_address = data.full_address;
              city_name = data.city_name;
              state_name = data.state_name;
            });
//
          });
          isLoading = false;
        });
      });
    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Cartsini_Cart_REPAYMENT',parameters:null);
    getDetails();
    super.initState();
    _loadData();
    _loadBankName();

  }

  void showAlertToast(String mesej) {
    Fluttertoast.showToast(
        msg: mesej,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
  }

  List<GestureDetector> _buildBankingListItems(MainScopedModel model){
    int index = 0;
    var banks = model.bankList;
    return banks.map((bank){
      var boxDecoration=index % 3 == 0?
      new BoxDecoration(color: Colors.white):
      new BoxDecoration(color: Colors.white);
      if (selectedBank == bank) {
        boxDecoration = new BoxDecoration(
          color: Colors.deepOrange.shade100,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        );
      } else {
        boxDecoration = new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        );
      }
      var container = Container(
        decoration: boxDecoration,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              alignment: Alignment.center,
              margin: new EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.transparent,
                      child: CupertinoActivityIndicator(radius: 15,),
                    ),
                    imageUrl: Constants.urlImage+bank.bank_logo,
                    fit: BoxFit.fitWidth,
                    width: 205,
                  )

                  /*CachedNetworkImage(
                    width: 205,
                    imageUrl: Constants.urlImage+bank.bank_logo,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter:
                            ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(radius: 15,),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),*/


              ),
            ),
          ],
        ),
      );
      index = index + 1;
      final gestureDetector = GestureDetector(
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
            child: container,
          ),
          onTap:() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              _bankId = bank.id;
              _bank = bank.bank_display_name;
            });
            prefs.setInt('bank_id', _bankId);
            prefs.setString('bank_name', _bank);

            print("You\'ve selected ${_bankId.toString()+' - '+_bank}");

            setState(() {
              selectedBank = bank;
              print("bankID >>> "+prefs.getInt('bank_id').toString());
            });
          }
      );
      return gestureDetector;
    }).toList();
  }

  _loadBankName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('bank_id');
      prefs.remove('bank_name');
      _bankId = (prefs.getInt('bank_id') ?? null);
      _bank = (prefs.getString('bank_name') ?? null);
      print(_bankId.toString());
      print(_bank);
    });
  }


  @override
  Widget build(BuildContext context) {
    Size _deviceSize = MediaQuery.of(context).size;
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model){
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xff084B8C),
          ),
          title: new Text(
            'Repayment',
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
            ),
          ),
        ),
        backgroundColor: Color(0xffEEEEEE),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7, right: 7),
                  child: Text(
                    'Shipping Address',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                    ),
                  ),
                )
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 7, top: 1, ),
                      child: Text(name ?? '',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7, top: 5, ),
                      child: Text(full_address ?? '',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /*Container(
                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                height: model.addrList.length > 0 ? MediaQuery.of(context).size.height * 0.22 : MediaQuery.of(context).size.height * 0.14,
                child: model.addrList.length > 0 ? ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _buildAddressListItems(model),
                ) : GestureDetector(
                  onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => AddAddress(frm: 'chk')));},
                  child: Container(
                    margin: EdgeInsets.only(left: 7.0, right: 7.0),
                    width: 255,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                          color: Colors.orangeAccent.shade400,
                          width: 1.0,
                          style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.orangeAccent.shade100,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 5.0),
                      ],
                    ),
                    child: Center(
                      child: new Text(
                        '+ Add Address',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.orangeAccent.shade700, fontSize: 16, fontWeight: FontWeight.w700,),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),*/

              SizedBox(height: 16,),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7, right: 7),
                    child: Text(
                      'Ordered Item(s)',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                      ),
                    ),
                  )
              ),

              orderedItem(),

              SizedBox(height: 16,),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7, right: 7),
                  child: Text(
                    'Payment Method',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                    ),
                  ),
                )
              ),
              /*Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text('Please let us know your gender:'),
                    ListTile(
                      leading: Radio(
                        value: 1,
                        groupValue: _payType,
                        onChanged: (value) {
                          setState(() {
                            _payType = value;
                          });
                        },
                      ),
                      title: Text('Direct Pay Banking'),
                    ),
                    ListTile(
                      leading: Radio(
                        value: 2,
                        groupValue: _payType,
                        onChanged: (value) {
                          setState(() {
                            _payType = value;
                          });
                        },
                      ),
                      title: Text('Fpx Retail Banking'),

                    ),
                    SizedBox(height: 5),
                    Text(_payType.toString())
                  ],
                ),
              ),*/

              Container(
                width: _deviceSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 7, top: 1, ),
                      child: Text(
                        'Retail banking.',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _buildBankingListItems(model),
                ),
              ),

            ],
          )
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    });
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(2.5),
      height: 56.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
                padding: const EdgeInsets.only(left: 5, top: 5, right: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Subtotal : RM${subtot}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Shipping :  RM${ship}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: RaisedButton(
                  onPressed: () async{
                    var params = "";
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    //_addrId = prefs.getInt('addr_id');
                    _bankId = prefs.getInt('bank_id');

                    //params = params + "address_id=" + address_id;
                    params = params + "order_id=" + _id.toString();
                    params = params + "&bank_id=" + _bankId.toString();
                    params = params + "&source=app";
                    params = params + "&payment_type=2";
                    print(Constants.postCheckout+params);

                    if(_bankId == null){
                      showAlertToast('Please select fpx banking.');
                    } else {
                      Map<String, dynamic> postData = {
                        'order_id': _id.toString(),
                        'bank_id': _bankId.toString(),
                        'source': 'app',
                        'payment_type': '2',
                      };

                      http.post(
                          Uri.parse(Constants.postRepayment),
                        headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
                        body: json.encode(postData),
                      ).then((response) {
                        //var resBody = json.decode(response.body);
                        print(response.statusCode.toString());
                        print(response.body);
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebViewContainer(Constants.postRepayment+params, prefs.getString('token'), _bank, total)));
                      });

                    }


                  },
                  color: Colors.green.shade600,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(right: 15),
                            //alignment: Alignment.bottomRight,
                            child: RichText(
                              text: TextSpan(
                                text: 'RM',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: total,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.start,
                            )
                        ),
                        Text(
                          "PAY",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  orderedItem(){
    return Padding(
        padding: const EdgeInsets.all(7),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: ordered.length,
          itemBuilder: (context, index) {
            var data = ordered[index];
            //listCartId.add(data.courier_charges);

            return Container(
              padding: EdgeInsets.all(2.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey.shade300, ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(1),
                                child: Text(
                                  data.merchant_name,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: data.order_items.length,
                              itemBuilder: (context, index) {
                                var cart = data.order_items[index];
                                var hrgOri = double.tryParse(cart.price);
                                var hrgShip = double.tryParse(data.courier_charges);

                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 10,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(left: 2, top: 2, right: 5, bottom: 2),
                                              width: 50,
                                              height: 50,
                                              child: ClipRRect(
                                                  borderRadius: new BorderRadius.circular(5.0),
                                                  child: CachedNetworkImage(
                                                    placeholder: (context, url) => Container(
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.transparent,
                                                      child: CupertinoActivityIndicator(radius: 15,),
                                                    ),
                                                    imageUrl: Constants.urlImage+cart.main_image,
                                                    width: 30,
                                                    height: 30,
                                                    fit: BoxFit.cover,
                                                  )
                                              ),
                                            ),
                                            Expanded(
                                              //padding: EdgeInsets.all(2),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                Expanded(
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          cart.product_name,
                                                          style: GoogleFonts.lato(
                                                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,),
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        /*Container(
                                                          child: cart.ispromo == '1' ? Text(
                                                            'Price:  RM' + double.parse(cart.promo_price).toStringAsFixed(2) + '  (Qty: ' + cart.quantity +')',
                                                            style: GoogleFonts.lato(
                                                              textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                                            ),
                                                          ) : Text(
                                                            'Price:  RM' +hrgOri.toStringAsFixed(2) + '  (Qty: ' + cart.quantity +')',
                                                            style: GoogleFonts.lato(
                                                              textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                                            ),
                                                          ),
                                                        ),*/
                                                        Container(
                                                          child: Row(
                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                              //mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    'RM' +hrgOri.toStringAsFixed(2),
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Qty: ' + cart.quantity +'',
                                                                  style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                                                  ),
                                                                ),
                                                              ]
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(top: 3),
                                                          child: Text(
                                                            'Delivery:  RM' +hrgShip.toStringAsFixed(2),
                                                            style: GoogleFonts.lato(
                                                              textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                              ]),
                                            )
                                          ]
                                      )
                                    ]
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
              ),
            );
          },
        )
    );
  }
}

