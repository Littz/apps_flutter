import 'dart:async';
import 'dart:convert';
import 'package:edagang/index.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_updater/native_updater.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
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
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription _sub;
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().logEvent(name: 'Splash_Screen',parameters:null);
    Timer(Duration(seconds: 3), () {
      //checkVersion();
      initDynamicLinks();
    });
  }

  void checkVersion() async {
    /// For example: You got status code of 412 from the
    /// response of HTTP request.
    /// Let's say the statusCode 412 requires you to force update
    int statusCode = 412;
    /// This could be kept in our local
    int localVersion = 17;
    /// This could get from the API
    int serverLatestVersion = 17;

    Future.delayed(Duration.zero, () {
      print('App version updater: '+statusCode.toString());
      if (statusCode == 412) {
        NativeUpdater.displayUpdateAlert(
          context,
          forceUpdate: true,
          appStoreUrl: '<Your App Store URL>',
          playStoreUrl: 'https://play.google.com/store/apps/details?id=com.digital.dagang.asia.edagang',
          iOSDescription: 'Edagang requires that you update to the latest version. You cannot use this app until it is updated.',
          iOSUpdateButtonLabel: 'Update',
          iOSCloseButtonLabel: 'Close App',
        );
      } else if (serverLatestVersion > localVersion) {
        NativeUpdater.displayUpdateAlert(
          context,
          forceUpdate: false,
          appStoreUrl: '<Your App Store URL>',
          playStoreUrl: 'https://play.google.com/store/apps/details?id=com.digital.dagang.asia.edagang',
          iOSDescription: 'Edagang recommends that you update to the latest version. You can keep using this app while downloading the update.',
          iOSUpdateButtonLabel: 'Update',
          iOSIgnoreButtonLabel: 'Later',
        );
      }
    });
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print('FIREBASE DEEP LINK &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');

    if (deepLink != null) {
      print(deepLink);
      String data = deepLink.toString().split('/')[2];
      String type = data.split('.')[0];
      String subtype = deepLink.toString().split('/')[3];
      String xid = deepLink.toString().split('/')[4];
      String xname = '';

      switch (type) {
        case "finapp":
          {
            switch (subtype) {
              case "product":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => FintoolDlPage(xid, xname)));
                break;
              default:
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Fintool(),));
                break;
            }
          }
          break;
        case "shopapp":
          {
            switch (subtype) {
              case "merchant":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MerchantDeeplink(xid, xname)));
                break;
              case "category":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CategoryDeeplink(xid, xname)));
                break;
              case "product":
                sharedPref.save("prd_id", xid);
                sharedPref.save("prd_title", xname);
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ProductDeeplink()));
                break;
              case "video":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VideoPlayDl(xid, xname)));
                break;
              default:
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Cartsini(),));
                break;
            }
          }
          break;
        case "bizapp":
          {
            switch (subtype) {
              case "company":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CompanyDeeplinkPage(xid, xname)));
                break;
              default:
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
                break;
            }
          }
          break;
        case "goilmuapp":
          {
            switch (subtype) {
              case "course":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => GoilmuDlPage(xid, xname)));
                break;
              case "company":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => GoilmuCompanyDlPage(xid, xname)));
                break;
              default:
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Goilmu(),));
                break;
            }
          }
          break;
        case "blurbapp":
          {
            switch (subtype) {
              case "career":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CareerDlPage(xid, xname)));
                break;
              case "property":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => PropDlShowcase(xid, xname)));
                break;
              case "auto":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AutoDlShowcase(xid, xname)));
                break;
              case "others":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => OtherDlPage(xid, xname)));
                break;
              case "company":
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BlurbCompanyPropertyDlPage(xid, xname)));
                break;
              default:
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Blurb(),));
                break;
            }
          }
          break;
        default:
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
          break;
      }
    } else {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Index(),));
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            Navigator.pushNamed(context, '/helloworld');
          }
        }, onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );
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
