import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProductCardItem extends StatelessWidget {
  SharedPref sharedPref = SharedPref();
  final Product product;

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
    var hrgOri = price.toStringAsFixed(2);

    double price2 = double.tryParse(product.promoPrice.toString()) ?? 0;
    assert(price2 is double);
    var hrgPromo = price2.toStringAsFixed(2);

    return InkWell(
      onTap: () {
        sharedPref.save("prd_id", product.id.toString());
        sharedPref.save("prd_title", product.name);
        Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
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
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.white,
                    child: Card(
                      color: Colors.white,
                      elevation: 0.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 190,),
                            child: Container(
                              margin: EdgeInsets.all(1),
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                fit: BoxFit.fitHeight,
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
                                errorWidget: (context, url, error) => Icon(CupertinoIcons.photo, size: 36,),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
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
                            margin: EdgeInsets.only(left: 4.0,right: 4.0,bottom: 2.0),
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
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  )
              )
          ),
        ),

      ),

      /*Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 210.0,
                width: MediaQuery.of(context).size.width / 2.2,
                margin: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.transparent,
                    child: CupertinoActivityIndicator(
                      radius: 17,
                    ),
                  ),
                  imageUrl: product.image,
                  fit: BoxFit.fitHeight,
                  height: 200,
                ), //Image.network(product.image),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1),
                        topRight: Radius.circular(1))
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  product.merchant_name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8,),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: product.ispromo == '1' ?
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "RM"+hrgPromo,
                              style: TextStyle(fontSize: 14.0, color: Colors.red),
                            ),
                            SizedBox(height: 2,),
                            Text(
                              "RM"+hrgOri,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ]
                      ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "RM"+hrgOri,
                              style: TextStyle(fontSize: 14.0, color: Colors.red),
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ]
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: product.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 15, width: 24,) : Container(),
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),*/
    );
  }

}
