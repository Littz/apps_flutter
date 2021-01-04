import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/acc_address.dart';
import 'package:edagang/screens/shop/webview_fpx.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckoutActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CheckoutActivityState();
  }
}

class CheckoutActivityState extends State<CheckoutActivity> {
  var selectedAddr = new Address();
  var selectedBank = new OnlineBanking();
  String _addr = '';
  int _addrId = 0;
  String _bank = '';
  int _bankId = 0;
  bool _btnEnabled = false;
  var listCartId = new List<int>();

  List<String> cartidList = new List();
  List<int> _cartidList = new List();
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    _loadCartId();
    _loadAddress();
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

  _loadCartId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartidList = (prefs.getStringList('list_cartid') ?? List<String>()) ;
      _cartidList = cartidList.map((i)=> int.parse(i)).toSet().toList();
      print('Cart Id list => $_cartidList');
      print(_cartidList.length);
    });
  }

  List<GestureDetector> _buildAddressListItems(MainScopedModel model){
    int index = 0;
    var addrs = model.addrList;
    return addrs.map((addr){
      var boxDecoration=index % 2 == 0?
      new BoxDecoration(color: Colors.white):
      new BoxDecoration(color: Colors.white);
      if (selectedAddr == addr) {
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
        child: Stack(
            children: <Widget>[
              new Container(
                child: Column(
                  children: <Widget>[
                    new Container(
                      width: 235,
                      //padding: const EdgeInsets.all(7),
                      margin: EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 3.0),
                      child: new Text(
                        addr.name,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    new Container(
                        width: 235,
                        //padding: const EdgeInsets.only(left: 7, right: 7, bottom: 7.0),
                        margin: EdgeInsets.only(left: 8, right: 8, bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.location,
                              color: Colors.deepOrange.shade600,
                              size: 18,
                            ),
                            Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  child:  new Text(
                                    addr.full_address,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                )
                            ),
                          ],
                        )
                    ),
                    new Container(
                      width: 235,
                      //padding: const EdgeInsets.all(7),
                      margin: EdgeInsets.only(left: 8, right: 8, bottom: 3.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.mail,
                                      color: Colors.deepOrange.shade600,
                                      size: 18,
                                    ),
                                    Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(2.0),
                                          child: new Text(
                                            addr.email ?? 'na',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(height: 3,),
                            new Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.phone,
                                      color: Colors.deepOrange.shade600,
                                      size: 18,
                                    ),
                                    Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(2.0),
                                          child: new Text(
                                            addr.mobile_no ?? 'na',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            ),

                          ]
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 7.0),
                            child: Container(
                                width: 235,
                                margin: EdgeInsets.only(left: 8, right: 8, top: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 17,
                                      child: OutlineButton(
                                        shape: StadiumBorder(),
                                        color: Colors.transparent,
                                        borderSide: BorderSide(color: Colors.orangeAccent.shade700),
                                        //icon: Icon(CupertinoIcons.add, size: 24, color: Colors.orangeAccent.shade700,),
                                        child: Text('Edit',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orangeAccent.shade700),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => new EditAddress(addrid: addr.id, nama: addr.name, fuladdr: addr.address, state: addr.state_id, city: addr.city_id, zipcode: addr.postcode, phone: addr.mobile_no)),
                                          );

                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      child: selectedAddr == addr ? Icon(
                                        CupertinoIcons.check_mark_circled_solid,
                                        color: Colors.green.shade600,
                                        size: 30,
                                      ) : null,
                                    ),
                                  ],
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ]
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
              _addrId = addr.id;
              _addr = addr.full_address;
            });
            prefs.setInt('addr_id', _addrId);
            prefs.setString('full_addr', _addr);

            print("You\'ve selected ${prefs.getInt('addr_id').toString()+' // '+prefs.getString('full_addr')}");

            setState(() {
              selectedAddr = addr;
              //params= "";
              print("addrID >>> "+prefs.getInt('addr_id').toString());
              //params = params + "address_id=" + _addrId.toString();
              //MaterialPageRoute route = MaterialPageRoute(builder: (context) => ListBanking2());
              //Navigator.push(context, route);
            });

          }
      );
      return gestureDetector;
    }).toList();
  }

  _loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('addr_id');
    prefs.remove('full_addr');
    setState(() {
      _addrId = (prefs.getInt('addr_id') ?? null);
      _addr = (prefs.getString('full_addr') ?? null);
      print(_addrId.toString());
      print(_addr);
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
              ),


              /*CachedNetworkImage(
                placeholder: (context, url) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                  child: CupertinoActivityIndicator(radius: 15,),
                ),
                imageUrl: Constants.urlImage+bank.bank_logo,
                fit: BoxFit.fitWidth,
                width: 205,
              ),*/
            ),

            /*Container(
              alignment: Alignment.center,
              height: 40,
              child: selectedBank == bank ? Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: Colors.green.shade600,
                size: 32,
              ) : null,
            ),*/
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
          title: new Text(
            'Checkout',
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff202020)),
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade300,
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
                        'Shipping Address.',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
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
                          'Please select shipping address.',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 7, top: 3,),
                        child: SizedBox(
                          height: 20,
                          child: RaisedButton(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => AddNewAddress(frm: 'chk')));},
                            child: Text("New Address", textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orangeAccent.shade700),
                              ),
                            ),
                          )
                        ),
                      ),

                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: _buildAddressListItems(model),
                  ),
                ),

                SizedBox(height: 30,),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7, right: 7),
                      child: Text(
                        'Online Banking.',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
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
                          'Please select online banking.',
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
                SizedBox(height: 0,),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: new Text('',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
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
        padding: EdgeInsets.only(left: 2.0, right: 2.0),
        //margin: EdgeInsets.all(4.0),
        height: 48.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Total :",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                        margin: EdgeInsets.only(bottom: 0),
                        child: RichText(
                          text: TextSpan(
                            text: 'RM',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                            children: <TextSpan>[
                              TextSpan(text: model.totalNett().toStringAsFixed(2),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                                  ),
                               ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        )
                        /*child: Text(
                          "RM${model.totalNett().toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade600),
                        )*/
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RaisedButton(
                    onPressed: () async{
                      var params = "";
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      for(var i = 0; i < _cartidList.length; i++) {
                        params = params + ("cart_id[" + i.toString() + "]=" + _cartidList[i].toString() + "&");
                      }

                      _addrId = prefs.getInt('addr_id');
                      _bankId = prefs.getInt('bank_id');

                      params = params + "address_id=" + _addrId.toString();
                      params = params + "&bank_id=" + _bankId.toString();
                      print(params);

                      if(_addrId == null) {
                        showAlertToast('Please select address.');
                      } else if(_bankId == null){
                        showAlertToast('Please select online banking.');
                      }else{
                        sharedPref.save('paid_amount', "RM${model.totalNett().toStringAsFixed(2)}");
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebViewContainer(Constants.postCheckout+params, prefs.getString('token'), _bank, model.totalNett().toStringAsFixed(2), _addr )));
                      }
                    },
                    color: Colors.green.shade600,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Place Order",
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

    });
  }

}
