import 'package:edagang/screens/biz/search.dart';
import 'package:edagang/screens/shop/search.dart';
import 'package:edagang/screens/upskill/search.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

Widget searchBar(BuildContext context) {
  return Container(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            splashColor: Colors.deepOrange.shade600,
            onTap: () {
              FirebaseAnalytics().logEvent(name: 'Smartbiz_search',parameters:null);
              Navigator.push(context, SlideRightRoute(page: SearchList()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 5),
              decoration: BoxDecoration(
                //border: Border.all(width: 1, color: Color(0xff2877EA),),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey.shade200,
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],*/
              ),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.transparent,
                    ),
                    height: 37,
                    width: 40,
                    child: Center(
                      child: Icon(LineAwesomeIcons.search,
                        color: Color(0xff084B8C),),

                    ),
                  ),
                  SizedBox(width: 3,),
                  Expanded(
                    child: Text(' Search',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Quicksand",
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
    ),
  );
}

Widget searchBar2(BuildContext context) {
  return Container(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            splashColor: Colors.deepOrange.shade600,
            onTap: () {
              Navigator.push(context, SlideRightRoute(page: SearchList2()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 5),
              decoration: BoxDecoration(
                //border: Border.all(width: 1, color: Color(0xff2877EA),),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey.shade200,
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],*/
              ),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.transparent,
                    ),
                    height: 37,
                    width: 40,
                    child: Center(
                      child: Icon(LineAwesomeIcons.search,
                        color: Color(0xff084B8C),),

                    ),
                  ),
                  SizedBox(width: 3,),
                  Expanded(
                    child: Text(' Search',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Quicksand",
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
    ),
  );
}

Widget searchBarShop(BuildContext context) {
  return Container(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            splashColor: Colors.deepOrange.shade600,
            onTap: () {
              Navigator.push(context, SlideRightRoute(page: SearchList3()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 5),
              decoration: BoxDecoration(
                //border: Border.all(width: 1, color: Color(0xff2877EA),),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey.shade200,
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],*/
              ),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.transparent,
                    ),
                    height: 37,
                    width: 40,
                    child: Center(
                      child: Icon(LineAwesomeIcons.search,
                        color: Colors.black87,),

                    ),
                  ),
                  SizedBox(width: 3,),
                  Expanded(
                    child: Text(' Search',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Quicksand",
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
    ),
  );
}