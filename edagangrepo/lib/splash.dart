import 'dart:async';
import 'package:edagang/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
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
          /*title: "SMARTBIZ",
          styleTitle: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
          ),
          description: "An excellent online platform promoting products, services, businesses and events, transforming visibility into business opportunities.",
          styleDescription: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),*/

          pathImage: "assets/sample.gif",
          //backgroundColor: Colors.white,
          //foregroundImageFit: BoxFit.fill,
          heightImage: 676,
          widthImage: 380
      ),
    );
    /*slides.add(
      new Slide(
        title: "FINTOOLS",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
        ),
        description: "Offers a range of financial services on an online platform to meet any business or personal financial requirements.",
        styleDescription: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        pathImage: "assets/images/intro_fintools.png",
        backgroundColor: Colors.white,
        foregroundImageFit: BoxFit.fill,
        heightImage: 257,
        widthImage: 380
      ),
    );*/
    /*slides.add(
      new Slide(
          title: "CARTSINI",
          styleTitle: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
          ),
          description: "Traditional marketplace but with a totally modern online shopping experience that broadens the horizon for both customers and providers of products and services.",
          styleDescription: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),

          pathImage: "assets/images/intro_cartsini.png",
          backgroundColor: Colors.white,
          foregroundImageFit: BoxFit.fill,
          heightImage: 257,
          widthImage: 380
      ),
    );
    slides.add(
      new Slide(
          title: "SMARTBIZ",
          styleTitle: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
          ),
          description: "An excellent online platform promoting products, services, businesses and events, transforming visibility into business opportunities.",
          styleDescription: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),

          pathImage: "assets/images/intro_smartbiz.png",
          backgroundColor: Colors.white,
          foregroundImageFit: BoxFit.fill,
          heightImage: 257,
          widthImage: 380
      ),
    );
    slides.add(
      new Slide(
          title: "GOILMU",
          styleTitle: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
          ),
          description: "The go-to for career transformation and new opportunities through training and upskilling for professionals and non professionals using immersive tools and techniques.",
          styleDescription: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),

          pathImage: "assets/images/intro_goilmu.png",
          backgroundColor: Colors.white,
          foregroundImageFit: BoxFit.fill,
          heightImage: 257,
          widthImage: 380
      ),
    );
    slides.add(
      new Slide(
          title: "BLURB",
          styleTitle: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
          ),
          description: "A virtual business world to conduct business-as -usual but within an immersive online ecosystem, enhancing the business process in pursuit of success.",
          styleDescription: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),

          pathImage: "assets/images/intro_blurb.png",
          backgroundColor: Colors.white,
          foregroundImageFit: BoxFit.fill,
          heightImage: 257,
          widthImage: 380
      ),
    );
    slides.add(
      new Slide(
          title: "VIRTUAL TRADE",
          styleTitle: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red.shade600),
          ),
          description: "The day-to-day office environment is transformed into a virtual office to seamlessly continue the usiness experience and enhance the effectiveness to pursue success. Also provides a virtual Convention and Exhibition Centre.",
          styleDescription: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),

          pathImage: "assets/images/intro_vrtrade.png",
          backgroundColor: Colors.white,
          foregroundImageFit: BoxFit.fill,
          heightImage: 257,
          widthImage: 380
      ),
    );*/

  }

  void onDonePress() {
// Do what you want
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      colorSkipBtn: Color(0xffDD0000),
      onSkipPress: this.onDonePress,
      colorDoneBtn: Color(0xffDD0000),
      onDonePress: this.onDonePress,
      colorActiveDot: Color(0xffDD0000),
      colorDot: Colors.grey,

    );
  }
}