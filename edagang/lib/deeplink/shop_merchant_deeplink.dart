import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/SABTitle.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';


class MerchantDeeplink extends StatefulWidget {
  String mercId, mercName;
  MerchantDeeplink(this.mercId, this.mercName);

  @override
  _MerchantDeeplinkState createState() {
    return new _MerchantDeeplinkState();
  }
}

const xpandedHeight = 185.0;

class _MerchantDeeplinkState extends State<MerchantDeeplink> {
  BuildContext context;
  ProductScopedModel model;
  SharedPref sharedPref = SharedPref();
  int pageIndex = 1;
  String _dl = "";
  ScrollController _scrollController;

  final Color color1 = Colors.grey;
  final Color color2 = Colors.white;
  final Color color3 = Colors.grey.shade300;

  final List<String> _dropdownValues = [
    "Popular",
    "Lowest",
    "Highest"
  ];
  String _currentlySelected = "Popular";
  Widget dropdownWidget() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: _dropdownValues.map((value) => DropdownMenuItem(
            child: Text(value),
            value: value,
          )).toList(),

          onChanged: (String value) {
            setState(() {
              _currentlySelected = value;
            });
          },
          isExpanded: false,
          value: _currentlySelected,
        )
    );
  }

  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'Deeplink_Cartsini_merchant_'+widget.mercName,parameters:null);
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > xpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    ProductScopedModel productModel = ProductScopedModel();
    productModel.parseMerchantProductsFromResponse(int.parse(widget.mercId), 1, _currentlySelected);

    return ScopedModel<ProductScopedModel>(
      model: productModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              expandedHeight: xpandedHeight,
              leading: InkWell(
                onTap: () {Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(1)));},
                splashColor: Colors.deepOrange.shade100,
                highlightColor: Colors.deepOrange.shade100,
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
              pinned: true,
              primary: true,
              title: SABTs(
                child: MerchantName(catId: int.parse(widget.mercId)),
              ),
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white
                  /*gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color(0xffF45432),
                      Colors.deepOrangeAccent.shade100,
                    ],
                  ),*/
                ),
                child: _showTitle ? null : FlexibleSpaceBar(
                  background: ProfileMerchant(catId: int.parse(widget.mercId)),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 10),
                  child: dropdownWidget(),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 10),
              sliver: ProductsListMerchantBody(catId: int.parse(widget.mercId), filte: _currentlySelected),
            ),
            SliverFillRemaining(
              child: new Container(color: Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }
}

class MerchantName extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final int catId;
  Map<dynamic, dynamic> responseBody;
  MerchantName({@required this.catId});

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return _getMercName();
      },
    );
  }

  _getMercName() {
    return Text(model.getCompanyName() ?? '',
      style: GoogleFonts.lato(
        textStyle: TextStyle(fontSize: 16, color: Colors.black,),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}

class ProfileMerchant extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final int catId;
  //final String filte;
  ProfileMerchant({@required this.catId});

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return _buildMerchantProfile();
      },
    );
  }

  _buildMerchantProfile() {
    return Container(
      height: 205,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 85, left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 10.0, top: 0.0),
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 2.5,
                          spreadRadius: 0.0,
                          offset: Offset(2.5, 2.5),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: model.getProfilePic().toString() == 'null' ? Image.asset('assets/icons/ic_launcher_new.png', height: 75, width: 75, fit: BoxFit.cover,) : CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 75,
                        width: 75,
                        imageUrl: Constants.urlImage + model.getProfilePic().toString() ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          child: CupertinoActivityIndicator(radius: 15,),
                        ),
                        errorWidget: (context, url, error) => ClipOval(child: Image.asset('assets/icons/ic_image_error.png', height: 75, width: 75, fit: BoxFit.cover,)),
                      ),
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 235,
                        //padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                        child: Text(model.getCompanyName() ?? '',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:0.0, top: 3.0,),
                        child: Text(model.getStateName() ?? '',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.black),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 3.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Joined : ",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.black),
                            ),
                            children: <TextSpan>[
                              TextSpan(text: model.getJoinDate() ?? '',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),

                      Container(
                        height: 40,
                        padding: const EdgeInsets.only(top: 12,),
                        child: RaisedButton.icon(
                            onPressed: () async {
                              await FlutterShare.share(
                                title: 'Cartsini',
                                text: '',
                                linkUrl: 'https://shopapp.e-dagang.asia/merchant/'+model.getMid().toString(),
                                chooserTitle: model.getCompanyName(),
                              );
                            },
                            icon: Icon(Icons.share, size: 22, color: Colors.white,),
                            label: Text('SHARE',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700,),
                              ),
                              //textAlign: TextAlign.center,
                            ),
                            color: Colors.deepOrange,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)
                            )
                        ),
                      ),
                    ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsListMerchantBody extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final int catId;
  final String filte;
  ProductsListMerchantBody({@required this.catId, this.filte});

  int pageIndex = 1;

  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> responseBody;
  Product product;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return _buildGridList();
      },
    );
  }

  _buildGridList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: new SliverStaggeredGrid.countBuilder(
        crossAxisCount: 4,
        mainAxisSpacing: 0.5,
        crossAxisSpacing: 0.5,
        itemCount: model.getProductsCount(),
        itemBuilder: (context, index) =>
            ProductCardItem(
              product: model.productsList[index],
            ),
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      ),
    );
  }
}
