import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/cart_history.dart';
import 'package:edagang/screens/shop/cart_review.dart';
import 'package:edagang/screens/shop/more_popular.dart';
import 'package:edagang/screens/shop/product_category.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/screens/shop/shop_NGO.dart';
import 'package:edagang/screens/shop/shop_cart.dart';
import 'package:edagang/screens/shop/shop_kooperasi.dart';
import 'package:edagang/screens/shop/shop_msg.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/utube/video_list.dart';
import 'package:edagang/utube/video_play.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:edagang/widgets/webview.dart';
import 'package:edagang/widgets/webview_bb.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, SlideRightRoute(page: ProductListCategory(catid, catname)));
      });
    } else if (ctype == "3") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, SlideRightRoute(page: ProductListMerchant(catid,catname)));
      });
    } else if (ctype == "4") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, SlideRightRoute(page: WebviewBixon(vrurl ?? '', imgurl ?? '')));
      });
    }
  }

  @override
  void initState() {
    new_content = getShopNewContent();
    super.initState();
    loadPhoto();
    FirebaseAnalytics().logEvent(name: 'Cartsini_Home',parameters:null);
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
                              : Container(
                            height: 28.0,
                            width: 28.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                //fit: BoxFit.fill,
                                image: NetworkImage(_photo),
                              ),
                            ),
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
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                              height: 138.0,
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
                                          height: 138,
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
            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0,),
                  child: InkWell(
                    highlightColor: Colors.blue.shade100,
                    splashColor: Colors.blue.shade100,
                    onTap: () {
                      Navigator.push(context,SlideRightRoute(page: VideoList()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'More ',
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
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: model.bvirtual.length == 0 ? Container() : _fetchVideo(),
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
                        'More ',
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
                  child: InkWell(
                      onTap: () {
                        FirebaseAnalytics().logEvent(name: 'Cartsini_cat_'+model.categories[index].catname,parameters:null);
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
        }
    );
  }

  Widget _fetchVideo() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            height: MediaQuery.of(context).size.height * 0.26,
            //height: 163,
            alignment: Alignment.center,
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: model.videos.length,
                itemBuilder: (context, index) {
                  var data = model.videos[index];
                  var d1 = data.link.split("v=");
                  var vlink = d1[1].toString();

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0),),
                      ),
                      elevation: 1.0,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        onTap: () {
                          Navigator.push(context, SlideRightRoute(page: VideoPlay(vlink,data.title)));
                          print('YOUTUBEEEEE======================');
                          print(vlink);
                          print(data.title);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                //width: MediaQuery.of(context).size.width * 0.6,
                                //height: 155,
                                //alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                      child: CachedNetworkImage(
                                        imageUrl: 'http://img.youtube.com/vi/'+ vlink +'/0.jpg',
                                        placeholder: (context, url) => Container(
                                          width: 30,
                                          height: 30,
                                          color: Colors.transparent,
                                          child: CupertinoActivityIndicator(radius: 15,),
                                        ),
                                        errorWidget: (context, url, error) => Image.asset(
                                          'assets/icons/ic_image_error.png',
                                          fit: BoxFit.cover,
                                        ),
                                        fit: BoxFit.fill,
                                        //height: 155,
                                        width: MediaQuery.of(context).size.width * 0.6,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(CupertinoIcons.arrowtriangle_right_circle, color: Colors.white, size: 40,),
                                    ),
                                  ]
                                )
                              ),
                              Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width * 0.6,
                                padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
                                alignment: Alignment.topLeft,
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  //borderRadius: BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.title,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        }
    );
  }
}
