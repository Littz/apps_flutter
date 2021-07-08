import 'package:edagang/screens/address_book.dart';
import 'package:edagang/screens/drawerbar.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:flutter/rendering.dart';
import 'package:edagang/screens/ads/ads_index.dart';
import 'package:edagang/screens/biz/biz_index.dart';
import 'package:edagang/screens/fin/fin_index.dart';
import 'package:edagang/screens/shop/cart_checkout.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/screens/shop/shop_index.dart';
import 'package:edagang/screens/upskill/skill_index.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/splash.dart';
import 'package:edagang/helper/constant.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';


void main() {

  WidgetsFlutterBinding.ensureInitialized(); //imp line need to be added first
  FlutterError.onError = (FlutterErrorDetails details) {
    print("Error INSIDE FRAME_WORK");
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
  SharedPref sharedPref = SharedPref();

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
    _model.fetchCourseProfessional();
    _model.fetchCourseTechnical();
    _model.fetchCourseSafety();
    _model.fetchCourseTraining();
    _model.fetchHomePageResponse();
    _model.fetchVideoListResponse();
    _model.fetchKoopListResponse();
    _model.fetchNgoListResponse();
    _model.fetchOrderStatusResponse();
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
          Widget error = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/ed_logo_greys.png', height: 120,),
                SizedBox(height: 26,),
                Icon(
                  LineAwesomeIcons.exclamation_triangle,
                  color: Colors.grey.shade500,
                  size: 36,
                ),
                Text('Rendering error...',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                  ),
                ),
              ],
            ),
          );
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

        /*routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => _MainScreen(),
          '/helloworld': (BuildContext context) => _DynamicLinkScreen(),
        },*/

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool navBarMode = false;
  int selectedIndex = 2;
  List<Widget> listBottomWidget = new List();
  List<Widget> tabWidget = [
    FinancePage(),
    ShopIndexPage(),
    BizPage(),
    UpskillPage(),
    AdvertPage(),
  ];
  void addHomePage() {
    listBottomWidget.add(FinancePage());
    listBottomWidget.add(ShopIndexPage());
    listBottomWidget.add(BizPage());
    listBottomWidget.add(UpskillPage());
    listBottomWidget.add(AdvertPage());
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedPage;
  }

  void onTabTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      drawer: DrawerBarMenu(),
      body: Stack(
        children: [
          tabWidget[selectedIndex],
          Positioned(
            left: 0,
            top: MediaQueryData.fromWindow(window).padding.top,
            child: Container(
              color: Colors.transparent,
              height: 56.0,
              width: 56.0,
              alignment: Alignment.center,
              child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(icon: Icon(LineAwesomeIcons.bars, color: Colors.black87,),
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  )
              ),
            )
          ),
        ],
      ),
      /*body: Builder(builder: (context) {
        return tabWidget[selectedIndex];
      }),*/
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: selectedIndex,
        //backgroundColor: Colors.redAccent.shade100,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff006FBD),
        //selectedItemColor: selectedIndex == 0 ? Color(0xffD91B3E) : selectedIndex == 1 ? Color(0xffF3552E) : selectedIndex == 2 ? Color(0xff084B8C) : selectedIndex == 3 ? Color(0xff70286D) : Color(0xff57585A)
        selectedLabelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        elevation: 0,
        iconSize: 32,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_fintools.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/images/ic_fintools2.png"),
              ),
              title: Text('Fintools')
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_cartsini.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/images/ic_cartsini2.png"),
              ),
              title: Text('Cartsini')
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_smartbiz.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/images/ic_smartbiz2.png"),
              ),
              title: Text('Smartbiz')
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_goilmu.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/images/ic_goilmu2.png"),
              ),
              title: Text('GoIlmu')
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_blurb.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/images/ic_blurb2.png"),
              ),
              title: Text('Blurb'),
          )
        ],
        /*items: [
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.dollar),
            title: Text("Fintools"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.shopping_cart),
            title: Text("Cartsini"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.user),
            title: Text("Smartbiz"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.bell_o),
            title: Text("Notification"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.user),
            title: Text("Profile"),
          ),
        ],*/
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
            //currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_fintools.png"),
                size: 20,
                color: selectedIndex == 0
                    ? Colors.orange
                    : Colors.black,
              ),
              title: Text('Fintools',
                style: TextStyle(
                    fontSize: 13.0,
                    color: selectedIndex == 0
                        ? Colors.orange
                        : Colors.black),
              )
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_cartsini.png"),
                color: selectedIndex == 1
                    ? Colors.orange
                    : Colors.black,
              ),
              title: Text('Cartsini',
                style: TextStyle(
                    fontSize: 10.0,
                    color: selectedIndex == 1
                        ? Colors.orange
                        : Colors.black),)
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_smartbiz.png"),
                color: selectedIndex == 2
                    ? Colors.orange
                    : Colors.black,
              ),
              title: Text('Smartbiz',
                style: TextStyle(
                    fontSize: 10.0,
                    color: selectedIndex == 2
                        ? Colors.orange
                        : Colors.black),)
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_goilmu.png"),
                color: selectedIndex == 3
                    ? Colors.orange
                    : Colors.black,
              ),
              title: Text('GoIlmu',
                style: TextStyle(
                    fontSize: 10.0,
                    color: selectedIndex == 3
                        ? Colors.orange
                        : Colors.black),)
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/ic_blurb.png"),
                color: selectedIndex == 4
                    ? Colors.orange
                    : Colors.black,
              ),
              title: Text('Blurb',
                style: TextStyle(
                    fontSize: 10.0,
                    color: selectedIndex == 4
                        ? Colors.orange
                        : Colors.black),)
          )

        ],
      ),*/
      /*bottomNavigationBar: FFNavigationBar(
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
            switch (index) {
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
            }
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
      ),*/
    );
  }
}
