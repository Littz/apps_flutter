import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Widget buildCircularProgressIndicator() {
  return Center(
    child: Container(
        width: 75,
        height: 75,
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xff2877EA)),
              strokeWidth: 1.7,
            ),
            SizedBox(height: 5.0,),
            Text('Loading...',
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontSize: 13),
              ),
            ),
          ],
        )
    ),
  );
}

Widget buildCupertinoProgressIndicator() {
  return Center(
    child: Container(
      width: 50,
      height: 50,
      color: Colors.transparent,
      child: CupertinoActivityIndicator(
        radius: 22,
      ),
    ),
  );
}