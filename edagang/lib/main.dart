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
import 'package:faker/faker.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:edagang/deeplink/deeplink_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  //WidgetsBinding.instance.renderView.automaticSystemUiAdjustment=false;

  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: null, //<------ changed
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
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
    _model.fetchGoilmuResponse();
    _model.fetchHomeBizResponse();
    _model.fetchVrBizResponse();
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
          //visualDensity: VisualDensity.adaptivePlatformDensity,
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
          "/Main": (BuildContext context) => new NewHomePage(2),
          "/ShopIndex": (BuildContext context) => new NewHomePage(1),
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
  //int pgIdx;
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
    //MainScopedModel xmodel = ScopedModel.of(context);
    selectedIndex = widget.selectedPage;
    addHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      /*body: ClipPath(
        clipper: MyClipper(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF3383CD),
                Color(0xFF11249F),
              ],
            ),
          ),
        ),
      ),*/
      body: Builder(builder: (context) {
        return listBottomWidget[selectedIndex];
      }),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Color(0xFFEEEEEE),
          //selectedItemBackgroundColor: Color(0xFF11249F),
          //selectedItemIconColor: Colors.white,
          //selectedItemLabelColor: Color(0xFF11249F),
          barHeight: 64,
          showSelectedItemShadow: false,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
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


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page;
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;

  @override
  void initState() {
    page = -1;
    paginationViewType = PaginationViewType.listView;
    key = GlobalKey<PaginationViewState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginationView Example'),
        actions: <Widget>[
          (paginationViewType == PaginationViewType.listView)
              ? IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () => setState(
                    () => paginationViewType = PaginationViewType.gridView),
          )
              : IconButton(
            icon: Icon(Icons.list),
            onPressed: () => setState(
                    () => paginationViewType = PaginationViewType.listView),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => key.currentState.refresh(),
          ),
        ],
      ),
      body: PaginationView<User>(
        key: key,
        header: Text('Top'),
        footer: Text('Loading..'),
        preloadedItems: <User>[
          User(faker.person.name(), faker.internet.email()),
          User(faker.person.name(), faker.internet.email()),
        ],
        paginationViewType: paginationViewType,
        itemBuilder: (BuildContext context, User user, int index) =>
        (paginationViewType == PaginationViewType.listView)
            ? ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
        )
            : GridTile(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(height: 8),
              Text(user.name),
              const SizedBox(height: 8),
              Text(user.email),
            ],
          ),
        ),
        pageFetch: pageFetch,
        pullToRefresh: true,
        onError: (dynamic error) => Center(
          child: Text('Some error occured'),
        ),
        onEmpty: Center(
          child: Text('Sorry! This is empty'),
        ),
        bottomLoader: Center(
          child: CircularProgressIndicator(),
        ),
        initialLoader: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<List<User>> pageFetch(int offset) async {
    print(offset);
    page = (offset / 20).round();
    final Faker faker = Faker();
    final List<User> nextUsersList = List.generate(
      20,
          (int index) => User(
        faker.person.name() + ' - $page$index',
        faker.internet.email(),
      ),
    );
    await Future<List<User>>.delayed(Duration(seconds: 1));
    return page == 5 ? [] : nextUsersList;
  }
}

class User {
  User(this.name, this.email);

  final String name;
  final String email;
}