import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/data/datas.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/screens/shop/more_popular.dart';
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
            backgroundColor: Colors.grey.shade100,
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

              /*SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(8, 10,8, 5),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0,0,0,10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: _newContentList(context),
                  )
                ),
              ),*/

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
            ]),
          ));
        }
    );
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
        crossAxisCount: 4,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var data = new_content[index];
        return Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
              ),
            ),
            elevation: 1.7,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
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
                      context, SlideRightRoute(page: DigitalPage()));
                }else if(data.id == 4) {
                  Navigator.push(
                      context, SlideRightRoute(page: MerchantRegister('https://office.e-dagang.asia/cartsini/register', 'Join Us')));
                }
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                        child: Image.asset(
                          data.imgPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 7,),
                    Container(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
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
      }, childCount: 4,
      ),
    );
  }

  Widget _fetchCategories() {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, child, model){
        return Container(
          padding: EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 0),
          color: Colors.transparent,
          height: 127,
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
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        width: 70.0,
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
                                  textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),
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

}

