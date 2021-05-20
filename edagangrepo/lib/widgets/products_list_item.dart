import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ProductsListItem extends StatelessWidget {
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  final Product product1;
  final Product product2;

  ProductsListItem({
    @required this.product1,
    @required this.product2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildProductItemCard(context, product1),
        product2 == null ? Container() : _buildProductItemCard(context, product2),
      ],
    );
  }

  _buildProductItemCard(BuildContext context, Product product) {

    double price = double.tryParse(product.price.toString()) ?? 0;
    assert(price is double);
    var hrgOri = price.toStringAsFixed(2);

    double price2 = double.tryParse(product.promoPrice.toString()) ?? 0;
    assert(price2 is double);
    var hrgPromo = price2.toStringAsFixed(2);

    return Container(
      width: MediaQuery.of(context).size.width / 2.35,
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
                  width: MediaQuery.of(context).size.width / 2.35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
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
                      fit: BoxFit.cover,
                      height: 190,
                    ),
                  ),
                ),

                SizedBox(height: 7,),
                Container(
                  width: MediaQuery.of(context).size.width / 2.35,
                  margin: EdgeInsets.only(left: 7.0,right: 7.0,bottom: 2.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    product.name,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500,),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.35,
                  margin: EdgeInsets.only(left: 7.0,right: 7.0,bottom: 2.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    product.merchant_name,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: MediaQuery.of(context).size.width / 2.35,
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
                        child: product.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 15, width: 24,) : Container(),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductShowcase()));
      },
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
          child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Card(
                  color: Colors.white,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 190,
                        width: MediaQuery.of(context).size.width / 2.35,
                        margin: EdgeInsets.all(1),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          height: 190,
                          imageUrl: product.image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 30,
                            height: 30,
                            color: Colors.transparent,
                            child: CupertinoActivityIndicator(radius: 15,),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.35,
                        margin: EdgeInsets.only(left: 4.0,right: 4.0,bottom: 2.0),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          product.name,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500,),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.35,
                        margin: EdgeInsets.only(left: 4.0,right: 4.0,bottom: 2.0),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          product.merchant_name,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.35,
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
                                                textStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600,),
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
                                      textStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600,),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: product.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 15, width: 24,) : Container(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );*/
  }


}
