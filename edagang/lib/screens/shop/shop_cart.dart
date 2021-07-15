import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/cart_checkout.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/shipping_address.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
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
  final myr = new NumberFormat("#,##0.00", "en_US");
  SharedPref sharedPref = SharedPref();

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
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          /*Container(
            margin: EdgeInsets.all(3),
            child: Text(
              '('+displayAmount+')',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
              ),
            ),
          )*/
        ]
    );
  }

  showStatusToast(String mesej, bool sts) {
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
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainScopedModel model){
      return WillPopScope(onWillPop: () {
        Navigator.of(context).pushReplacementNamed("/ShopIndex");
        return null;
      },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: false,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'My Cart ',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
                    ),
                  ),
                  new Text(
                    '('+model.getCartotal().toString()+')',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 14,
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
        padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
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
                        borderRadius: BorderRadius.all(Radius.circular(1)),
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
                            padding: EdgeInsets.only(left: 5, right: 0),
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
                                      //padding: EdgeInsets.only(left: 24),
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: InkWell(
                                        onTap: () {
                                          sharedPref.save("prd_id", cart.product_id);
                                          sharedPref.save("prd_title", cart.name);
                                          Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                                        },
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(right: 10, top: 0),
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints: BoxConstraints(),
                                                    alignment: Alignment.topLeft,
                                                    icon: Icon(CupertinoIcons.trash,color: Colors.red.shade600,),
                                                    onPressed: () {
                                                      model.removeProduct(int.parse(cart.cart_id),int.parse(cart.product_id));
                                                    },
                                                  )
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(right: 5, top: 2),
                                                  width: 60,
                                                  height: 60,
                                                  alignment: Alignment.topLeft,
                                                  color: Colors.white,
                                                  child: ClipRRect(
                                                    borderRadius: new BorderRadius.circular(5.0),
                                                    child: CachedNetworkImage(
                                                      alignment: Alignment.topLeft,
                                                      placeholder: (context, url) => Container(
                                                        color: Colors.transparent,
                                                        child: Image.asset('assets/images/ed_logo_greys.png',width: 50,height: 50,),
                                                      ),
                                                      imageUrl: cart.main_image,
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    )
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(2.0),
                                                    alignment: Alignment.topLeft,
                                                    child: Column(
                                                      //mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.only(left: 2, right: 10, top: 0),
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
                                                        Container(
                                                          padding: EdgeInsets.only(left: 2, right: 2, bottom: 0),
                                                          child: cart.have_variation == '1' ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Text(
                                                                cart.cart_variation[0].variation_name+' : ',
                                                                style: GoogleFonts.lato(
                                                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                                                ),
                                                              ),
                                                              Text(
                                                                cart.cart_variation.length > 1 ? cart.cart_variation[1].option_name : cart.cart_variation[0].option_name,
                                                                style: GoogleFonts.lato(
                                                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                                                ),
                                                              ),
                                                            ]
                                                          ) : null,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 0, right: 2, top: 0),
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
                                                                          "RM${myr.format(double.parse(cart.promo_price))}",
                                                                          style: GoogleFonts.lato(
                                                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 2),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 4),
                                                                        child: Text(
                                                                          "RM${myr.format(hrgOri)}" ?? "RM0.00",
                                                                          style: GoogleFonts.lato(
                                                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]
                                                                  )
                                                                ) : Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                                                  child: Text(
                                                                    "RM${myr.format(hrgOri)}" ?? "RM0.00",
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
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
                                                                          model.isLoading4 ? buildCircularProgressIndicator() : model.updCartQty(cartId: int.parse(cart.cart_id), productId: int.parse(cart.product_id), quantity: quantity);
                                                                        }else if(quantity < cart.min_order){
                                                                          showStatusToast('Minumum quantity order is '+qty_text, false);
                                                                        }


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
                                                                          model.isLoading4 ? buildCircularProgressIndicator() : model.updCartQty(cartId: int.parse(cart.cart_id), productId: int.parse(cart.product_id), quantity: quantity);
                                                                        }else if(quantity >  int.parse(cart.stock)){
                                                                          showStatusToast('No more stock available.', false);
                                                                        }

                                                                      },
                                                                    ),
                                                                  ]
                                                                )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        /*Container(
                                                          padding: EdgeInsets.only(left: 2, right: 2, bottom: 0),
                                                          child: int.parse(cart.stock) == int.parse(qty_text) ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: <Widget>[
                                                                Text(
                                                                  cart.cart_variation[0].variation_name+' : ',
                                                                  style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  cart.cart_variation.length > 1 ? cart.cart_variation[1].option_name : cart.cart_variation[0].option_name,
                                                                  style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                                                  ),
                                                                ),
                                                              ]
                                                          ) : null,
                                                        ),*/
                                                      ],
                                                    ),
                                                  ),
                                                  //flex: 100,
                                                )
                                              ],
                                            ),
                                          ]
                                        )
                                      )
                                    ),
                                    /*Positioned(
                                      top: 0,
                                      left: -5,
                                      child: Container(
                                        child: IconButton(
                                          constraints: BoxConstraints(),
                                          alignment: Alignment.center,
                                          icon: Icon(LineAwesomeIcons.trash_o,color: Colors.red.shade600,),
                                          onPressed: () {
                                            model.removeProduct(int.parse(cart.cart_id),int.parse(cart.product_id));
                                          },
                                        )
                                      ),
                                    )*/
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
        height: 48.0,
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
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Subtotal: ",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,),
                                ),
                                //textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text: TextSpan(
                                  text: ' RM',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: myr.format(model.getTotalCost()),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
                                        ),
                                    ),
                                  ],
                                ),
                                //textAlign: TextAlign.center,
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
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                  onPressed: () async{
                    print(listCartId);
                    List<String> cartIdListString = listCartId.map((i)=>i.toString()).toSet().toList();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setStringList('list_cartid', cartIdListString);
                    prefs.setDouble('subtotal', model.getTotalCost());

                    if(model.addrList.length > 0) {
                      prefs.setInt('ship_id', model.addrList[0].id);
                      Navigator.push(context, SlideRightRoute(page: CheckoutActivity()));
                      model.updShipping(addr_id: model.addrList[0].id);
                    }else{
                      Navigator.push(context, SlideRightRoute(page: ShippingAddress()));
                    }
                  },
                  color: Colors.deepOrange.shade600,
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



class ChkBoxPage extends StatefulWidget {
  @override
  _ChkBoxPageState createState() => _ChkBoxPageState();
}

class _ChkBoxPageState extends State<ChkBoxPage> {
  bool isSelectionMode = false;
  List<Map> staticData = MyData.data;
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Item'),
      ),
      body: ListView.builder(
        itemBuilder: (builder, index) {
          Map data = staticData[index];
          selectedFlag[index] = selectedFlag[index] ?? false;
          bool isSelected = selectedFlag[index];

          return ListTile(
            onLongPress: () => onLongPress(isSelected, index),
            onTap: () => onTap(isSelected, index),
            title: Text("${data['name']}"),
            subtitle: Text("${data['email']}"),
            leading: _buildSelectIcon(isSelected, data),
          );
        },
        itemCount: staticData.length,
      ),
      floatingActionButton: _buildSelectAllButton(),
    );
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _buildSelectIcon(bool isSelected, Map data) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text('${data['id']}'),
      );
    }
  }

  Widget _buildSelectAllButton() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: _selectAll,
        child: Icon(
          isFalseAvailable ? Icons.done_all : Icons.remove_done,
        ),
      );
    } else {
      return null;
    }
  }

  void _selectAll() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }
}

class MyData {
  static List<Map> data = [
    {
      "id": 1,
      "name": "Marchelle",
      "email": "mailward0@hibu.com",
      "address": "57 Bowman Drive"
    },
    {
      "id": 2,
      "name": "Modesty",
      "email": "mviveash1@sohu.com",
      "address": "2171 Welch Avenue"
    },
    {
      "id": 3,
      "name": "Maure",
      "email": "mdonaghy2@dell.com",
      "address": "4623 Chinook Circle"
    },
    {
      "id": 4,
      "name": "Myrtie",
      "email": "mkilfoyle3@yahoo.co.jp",
      "address": "406 Kings Road"
    },
    {
      "id": 5,
      "name": "Winfred",
      "email": "wvenn4@baidu.com",
      "address": "2444 Pawling Lane"
    },
    {
      "id": 6,
      "name": "Josi",
      "email": "jfarnall5@moonfruit.com",
      "address": "0 Hoepker Lane"
    },
    {
      "id": 7,
      "name": "Carma",
      "email": "cludlom6@elpais.com",
      "address": "01349 Logan Terrace"
    },
    {
      "id": 8,
      "name": "Carol",
      "email": "ccastiglio7@ameblo.jp",
      "address": "67871 Raven Pass"
    },
    {
      "id": 9,
      "name": "Nicolas",
      "email": "ncorse8@hud.gov",
      "address": "32212 Banding Alley"
    },
    {
      "id": 10,
      "name": "Blondie",
      "email": "bgreensall9@usatoday.com",
      "address": "217 South Trail"
    },
    {
      "id": 11,
      "name": "Filbert",
      "email": "fburlea@tumblr.com",
      "address": "3 Mayfield Pass"
    },
    {
      "id": 12,
      "name": "Imojean",
      "email": "iwalbrookb@zdnet.com",
      "address": "91904 Fieldstone Lane"
    },
    {
      "id": 13,
      "name": "Rochell",
      "email": "rsharplesc@drupal.org",
      "address": "46 Schmedeman Place"
    },
    {
      "id": 14,
      "name": "Fayina",
      "email": "fwellwoodd@mapquest.com",
      "address": "1 Anderson Street"
    },
    {
      "id": 15,
      "name": "Dilan",
      "email": "dgethinge@wsj.com",
      "address": "87297 High Crossing Alley"
    },
    {
      "id": 16,
      "name": "Berkie",
      "email": "bmousbyf@si.edu",
      "address": "5611 Colorado Drive"
    },
    {
      "id": 17,
      "name": "Aliza",
      "email": "aabelsg@de.vu",
      "address": "56 Dunning Way"
    },
    {
      "id": 18,
      "name": "Gene",
      "email": "gernih@slashdot.org",
      "address": "0479 Jay Court"
    },
    {
      "id": 19,
      "name": "Devland",
      "email": "dlindbladi@geocities.jp",
      "address": "0971 Johnson Terrace"
    },
    {
      "id": 20,
      "name": "Leigh",
      "email": "larlidgej@xinhuanet.com",
      "address": "430 Hanover Park"
    },
    {
      "id": 21,
      "name": "Annamaria",
      "email": "agerreyk@jiathis.com",
      "address": "03345 Larry Junction"
    },
    {
      "id": 22,
      "name": "Agace",
      "email": "arubenczykl@meetup.com",
      "address": "119 Stuart Alley"
    },
    {
      "id": 23,
      "name": "Ninette",
      "email": "nhuglim@npr.org",
      "address": "746 Calypso Plaza"
    },
    {
      "id": 24,
      "name": "Sosanna",
      "email": "scopestaken@cloudflare.com",
      "address": "81924 North Parkway"
    },
    {
      "id": 25,
      "name": "Millard",
      "email": "mcullumo@jigsy.com",
      "address": "6215 Hoepker Park"
    },
    {
      "id": 26,
      "name": "Alden",
      "email": "aconvillep@seattletimes.com",
      "address": "13 Mayfield Pass"
    },
    {
      "id": 27,
      "name": "Roderich",
      "email": "rquinlanq@feedburner.com",
      "address": "58 Dawn Parkway"
    },
    {
      "id": 28,
      "name": "Jesse",
      "email": "jblackallerr@github.com",
      "address": "286 Stone Corner Drive"
    },
    {
      "id": 29,
      "name": "Grace",
      "email": "gmaytoms@reverbnation.com",
      "address": "52817 Shelley Place"
    },
    {
      "id": 30,
      "name": "Lurline",
      "email": "lvennardt@goo.ne.jp",
      "address": "8 Cherokee Plaza"
    },
    {
      "id": 31,
      "name": "Bernie",
      "email": "bsworderu@wordpress.com",
      "address": "6223 Harbort Street"
    },
    {
      "id": 32,
      "name": "Dana",
      "email": "dknevetv@linkedin.com",
      "address": "6 Waxwing Alley"
    },
    {
      "id": 33,
      "name": "Emelita",
      "email": "emckernonw@hugedomains.com",
      "address": "823 Kings Alley"
    },
    {
      "id": 34,
      "name": "Mikey",
      "email": "maldissx@cyberchimps.com",
      "address": "83570 Lerdahl Park"
    },
    {
      "id": 35,
      "name": "Hortensia",
      "email": "hgarmony@guardian.co.uk",
      "address": "9 Ryan Drive"
    },
    {
      "id": 36,
      "name": "Nicolis",
      "email": "nfallsz@privacy.gov.au",
      "address": "414 Nelson Park"
    },
    {
      "id": 37,
      "name": "Christoforo",
      "email": "cdunan10@salon.com",
      "address": "342 Division Point"
    },
    {
      "id": 38,
      "name": "Abie",
      "email": "acoulter11@unblog.fr",
      "address": "04 4th Trail"
    },
    {
      "id": 39,
      "name": "Lowell",
      "email": "lguihen12@mit.edu",
      "address": "177 Banding Parkway"
    },
    {
      "id": 40,
      "name": "Sherye",
      "email": "sardron13@dagondesign.com",
      "address": "3720 Killdeer Way"
    },
    {
      "id": 41,
      "name": "Laura",
      "email": "lruit14@mlb.com",
      "address": "9818 Moland Avenue"
    },
    {
      "id": 42,
      "name": "Carlen",
      "email": "cjacquet15@indiatimes.com",
      "address": "5191 Bay Way"
    },
    {
      "id": 43,
      "name": "Mirabel",
      "email": "methridge16@businesswire.com",
      "address": "027 West Junction"
    },
    {
      "id": 44,
      "name": "Shellie",
      "email": "sffrenchbeytagh17@theatlantic.com",
      "address": "075 Merrick Place"
    },
    {
      "id": 45,
      "name": "Rossie",
      "email": "rpecht18@craigslist.org",
      "address": "6127 Barnett Terrace"
    },
    {
      "id": 46,
      "name": "Adelle",
      "email": "amichelotti19@google.com.hk",
      "address": "0763 Vidon Alley"
    },
    {
      "id": 47,
      "name": "Welby",
      "email": "wtremblet1a@rediff.com",
      "address": "968 Oneill Street"
    },
    {
      "id": 48,
      "name": "Julianne",
      "email": "jchessun1b@princeton.edu",
      "address": "9 Arizona Pass"
    },
    {
      "id": 49,
      "name": "Hilly",
      "email": "hgodlonton1c@slideshare.net",
      "address": "264 Buell Center"
    },
    {
      "id": 50,
      "name": "Velma",
      "email": "vomullaney1d@hud.gov",
      "address": "61 Mosinee Crossing"
    },
    {
      "id": 51,
      "name": "Maisie",
      "email": "mlewty1e@prweb.com",
      "address": "7 Oriole Crossing"
    },
    {
      "id": 52,
      "name": "Teirtza",
      "email": "tsturge1f@amazon.co.uk",
      "address": "5 Vidon Crossing"
    },
    {
      "id": 53,
      "name": "Karrah",
      "email": "kneaves1g@yolasite.com",
      "address": "6018 Lotheville Hill"
    },
    {
      "id": 54,
      "name": "Packston",
      "email": "plemanu1h@harvard.edu",
      "address": "4751 Iowa Hill"
    },
    {
      "id": 55,
      "name": "Kary",
      "email": "kflips1i@php.net",
      "address": "53139 Magdeline Road"
    },
    {
      "id": 56,
      "name": "Megan",
      "email": "mrivelon1j@businesswire.com",
      "address": "56 Hallows Place"
    },
    {
      "id": 57,
      "name": "Banky",
      "email": "bwratten1k@google.ru",
      "address": "2726 Prairieview Park"
    },
    {
      "id": 58,
      "name": "Darsie",
      "email": "dmossop1l@homestead.com",
      "address": "59274 Elmside Place"
    },
    {
      "id": 59,
      "name": "Blane",
      "email": "bburleton1m@hibu.com",
      "address": "9935 3rd Crossing"
    },
    {
      "id": 60,
      "name": "Bald",
      "email": "bbuckerfield1n@slashdot.org",
      "address": "848 Pankratz Parkway"
    },
    {
      "id": 61,
      "name": "Maire",
      "email": "mrichardot1o@eepurl.com",
      "address": "3691 Hudson Avenue"
    },
    {
      "id": 62,
      "name": "Cherie",
      "email": "cshurlock1p@tinypic.com",
      "address": "00 Derek Road"
    },
    {
      "id": 63,
      "name": "Pen",
      "email": "plevy1q@infoseek.co.jp",
      "address": "2839 Ruskin Crossing"
    },
    {
      "id": 64,
      "name": "Spike",
      "email": "swakeling1r@nasa.gov",
      "address": "54 Superior Court"
    },
    {
      "id": 65,
      "name": "Esteban",
      "email": "esmoth1s@rakuten.co.jp",
      "address": "26640 Muir Court"
    },
    {
      "id": 66,
      "name": "Gabriele",
      "email": "gabramamovh1t@webeden.co.uk",
      "address": "7 Arapahoe Center"
    },
    {
      "id": 67,
      "name": "Randy",
      "email": "rcaveau1u@timesonline.co.uk",
      "address": "3752 Del Mar Place"
    },
    {
      "id": 68,
      "name": "Tabb",
      "email": "todd1v@360.cn",
      "address": "07 Coleman Lane"
    },
    {
      "id": 69,
      "name": "Ginnifer",
      "email": "ggerman1w@netscape.com",
      "address": "3414 Michigan Court"
    },
    {
      "id": 70,
      "name": "Corie",
      "email": "cbarnardo1x@freewebs.com",
      "address": "69066 Magdeline Place"
    },
    {
      "id": 71,
      "name": "Ravi",
      "email": "rlawful1y@elpais.com",
      "address": "0580 Forster Lane"
    },
    {
      "id": 72,
      "name": "Adelheid",
      "email": "aplenderleith1z@cdbaby.com",
      "address": "1307 Oak Terrace"
    }
  ];
}