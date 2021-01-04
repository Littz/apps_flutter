import 'package:badges/badges.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/shop_acc.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/screens/shop/shop_home.dart';
import 'package:edagang/screens/shop/shop_msg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class ShopIndexPage extends StatefulWidget {
  final TabController tabcontroler;
  final int navibar_idx;
  ShopIndexPage({this.tabcontroler, this.navibar_idx});

  @override
  _ShopIndexPageState createState() => _ShopIndexPageState();
}

class _ShopIndexPageState extends State<ShopIndexPage> {
  int _index;
  int selectedPosition = 0;
  List<Widget> listBottomWidget = new List();

  @override
  void initState() {
    super.initState();
    //MainScopedModel xmodel = ScopedModel.of(context);
    selectedPosition = widget.navibar_idx;
    addHomePage(widget.tabcontroler);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, _model){
      return Scaffold(
            backgroundColor: Colors.grey.shade100,
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
          );
    });
  }

  void addHomePage(TabController controller) {
    listBottomWidget.add(ShopHomePage(tabcontroler: controller,));
    listBottomWidget.add(ShopMessagePage());
    listBottomWidget.add(ShopCartPage());
    listBottomWidget.add(ShopAccountPage());
  }

}
