import 'package:edagang/deeplink/ads_career_deeplink.dart';
import 'package:edagang/deeplink/biz_company_deeplink.dart';
import 'package:edagang/deeplink/shop_category_deeplink.dart';
import 'package:edagang/deeplink/shop_merchant_deeplink.dart';
import 'package:edagang/deeplink/shop_product_deeplink.dart';
import 'package:edagang/main.dart';
import 'package:edagang/screens/ads/ads_career_detail.dart';
import 'package:edagang/screens/biz/biz_company_detail.dart';
import 'package:edagang/screens/shop/product_category.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edagang/deeplink/deeplink_bloc.dart';


class DeeplinkWidget extends StatefulWidget {

  @override
  DeeplinkWidgetState createState() => DeeplinkWidgetState();
}

class DeeplinkWidgetState extends State<DeeplinkWidget> {
  SharedPref sharedPref = SharedPref();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if( snapshot.hasData ) {

          String uri = snapshot.data.toString();
          String parse = uri.replaceFirst("app://edagang/", "");
          print("LINK IS ${snapshot.data}");
          print("AFTER PARSE IS ${parse}");

          List<String> links = parse.split("/");
          String cat = links[0];
          String type = links[1];
          String xid = links[2];
          String xname = links[3];
          print("VALUE ID ${type} ==> ${xid}");
          print("VALUE TITLE ${type} ==> ${cat}");

          //sharedPref.save("cat_id", links[1]);
            switch (cat) {
              case "cartsini":
                {
                  switch (type) {
                    case "merchant":
                      return MerchantDeeplink(xid, xname);
                      break;
                    case "category":
                      return CategoryDeeplink(xid, xname);
                      break;
                    case "product":
                      sharedPref.save("prd_id", xid);
                      sharedPref.save("prd_title", xname);
                      return ProductDeeplink();
                      break;
                    default:
                      return Container();
                      break;
                  }
                }
                break;
              case "smartbiz":
                {
                  switch (type) {
                    case "company":
                      return CompanyDeeplinkPage(xid, xname);
                      break;
                    default:
                      return Container();
                      break;
                  }
                }
                break;
              case "blurb":
                {
                  switch (type) {
                    case "career":
                      return CareerDeeplinkPage(xid, xname);
                      break;
                    default:
                      return Container();
                      break;
                  }
                }
                break;
              default:
                return Container();
                break;
            }
        }else {
          //return SimpleTab(2,0);
          return NewHomePage(2,0);
        }
      },
    );
  }
}