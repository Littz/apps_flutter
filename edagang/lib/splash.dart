import 'dart:async';
import 'package:edagang/index.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'deeplink/ads_auto_deeplink.dart';
import 'deeplink/ads_career_deeplink.dart';
import 'deeplink/ads_company_deeplink.dart';
import 'deeplink/ads_other_deeplink.dart';
import 'deeplink/ads_prop_deeplink.dart';
import 'deeplink/biz_company_deeplink.dart';
import 'deeplink/fintools_deeplink.dart';
import 'deeplink/goilmu_company_deeplink.dart';
import 'deeplink/goilmu_deeplink.dart';
import 'deeplink/shop_category_deeplink.dart';
import 'deeplink/shop_merchant_deeplink.dart';
import 'deeplink/shop_product_deeplink.dart';
import 'deeplink/video_deeplink.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Splash_Screen',parameters:null);
    Timer(Duration(seconds: 3), () {
      checkDeepLink();
      //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
    });
  }

  checkDeepLink() async {
    _sub = getLinksStream().listen((String link) {
      print('initPlatformStateForStringUniLinks: $link');
    }, onError: (err) {
      print('error $err');
    });

    getLinksStream().listen((String link) {
      print('initState index got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    String initialLink;
    Uri initialUri;
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      WidgetsFlutterBinding.ensureInitialized();
      if (initialLink != null) initialUri = Uri.parse(initialLink);

      if (initialLink!=null && initialLink.isNotEmpty) {

        String type = initialLink.toString().split('/')[3];
        String subtype = initialLink.toString().split('/')[4];
        String xid = initialLink.toString().split('/')[5];
        String xname = initialLink.toString().split('/')[6];

        switch (type) {
          case "cartsini":
            {
              switch (subtype) {
                case "merchant":
                  //return MerchantDeeplink(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MerchantDeeplink(xid, xname)));
                  break;
                case "category":
                  //return CategoryDeeplink(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CategoryDeeplink(xid, xname)));
                  break;
                case "product":
                  //return ProductDeeplink();
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ProductDeeplink()));
                  break;
                case "video":
                  //return VideoPlay(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VideoPlayDl(xid, xname)));
                  break;
                default:
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Cartsini(),));
                  break;
              }
            }
            break;
          case "smartbiz":
            {
              switch (subtype) {
                case "company":
                  //return CompanyDeeplinkPage(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CompanyDeeplinkPage(xid, xname)));
                  break;
                default:
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
                  break;
              }
            }
            break;
          case "fintools":
            {
              switch (subtype) {
                case "product":
                  //return FintoolDlPage(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => FintoolDlPage(xid, xname)));
                  break;
                default:
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Fintool(),));
                  break;
              }
            }
            break;
          case "blurb":
            {
              switch (subtype) {
                case "career":
                  //return CareerDlPage(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CareerDlPage(xid, xname)));
                  break;
                case "property":
                  //return PropDlShowcase(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => PropDlShowcase(xid, xname)));
                  break;
                case "auto":
                  //return AutoDlShowcase(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AutoDlShowcase(xid, xname)));
                  break;
                case "others":
                //return BlurbCompanyPropertyDlPage(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => OtherDlPage(xid, xname)));
                  break;
                case "company":
                  //return BlurbCompanyPropertyDlPage(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BlurbCompanyPropertyDlPage(xid, xname)));
                  break;
                default:
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Blurb(),));
                  break;
              }
            }
            break;
          case "goilmu":
            {
              switch (subtype) {
                case "course":
                  //return GoilmuDlPage(xid, xname);
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => GoilmuDlPage(xid, xname)));
                  break;
                case "company":
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => GoilmuCompanyDlPage(xid, xname)));
                  break;
                default:
                  return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Goilmu(),));
                  break;
              }
            }
            break;
          default:
            return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
            break;
        }
      } else {
        return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
      }

    }catch(e){
      print('error initialLink >>>>  $e');
    }

    print('   $initialLink    <<<<  initialLink   $initialUri    <<< initialUri ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
