import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';


class ProductCardItem extends StatelessWidget {
  SharedPref sharedPref = SharedPref();
  final Product product;
  final myr = new NumberFormat("#,##0.00", "en_US");

  ProductCardItem({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return _buildProductItemCard(context, product);
  }

  _buildProductItemCard(BuildContext context, Product product) {

    double price = double.tryParse(product.price.toString()) ?? 0;
    assert(price is double);
    //var hrgOri = price.toStringAsFixed(2);
    var hrgOri = myr.format(price);

    double price2 = double.tryParse(product.promoPrice.toString()) ?? 0;
    assert(price2 is double);
    var hrgPromo = myr.format(price2);

    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          ),
        ),
        elevation: 1.7,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          ),
          onTap: () {
            sharedPref.save("prd_id", product.id.toString());
            sharedPref.save("prd_title", product.name);
            Navigator.push(context, SlideRightRoute(page: ProductShowcase()));

          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 190,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                    child: CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Image.asset('assets/images/ed_logo_greys.png', width: 120,
                          height: 120,),
                      ),
                      errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                      fit: product.merchant_name.contains('NI HSIN') || product.merchant_name.contains('Hijrah Water') ? BoxFit.fitWidth : BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 7,),
                Container(
                  margin: EdgeInsets.only(left: 7.0,right: 7.0,bottom: 2.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    product.name,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500,),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 7.0,right: 7.0,bottom: 2.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    product.merchant_name,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(left: 7.0,right: 7.0,bottom: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: product.ispromo == '1' ?
                          Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 0),
                                      child: Text(
                                        "RM"+hrgPromo,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500,),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 0),
                                      child: Text(
                                        "RM"+hrgOri,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                        ),
                                      ),
                                    ),
                                  ])
                          ) : Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              "RM"+hrgOri,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: product.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 24, width: 24,) : Container(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
              ]
          ),
        ),
      ),
    );
    /*return InkWell(
      onTap: () {
        sharedPref.save("prd_id", product.id.toString());
        sharedPref.save("prd_title", product.name);
        Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 190,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                child: Hero(
                  tag: 'imgGrid',
                  child: CachedNetworkImage(
                    imageUrl: product.image ?? '',
                    placeholder: (context, url) => Container(
                      width: 30,
                      height: 30,
                      color: Colors.transparent,
                      child: CupertinoActivityIndicator(radius: 15,),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/icons/ic_image_error.png',
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.fitHeight,
                    height: 190,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7,),
            Container(
              height: 25,
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerLeft,
              child: Text(
                'title name',
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]
      ),
    );*/
  }

}


class PopularCardItem extends StatelessWidget {
  SharedPref sharedPref = SharedPref();
  final Product product;
  final myr = new NumberFormat("#,##0.00", "en_US");

  PopularCardItem({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return _buildProductItemCard(context, product);
  }

  _buildProductItemCard(BuildContext context, Product product) {

    double price = double.tryParse(product.price.toString()) ?? 0;
    assert(price is double);
    //var hrgOri = price.toStringAsFixed(2);
    var hrgOri = myr.format(price);

    double price2 = double.tryParse(product.promoPrice.toString()) ?? 0;
    assert(price2 is double);
    var hrgPromo = myr.format(price2);

    return Container(
      width: 125,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0),),
        ),
        elevation: 1.7,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          ),
          onTap: () {
            sharedPref.save("prd_id", product.id.toString());
            sharedPref.save("prd_title", product.name);
            Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
            FirebaseAnalytics().logEvent(name: 'Cartsini_popular_'+product.name,parameters:null);
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 135,
                  width: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                    child: CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Image.asset('assets/images/ed_logo_greys.png', width: 80,
                          height: 80,),
                      ),
                      errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                      fit: BoxFit.cover,
                      height: 135,
                    ),
                  ),
                ),

                Container(
                  width: 125,
                  padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
                  alignment: Alignment.bottomLeft,
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: product.ispromo == '1' ?
                                Container(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 0),
                                            child: Text(
                                              "RM"+hrgPromo,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 0),
                                            child: Text(
                                              "RM"+hrgOri,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                              ),
                                            ),
                                          ),
                                        ]
                                    )
                                ) : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    "RM"+hrgOri,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              alignment: Alignment.topLeft,
                              child: product.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 24, width: 24,) : Container(),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

}


class PromoCardItem extends StatelessWidget {
  SharedPref sharedPref = SharedPref();
  final Product product;
  final myr = new NumberFormat("#,##0.00", "en_US");

  PromoCardItem({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return _buildProductItemCard(context, product);
  }

  _buildProductItemCard(BuildContext context, Product product) {

    double price = double.tryParse(product.price.toString()) ?? 0;
    assert(price is double);
    //var hrgOri = price.toStringAsFixed(2);
    var hrgOri = myr.format(price);

    double price2 = double.tryParse(product.promoPrice.toString()) ?? 0;
    assert(price2 is double);
    var hrgPromo = myr.format(price2);

    return Container(
      width: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0),),
        ),
        elevation: 1.0,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          ),
          onTap: () {
            sharedPref.save("prd_id", product.id.toString());
            sharedPref.save("prd_title", product.name);
            Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 140,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                  child: CachedNetworkImage(
                    imageUrl: product.image ?? '',
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Image.asset('assets/images/ed_logo_greys.png', width: 90,
                        height: 90,),
                    ),
                    errorWidget: (context, url, error) => Icon(LineAwesomeIcons.file_image_o, size: 44, color: Color(0xffcecece),),
                    fit: product.merchant_name.contains('NI HSIN') ? BoxFit.fitWidth : BoxFit.cover,
                    height: 140,
                  ),
                ),
              ),

              Container(
                width: 150,
                padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 7.0),
                alignment: Alignment.bottomLeft,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500,),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: product.ispromo == '1' ?
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    child: Text(
                                      "RM"+hrgPromo,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    child: Text(
                                      "RM"+hrgOri,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                      ),
                                    ),
                                  ),
                                ]
                              )
                            ) : Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                "RM"+hrgOri,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500,),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: product.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 24, width: 24,) : Container(),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

}


class VrCardItem extends StatelessWidget {
  final Image vrimg;
  final String label;
  final String sublabel, footer;

  VrCardItem({
    @required this.vrimg,
    @required this.label,
    @required this.sublabel,
    @required this.footer,
  })  : assert(vrimg != null),
        assert(label != null),
        assert(sublabel != null),
        assert(footer != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0),),
        ),
        elevation: 1.7,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 175,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                  child: Image(image: vrimg.image, height: 175, width: MediaQuery.of(context).size.width, fit: BoxFit.fill,),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.bottomLeft,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600,),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        sublabel,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        footer,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.w600,),
                        ),
                      ),

                    ]
                ),
              ),
            ]
        ),
      ),
    );
  }
}

