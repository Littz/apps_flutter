import 'dart:convert';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/shipping_address.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/screens/shop/webview_pay.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CheckoutActivity extends StatefulWidget {
  //final List<String> cartId;
  //CheckoutActivity(this.cartId);

  @override
  CheckoutActivityState createState() => CheckoutActivityState();
}

class CheckoutActivityState extends State<CheckoutActivity> {
  MainScopedModel _model = MainScopedModel();
  var selectedAddr = new Address();
  var selectedBank = new OnlineBanking();
  String _addr = '';
  int _addrId, adrid, ship_id;
  String recipient, address, poscode, mobileno, emel, defship, defbill, fulladdr;
  String _bank = '';
  int _bankId = 0;
  double subtot = 0.0;
  bool isLoading = false;
  final myr = new NumberFormat("#,##0.00", "en_US");

  List<String> cartidList = new List();
  List<int> _cartidList = new List();
  SharedPref sharedPref = SharedPref();

  getShippingAddr(int adr_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    try {
      setState(() {

        print("Addr id : "+adr_id.toString());

        http.get(
          Uri.parse('https://shopapp.e-dagang.asia/api/account/address/'+adr_id.toString()),
          headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
        ).then((response) {

          var resBody = json.decode(response.body);

          setState(() {

            adrid = resBody['data']['address']['id'];
            recipient = resBody['data']['address']['name'];
            address = resBody['data']['address']['address'];
            poscode = resBody['data']['address']['postcode'];
            mobileno = resBody['data']['address']['mobile_no'];
            emel = resBody['data']['address']['email'];
            defship = resBody['data']['address']['default_shipping'];
            defbill = resBody['data']['address']['default_billing'];
            fulladdr = resBody['data']['address']['full_address'];

          });
          isLoading = false;

        });
      });
    } catch (Excepetion ) {
      print("error!");
    }
  }

  _loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _addrId = prefs.getInt('ship_id');
      getShippingAddr(_addrId);

      print(_addrId.toString());

    });
  }

  _loadCartId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartidList = (prefs.getStringList('list_cartid') ?? List<String>()) ;
      _cartidList = cartidList.map((i)=> int.parse(i)).toSet().toList();
      print('Cart Id list => $_cartidList');
      print(_cartidList.length);
      subtot = prefs.getDouble('subtotal');
    });
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
          //color: Colors.deepOrange.shade100,
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.deepOrange.shade500, width: 2),
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
                    fit: BoxFit.cover,
                    width: 205,
                  )
              ),
            ),
          ],
        ),
      );
      index = index + 1;
      final gestureDetector = GestureDetector(
        child: Card(
          elevation: 1.0,
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
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Cartsini_Cart_Checkout',parameters:null);
    super.initState();

    _loadAddress();
    _loadCartId();
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
            'Checkout',
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
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
                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                    ),
                  ),
                )
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                //height: model.addrList.length > 0 ? MediaQuery.of(context).size.height * 0.22 : MediaQuery.of(context).size.height * 0.14,
                child: InkResponse(
                  onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ShippingAddress()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey.shade500,),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(recipient ?? '',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Text('Change >',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.deepOrange.shade500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(mobileno ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                            ),
                          ),
                          Text(fulladdr ?? '',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                            ),
                          ),
                        ],
                      )
                    )
                ),
              ),

              SizedBox(height: 16,),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7, right: 7),
                    child: Text(
                      'Ordered Item(s)',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                      ),
                    ),
                  )
              ),

              orderedItem(model),

              SizedBox(height: 16,),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7, right: 7),
                  child: Text(
                    'Payment Method',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                    ),
                  ),
                )
              ),
              Container(
                width: _deviceSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 7, top: 1, ),
                      child: Text(
                        'FPX banking.',
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
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model){
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(0),
        height: 59.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(2.5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Subtotal:",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: model.getTotalCourier() != null ? Text(
                              "RM" + myr.format(model.getTotalCostR()),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                              ),
                            ) : Text("RM0.00",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                        ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Shipping:",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: model.getTotalCourier() != null ? Text(
                                "RM" + myr.format(model.getTotalCourierR()),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                ),
                              ) : Text(
                                "RM0.00",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                ),
                              ),
                            ),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Total:",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: model.getTotalCourier() != null ? Text(
                                "RM" + myr.format(model.totalNettR()),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                ),
                              ) : Text(
                                "RM0.00",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                ),
                              ),
                            ),
                          ]
                      ),

                    ],
                  )
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: SizedBox(
                    height: 48,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                        onPressed: () async{
                          var params = "";
                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          for(var i = 0; i < _cartidList.length; i++) {
                            params = params + ("cart_id[" + i.toString() + "]=" + _cartidList[i].toString() + "&");
                          }

                          //_addrId = prefs.getInt('addr_id');
                          _bankId = prefs.getInt('bank_id');

                          params = params + "address_id=" + _addrId.toString();
                          params = params + "&bank_id=" + _bankId.toString();
                          print(params);

                          if(_bankId == null){
                            showAlertToast('Please select fpx banking.');
                          }else{
                            sharedPref.save('paid_amount', "RM${myr.format(model.totalNettR())}");
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebViewPayment(Constants.postCheckout+params, prefs.getString('token'), _bank, model.totalNettR().toStringAsFixed(2))));
                          }
                        },
                        color: Colors.deepOrange.shade600,
                        child: Text(
                          "Place Order",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      )
                    )
              ),
            ),
          ],
        ),
      );

    });
  }

  orderedItem(MainScopedModel model){
    return Padding(
        padding: const EdgeInsets.all(7),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: model.cartResume.length,
          itemBuilder: (context, index) {
            var data = model.cartResume[index];
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
                        color: Colors.white,
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
                                  data.company_name,
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
                              itemCount: data.cart_products.length,
                              itemBuilder: (context, index) {
                                var cart = data.cart_products[index];
                                var hrgOri = double.tryParse(cart.price);
                                var hrgShip = double.tryParse(data.courier_charges);

                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
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
                                                    imageUrl: cart.main_image,
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
                                                          cart.name,
                                                          style: GoogleFonts.lato(
                                                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,),
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                              //mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Expanded(
                                                                  child: cart.ispromo == '1' ? Text(
                                                                    'RM' + myr.format(double.tryParse(cart.promo_price.toString())),
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,),
                                                                    ),
                                                                  ) : Text(
                                                                    'RM' +myr.format(hrgOri),
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
                                                            'Delivery:  RM' +myr.format(hrgShip),
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
