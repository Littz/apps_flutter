import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/more_popular.dart';
import 'package:edagang/screens/shop/more_promo.dart';
import 'package:edagang/screens/shop/product_category.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/screens/shop/product_merchant.dart';
import 'package:edagang/screens/shop/shop_NGO.dart';
import 'package:edagang/screens/shop/shop_digital.dart';
import 'package:edagang/screens/shop/shop_kooperasi.dart';
import 'package:edagang/screens/shop/webview.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:edagang/widgets/searchbar.dart';
import 'package:edagang/widgets/square_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class ShopHomePage extends StatefulWidget {
  final TabController tabcontroler;
  ShopHomePage({this.tabcontroler});

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  BuildContext context;
  List<Menus> new_content = new List();

  goToDetailsPage(BuildContext context, Banner_ item) {
    String catname = item.title ?? '';
    String catid = item.itemId.toString();
    String ctype = item.type.toString();
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
    }
  }

  @override
  void initState() {
    new_content = getShopNewContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            widget.tabcontroler.animateTo(2);
            return null;
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0.0,
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: searchBarShop(context),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.grey.shade200,
            body: CustomScrollView(slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 5),
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
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
                                              fit: BoxFit.fitWidth,
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
                  ),
                )
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
                      /*InkWell(
                        highlightColor: Colors.deepOrange.shade100,
                        splashColor: Colors.deepOrange.shade100,
                        onTap: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => ProductListPromotion(ctype: '4',catId: '0',catName: 'Promotions',total: model.promoProducts.length)
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
                      ),*/
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

              /*SliverPadding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 5),
                sliver: _newContentList(context),
              ),*/

              SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0,0,0,10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: _newContentList(context),
                  )
                ),
              ),


              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 0),
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
            ]),
          ));
        }
    );
  }


  Widget _fetchPromoList() {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return Container(
          margin: EdgeInsets.only(left: 9, right: 9),
          height: 220,
          width: 125,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: model.promoProducts.length,
            itemBuilder: (context, index) {
              var data = model.promoProducts[index];
              double leftMargin = 0;
              double rightMargin = 0;
              if (index != model.promoProducts.length - 1) {
                leftMargin = 5;
              } else {
                leftMargin = 5;
                rightMargin = 5;
              }
              double price = double.tryParse(data.price.toString()) ?? 0;
              assert(price is double);
              var hrgOri = price.toStringAsFixed(2);

              double price2 = double.tryParse(data.promoPrice.toString()) ?? 0;
              assert(price2 is double);
              var hrgPromo = price2.toStringAsFixed(2);
              return InkWell(
                onTap: () {
                  sharedPref.save("prd_id", model.promoProducts[index].id.toString());
                  sharedPref.save("prd_title", model.promoProducts[index].name);
                  Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductShowcase()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 2.5, right: 2.5, top: 5),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          /*image: DecorationImage(
                            image: CachedNetworkImageProvider(data.image,),
                            fit: BoxFit.cover,
                          ),*/
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(
                            color: Color(0xffF45432),
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 120.0,
                          imageUrl: data.image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  //colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          //placeholder: (context, url) => CupertinoActivityIndicator(radius: 15,),
                          placeholder: (context, url) =>
                              Container(
                                width: 30,
                                height: 30,
                                color: Colors.transparent,
                                child: CupertinoActivityIndicator(radius: 15,),
                              ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        width: 125.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              data.name,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.black, fontSize: 12,),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            /*Text(
                              data.merchant_name,
                              style: TextStyle(color: Colors.black.withOpacity(.7), fontSize: 10),
                            ),*/
                            Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: data.ispromo == '1' ?
                                      Container(
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 0),
                                              child: Text(
                                                "RM"+hrgPromo,
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600,),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 0),
                                              child: Text(
                                                "RM"+hrgOri,
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                                ),
                                              ),
                                            ),
                                          ])
                                      ) : Container(
                                      margin: EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(
                                        "RM"+hrgOri,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600,),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 5, top: 3),
                                    child: data.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 15, width: 24,) : Container(),
                                  ),
                                ]
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        );
      }
    );
  }

  Widget _newContentList(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: InkWell(
            onTap: () {Navigator.push(context, SlideRightRoute(page: KooperasiPage()));},
            child: SquareButton(
              icon: Image.asset('assets/icons/shop_koop.png'),
              label: 'Koperasi',
              lebar: 75,
              tinggi: 75,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: InkWell(
            onTap: () {Navigator.push(context, SlideRightRoute(page: NgoPage()));},
            child: SquareButton(
              icon: Image.asset('assets/icons/shop_wholesale.png'),
              label: 'NGO',
              lebar: 75,
              tinggi: 75,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: InkWell(
            onTap: () {Navigator.push(context, SlideRightRoute(page: DigitalPage()));},
            child: SquareButton(
              icon: Image.asset('assets/icons/shop_digital.png'),
              label: 'Digital',
              lebar: 75,
              tinggi: 75,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: InkWell(
            onTap: () {Navigator.push(context, SlideRightRoute(page: MerchantRegister('https://shopapp.e-dagang.asia/merchant/register', 'Join Us')));},
            child: SquareButton(
              icon: Image.asset('assets/icons/shop_join.png'),
              label: 'Join Us',
              lebar: 75,
              tinggi: 75,
            ),
          ),
        ),
      ],
    );

    /*return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {Navigator.push(context, SlideRightRoute(page: KooperasiPage()));},
                child: SquareButton(
                  icon: Image.asset('assets/icons/shop_koop.png',),
                  label: 'Koperasi',
                  lebar: 76,
                  tinggi: 76,
                ),
              ),
            ),
          ),
          SizedBox(width: 5,),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {Navigator.push(context, SlideRightRoute(page: NgoPage()));},
                child: SquareButton(
                  icon: Image.asset('assets/icons/shop_wholesale.png',),
                  label: 'NGO',
                  lebar: 76,
                  tinggi: 76,
                ),
              ),
            ),
          ),
          SizedBox(width: 5,),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {Navigator.push(context, SlideRightRoute(page: DigitalPage()));},
                child: SquareButton(
                  icon: Image.asset('assets/icons/shop_digital.png',),
                  label: 'Digital',
                  lebar: 76,
                  tinggi: 76,
                ),
              ),
            ),
          ),
          SizedBox(width: 5,),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {Navigator.push(context, SlideRightRoute(page: MerchantRegister('https://shopapp.e-dagang.asia/merchant/register', 'Join Us')));},
                child: SquareButton(
                  icon: Image.asset('assets/icons/shop_join.png',),
                  label: 'Join Us',
                  lebar: 76,
                  tinggi: 76,
                ),
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );*/
  }

  Widget _fetchCategories() {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return Container(
          margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 8),
          color: Colors.white,
          height: 120,
          alignment: Alignment.center,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: model.categories.length,
            itemBuilder: (context, index) {
              var data = model.categories[index];
              return Container(
                padding: EdgeInsets.only(left: 3.6, top: 8, right: 3.6,),
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 0.0,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    print("category name : " + model.categories[index].catname);
                    sharedPref.save("cat_id", model.categories[index].catid.toString());
                    sharedPref.save("cat_title", model.categories[index].catname);
                    Navigator.push(context, SlideRightRoute(page: ProductListCategory(model.categories[index].catid.toString(),model.categories[index].catname)));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(color: Color(0xffF45432), width: 1.0,),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 70.0,
                            width: 70.0,
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
                        padding: EdgeInsets.all(2.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                data.catname,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500,),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
            margin: EdgeInsets.only(left: 7, right: 7,),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var data = model.topProducts[index];
                  double leftMargin = 0;
                  double rightMargin = 0;
                  double radius = 16;
                  if (index != model.topProducts.length - 1) {
                    leftMargin = 7;
                  } else {
                    leftMargin = 7;
                    rightMargin = 7;
                  }

                  double price = double.tryParse(data.price.toString()) ?? 0;
                  assert(price is double);
                  var hrgOri = price.toStringAsFixed(2);

                  double price2 = double.tryParse(data.promoPrice.toString()) ?? 0;
                  assert(price2 is double);
                  var hrgPromo = price2.toStringAsFixed(2);

                  return InkWell(
                    child: Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  width: 120,
                                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: data.image ?? '',
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ),
                                ),
                                flex: 70,
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 120,
                                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                child: Text(
                                  data.name,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                  width: 120,
                                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: data.ispromo == '1' ?
                                          Container(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 2),
                                                      child: Text(
                                                        "RM"+hrgPromo,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500,),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 2),
                                                      child: Text(
                                                        "RM"+hrgOri,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                                        ),
                                                      ),
                                                    ),
                                                  ])
                                          ) : Container(
                                            margin: EdgeInsets.symmetric(horizontal: 2),
                                            child: Text(
                                              "RM"+hrgOri,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500,),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: data.delivery == '1' ? Image.asset(
                                          'assets/icons/ic_truck_free.png', height: 15,
                                          width: 24,) : Container(),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(height: 3),
                            ],
                          ),
                        ),
                      ),

                    ),
                    onTap: () {
                      sharedPref.save("prd_id", model.topProducts[index].id.toString());
                      sharedPref.save("prd_title", model.topProducts[index].name);
                      Navigator.push(context, SlideRightRoute(page: ProductShowcase()));
                    },
                    splashColor: Colors.deepOrange.shade100,
                    highlightColor: Colors.deepOrange.shade100,
                  );
                },
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

}

