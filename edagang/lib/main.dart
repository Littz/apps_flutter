import 'package:edagang/screens/ads/ads_index.dart';
import 'package:edagang/screens/biz/biz_index.dart';
import 'package:edagang/screens/fin/fin_index.dart';
import 'package:edagang/screens/shop/acc_address.dart';
import 'package:edagang/screens/shop/cart_checkout.dart';
import 'package:edagang/screens/shop/shop_index.dart';
import 'package:edagang/screens/upskill/skill_index.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/splash.dart';
import 'package:edagang/utils/constant.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:edagang/deeplink/deeplink_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppPageState createState() => new _MyAppPageState();
}

class _MyAppPageState extends State<MyApp> {
  final MainScopedModel _model = MainScopedModel();
  String _emailAddress;
  bool _enableConsentButton = false;
  bool _requireConsent = false;
  int _counter = 0;
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

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges changes) {
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
    _model.fetchBizCat();
    _model.fetchBizProd();
    _model.fetchBizSvc();
    _model.fetchVisitedList();
    _model.fetchCompanyList();
    _model.fetchSkillCat();
    _model.fetchJobsCat();
    _model.fetchCourseList();
    _model.fetchCourseProfessional();
    _model.fetchCourseTechnical();
    _model.fetchCourseSafety();
    _model.fetchCourseTraining();
    _model.fetchHomePageResponse();
    _model.fetchKoopListResponse();
    _model.fetchNgoListResponse();
    loadAuth();

    super.initState();
    initOneSignal();
  }
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return ScopedModel<MainScopedModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eDagang',
        //theme: AppTheme.lightTheme,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.cyan[600],
          scaffoldBackgroundColor: Colors.white,
          /*textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),*/
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: SplashScreen(),
        /*home: Scaffold(
            body: Provider<DeepLinkBloc>(
                builder: (context) => _bloc,
                dispose: (context, bloc) => bloc.dispose(),
                child: DeeplinkWidget()
            )
        ),*/

        routes: <String, WidgetBuilder>{
          "/Main": (BuildContext context) => new SimpleTab(2,0),
          "/ShopIndex": (BuildContext context) => new SimpleTab(1,0),
          "/ShopCart": (BuildContext context) => new SimpleTab(1,2),
          "/Address": (BuildContext context) => new AddressBook(),
          "/Checkout": (BuildContext context) => new CheckoutActivity(),
          "/Login": (BuildContext context) => new SignInOrRegister(),
        },
      )
    );
  }
}

class CustomTab {
  const CustomTab({this.title, this.color});

  final String title;
  final Color color;
}

class SimpleTab extends StatefulWidget {
  int selectedPage, pgIdx;
  SimpleTab(this.selectedPage, this.pgIdx);

  @override
  _SimpleTabState createState() => _SimpleTabState();
}

class _SimpleTabState extends State<SimpleTab> with SingleTickerProviderStateMixin {
  TabController controller;
  List<CustomTab> tabs = const <CustomTab>[
    const CustomTab(title: 'FinTools', color: Color(0xffD81C3F)),
    const CustomTab(title: 'Cartsini', color: Color(0xffF35532)),
    const CustomTab(title: 'SmartBiz', color: Color(0xff2877EA)),
    const CustomTab(title: 'GOilmu', color: Color(0xff70286D)),
    const CustomTab(title: 'Blurb', color: Color(0xff57585A)),
  ];

  int idx = 0;
  CustomTab selectedTab;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: tabs.length, vsync: this, initialIndex: widget.selectedPage,);
    controller.addListener(_select);
    selectedTab = tabs[widget.selectedPage];
  }

  void _select() {
    setState(() {
      selectedTab = tabs[controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white, //selectedTab.color,
        title: new TabBar(
          controller: controller,
          isScrollable: true,
          //indicatorPadding: EdgeInsets.all(0.5),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3.0,
          indicatorColor: selectedTab.color,  //(0xffC2202D),
          unselectedLabelColor: Color(0xff9A9A9A),
          labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          labelColor: selectedTab.color, //Color(0xffCC0E27),
          labelStyle: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),
          ),
          unselectedLabelStyle: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,),
          ),
          tabs: tabs.map((e) => new Tab(
            text: e.title,
          )).toList()
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: TabBarView(controller: controller, children: <Widget>[
          FinancePage(tabcontroler: controller),
          ShopIndexPage(tabcontroler: controller, navibar_idx: widget.pgIdx,),
          BizPage(tabcontroler: controller),
          UpskillPage(tabcontroler: controller),
          AdvertPage(tabcontroler: controller),
      ])
    );
  }
}
