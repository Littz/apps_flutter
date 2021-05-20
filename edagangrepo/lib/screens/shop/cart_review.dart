import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/cart_history.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:shared_preferences/shared_preferences.dart';

class MyReview extends StatefulWidget {

  @override
  _MyReviewState createState() => new _MyReviewState();
}

class _MyReviewState extends State<MyReview> {

  @override
  void initState() {
    super.initState();
  }

  Widget _showLoginFirst() {
    return Center(
      //title: new Text("Conversation Request"),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              "images/cartsini_logo.png",
              height: 120.0,
              //width: 210.0,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(height: 10,),
            new Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: new RaisedButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => SignInOrRegister()));},
                child: new Text(
                  "SIGN-IN",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontWeight: FontWeight.w700,),
                  ),
                ),
                color: Colors.deepOrange,
                textColor: Colors.white,
                elevation: 5.0,
              ),
            ),
            new Column(
              children: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context){return Register();}));
                  },
                  child: new Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: new Text(
                        "SIGN-UP an account",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 15, decoration: TextDecoration.underline),
                        ),
                      )
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Color(0xff084B8C),
              ),
              title: new Text(
                'My Reviews',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 18, color: Colors.black,),
                ),
              ),
            ),
            backgroundColor: Color(0xffEEEEEE),
            body: model.isAuthenticated ?

            /*model.historyOrders.length > 0 ?
            CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: model.historyOrders.length,
                      itemBuilder: (context, index) {
                        var data = model.historyOrders[index];
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Card(
                              elevation: 1,
                              child: Container(
                                margin: EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: data.order_group.length,
                                        itemBuilder: (context, index) {
                                          var pstatus = data.status;
                                          var ogrp = data.order_group[index];

                                          return Container(
                                              padding: EdgeInsets.only(bottom: 7),
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 0, right: 0),
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
                                                                            padding: EdgeInsets.all(2),
                                                                            width: 70,
                                                                            height: 70,
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
                                                                                  width: 70,
                                                                                  height: 70,
                                                                                  fit: BoxFit.cover,
                                                                                )
                                                                            ),
                                                                          ),
                                                                          Expanded(

                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: <Widget>[
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.all(0),
                                                                                        child: Text(
                                                                                          'Order# '+data.order_no,
                                                                                          style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.all(0),
                                                                                        child: Text(
                                                                                          'Date: '+data.payment_txn_date,
                                                                                          style: GoogleFonts.lato(
                                                                                            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ]),
                                                                                    SizedBox(height: 2,),
                                                                                    Text(
                                                                                      item.product_name,
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                                                                      ),
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                    Container(
                                                                                      padding: EdgeInsets.only(top: 2),
                                                                                      child: Text(
                                                                                        ogrp.merchant_name,
                                                                                        style: GoogleFonts.lato(
                                                                                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 3,),
                                                                                    Text(
                                                                                      pstatus == '1' ? 'Delivered' : 'Cancelled',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.lato(
                                                                                        textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, fontStyle: FontStyle.italic),
                                                                                      ),
                                                                                    )
                                                                                  ]
                                                                                ),
                                                                              ),

                                                                            ]),


                                                                          )
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
                                  ],
                                ),
                              )
                          ),
                        );
                      },
                    ),
                  )
                ])
              )
            ]) : */

            Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.mood_bad, color: Colors.grey, size: 50,),
                  SizedBox(height: 20,),
                  Text(
                    'You don\'t have any purchases to review',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(0, 0, 0, 0.8),),
                    ),
                  ),
                ],
              )
            ) : _showLoginFirst(),
          );
        }
    );
  }

  Widget dateStatus(String txndate, String status) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
        padding: EdgeInsets.all(0),
        child: Text(
          status,
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
          ),
        ),
      )
    ]);
  }

}


class WriteReview extends StatefulWidget {
  final String id,img,name,odrid,merchant, deli;
  WriteReview(this.id, this.img, this.name, this.odrid, this.merchant, this.deli);

  @override
  _WriteReviewState createState() => new _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final Map<String, dynamic> _formData = {'review': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final reviewKey = GlobalKey<ScaffoldState>();
  TextEditingController _reviewController = TextEditingController();
  int _dropdownValue;
  bool _isLoader = false;

  @override
  void initState() {
    super.initState();
  }

  void _submitReview(MainScopedModel model, String pid, String oid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoader = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }
    _formKey.currentState.save();

    Map<dynamic, dynamic> rvwData = Map();
    rvwData = {
      'product_id': pid,
      'review_text': _formData['review'],
      'rating': _dropdownValue.toString(),
      'order_id': oid,
      'review_image': '',
    };

    print('REVIEW PARAMETER VALUE:+++++++++++++++++++');
    print(pid);
    print(oid);
    print(_dropdownValue.toString());
    print(_formData['review']);

    http.post('https://shopapp.e-dagang.asia/api/product/review',
        headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
        body: JSON.jsonEncode(rvwData)
    ).then((response) {
      model.fetchOrderHistoryResponse();
      print('PRODUCT REVIEW >>>>>');
      print(response.statusCode.toString());
      print(response.body);
      Navigator.pushReplacement(context, SlideRightRoute(page: CartHistory()));
    });

    setState(() {
      _isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: new Text(
                'Write Review',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff202020),),
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            body: Center(
                child: Form(
                  key: _formKey,
                  autovalidate: false,
                  child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
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
                              width: 70,
                              height: 70,
                              child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.transparent,
                                      child: CupertinoActivityIndicator(radius: 15,),
                                    ),
                                    imageUrl: Constants.urlImage+widget.img,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            Expanded(
                              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          widget.name,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.merchant,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.deli,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]
                                  ),
                                ),
                                SizedBox(width: 5),
                              ]),
                            )
                          ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Rating :  ",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black,),
                            ),
                          ),
                          DropdownButton<int>(
                            value: _dropdownValue,
                            icon: Icon(CupertinoIcons.star_fill, color: Colors.deepOrange.shade500,),
                            dropdownColor: Colors.grey.shade100,
                            iconSize: 20,
                            elevation: 0,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black,),
                            ),
                            underline: Container(
                              height: 1.5,
                              color: Colors.deepOrange.shade500,
                            ),
                            onChanged: (int newValue) {
                              setState(() {
                                _dropdownValue = newValue;
                              });
                            },
                            items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString(),
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff202020),),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerRight,
                            child: rate_level(_dropdownValue),
                          )
                        ],
                      ),
                      TextFormField(
                        //controller: _reviewController,
                        maxLines: 7,
                        decoration: InputDecoration(
                          hintText: "What do you think of this product?",
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please write some review.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['review'] = value;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          color: Colors.deepOrange.shade500,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 80),
                            child: Text(
                              "Submit Review",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_dropdownValue != null) {
                              print(_dropdownValue.toString());
                              print(_formData['review']);
                              _submitReview(model,widget.id,widget.odrid);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Rating.',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700,),
                                      ),
                                    ),
                                    content: Text('Please rate this product',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text('Close',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600,),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              /*reviewKey.currentState.showSnackBar(SnackBar(
                              content: Text("Need to add rating!"),
                            ));*/
                            }
                          },
                        ),
                      ),

                    ],
                  ),
                )
                )
            )
          );
        });
  }

  Widget rate_level(int rate){
    String txt;
    if(rate == 5) {
      return Text(
        "Delightful",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        ),
      );
    }else if(rate == 4) {
      return Text(
        "Satisfactory",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        ),
      );
    }else if(rate == 3) {
      return Text(
        "Good",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        ),
      );
    }else if(rate == 2) {
      return Text(
        "Poor",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        ),
      );
    }else if(rate == 1) {
      return Text(
        "Very Poor",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        ),
      );
    }else{
      return Text(
        "",
      );
    }
  }

}