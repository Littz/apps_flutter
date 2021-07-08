import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String dummyProfilePic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s';
  static List<String> dummyProfilePicList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s',//
    'http://www.azembelani.co.za/wp-content/uploads/2016/07/20161014_58006bf6e7079-3.png',//
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzDG366qY7vXN2yng09wb517WTWqp-oua-mMsAoCadtncPybfQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq7BgpG1CwOveQ_gEFgOJASWjgzHAgVfyozkIXk67LzN1jnj9I&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPxjRIYT8pG0zgzKTilbko-MOv8pSnmO63M9FkOvfHoR9FvInm&s',
    'https://cdn5.f-cdn.com/contestentries/753244/11441006/57c152cc68857_thumb900.jpg',
    'https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg'
  ];

  static Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static String appName = "E-Dagang";
  static String tokenGuest = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjJhN2NiM2U2NTllY2MwMTFlN2JiNjM4MDA3MWJkYWE5OTQxY2I5NzMwNjNmY2RhOGNlYmM1Mzc3ZWNmODM1MDljMGYyMGUwOWFkYzBkZWViIn0.eyJhdWQiOiIzIiwianRpIjoiMmE3Y2IzZTY1OWVjYzAxMWU3YmI2MzgwMDcxYmRhYTk5NDFjYjk3MzA2M2ZjZGE4Y2ViYzUzNzdlY2Y4MzUwOWMwZjIwZTA5YWRjMGRlZWIiLCJpYXQiOjE1NzA5Njg0NzUsIm5iZiI6MTU3MDk2ODQ3NSwiZXhwIjoxNjAyNTkwODc1LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.rYqZDXoFnc-pMZecqieKqmuJG9rWgXKTf-2Ix09dcO52iACHZ-MaxhE1sjfms3VUHv0-klZqa8Q5ZblyqRTX6bWbK02fB28o8Mi0MDJYjjTsa-l6_Us-JxEJZPfaICWGitO6KGQ0kkiD-0l8VSsiBpZPtXOR5mgVCL4Ws15tdJ6bwwGskNcEg02E1EaMf-VdYZrjXpXN7C6Gq8UU73iJsO1NOSvVgfHlwFBbrl4Pby8KoVFYFvmq357wn8uwJiycU0Ggc6zmOe5u51AtoSbKVGoXBNoi80vKGVobUmWfCdYKhEZWth81HQyULQBRY4VvCz9NlfUvKJRs--LLLw0VXSWC3A3GtJKYuMp9adr84hfPSOV9sJE98dzVZwXQH0jkRd_owSq6Cq2daLuKk1SHgzZ_46BpLtTrwCWCeDDYnew-m5M1LJqeS8k96b3JftXtccnjUN1EIiai6MaIiZ9NI9P7oOLKA1H2ycp8eHwwixIsDBCoi_a1NTjOw-z84YeEz5QSUQ2dsgt9EVEtZEYujOCoraLW9y1uoKP1zMB5ApdxIaeeO3Ap0Lr25GxJI1U5enEx4m_mxIJgxhQ7IkjU-JkX0v4YAkuZhj-JqTk6nQFWJzjEOTmZMsLmHz6vOBZwKNqaRfSgKcWwETO9VIoHydIYzP3rmRFkFiSRo5ITzB4";

  static String bizAPI = "https://bizapp.e-dagang.asia/api";
  static String tuneupAPI = "https://goilmuapp.e-dagang.asia/api";
  static String shopAPI = "https://shopapp.e-dagang.asia/api";

  static String apiRegister = shopAPI+"/register";
  static String apiLogin = shopAPI+"/login";
  static String apiLogout = shopAPI+"/logout";
  static String urlImage = "https://shopapp.e-dagang.asia";
  static String shopHome = shopAPI+"/home";
  static String shopKoop = shopAPI+"/coop/list";
  static String shopKoopProduct = shopAPI+"/coop/product";
  static String shopNgo = shopAPI+"/ngo/list";
  static String shopNgoProduct = shopAPI+"/ngo/product";
  static String shopSingleProduct = shopAPI+"/product/";
  static String shopProductCategory = shopAPI+"/product/category";
  static String shopProductMerchant = shopAPI+"/product/merchant";
  static String shopCart = shopAPI+"/cart";
  static String postCheckout = shopAPI+"/cart/checkout?";
  static String addressAPI = shopAPI+"/account/address";
  static String getFpxbank = shopAPI+"/fpx/banklist";
  static String getHistory = shopAPI+"/order/history";
  static String getState = shopAPI+"/lookup/state";
  static String getCity = shopAPI+"/lookup/city/";

  static String postReorder = shopAPI+"/order/details"; //<order_id>
  static String postRepayment = shopAPI+"/order/makepayment"; //<order_id><payment_type><bank_id><source>

  //POST https://shopapp.e-dagang.asia/api/order/details
  //Param: order_id

  //POST https://shopapp.e-dagang.asia/api/order/makepayment
  //Param:
  //order_id
  //payment_type 	// 1-direct; 2=fpx
  //bank_id
  //source			// web / app

  static const kAndroidUserAgent = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

  static const double padding =10;
  static const double avatarRadius =10;

  static Color lightPrimary = Colors.deepOrange.shade600;
  static Color darkPrimary = Colors.deepOrange.shade300;
  static Color lightAccent = Color(0xffF35533);
  static Color darkAccent = Color(0xffF35533);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.blueGrey.shade200;
  static Color ratingBG = Colors.yellow[600];

  static Uint8List kTransparentImage = new Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
  ]);
}

//================================================= Custom Button
class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).primaryColor,
        child: MaterialButton(
          onPressed: callback,
          minWidth: 140.0,
          height: 35.0,
          child: Text(
            text,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.blue.shade700, fontSize: 16, fontWeight: FontWeight.w700,),
            ),
          ),
        ),
      ),
    );
  }
}

//================================================= Border Button
class BorderButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const BorderButton({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        child: MaterialButton(
          onPressed: callback,
          minWidth: 130.0,
          height: 30.0,
          child: Text(
            text,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

//================================================ Hex Color

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}