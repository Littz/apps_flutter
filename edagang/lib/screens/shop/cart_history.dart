import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/cart_review.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/progressIndicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class CartHistory extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CartHistoryOrderPageState();
  }
}

class _CartHistoryOrderPageState extends State<CartHistory> {

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Cartsini_Cart_History',parameters:null);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, model)
    {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: false,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Color(0xff084B8C),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "My Orders",
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17 , fontWeight: FontWeight.w600,),
            ),
          ),
        ),
        backgroundColor: Color(0xffEEEEEE),
        body: model.isLoadingOrder ? buildCircularProgressIndicator() : CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.all(5),
                  child: HistoryOrdersBody(),
                )
              ])
          )
        ]),
      );
    });
  }
}

class HistoryOrdersBody extends StatelessWidget {
  BuildContext context;
  MainScopedModel model;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return _buildOrderList();
      },
    );
  }

  _buildOrderList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: model.historyOrders.length == 0 ? _emptyContent() : ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: model.historyOrders.length,
        itemBuilder: (context, index) {
          var data = model.historyOrders[index];
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              elevation: 3,
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    dateStatus('Order# '+data.order_no, 'Date: '+data.payment_txn_date),
                    Padding(
                      padding: EdgeInsets.only(left: 0, right: 5, top: 5, bottom: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: data.order_group.length,
                        itemBuilder: (context, index) {
                          var pstatus = data.status;
                          var ogrp = data.order_group[index];
                          var kurier = ogrp.courier_company;
                          var courcaj = double.tryParse(ogrp.courier_charges);
                          return Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Text(
                                      ogrp.merchant_name,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, right: 0),
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) => Divider(
                                      color: Colors.grey,
                                      indent: 0.0,
                                      thickness: 0.7,
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
                                                padding: EdgeInsets.only(right: 5, top: 2),
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
                                                    imageUrl: Constants.urlImage+item.main_image,
                                                    width: 30,
                                                    height: 30,
                                                    fit: BoxFit.cover,
                                                  )
                                                ),
                                              ),

                                              Expanded(
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
                                                                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,),
                                                                ),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  'RM' +hrga.toStringAsFixed(2)+'  x  '+item.quantity,
                                                                  style: GoogleFonts.lato(
                                                                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          alignment: Alignment.bottomRight,
                                                          child: prdReview(data.status, item.reviewed, item.product_id,item.main_image,item.product_name,data.id,ogrp.merchant_name,kurier)
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(top: 3),
                                                      child: data.status == '1' ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text('Courier:',
                                                            style: GoogleFonts.lato(
                                                              textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Text('RM'+courcaj.toStringAsFixed(2)+'\n'+kurier,
                                                            style: GoogleFonts.lato(
                                                              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                                            ),
                                                          ),
                                                        ]
                                                      ) : Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text('Courier:',
                                                              style: GoogleFonts.lato(
                                                                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Text('RM'+courcaj.toStringAsFixed(2),
                                                              style: GoogleFonts.lato(
                                                                textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                    ),
                                                  ]
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
                      padding: EdgeInsets.only(left: 0, right: 5, top: 8, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                'Total: RM'+data.total_price,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: odrStatus(data.status.toString()),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }


  Widget prdReview(String status, String review, String pid, String img, String pname, int id, String merchant, String kurier) {
    switch (status) {
      case '1':
        {
          switch (review) {
            case "0":
              return RaisedButton(
                shape: StadiumBorder(),
                onPressed: () {
                  Navigator.push(context, SlideRightRoute(page: WriteReview(pid,img,pname,id.toString(),merchant,kurier)));
                },
                child: new Text(
                  "Review",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ),
                color: Colors.deepOrange,
                textColor: Colors.white,
                elevation: 1.0,
                padding: EdgeInsets.all(0.0),
              );
              break;
            default:
              return Text(
                'Reviewed',
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey.shade600),
                ),
              );
              break;
          }
        }
        break;
      default:
        return Container();
        break;
    }
  }

  Widget odrStatus(String value) {
    switch (value) {
      case '1':
        return Text(
          'Delivered',
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green.shade600),
          ),
        );
        break;
      case '0':
        return Text(
          'Unpaid',
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red),
          ),
        );
        break;
      case '6':
        return Text(
          'Cancelled',
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red),
          ),
        );
        break;
      default:
        return Container();
        break;
    }

  }

  Widget dateStatus(String txndate, String status) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        padding: EdgeInsets.all(0),
        child: Text(
          txndate,
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(3),
        child: Text(
          status,
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
          ),
        ),
      )
    ]);
  }

  _emptyContent() {
    return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(CupertinoIcons.shopping_cart, color: Colors.red.shade500, size: 50,),
              //Image.asset('images/ic_qrcode3.png', width: 26, height: 26,),
              SizedBox(height: 20,),
              Text(
                'No purchased item found.',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                ),
              ),
              new FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context){return NewHomePage(1);}));
                },
                child: new Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Text(
                      "CONTINUE SHOPPING",
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

