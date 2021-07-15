import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:edagang/screens/address_book.dart';
import 'package:edagang/screens/drawerbar.dart';
import 'package:edagang/helper/shared_prefrence_helper.dart';
import 'package:edagang/screens/shop/order_details.dart';
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
import 'package:flutter/scheduler.dart';
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
  bool _enableConsentButton = false;
  String _phoneType, _osVer = '';

  loadAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String xsToken = prefs.getString('token');
    if (xsToken != null) {
      _model.fetchProfile();
      _model.fetchCartTotal();
      _model.fetchCartsFromResponse();
      _model.fetchAddressList();
      _model.fetchBankList();
      _model.fetchOrderStatusResponse();
    } else {
      print("GUEST TOKEN >>>> "+Constants.tokenGuest);
    }
  }

  void initOneSignal() async {
    if (!mounted) return;

    /*OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      this.setState(() {
        _debugLabelString = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');
      /// Display Notification, send null to not display
      event.complete(null);

      this.setState(() {
        _debugLabelString =
        "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
        "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
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

    OneSignal.shared.setSMSSubscriptionObserver(
            (OSSMSSubscriptionStateChanges changes) {
          print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
        });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId("2ee5bcc3-30a9-40cd-9de8-1aaec0d71fe3");

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
    _enableConsentButton = requiresConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    //oneSignalInAppMessagingTriggerExamples();

    OneSignal.shared.disablePush(false);

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    //oneSignalOutcomeEventsExamples();

    bool userProvidedPrivacyConsent = await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");*/


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
    final status = await OneSignal.shared.getPermissionSubscriptionState();
    final playerId = status.subscriptionStatus.userId.toString();
    sharedPref.save('player_id', playerId);
  }

  void getDevInfo() async {
    if (!mounted) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceInfo,deviceInfo2;

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      print('$systemName $version, $name $model');
      deviceInfo = '$systemName $version';
      deviceInfo2 = '$name $model'; // iOS 13.1, iPhone 11 Pro Max iPhone
    } else {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      print('Android $release (SDK $sdkInt), $manufacturer $model');
      deviceInfo = 'Android $release (SDK $sdkInt)';
      deviceInfo2 = '$manufacturer $model'; // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }

    setState(() {

      prefs.setString('phone_type', deviceInfo2);
      prefs.setString('os_version', deviceInfo);

    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initOneSignal();
      getDevInfo();
      loadAuth();
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

    });

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
                Text('Rendering widget...',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600,),
                  ),
                ),
              ],
            ),
          );
          if (widget is Scaffold || widget is Navigator) error = Scaffold(body: Center(child: error));
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
          "/ToPay": (BuildContext context) => new MyOrders(0),
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


/*
class MyAppx extends StatefulWidget {
  @override
  _MyAppxState createState() => new _MyAppxState();
}

class _MyAppxState extends State<MyAppx> {
  String _debugLabelString = "";
  String _emailAddress;
  String _smsNumber;
  String _externalUserId;
  bool _enableConsentButton = false;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
  if (!mounted) return;

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
  this.setState(() {
  _debugLabelString =
  "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  });
  });

  OneSignal.shared
      .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
  print('FOREGROUND HANDLER CALLED WITH: ${event}');
  /// Display Notification, send null to not display
  event.complete(null);

  this.setState(() {
  _debugLabelString =
  "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  });
  });

  OneSignal.shared
      .setInAppMessageClickedHandler((OSInAppMessageAction action) {
  this.setState(() {
  _debugLabelString =
  "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
  });
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
  print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
  print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setEmailSubscriptionObserver(
  (OSEmailSubscriptionStateChanges changes) {
  print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setSMSSubscriptionObserver(
  (OSSMSSubscriptionStateChanges changes) {
  print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
  });

  // NOTE: Replace with your own app ID from https://www.onesignal.com
  await OneSignal.shared.setAppId("2ee5bcc3-30a9-40cd-9de8-1aaec0d71fe3");

  bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

  this.setState(() {
  _enableConsentButton = requiresConsent;
  });

  // Some examples of how to use In App Messaging public methods with OneSignal SDK
  oneSignalInAppMessagingTriggerExamples();

  OneSignal.shared.disablePush(false);

  // Some examples of how to use Outcome Events public methods with OneSignal SDK
  oneSignalOutcomeEventsExamples();

  bool userProvidedPrivacyConsent = await OneSignal.shared.userProvidedPrivacyConsent();
  print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
  }

  void _handleGetTags() {
  OneSignal.shared.getTags().then((tags) {
  if (tags == null) return;

  setState((() {
  _debugLabelString = "$tags";
  }));
  }).catchError((error) {
  setState(() {
  _debugLabelString = "$error";
  });
  });
  }

  void _handleSendTags() {
  print("Sending tags");
  OneSignal.shared.sendTag("test2", "val2").then((response) {
  print("Successfully sent tags with response: $response");
  }).catchError((error) {
  print("Encountered an error sending tags: $error");
  });

  print("Sending tags array");
  var sendTags = {'test': 'value'};
  OneSignal.shared.sendTags(sendTags).then((response) {
  print("Successfully sent tags with response: $response");
  }).catchError((error) {
  print("Encountered an error sending tags: $error");
  });
  }

  void _handlePromptForPushPermission() {
  print("Prompting for Permission");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  print("Accepted permission: $accepted");
  });
  }

  void _handleGetDeviceState() async {
  print("Getting DeviceState");
  OneSignal.shared.getDeviceState().then((deviceState) {
  print("DeviceState: ${deviceState?.jsonRepresentation()}");
  this.setState(() {
  _debugLabelString = deviceState?.jsonRepresentation() ?? "Device state null";
  });
  });
  }

  void _handleSetEmail() {
  if (_emailAddress == null) return;

  print("Setting email");

  OneSignal.shared.setEmail(email: _emailAddress).whenComplete(() {
  print("Successfully set email");
  }).catchError((error) {
  print("Failed to set email with error: $error");
  });
  }

  void _handleLogoutEmail() {
  print("Logging out of email");

  OneSignal.shared.logoutEmail().then((v) {
  print("Successfully logged out of email");
  }).catchError((error) {
  print("Failed to log out of email: $error");
  });
  }

  void _handleSetSMSNumber() {
  if (_smsNumber == null) return;

  print("Setting SMS Number");

  OneSignal.shared.setSMSNumber(smsNumber: _smsNumber).then((response) {
  print("Successfully set SMSNumber with response $response");
  }).catchError((error) {
  print("Failed to set SMS Number with error: $error");
  });
  }

  void _handleLogoutSMSNumber() {
  print("Logging out of smsNumber");

  OneSignal.shared.logoutSMSNumber().then((response) {
  print("Successfully logoutEmail with response $response");
  }).catchError((error) {
  print("Failed to log out of SMSNumber: $error");
  });
  }

  void _handleConsent() {
  print("Setting consent to true");
  OneSignal.shared.consentGranted(true);

  print("Setting state");
  this.setState(() {
  _enableConsentButton = false;
  });
  }

  void _handleSetLocationShared() {
  print("Setting location shared to true");
  OneSignal.shared.setLocationShared(true);
  }

  void _handleDeleteTag() {
  print("Deleting tag");
  OneSignal.shared.deleteTag("test2").then((response) {
  print("Successfully deleted tags with response $response");
  }).catchError((error) {
  print("Encountered error deleting tag: $error");
  });

  print("Deleting tags array");
  OneSignal.shared.deleteTags(['test']).then((response) {
  print("Successfully sent tags with response: $response");
  }).catchError((error) {
  print("Encountered an error sending tags: $error");
  });
  }

  void _handleSetExternalUserId() {
  print("Setting external user ID");
  if (_externalUserId == null) return;

  OneSignal.shared.setExternalUserId(_externalUserId).then((results) {
  if (results == null) return;

  this.setState(() {
  _debugLabelString = "External user id set: $results";
  });
  });
  }

  void _handleRemoveExternalUserId() {
  OneSignal.shared.removeExternalUserId().then((results) {
  if (results == null) return;

  this.setState(() {
  _debugLabelString = "External user id removed: $results";
  });
  });
  }

  void _handleSendNotification() async {
  var deviceState = await OneSignal.shared.getDeviceState();

  if (deviceState == null || deviceState.userId == null)
  return;

  var playerId = deviceState.userId;

  var imgUrlString =
  "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

  var notification = OSCreateNotification(
  playerIds: [playerId],
  content: "this is a test from OneSignal's Flutter SDK",
  heading: "Test Notification",
  iosAttachments: {"id1": imgUrlString},
  bigPicture: imgUrlString,
  buttons: [
  OSActionButton(text: "test1", id: "id1"),
  OSActionButton(text: "test2", id: "id2")
  ]);

  var response = await OneSignal.shared.postNotification(notification);

  this.setState(() {
  _debugLabelString = "Sent notification with response: $response";
  });
  }

  void _handleSendSilentNotification() async {
  var deviceState = await OneSignal.shared.getDeviceState();

  if (deviceState == null || deviceState.userId == null)
  return;

  var playerId = deviceState.userId;

  var notification = OSCreateNotification.silentNotification(
  playerIds: [playerId], additionalData: {'test': 'value'});

  var response = await OneSignal.shared.postNotification(notification);

  this.setState(() {
  _debugLabelString = "Sent notification with response: $response";
  });
  }

  oneSignalInAppMessagingTriggerExamples() async {
  /// Example addTrigger call for IAM
  /// This will add 1 trigger so if there are any IAM satisfying it, it
  /// will be shown to the user
  OneSignal.shared.addTrigger("trigger_1", "one");

  /// Example addTriggers call for IAM
  /// This will add 2 triggers so if there are any IAM satisfying these, they
  /// will be shown to the user
  Map<String, Object> triggers = new Map<String, Object>();
  triggers["trigger_2"] = "two";
  triggers["trigger_3"] = "three";
  OneSignal.shared.addTriggers(triggers);

  // Removes a trigger by its key so if any future IAM are pulled with
  // these triggers they will not be shown until the trigger is added back
  OneSignal.shared.removeTriggerForKey("trigger_2");

  // Get the value for a trigger by its key
  Object triggerValue = await OneSignal.shared.getTriggerValueForKey("trigger_3");
  print("'trigger_3' key trigger value: ${triggerValue?.toString()}");

  // Create a list and bulk remove triggers based on keys supplied
  List<String> keys = ["trigger_1", "trigger_3"];
  OneSignal.shared.removeTriggersForKeys(keys);

  // Toggle pausing (displaying or not) of IAMs
  OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
  // Await example for sending outcomes
  outcomeAwaitExample();

  // Send a normal outcome and get a reply with the name of the outcome
  OneSignal.shared.sendOutcome("normal_1");
  OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
  print(outcomeEvent.jsonRepresentation());
  });

  // Send a unique outcome and get a reply with the name of the outcome
  OneSignal.shared.sendUniqueOutcome("unique_1");
  OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
  print(outcomeEvent.jsonRepresentation());
  });

  // Send an outcome with a value and get a reply with the name of the outcome
  OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
  OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
  print(outcomeEvent.jsonRepresentation());
  });
  }

  Future<void> outcomeAwaitExample() async {
  var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
  print(outcomeEvent.jsonRepresentation());
  }

  @override
  Widget build(BuildContext context) {
  return new MaterialApp(
  home: new Scaffold(
  appBar: new AppBar(
  title: const Text('OneSignal Flutter Demo'),
  backgroundColor: Color.fromARGB(255, 212, 86, 83),
  ),
  body: Container(
  padding: EdgeInsets.all(10.0),
  child: SingleChildScrollView(
  child: new Table(
  children: [
  new TableRow(children: [
  new OneSignalButton(
  "Get Tags", _handleGetTags, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Send Tags", _handleSendTags, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Prompt for Push Permission",
  _handlePromptForPushPermission, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Print Device State",
  _handleGetDeviceState,
  !_enableConsentButton)
  ]),
  new TableRow(children: [
  new TextField(
  textAlign: TextAlign.center,
  decoration: InputDecoration(
  hintText: "Email Address",
  labelStyle: TextStyle(
  color: Color.fromARGB(255, 212, 86, 83),
  )),
  onChanged: (text) {
  this.setState(() {
  _emailAddress = text == "" ? null : text;
  });
  },
  )
  ]),
  new TableRow(children: [
  Container(
  height: 8.0,
  )
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Set Email", _handleSetEmail, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Logout Email", _handleLogoutEmail,
  !_enableConsentButton)
  ]),
  new TableRow(children: [
  new TextField(
  textAlign: TextAlign.center,
  decoration: InputDecoration(
  hintText: "SMS Number",
  labelStyle: TextStyle(
  color: Color.fromARGB(255, 212, 86, 83),
  )),
  onChanged: (text) {
  this.setState(() {
  _smsNumber = text == "" ? null : text;
  });
  },
  )
  ]),
  new TableRow(children: [
  Container(
  height: 8.0,
  )
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Set SMS Number", _handleSetSMSNumber, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Logout SMS Number", _handleLogoutSMSNumber,
  !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Provide GDPR Consent", _handleConsent,
  _enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Set Location Shared",
  _handleSetLocationShared, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Delete Tag", _handleDeleteTag, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Post Notification",
  _handleSendNotification, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton("Post Silent Notification",
  _handleSendSilentNotification, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new TextField(
  textAlign: TextAlign.center,
  decoration: InputDecoration(
  hintText: "External User ID",
  labelStyle: TextStyle(
  color: Color.fromARGB(255, 212, 86, 83),
  )),
  onChanged: (text) {
  this.setState(() {
  _externalUserId = text == "" ? null : text;
  });
  },
  )
  ]),
  new TableRow(children: [
  Container(
  height: 8.0,
  )
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Set External User ID", _handleSetExternalUserId, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new OneSignalButton(
  "Remove External User ID", _handleRemoveExternalUserId, !_enableConsentButton)
  ]),
  new TableRow(children: [
  new Container(
  child: new Text(_debugLabelString),
  alignment: Alignment.center,
  )
  ]),
  ],
  ),
  ),
  )),
  );
  }
}

typedef void OnButtonPressed();

class OneSignalButton extends StatefulWidget {
  final String title;
  final OnButtonPressed onPressed;
  final bool enabled;

  OneSignalButton(this.title, this.onPressed, this.enabled);

  State<StatefulWidget> createState() => new OneSignalButtonState();
}

class OneSignalButtonState extends State<OneSignalButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Table(
      children: [
        new TableRow(children: [
          new FlatButton(
            disabledColor: Color.fromARGB(180, 212, 86, 83),
            disabledTextColor: Colors.white,
            color: Color.fromARGB(255, 212, 86, 83),
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            child: new Text(widget.title),
            onPressed: widget.enabled ? widget.onPressed : null,
          )
        ]),
        new TableRow(children: [
          Container(
            height: 8.0,
          )
        ]),
      ],
    );
  }
}*/
