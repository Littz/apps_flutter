import 'dart:async';
import 'package:edagang/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network('https://shopapp.e-dagang.asia/api/welcome'),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "INTRODUCTION",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
        ),
        description: "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        styleDescription: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        pathImage: "assets/lg_edagang.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        title: "PENCIL",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
        ),
        description: "Ye indulgence unreserved connection alteration appearance",
        styleDescription: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        pathImage: "assets/lg_edagang.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
        ),
        description:"Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        styleDescription: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        pathImage: "assets/lg_edagang.png",
        backgroundColor: Colors.white,

      ),
    );

  }

  void onDonePress() {
// Do what you want
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      colorSkipBtn: Colors.red,
      onSkipPress: this.onDonePress,
      colorDoneBtn: Colors.red,
      onDonePress: this.onDonePress,
      colorActiveDot: Colors.red,
      colorDot: Colors.grey,

    );
  }
}