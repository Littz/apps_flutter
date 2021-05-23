import 'package:flutter/rendering.dart';
import 'package:edagang/screens/ads/ads_index.dart';
import 'package:edagang/screens/biz/biz_index.dart';
import 'package:edagang/screens/fin/fin_index.dart';
import 'package:edagang/screens/shop/acc_address.dart';
import 'package:edagang/screens/shop/cart_checkout.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/screens/shop/shop_index.dart';
import 'package:edagang/screens/upskill/skill_index.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/splash.dart';
import 'package:edagang/utils/constant.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized(); //imp line need to be added first
  FlutterError.onError = (FlutterErrorDetails details) {
    print("Error From INSIDE FRAME_WORK");
    print("----------------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");
  };
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: null,
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title, this.uri}) : super(key: key);
  final String title;
  final Uri uri;

  @override
  _MyAppPageState createState() => new _MyAppPageState();
}

class _MyAppPageState extends State<MyApp> {
  final MainScopedModel _model = MainScopedModel();
  bool _requireConsent = false;
  String _debugLabelString = "";

  loadAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String xsToken = prefs.getString('token');
    if (xsToken != null) {
      _model.fetchProfile();
      _model.fetchCartTotal();
      _model.fetchCartsFromResponse();
      _model.fetchCartReload();
      _model.fetchAddressList();
      _model.fetchBankList();
      _model.fetchOrderHistoryResponse();
    } else {
      print("GUEST TOKEN >>>> "+Constants.tokenGuest);
    }
  }

  void initOneSignal() {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("OPENED NOTIFICATION");
      print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
      this.setState(() {
        _debugLabelString = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    final app_id = "2ee5bcc3-30a9-40cd-9de8-1aaec0d71fe3";
    OneSignal.shared.init(
        app_id,
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl : true
        }
    );
  }

  @override
  void initState() {
    _model.loggedInUser();
    _model.fetchHomeFinResponse();
    _model.fetchHomeBlurbResponse();
    _model.fetchBlurbOtherResponse();
    _model.fetchGoilmuResponse();
    _model.fetchHomeBizResponse();
    _model.fetchVrBizResponse();
    _model.fetchVisitedList();
    _model.fetchCompanyList();
    _model.fetchSkillCat();
    //_model.fetchJobsCat();
    _model.fetchCourseList();
    _model.fetchCourseProfessional();
    _model.fetchCourseTechnical();
    _model.fetchCourseSafety();
    _model.fetchCourseTraining();
    _model.fetchHomePageResponse();
    _model.fetchVideoListResponse();
    _model.fetchKoopListResponse();
    _model.fetchNgoListResponse();
    loadAuth();

    super.initState();
    initOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainScopedModel>(
      model: _model,
      child: MaterialApp(
        builder: (BuildContext context, Widget widget) {
          Widget error = Text('...rendering error...');
          if (widget is Scaffold || widget is Navigator)
            error = Scaffold(body: Center(child: error));
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
          return widget;
        },
        debugShowCheckedModeBanner: false,
        title: 'eDagang',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.cyan[600],
          scaffoldBackgroundColor: Colors.white,
        ),

        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          "/Main": (BuildContext context) => new NewHomePage(2),
          "/Fintool": (BuildContext context) => new NewHomePage(0),
          "/ShopIndex": (BuildContext context) => new NewHomePage(1),
          "/Goilmu": (BuildContext context) => new NewHomePage(3),
          "/Blurb": (BuildContext context) => new NewHomePage(4),
          "/ShopCart": (BuildContext context) => new ShopCartPage(),
          "/Address": (BuildContext context) => new AddressBook(),
          "/Checkout": (BuildContext context) => new CheckoutActivity(),
          "/Login": (BuildContext context) => new SignInOrRegister(),
        },
      )
    );
  }
}

class NewHomePage extends StatefulWidget {
  int selectedPage;
  NewHomePage(this.selectedPage);

  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {

  bool navBarMode = false;
  int selectedIndex = 2;
  List<Widget> listBottomWidget = new List();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedPage;
    addHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      body: Builder(builder: (context) {
        return listBottomWidget[selectedIndex];
      }),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Color(0xFFEEEEEE),
          barHeight: 64,
          showSelectedItemShadow: false,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
            /*switch (index) {
              case 0:
                FirebaseAnalytics().logEvent(name: 'Fintools_Tab',parameters:null);
                break;
              case 1:
                FirebaseAnalytics().logEvent(name: 'Cartsini_Tab',parameters:null);
                break;
              case 2:
                FirebaseAnalytics().logEvent(name: 'Smartbiz_Tab',parameters:null);
                break;
              case 3:
                FirebaseAnalytics().logEvent(name: 'Goilmu_Tab',parameters:null);
                break;
              case 4:
                FirebaseAnalytics().logEvent(name: 'Blurb_Tab',parameters:null);
                break;
              default:
                FirebaseAnalytics().logEvent(name: 'Smartbiz_Tab',parameters:null);
                break;
            }*/
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: CupertinoIcons.money_dollar,
            label: 'Fintools',
            selectedBackgroundColor: Color(0xffD91B3E),
            selectedLabelColor: Color(0xffD91B3E),
          ),
          FFNavigationBarItem(
            iconData: CupertinoIcons.cart,
            label: 'Cartsini',
            selectedBackgroundColor: Color(0xffF3552E),
            selectedLabelColor: Colors.black,
          ),
          FFNavigationBarItem(
            iconData: CupertinoIcons.chart_bar_alt_fill,
            label: 'Smartbiz',
            selectedBackgroundColor: Color(0xff357FEB),
            selectedLabelColor: Color(0xff084B8C),
          ),
          FFNavigationBarItem(
            iconData: CupertinoIcons.book,
            label: 'GOilmu',
            selectedBackgroundColor: Color(0xff930894),
            selectedLabelColor: Color(0xff70286D),
          ),
          FFNavigationBarItem(
            iconData: CupertinoIcons.tv,
            label: 'Blurb',
            selectedBackgroundColor: Color(0xff57585A),
            selectedLabelColor: Color(0xff57585A),
          ),
        ],
      ),

    );
  }

  void addHomePage() {
    listBottomWidget.add(FinancePage());
    listBottomWidget.add(ShopIndexPage());
    listBottomWidget.add(BizPage());
    listBottomWidget.add(UpskillPage());
    listBottomWidget.add(AdvertPage());
  }

}
