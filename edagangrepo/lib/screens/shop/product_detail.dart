import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/blur_icon.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/photo_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_indicator/page_indicator.dart';
import "package:scoped_model/scoped_model.dart";
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductShowcase extends StatefulWidget {
  @override
  _ProductShowcasePageState createState() => _ProductShowcasePageState();
}

class _ProductShowcasePageState extends State<ProductShowcase> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<dynamic, dynamic> responseBody;
  SharedPref sharedPref = SharedPref();
  final double bottomSheetCornerRadius = 50;
  bool _isVariationLoading = true;
  List<ProductVariation> listProdVar = [];
  int _value = 0;
  var variationVal = List<String>();
  var optionVal = List<String>();
  BuildContext mcontext;
  String _id = "";
  String _title = "";
  String _dl = "";
  String qnty_txt = "";
  String varName;
  int quantity = 1;
  final myr = new NumberFormat("#,##0.00", "en_US");

  var listVariation = new List<int>();
  var listOption = new List<int>();

  int pid,minOrder;
  double price,promoPrice;
  String name,catid,delivery,ispromo,summary,details,image,merchant_id,merchant_name,stock,have_variation;
  List images = List();
  List reviews = List();
  bool isLoading = false;

  loadPrefs() async {
    try {
      String id = await sharedPref.read("prd_id");
      String title = await sharedPref.read("prd_title");

      setState(() {
        _id = id;
        _title = title ?? '';

        print("product ID : "+_id);
        print("product NAME : "+_title);
      });

    } catch (Excepetion ) {
      print("error!");
    }
  }

  getDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      String id = await sharedPref.read("prd_id");
      String title = await sharedPref.read("prd_title");

      setState(() {
        _id = id;
        _title = title ?? '';

        print("product ID : "+_id);
        print("product NAME : "+_title);

        http.get(
          Constants.shopSingleProduct+id,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
        ).then((response) {
          responseBody = json.decode(response.body);
          var resBody = json.decode(response.body);
          print('RESPONSE');
          print(resBody);

          setState(() {

            List<ProductVariation> prodVariation = [];
            resBody["data"]["product"]["product_variation"].forEach(
                  (prodVariasi) {

                List<VariationOption> varOption = [];
                prodVariasi["variation_option"].forEach(
                        (varOpt) {
                      varOption.add(
                        new VariationOption(
                          id: varOpt["id"],
                          variation_id: varOpt["variation_id"].toString(), // after migration -> int to string
                          option_name: varOpt["option_name"],
                          unit_price: varOpt["unit_price"].toString(), // after migration -> int to string
                          stock: varOpt["stock"].toString() == null ? '0' : varOpt["stock"].toString(), // after migration -> int to string
                          image_url: varOpt["image_url"],
                        ),
                      );
                    }
                );

                prodVariation.add(
                  new ProductVariation(
                    id: prodVariasi["id"],
                    product_id: prodVariasi["product_id"].toString(), // after migration -> int to string
                    variation_name: prodVariasi["variation_name"],
                    have_image: prodVariasi["have_image"],
                    variation_option: varOption,
                  ),
                );

              },
            );

            List<Images> imagesOfProductList = [];
            resBody['data']['product']['product_image'].forEach(
                  (newImage) {
                imagesOfProductList.add(
                  new Images(
                    id: newImage["id"],
                    productId: newImage["product_id"].toString(),  // after migration -> int to string
                    imageURL: Constants.urlImage+newImage["image_url"],
                  ),
                );
              },
            );

            List<Video> videoOfProductList = [];
            resBody['data']['product']['product_video'].forEach(
                  (newImage) {
                videoOfProductList.add(
                  new Video(
                    id: newImage["id"],
                    productId: newImage["product_id"].toString(),  // after migration -> int to string
                    link: Constants.urlImage+newImage["video_url"],
                  ),
                );
              },
            );

            List<Review> reviewsList = [];
            resBody['data']['product']['product_review'].forEach(
                  (newRview) {
                reviewsList.add(
                  new Review(
                      user_id: newRview["user_id"].toString(),  // after migration -> int to string
                      product_id: newRview["product_id"].toString(), // after migration -> int to string
                      review_text: newRview["review_text"],
                      rating: newRview["rating"].toString(), // after migration -> int to string
                      userName: newRview["user"]["fullname"]
                  ),
                );
              },
            );
            var data = Product(
              id: resBody['data']['product']['id'],
              name: resBody['data']['product']['name'],
              ispromo: resBody['data']['product']['ispromo'].toString(),  // after migration -> int to string
              price: resBody['data']['product']["price"].toString() != null ? resBody['data']['product']["price"].toString() : '0.00',  // after migration -> int to string
              promoPrice: resBody['data']['product']["promo_price"].toString() != null ? resBody['data']['product']["promo_price"].toString() : '0.00',  // after migration -> int to string
              delivery: resBody['data']['product']['delivery_included'],
              summary: resBody['data']['product']['summary'],
              details: resBody['data']['product']['details'],
              image: Constants.urlImage+resBody['data']['product']['main_image'],
              images: imagesOfProductList,
              hasVariants: resBody['data']['product']['have_variation'],
              stock: resBody['data']['product']['stock'].toString(), // after migration -> int to string
              minOrder: resBody['data']['product']['min_order'],
              merchant_name: resBody['data']['product']['merchant']['company_name'],
              merchant_id: resBody['data']['product']['merchant_id'],
              reviews: reviewsList,
              variations: prodVariation,
            );

            pid = data.id ?? '';
            name = data.name ?? '';
            ispromo = data.ispromo ?? '';
            price = double.tryParse(data.price.toString()) ?? '';
            promoPrice = double.tryParse(data.promoPrice.toString()) ?? '';
            delivery = data.delivery ?? '';
            summary = data.summary ?? '';
            details = data.details ?? '';
            image = data.image ?? '';
            images = data.images ?? '';
            merchant_name = data.merchant_name ?? '';
            merchant_id = data.merchant_id ?? '';
            reviews = data.reviews ?? '';
            stock = data.stock ?? "0";
            minOrder = data.minOrder ?? 0;
            have_variation = data.hasVariants;
            listProdVar = data.variations;
            quantity = minOrder;
            qnty_txt = minOrder.toString();
            //varName = listProdVar[0].variation_name;

            print('CART PARAMS |||||||||||||||||||||||');
            print(stock);
            print(promoPrice);
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
    getDetails();
    super.initState();
    loadPrefs();
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
    final coverImageHeightCalc = MediaQuery.of(context).size.height / 2.6 + bottomSheetCornerRadius;
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
          ),
        ),
        color: Colors.white.withOpacity(0.8),
      ) : CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: Colors.white,
            expandedHeight: coverImageHeightCalc,
            leading: Hero(
              tag: "back",
              child: InkWell(
                onTap: () {Navigator.pop(context);},
                splashColor: Colors.deepOrange.shade100,
                highlightColor: Colors.deepOrange.shade100,
                child: BlurIcon(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              )
            ),
            flexibleSpace: new FlexibleSpaceBar(
              background: _productImages(),
            ),
            actions: <Widget>[
              Hero(
                tag: "share",
                child: InkWell(
                  onTap: () async {
                    await FlutterShare.share(
                      title: 'Cartsini',
                      text: '',
                      linkUrl: 'https://shopapp.e-dagang.asia/product/'+pid.toString(),
                      chooserTitle: _title,
                    );
                  },
                  splashColor: Colors.deepOrange.shade100,
                  highlightColor: Colors.deepOrange.shade100,
                  child: BlurIcon(
                    icon: Icon(Icons.share,color: Colors.white,),
                  ),
                )
              ),
              _shoppingCartBadge(),
            ],
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              new Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 5.0),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(name ?? "",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(left: 0.0, top: 5.0),
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListMerchant(merchant_id,merchant_name)));
                                  },
                                  child: new Text(
                                    merchant_name ?? "",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Constants.darkAccent, decoration: TextDecoration.underline),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                            ),
                          ]
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            child: ispromo == '1' ?
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    'RM'+myr.format(promoPrice),
                                    //ispromo == '1' ? 'RM'+promoPrice.toString() ?? 'RM0.00' : 'RM'+price.toString() ?? 'RM0.00',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w600, color: Constants.darkAccent),
                                    )
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "RM"+myr.format(price),
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade600, decoration: TextDecoration.lineThrough),
                                    ),
                                  ),
                                ]
                              ) :
                              new Text(
                                'RM'+myr.format(price),
                                //ispromo == '1' ? 'RM'+promoPrice.toString() ?? 'RM0.00' : 'RM'+price.toString() ?? 'RM0.00',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w600, color: Constants.darkAccent),
                                ),
                              ),
                          ),

                          new Row(
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(right: 7.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Qty :",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                                      ),
                                    ),
                                    SizedBox(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(CupertinoIcons.minus_circled, color: Colors.deepOrange.shade700,),
                                              onPressed: () {

                                                if (quantity > minOrder) {
                                                  setState(() {
                                                    quantity = quantity - 1;
                                                    qnty_txt = quantity.toString();
                                                  });
                                                }
                                              },
                                            ),
                                            Text(qnty_txt),
                                            IconButton(
                                              icon: Icon(CupertinoIcons.add_circled, color: Colors.deepOrange.shade700,),
                                              onPressed: () {

                                                if(quantity < int.parse(stock)) {
                                                  setState(() {
                                                    quantity = quantity + 1;
                                                    qnty_txt = quantity.toString();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      child: delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 24, width: 37,) : Container(),
                    ),

                    new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0),
                      child: _productVariation(),
                    ),

                    new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              //Icon(Icons.description),
                              Text('Summary',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                              ),
                              //Icon(CupertinoIcons.chevron_forward, color: Colors.black,
                              //),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: _productSpecification(),
                          ),
                          SizedBox(height: 10,),
                          new Divider(
                            height: 1.0,
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              //Icon(Icons.folder_special),
                              Text('Details',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: _productDescription(),
                          ),
                          SizedBox(height: 10,),
                          new Divider(
                            height: 1.0,
                          ),
                          SizedBox(height: 10,),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text('Ratings & Reviews  ('+reviews.length.toString()+')',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('Ratings & Reviews  ('+reviews.length.toString()+')',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                                  ),
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.deepOrange.shade100,
                                splashColor: Colors.deepOrange.shade100,
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'See all ',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xffF45432)),
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.right_chevron,
                                      size: 17,
                                      color: Color(0xffF45432),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _productRatingReview(),
                          SizedBox(height: 10,),
                          new Divider(height: 1.0,),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
      bottomNavigationBar: isLoading ? null : _buildBottomNavigationBar(),
    );
  }

  getprodVariation(String pid) async {
    setState(() {
      _isVariationLoading = true;
    });

    http.get(
      Constants.shopSingleProduct+pid,
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
    ).then((response) {
      print(response.body);

      responseBody = json.decode(response.body);
      print(responseBody['message']);
      print(responseBody['package']);

      responseBody['data']['product']['product_variation'].forEach((prodVar) {

        List<VariationOption> varOption = [];
        prodVar['variation_option'].forEach((varopt) {
          varOption.add(
            new VariationOption(
                id: varopt['id'],
                variation_id: varopt['variation_id'],
                option_name: varopt['option_name'],
                unit_price: varopt['unit_price'],
                stock: varopt['stock'],
                image_url: varopt['image_url']
            ),
          );
        },
        );

        setState(() {
          listProdVar.add(
              ProductVariation(
                id: prodVar['id'],
                product_id: prodVar['product_id'],
                variation_name: prodVar['variation_name'],
                have_image: prodVar['have_image'],
                variation_option: varOption,
              )
          );
        });
      });

      setState(() {
        _isVariationLoading = false;
      });
    });
  }

  Widget _shoppingCartBadge() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
          return model.isAuthenticated ? model.getCartotal() == 0 ? Hero(
            tag: "cart",
            child: BlurIcon(
              icon: Icon(
                CupertinoIcons.shopping_cart,
                color: Colors.white,
                //size: 24.0,
              ),
            ),
          ) : Badge(
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text(
                model.getCartotal().toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                ),
            ),
            child: Hero(
                tag: "cart",
                child: InkWell(
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ShopCartPage()));
                    Navigator.push(context, SlideRightRoute(page: ShopCartPage()));
                  },
                  splashColor: Colors.deepOrange.shade100,
                  highlightColor: Colors.deepOrange.shade100,
                  child: BlurIcon(
                    icon: Icon(
                      CupertinoIcons.shopping_cart,
                      color: Colors.white,
                      //size: 24.0,
                    ),
                  ),
                )
            ),
          ) : Hero(
              tag: "cart",
              child: InkWell(
                onTap: () {},
                splashColor: Colors.deepOrange.shade100,
                highlightColor: Colors.deepOrange.shade100,
                child: BlurIcon(
                  icon: Icon(
                    CupertinoIcons.shopping_cart,
                    color: Colors.white,
                    //size: 24.0,
                  ),
                ),
              )
          );
        }
    );
  }

  Widget _productImages() {
    if(images.length == 0) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PhotoViewer(imej: image,),)
          );
        },
        child: Hero(
          tag: "Cartsini",
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              width: 50,
              height: 50,
              color: Colors.transparent,
              child: CupertinoActivityIndicator(
                radius: 17,
              ),
            ),
            imageUrl: image ?? "",
            fit: merchant_name.contains('NI HSIN') || merchant_name.contains('Hijrah Water') ? BoxFit.fitWidth : BoxFit.cover,
          ),
        ),
      );
    }else{
      return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: PageIndicatorContainer(
              align: IndicatorAlign.bottom,
              length: images.length,
              indicatorSpace: 8.0,
              padding: EdgeInsets.only(bottom: 10),
              indicatorColor: Colors.grey.shade300,
              indicatorSelectorColor: Colors.deepOrange.shade700,
              shape: IndicatorShape.circle(size: 7),

              child: PageView(
                children: images.map(
                      (image) {
                    return GestureDetector(
                      onTap:  () {
                        Navigator.push(context, SlideRightRoute(page: PhotoViewer(imej: image.imageURL,)));
                      },
                      child: Hero(
                          tag: "Cartsini",
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.transparent,
                              child: CupertinoActivityIndicator(
                                radius: 17,
                              ),
                            ),
                            imageUrl: image.imageURL,
                            fit: merchant_name.contains('NI HSIN') || merchant_name.contains('Hijrah Water') ? BoxFit.fitWidth : BoxFit.cover,
                          ),
                        ),
                    );
                  },
                ).toList(),
              ),
            )
        ),
      );
    }
  }

  Widget _productVariation() {
    if(have_variation == 'Y'){
      return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
          for (int i = 0; i < listProdVar.length; i++) ...[
      Padding(
      padding: EdgeInsets.only(left: 0),
    child: Text(
    listProdVar[i].variation_name+' :',
    style: GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
    ),
    ),
    ),

    new Wrap(
    direction: Axis.horizontal,
    spacing: 4.0,
    runSpacing: 1.0,
    children: <Widget>[
    for (int j = 0; j < listProdVar[i].variation_option.length; j++)
    Padding(
    padding: EdgeInsets.only(right: 0),
    child: ChoiceChip(
    label: Text(
    listProdVar[i].variation_option[j].option_name.length == 1 ? ' '+listProdVar[i].variation_option[j].option_name.toUpperCase()+' '  : listProdVar[i].variation_option[j].option_name.toUpperCase(),
    style: GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 12,
    color: _value == listProdVar[i].variation_option[j].id ? Colors.deepOrange.shade600 : Colors.grey.shade600,
    fontWeight: _value == listProdVar[i].variation_option[j].id ? FontWeight.bold : FontWeight.w500,),
    ),
    ),
    pressElevation: 5,
    selected: _value == listProdVar[i].variation_option[j].id,
    selectedColor: Colors.white,
    backgroundColor: Colors.grey.shade200,
    onSelected: (bool value) {
    setState(() {
    varName = listProdVar[i].variation_name;
    _value = value ? listProdVar[i].variation_option[j].id : null;
    print('Selected variation >>>>>>>>>>>>>>>>>>>>>');
    print('variation['+i.toString()+'][variation_id]='+listProdVar[i].id.toString());
    print('variation['+i.toString()+'][option_id]='+_value.toString());
    });
    },
    shape: StadiumBorder(
    side: BorderSide(color: _value == listProdVar[i].variation_option[j].id ? Colors.deepOrange.shade600 : Colors.grey.shade600),
    ),
    labelStyle: TextStyle(
    color: _value == listProdVar[i].variation_option[j].id ? Colors.deepOrange.shade600 : Colors.grey.shade600,
    fontWeight: _value == listProdVar[i].variation_option[j].id ? FontWeight.bold : null,
    ),

    ),
    )
    ]
    ),
    ],
    ]
    ),
    );
    }else{
    return Container();
    }
  }

  Widget _productDescription() {
    if(details == null) {
      return Container(
        child: Text(
          "This product has no detail.",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
      );
    }else{
      return new SingleChildScrollView(
        child: htmlText(details),
      );
    }
  }

  Widget _productSpecification() {
    if(summary == null) {
      return Container(
        child: Text(
          "This product has no summary.",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
      );
    }else{
      return new SingleChildScrollView(
        child: htmlText(summary),
      );
    }
  }

  Widget _productRatingReview() {
    if(reviews.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Text(
            "This product has no review.",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      );
    }else{
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: new SingleChildScrollView(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: reviews.length > 3 ? 3 : reviews.length,
              itemBuilder: (context, index) {
                var data = reviews[index];
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          maxRadius: 40,
                          child: Icon(CupertinoIcons.person_fill, size: 36,  color: Colors.grey.shade600,),
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        data.userName,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Text(
                                          data.review_text,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ]
                        ),
                      )
                    ]
                );
              },
            ),
          )
      );

    }
  }

  Widget _buildBottomNavigationBar() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
          return Container(
              padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: RaisedButton(
                        onPressed: () {
                          var params = "";
                          if (int.parse(stock) > 0) {
                            if (model.isAuthenticated) {
                              if(have_variation == 'Y') {
                                if(_value == 0){
                                  showStatusToast('Please select '+listProdVar[0].variation_name, false);
                                }else {
                                  for (var i = 0; i < listProdVar.length; i++) {
                                    params = params + ("variation[" + i.toString() + "][variation_id]=" + listProdVar[i].id.toString() + "&");
                                    params = params + ("variation[" + i.toString() + "][option_id]=" + _value.toString() + "&");
                                  }

                                  params = params + "product_id=" + int.parse(_id).toString();
                                  params = params + "&quantity=" + quantity.toString();

                                  model.addProduct(param: params);
                                  //showStatusToast('Adding '+name+' to cart', true);
                                  Navigator.of(context).pushReplacementNamed("/ShopCart");
                                }
                              }else{
                                params = params + "product_id=" + int.parse(_id).toString();
                                params = params + "&quantity=" + quantity.toString();

                                model.addProduct(param: params);
                                showStatusToast('Added '+name+' to cart.', true);
                                //Navigator.of(context).pushReplacementNamed("/ShopCart");
                              }
                              print(params);
                            }else{
                              //_showAuthDialog();
                              Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                            }
                          }
                        },
                        color: Colors.green.shade600,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                int.parse(stock) > 0 ? 'Add to Cart' : 'Out of Stock',
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
                ]
              )

          );
        }
    );
  }
}

