import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final themeData = CartsiniThemeProvider.get();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/ed_logo_grey.png', height: 150,),
          Text('No listing at the moment.',
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
            ),
          ),
        ],
      ),

    );
  }
}
