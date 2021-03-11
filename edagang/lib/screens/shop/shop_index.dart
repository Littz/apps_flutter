import 'package:badges/badges.dart';
import 'package:edagang/notification.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/search.dart';
import 'package:edagang/screens/shop/shop_acc.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/screens/shop/shop_home.dart';
import 'package:edagang/screens/shop/shop_msg.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTab {
  const CustomTab({this.icon, this.title, this.color});
  final Icon icon;
  final String title;
  final Color color;
}

class ShopIndexPage extends StatefulWidget {
  //int selectedPage, pgIdx;
  //ShopIndexPage(this.selectedPage, this.pgIdx);


  int selectedPage;
  int tabcontroler;
  ShopIndexPage({this.selectedPage, this.tabcontroler});

  @override
  _ShopIndexPageState createState() => _ShopIndexPageState();
}

class _ShopIndexPageState extends State<ShopIndexPage> {
  int _index;
  int selectedPosition = 0;
  List<Widget> listBottomWidget = new List();
  String _logType,_photo = "";

  loadPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _logType = prefs.getString("login_type");
        _photo = prefs.getString("photo");
        print("Sosmed photo : "+_photo);
      });

    } catch (Excepetion ) {
      print("error!");
    }
  }

  @override
  void initState() {
    super.initState();
    selectedPosition = widget.selectedPage;
    loadPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, _model){
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            leading: _model.isAuthenticated ? Padding(
                padding: EdgeInsets.all(13),
                child:  _logType == '0' ? Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown) : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(_photo ?? '', fit: BoxFit.fill,),
                )
            ) : Container(),
            centerTitle: true,
            title: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Image.asset('assets/icons/ic_edagang.png', height: 28, width: 30,),
                  Image.asset('assets/icons/ic_cartsini.png', height: 24, width: 108,),
                ],
              ),
            ),
            actions: [
              /*CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.search,
                    color: Color(0xff084B8C),
                  ),
                  onPressed: () { Navigator.push(context, SlideRightRoute(page: SearchList3()));},
                ),
              ),*/
              Padding(
                padding: EdgeInsets.only(left: 2, right: 10,),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.search,
                      color: Color(0xff084B8C),
                    ),
                    onPressed: () { Navigator.push(context, SlideRightRoute(page: SearchList3()));},
                  ),
                ),
              ),

            ],
            backgroundColor: Colors.white,
            bottom: TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Color(0xffF3552E),
              unselectedLabelColor: Color(0xff9A9A9A),
              labelColor: Color(0xffF3552E),
              labelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,),
              ),
              unselectedLabelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
              ),
              tabs: [
                Tab(icon: Icon(CupertinoIcons.house), text: "Home"),
                Tab(icon: Icon(CupertinoIcons.bell), text: "Message"),
                Tab(icon: _model.isAuthenticated ? _model.getCartotal() == 0 ? Icon(CupertinoIcons.cart) : Badge(
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  borderRadius: BorderRadius.circular(100),
                  child: Icon(CupertinoIcons.cart, ),
                  badgeContent: Text(
                    _model.getCartotal().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ) : Icon(CupertinoIcons.cart, ), text: "Cart"),
                Tab(icon: Icon(CupertinoIcons.person), text: "Account"),
              ],
            ),

          ),
          body: TabBarView(
            children: [
              ShopHomePage(tabcontroler: widget.tabcontroler),
              ShopMessagePage(tabcontroler: widget.tabcontroler),
              ShopCartPage(tabcontroler: widget.tabcontroler),
              ShopAccountPage(tabcontroler: widget.tabcontroler),
            ],
          ),
        ),
      );

      /*return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.house, ), label: "Home", activeIcon: Icon(CupertinoIcons.house_fill, )),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.bell, ), label: "Message", activeIcon: Icon(CupertinoIcons.bell_fill, )),
                BottomNavigationBarItem(
                    icon: _model.isAuthenticated ? _model.getCartotal() == 0 ? Icon(CupertinoIcons.cart) : Badge(
                      badgeColor: Colors.red,
                      shape: BadgeShape.circle,
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(CupertinoIcons.cart, ),
                      badgeContent: Text(
                          _model.getCartotal().toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                      ),
                    ) : Icon(CupertinoIcons.cart, ),

                    activeIcon: _model.isAuthenticated ? _model.getCartotal() == 0 ? Icon(CupertinoIcons.cart_fill) : Badge(
                      badgeColor: Colors.red,
                      shape: BadgeShape.circle,
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(CupertinoIcons.cart_fill, ),
                      badgeContent: Text(
                          _model.getCartotal().toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                      ),
                    ) : Icon(CupertinoIcons.cart_fill, ),

                    label: "Cart",),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person, ), label: "Account", activeIcon: Icon(CupertinoIcons.person_fill, )),
              ],
              currentIndex: selectedPosition,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.deepOrange.shade600,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
              unselectedItemColor: Colors.grey.shade600,
              onTap: (position) {
                setState(() {
                  selectedPosition = position;
                });
              },
            ),
            body: Builder(builder: (context) {
              return listBottomWidget[selectedPosition];
            }),
          );*/
    });
  }

/*Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text("Cartsini",
              style: TextStyle(
                //color: isShrink ? Colors.black : Colors.white,
                fontSize: 16.0,
              )
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () { Navigator.push(context, SlideRightRoute(page: SearchList3()));},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 16,),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {Navigator.push(context, SlideRightRoute(page: NotificationPage()));},
                ),
              ),
            ),

          ],
          backgroundColor: Colors.white, //selectedTab.color,
          bottom: new TabBar(
              controller: controller,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              //indicatorWeight: 3.0,
              indicatorColor: Color(0xffC2202D),
              unselectedLabelColor: Color(0xff9A9A9A),
              //labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              labelColor: Color(0xffCC0E27),
              labelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,),
              ),
              unselectedLabelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
              ),
              tabs: tabs.map((e) => new Tab(
                text: e.title,
              )).toList()
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: TabBarView(controller: controller, children: <Widget>[
          ShopHomePage(tabcontroler: controller),
          ShopMessagePage(tabcontroler: controller),
          ShopCartPage(tabcontroler: controller),
          ShopAccountPage(tabcontroler: controller),
        ])
    );
  }*/
}