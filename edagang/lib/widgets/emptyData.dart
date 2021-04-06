import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final themeData = CartsiniThemeProvider.get();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/icons/empty.png', height: 120,),
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
