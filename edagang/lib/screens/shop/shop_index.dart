import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/biz/biz_index.dart';
import 'package:edagang/screens/shop/cart_history.dart';
import 'package:edagang/screens/shop/cart_review.dart';
import 'package:edagang/screens/shop/more_popular.dart';
import 'package:edagang/screens/shop/product_category.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/screens/shop/search.dart';
import 'package:edagang/screens/shop/shop_NGO.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/screens/shop/shop_kooperasi.dart';
import 'package:edagang/screens/shop/shop_msg.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:edagang/widgets/webview_bb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class CustomTab {
  const CustomTab({this.icon, this.title, this.color});
  final Icon icon;
  final String title;
  final Color color;
}

class ShopIndexPage extends StatefulWidget {

  @override
  _ShopIndexPageState createState() => _ShopIndexPageState();
}

class _ShopIndexPageState extends State<ShopIndexPage> {
  int _index;
  int selectedPosition = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> listBottomWidget = new List();
  String _logType,_photo = "";
  String _selectedItem = 'Notification';
  SharedPref sharedPref = SharedPref();
  List<Menus> new_content = new List();

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

  goToDetailsPage(BuildContext context, Banner_ item) {
    String imgurl = 'https://shopapp.e-dagang.asia'+item.imageUrl;
    String catname = item.title ?? '';
    String catid = item.itemId.toString();
    String ctype = item.type.toString();
    String vrurl = item.link_url;
    if(ctype == "1") {
      sharedPref.save("prd_id", catid);
      sharedPref.save("prd_title", catname);
      Navigator.push(context, SlideRightRoute(page: ProductShowcase()));

    } else if (ctype == "2") {
      print('CATTTTTTTT#############################################');
      print(catid);
      print(catname);

      Navigator.push(context, SlideRightRoute(page: ProductListCategory(catid, catname)));
    } else if (ctype == "3") {

      Navigator.push(context, SlideRightRoute(page: ProductListMerchant(catid,catname)));
    } else if (ctype == "4") {

      Navigator.push(context, SlideRightRoute(page: WebviewBixon(vrurl ?? '', imgurl ?? '')));
    }
  }

  @override
  void initState() {
    new_content = getShopNewContent();
    super.initState();
    //selectedPosition = widget.selectedPage;
    loadPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, _model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            Navigator.of(context).pushReplacementNamed("/Main");
            return Future.value(true);
          },
            child: Scaffold(
              backgroundColor: Color(0xffEEEEEE),
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0.0,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      floating: true,
                      backgroundColor: Colors.white,
                      /*leading: _model.isAuthenticated ? Padding(
                          padding: EdgeInsets.all(13),
                          child:  _logType == '0' ? Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown) : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(_photo ?? '', fit: BoxFit.fill,),
                          )
                      ) : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.power,
                            color: Color(0xff084B8C),
                          ),
                          onPressed: () {Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));},
                        ),
                      ),*/
                      /*leading: _model.isAuthenticated ? Padding(
                          padding: EdgeInsets.all(13),
                          child:  _logType == '0' ? Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.scaleDown) : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(_photo ?? '', fit: BoxFit.fill,),
                          )
                      ) : Container(),*/
                      centerTitle: true,
                      title: Image.asset('assets/icons/ic_cartsini.png', height: 24, width: 108,),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(left: 2, right: 10,),
                          child: _model.isAuthenticated ?
                          _logType == '0' ?
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/icons/ic_edagang.png', fit: BoxFit.fill, height: 27, width: 27),
                          )
                              : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(_photo ?? '', fit: BoxFit.fill, height: 27, width: 27,),
                              )
                          )
                              : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.power,
                                color: Color(0xff084B8C),
                              ),
                              onPressed: () {Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));},
                            ),
                          ),
                        ),

                      ],
                      bottom: AppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        title: Container(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: searchBarShop(context),
                              ),
                              SizedBox(width: 8,),
                              CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: IconButton(
                                  icon: _model.isAuthenticated ? _model.getCartotal() == 0 ? Icon(CupertinoIcons.shopping_cart,color: Color(0xff084B8C)) : Badge(
                                    badgeColor: Colors.red,
                                    shape: BadgeShape.circle,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Icon(CupertinoIcons.shopping_cart,color: Color(0xff084B8C)),
                                    badgeContent: Text(
                                      _model.getCartotal().toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ) : Icon(CupertinoIcons.shopping_cart,color: Color(0xff084B8C)),
                                  onPressed: () {
                                    _model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: ShopCartPage())) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                  },
                                ),
                              ),
                              SizedBox(width: 2,),
                              CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: IconButton(
                                  icon: Icon(
                                    CupertinoIcons.bell_fill,
                                    color: Color(0xff084B8C),
                                  ),
                                  onPressed: () {
                                    _model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: ShopMessagePage())) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                  },
                                ),
                              ),
                              SizedBox(width: 2,),
                              CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: PopupMenuButton(
                                  icon: Icon(Icons.person, color: Color(0xff084B8C),),
                                  itemBuilder: (BuildContext bc) => [
                                    PopupMenuItem(child: ListTile(
                                      //leading: Icon(Icons.notifications),
                                      title: Text('My Orders'),
                                    ), value: "1"),
                                    PopupMenuItem(child: ListTile(
                                      //leading: Icon(Icons.settings),
                                      title: Text('My Review'),
                                    ), value: "2"),
                                    //PopupMenuItem(child: ListTile(
                                      //leading: Icon(Icons.settings),
                                    //  title: Text('Search'),
                                    //), value: "3"),

                                  ],
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedItem = value;
                                      print("Selected context menu: $_selectedItem");
                                      if(_selectedItem == '1'){
                                        _model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: CartHistory())) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                      }
                                      if(_selectedItem == '2'){
                                        _model.isAuthenticated ? Navigator.push(context, SlideRightRoute(page: MyReview())) : Navigator.push(context, SlideRightRoute(page: SignInOrRegister()));
                                      }
                                      //if(_selectedItem == '3'){
                                      //  Navigator.push(context, SlideRightRoute(page: SearchList3()));
                                      //}
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(bottom: 5, top: 90),
                            child: Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                                    elevation: 1,
                                    child: ClipPath(
                                        clipper: ShapeBorderClipper(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                        ),
                                        child: Container(
                                            height: 150.0,
                                            decoration: new BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                            ),
                                            child: Swiper(
                                              autoplay: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    goToDetailsPage(context, _model.banners[index]);
                                                  },
                                                  child: ClipRRect(
                                                      borderRadius: new BorderRadius.circular(8.0),
                                                      child: CachedNetworkImage(
                                                        placeholder: (context, url) => Container(
                                                          width: 40,
                                                          height: 40,
                                                          color: Colors.transparent,
                                                          child: CupertinoActivityIndicator(radius: 15,),
                                                        ),
                                                        imageUrl: Constants.urlImage + _model.banners[index].imageUrl,
                                                        fit: BoxFit.fill,
                                                        height: 150,
                                                        width: MediaQuery.of(context).size.width,
                                                      )
                                                  ),
                                                );
                                              },
                                              itemCount: _model.banners.length,
                                              pagination: new SwiperPagination(
                                                  builder: new DotSwiperPaginationBuilder(
                                                    activeColor: Colors.deepOrange.shade500,
                                                    activeSize: 7.0,
                                                    size: 7.0,
                                                  )
                                              ),
                                            )
                                        )
                                    )
                                )
                            )
                        ),
                      ),*/
                    ),
                    /*SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 48.0,
                        maxHeight: 60.0,
                        child: searchBarShop(context),
                      ),
                    )*/
                  ];
                },

                body: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _fetchBody(key: "key1"),
                )
              ),
            )
          );
        }
    );
  }

  Widget _fetchBody({String key}){
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
    {
      return CustomScrollView(slivers: <Widget>[
        SliverList(delegate: SliverChildListDelegate([
          Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      elevation: 1,
                      child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          child: Container(
                              height: 150.0,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Swiper(
                                autoplay: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      goToDetailsPage(context, model.banners[index]);
                                    },
                                    child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) => Container(
                                            width: 40,
                                            height: 40,
                                            color: Colors.transparent,
                                            child: CupertinoActivityIndicator(radius: 15,),
                                          ),
                                          imageUrl: Constants.urlImage + model.banners[index].imageUrl,
                                          fit: BoxFit.fill,
                                          height: 150,
                                          width: MediaQuery.of(context).size.width,
                                        )
                                    ),
                                  );
                                },
                                itemCount: model.banners.length,
                                pagination: new SwiperPagination(
                                    builder: new DotSwiperPaginationBuilder(
                                      activeColor: Colors.deepOrange.shade500,
                                      activeSize: 7.0,
                                      size: 7.0,
                                    )
                                ),
                              )
                          )
                      )
                  )
              )
          ),
        ])),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text('Promotions',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: model.promoProducts.length == 0 ? Container() : _fetchPromoList(),
        ),

        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            child: Text('Featured',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.fromLTRB(8, 10, 8, 5),
          sliver: _newContentList(context),
        ),

        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 5),
            child: Text('Categories', style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
            ),),
          ),
        ),

        SliverToBoxAdapter(
          child: model.categories.length == 0 ? Container() : _fetchCategories(),
        ),

        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text('Most Popular',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.deepOrange.shade100,
                  splashColor: Colors.deepOrange.shade100,
                  onTap: () {
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => ProductListTop(ctype: '5', catId: '0', catName: 'Most Popular', total: model.topProducts.length)
                    );
                    Navigator.push(context, route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'See all ',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xffF45432)),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.right_chevron,
                        size: 17,
                        color: Color(0xffF45432),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: model.topProducts.length == 0 ? Container() : _fetchPopular(),
        ),

        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
            child: Text('You may also like', style: GoogleFonts.lato(
              textStyle: TextStyle(color: Color(0xff202020), fontSize: 16, fontWeight: FontWeight.w600,),
            ),),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.only(left: 7, top: 10, right: 7, bottom: 15),
          sliver: _fetchFeatures(),
        ),
      ]);
    });
  }

  Widget _fetchPromoList() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            height: 245,
            width: 150,
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: model.promoProducts.length,
              itemBuilder: (context, index) =>
                  PromoCardItem(
                    product: model.promoProducts[index],
                  ),
            ),
          );
        }
    );
  }

  Widget _newContentList(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        //childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var data = new_content[index];
        return Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            elevation: 1.5,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              onTap: () {
                if(data.id == 1) {
                  Navigator.push(
                      context, SlideRightRoute(page: KooperasiPage()));
                }else if(data.id == 2) {
                  Navigator.push(
                      context, SlideRightRoute(page: NgoPage()));
                }else if(data.id == 3) {
                  Navigator.push(
                      context, SlideRightRoute(page: WebviewWidget('https://office.e-dagang.asia/cartsini/register', 'Join Us')));
                }
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                          child: Image.asset(
                            data.imgPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),

                    //SizedBox(height: 5,),
                    Container(
                      height: 25,
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]
              ),
            ),
          ),
        );
      }, childCount: 3,
      ),
    );
  }

  Widget _fetchCategories() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            padding: EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 0),
            color: Colors.transparent,
            height: 125,
            alignment: Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              //padding: EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: model.categories.length,
              itemBuilder: (context, index) {
                var data = model.categories[index];
                return Padding(
                  //padding: EdgeInsets.only(left: 3.6, top: 8, right: 3.6,),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  /*alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 0.0,
                  ),
                ),*/
                  child: InkWell(
                      onTap: () {
                        print("category name : " + model.categories[index].catname);
                        sharedPref.save("cat_id", model.categories[index].catid.toString());
                        sharedPref.save("cat_title", model.categories[index].catname);
                        Navigator.push(context, SlideRightRoute(page: ProductListCategory(model.categories[index].catid.toString(),model.categories[index].catname)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 65.0,
                            width: 65.0,
                            decoration: new BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 1.5,
                                  spreadRadius: 0.0,
                                  offset: Offset(1.5, 1.5),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 65.0,
                                width: 65.0,
                                imageUrl: Constants.urlImage + data.catimage ?? '',
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: 30,
                                  height: 30,
                                  color: Colors.transparent,
                                  child: CupertinoActivityIndicator(radius: 15,),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          Container(
                            width: 70.0,
                            padding: EdgeInsets.only(top: 5, right: 5),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                data.catname,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              },
            ),
          );
        }
    );
  }

  Widget _fetchPopular() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            margin: EdgeInsets.only(left: 8, right: 8,),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 215),
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    PopularCardItem(
                      product: model.topProducts[index],
                    ),
                itemCount: 10,
                primary: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        });
  }

  Widget _fetchFeatures() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model)
        {
          return SliverStaggeredGrid.countBuilder(
            crossAxisCount: 4,
            mainAxisSpacing: 0.5,
            crossAxisSpacing: 0.5,
            staggeredTileBuilder: (index) => StaggeredTile.fit(2),
            itemBuilder: (context, index) =>
                ProductCardItem(
                  product: model.featureProducts[index],
                ),
            itemCount: model.featureProducts.length,
          );
        });
  }


  /*Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder: (context, child, _model){
      return Scaffold(
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
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: _model.isAuthenticated ? _model.getCartotal() == 0 ? "" : Badge(
                  badgeColor: Colors.red,
                  shape: BadgeShape.circle,
                  borderRadius: BorderRadius.circular(100),
                  child: Icon(CupertinoIcons.shopping_cart,color: Color(0xff084B8C)),
                  badgeContent: Text(
                    _model.getCartotal().toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ) : Icon(CupertinoIcons.shopping_cart,color: Color(0xff084B8C)),
                onPressed: () { Navigator.push(context, SlideRightRoute(page: ShopCartPage()));},
                //onPressed: () { Navigator.push(context, SlideRightRoute(page: SearchList3()));},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2,),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.bell_fill,
                    color: Color(0xff084B8C),
                  ),
                  onPressed: () {Navigator.push(context, SlideRightRoute(page: ShopMessagePage()));},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2, right: 10,),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: PopupMenuButton(
                  icon: Icon(Icons.person, color: Color(0xff084B8C),),
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(child: ListTile(
                      //leading: Icon(Icons.notifications),
                      title: Text('My Orders'),
                    ), value: "1"),
                    PopupMenuItem(child: ListTile(
                      //leading: Icon(Icons.settings),
                      title: Text('My Review'),
                    ), value: "2"),
                    PopupMenuItem(child: ListTile(
                      //leading: Icon(Icons.settings),
                      title: Text('Search'),
                    ), value: "3"),

                  ],

                  onSelected: (value) {
                    setState(() {
                      _selectedItem = value;
                      print("Selected context menu: $_selectedItem");
                      if(_selectedItem == '1'){
                        Navigator.push(context, SlideRightRoute(page: CartHistory()));
                      }
                      if(_selectedItem == '2'){
                        Navigator.push(context, SlideRightRoute(page: MyReview()));
                      }
                      if(_selectedItem == '3'){
                        Navigator.push(context, SlideRightRoute(page: SearchList3()));
                      }
                    });
                  },
                ),
              ),
            ),

          ],
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color(0xffEEEEEE),
        body: ShopHomePage(),
      );

      *//*return Scaffold(
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
          );*//*
    });
  }*/

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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}