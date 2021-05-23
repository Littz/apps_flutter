import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/cart_checkout.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCartPage extends StatefulWidget {
  final int tabcontroler;
  ShopCartPage({this.tabcontroler});

  @override
  _ShopCartPageState createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Map<dynamic, dynamic> responseBody;
  var listCartId = new List<int>();

  @override
  initState() {
    FirebaseAnalytics().logEvent(name: 'Cartsini_Cart_page',parameters:null);
    super.initState();
    listCartId = List();
  }

  Widget merchantRow(String title, String displayAmount) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(3),
            child: Text(
              title,
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(3),
            child: Text(
              '('+displayAmount+')',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
              ),
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model){
      return WillPopScope(key: _scaffoldKey, onWillPop: () {
        Navigator.of(context).pushReplacementNamed("/ShopIndex");
        return null;
      },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'My Cart ',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18,),
                    ),
                  ),
                  new Text(
                    '('+model.getCartotal().toString()+')',
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
          body: model.isLoading3 ? buildCircularProgressIndicator() : model.getCartotal() > 0 ? _cartItems(model) : _emptyContent(),
          //body: _cartItems(model),
          bottomNavigationBar: model.cartList.length > 0 ? _buildBottomNavigationBar() : null,
        )
      );
    });
  }

  _cartItems(MainScopedModel model) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: model.cartList.length,
          itemBuilder: (context, index) {
            var data = model.cartList[index];
            listCartId.add(data.id);

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
                                padding: EdgeInsets.all(0),
                                child: merchantRow(
                                    data.company_name.toUpperCase(),
                                    data.cart_products.length > 1 ? data.cart_products.length.toString() + ' Items' : data.cart_products.length.toString() + ' Item'
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

                                String qty_text = cart.quantity;
                                int quantity = int.parse(cart.quantity);
                                return Stack(
                                  children: <Widget>[
                                    Container(
                                      //padding: EdgeInsets.all(5.0),
                                        margin: EdgeInsets.only(left: 0, right: 0, bottom: 5),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width: 65,
                                                    height: 65,
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: CachedNetworkImage(
                                                      placeholder: (context, url) => Container(
                                                        width: 40,
                                                        height: 40,
                                                        color: Colors.transparent,
                                                        child: CupertinoActivityIndicator(radius: 15,),
                                                      ),
                                                      imageUrl: cart.main_image,
                                                      fit: BoxFit.scaleDown,
                                                      width: 56,
                                                      height: 56,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            padding: EdgeInsets.only(left: 2, right: 2, top: 0),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      cart.name,
                                                                      textAlign: TextAlign.left,
                                                                      style: GoogleFonts.lato(
                                                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                                                      ),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 2,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 5,),
                                                                  SizedBox(
                                                                    height: 18,
                                                                    child: FlatButton(
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: new BorderRadius.circular(1.0),
                                                                      ),
                                                                      color: Colors.transparent,
                                                                      child: Text('Delete',
                                                                          style: GoogleFonts.lato(
                                                                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.red),
                                                                          ),
                                                                      ),
                                                                      highlightColor: Colors.grey,
                                                                      splashColor: Colors.grey,
                                                                      onPressed: () {
                                                                        model.removeProduct(int.parse(cart.cart_id),int.parse(cart.product_id));
                                                                      },
                                                                    ),
                                                                  )

                                                                ]
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.only(left: 2, right: 2, top: 0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: cart.ispromo == '1' ?
                                                                  Container(
                                                                      //alignment: Alignment.topLeft,
                                                                      child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                              child: Text(
                                                                                "RM${double.parse(cart.promo_price).toStringAsFixed(2)}",
                                                                                style: GoogleFonts.lato(
                                                                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.red),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 2),
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                              child: Text(
                                                                                "RM${hrgOri.toStringAsFixed(2)}" ?? "RM0.00",
                                                                                style: GoogleFonts.lato(
                                                                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade600, decoration: TextDecoration.lineThrough),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]
                                                                      )
                                                                  ) : Container(
                                                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                                                    child: Text(
                                                                      "RM${hrgOri.toStringAsFixed(2)}" ?? "RM0.00",
                                                                      style: GoogleFonts.lato(
                                                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.red),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                    //alignment: Alignment.centerRight,
                                                                    //color: Colors.grey.shade300,
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: <Widget>[
                                                                          IconButton(
                                                                            icon: Icon(
                                                                              CupertinoIcons.minus_circled,
                                                                              color: Colors.deepOrange.shade700,),
                                                                            onPressed: () {
                                                                              if(quantity > cart.min_order){
                                                                                setState(() {
                                                                                  quantity = quantity - 1;
                                                                                  print(quantity.toString());
                                                                                  qty_text = quantity.toString();

                                                                                });
                                                                              }
                                                                              model.isLoading4 ? buildCircularProgressIndicator() : model.updCartQty(cartId: int.parse(cart.cart_id), productId: int.parse(cart.product_id), quantity: quantity);

                                                                            },
                                                                          ),
                                                                          Text(qty_text),
                                                                          IconButton(
                                                                            icon: Icon(
                                                                              CupertinoIcons.add_circled,
                                                                              color: Colors.deepOrange.shade700,),
                                                                            onPressed: () {
                                                                              if(quantity <  int.parse(cart.stock)){
                                                                                setState(() {
                                                                                  print(cart.cart_id);
                                                                                  print(cart.product_id);

                                                                                  quantity = quantity + 1;
                                                                                  print(quantity.toString());
                                                                                  qty_text = quantity.toString();

                                                                                });
                                                                              }
                                                                              model.isLoading4 ? buildCircularProgressIndicator() : model.updCartQty(cartId: int.parse(cart.cart_id), productId: int.parse(cart.product_id), quantity: quantity);
                                                                            },
                                                                          ),
                                                                        ]
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.only(left: 7, right: 2, bottom: 0),
                                                            child: cart.have_variation == '1' ? Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  Text(
                                                                    cart.cart_variation[0].variation_name+' : ',
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                                                    ),
                                                                  ),
                                                                  Transform(
                                                                    transform: new Matrix4.identity()..scale(0.8),
                                                                    child: new Chip(
                                                                      label: Text(
                                                                        cart.cart_variation.length > 1 ? cart.cart_variation[1].option_name.toUpperCase() : cart.cart_variation[0].option_name.toUpperCase(),
                                                                        style: GoogleFonts.lato(
                                                                          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.deepOrangeAccent.shade400),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: Colors.white70,
                                                                      shape: StadiumBorder(
                                                                        side: BorderSide(width: 1,color: Colors.deepOrangeAccent.shade400,),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]
                                                            ) : null,
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    flex: 100,
                                                  )
                                                ],
                                              ),
                                            ]
                                        )
                                    ),

                                  ],
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

  _buildBottomNavigationBar() {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model){
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(2.5),
        height: 56.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(top: 5, right: 10),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: model.getTotalCourier() != null ? Text(
                          "Shipping :  RM${model.getTotalCourier().toStringAsFixed(2)}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                          ),
                        ) : Text(
                          "Shipping :  RM0.00",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                          ),
                        ),
                      ),
                    ),*/
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Subtotal",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: RichText(
                                text: TextSpan(
                                  text: 'RM',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: model.getTotalCost().toStringAsFixed(2),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
                                        ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              )
                            ),
                          ],
                        )
                      )
                    ),
                  ],
                )
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: RaisedButton(
                  onPressed: () async {
                    print(listCartId);
                    List<String> cartIdListString = listCartId.map((i)=>i.toString()).toSet().toList();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setStringList('list_cartid', cartIdListString);
                    prefs.setDouble('subtotal', model.getTotalCost());
                    Navigator.push(context, SlideRightRoute(page: CheckoutActivity()));
                    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CheckoutActivity()));
                  },
                  color: Colors.green.shade600,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Check Out",
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

  _emptyContent() {
    return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 80,),
              Icon(CupertinoIcons.shopping_cart ,
                color: Colors.red.shade500, size: 50,),
              //Image.asset('images/ic_qrcode3.png', width: 26, height: 26,),
              SizedBox(height: 20,),
              Text(
                "You don't have any purchased item in your cart.",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),
                ),
              ),
              new FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/ShopIndex");
                },
                child: new Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Text(
                      "Start shopping",
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
