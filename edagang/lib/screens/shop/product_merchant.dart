import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/main.dart';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/screens/shop/product_detail.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductListMerchant extends StatefulWidget {
  String mercId, mercName;
  ProductListMerchant(this.mercId, this.mercName);

  @override
  _ProductListMerchantState createState() {
    return new _ProductListMerchantState();
  }
}

const xpandedHeight = 185.0;

class _ProductListMerchantState extends State<ProductListMerchant> {
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
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              leading: InkWell(
                onTap: () {Navigator.pop(context);},
                splashColor: Colors.deepOrange.shade100,
                highlightColor: Colors.deepOrange.shade100,
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
              pinned: true,
              primary: true,
              title: SABT(
                child: Container(
                  child: Text(widget.mercName.replaceAll('%20', ' ') ?? '',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )
                ),
              ),
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color(0xffF45432),
                      Colors.deepOrangeAccent.shade100,
                    ],
                  ),
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
            )
          ],
        ),
      ),
    );
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
    context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    bool visible = settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}

class ProfileMerchant extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final int catId;
  //final String filte;
  ProfileMerchant({@required this.catId});


  Future<void> share() async {
  await FlutterShare.share(
  title: 'Cartsini',
  text: '',
  linkUrl: 'https://shopapp.e-dagang.asia/merchant/'+model.getMid().toString(),
  chooserTitle: model.getCompanyName(),
  );
  }

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
                  child: ClipOval(
                    child: model.getProfilePic() == null ? Container(width: 75,height: 75,color: Colors.grey.shade200,) : CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 75,
                      width: 75,
                      imageUrl: Constants.urlImage + model.getProfilePic() ?? '',
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
                        width: 75,
                        height: 75,
                        color: Colors.grey.shade200,
                        //child: CupertinoActivityIndicator(radius: 15,),
                      ),
                      errorWidget: (context, url, error) => Icon(CupertinoIcons.photo, size: 36, color: Colors.grey.shade200,),
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
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:0.0, top: 3.0,),
                        child: Text(model.getStateName() ?? '',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.white),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 3.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Members since ",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.white),
                            ),
                            children: <TextSpan>[
                              TextSpan(text: model.getJoinDate() ?? '',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                          /*Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Member since:',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Colors.white),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(model.getJoinDate() ?? '',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ]
                        ),*/
                      ),

                      Container(
                        height: 40,
                        padding: const EdgeInsets.only(top: 12,),
                        child: OutlineButton.icon(
                          onPressed: () => share(),
                          icon: Icon(Icons.share, size: 20, color: Colors.white,),
                          label: Text('SHARE',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700,),
                            ),
                            //textAlign: TextAlign.center,
                          ),
                          highlightedBorderColor: Colors.orange,
                          color: Colors.transparent,
                          borderSide: new BorderSide(color: Colors.white),
                          shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)
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
        //return model.isLoadingMer ? _buildCircularProgressIndicator() : _buildListView();
      },
    );
  }

  _buildCircularProgressIndicator() {
    return Container(
      padding: EdgeInsets.only(top: 150),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        ),
      ),
      color: Colors.transparent,
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