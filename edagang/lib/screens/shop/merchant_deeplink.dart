import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/products_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MerchantShowcase extends StatefulWidget {
  @override
  _MerchantShowcaseState createState() {
    return new _MerchantShowcaseState();
  }
}

const xpandedHeight = 185.0;
class _MerchantShowcaseState extends State<MerchantShowcase> {
  BuildContext context;
  ProductScopedModel model;
  SharedPref sharedPref = SharedPref();
  int pageIndex = 1;
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
  String _id = "1";
  String _title = "Cartsini";
  String _jdate = "";
  String _state = "";
  String _image = "";

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

  loadPrefs() async {
    try {
      String id = await sharedPref.read("mer_id");
      String title = await sharedPref.read("mer_title");

      setState(() {
        _id = id;
        _title = title;

        print("merchant ID : "+_id);
        print("merchant NAME : "+_title);
      });

    } catch (Excepetion ) {
      print("error!");
    }
  }

  getMerchant() async {
    try {
      String id = await sharedPref.read("mer_id");
      String title = await sharedPref.read("mer_title");

      setState(() {
        _id = id;
        _title = title;

        Map<String, dynamic> postData = {
          'merchant_id': id,
          'sort': 'top',
        };

        http.post(
          Constants.shopProductMerchant,
          headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
          body: json.encode(postData),
        ).then((response) {
          var resBody = json.decode(response.body);
          print(resBody);

          setState(() {
            var mer_name = resBody['data']['merchant']['company_name'];
            _title = mer_name;
            _jdate = resBody['data']['merchant']['join_date'];
            _state = resBody['data']['merchant']['merchant_state']['state_name'];
            _image = resBody['data']['merchant']['user']['profile_pic'];

            print('${mer_name}');
            sharedPref.save('mer_title', '${mer_name}');

          });
        });

      });

    } catch (Excepetion ) {
      print("error!");
    }

  }

  @override
  void initState() {
    getMerchant();
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    loadPrefs();
  }

  bool get _showTitle {
    return _scrollController.hasClients
        && _scrollController.offset > xpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    ProductScopedModel productModel = ProductScopedModel();
    productModel.parseMerchantProductsFromResponse(int.parse(_id), 1, _currentlySelected);

    return ScopedModel<ProductScopedModel>(
      model: productModel,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
                expandedHeight: xpandedHeight,
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.black87,size: 24.0,),
                  onPressed: () {Navigator.of(context).pushNamed("/Main");},
                ),
                title: _showTitle ? Text(_title,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ) : null,
                flexibleSpace: _showTitle ? null : FlexibleSpaceBar(
                  title: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(''),
                      Text(''),
                    ],
                  ),
                  background: _buildHeader(),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 10),
                    child: dropdownWidget(),
                  ),
                ],
              ),
            ];
          },
          body: ProductsListMerchant(catId: int.parse(_id), filte: _currentlySelected),
        ),

        backgroundColor: Colors.grey.shade100,
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      height: 185,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: -95,
            top: -185,
            child: Container(
              width: 365,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //gradient: LinearGradient(List: [color1, color2]),
                  boxShadow: [
                    BoxShadow(color: color3,offset: Offset(4.0,4.0),blurRadius: 10.0)
                  ]
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 75, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 10.0, top: 0.0),
                  child: ClipOval(
                      child: _image == null ? Image.asset(
                        'images/ic_launcherVI.png', fit: BoxFit.cover,
                        height: 75,
                        width: 75,)
                          : CachedNetworkImage(
                        placeholder: (context, url) =>
                            Container(
                              width: 40,
                              height: 40,
                              color: Colors.transparent,
                              child: CupertinoActivityIndicator(
                                radius: 15,
                              ),
                            ),
                        imageUrl: Constants.urlImage + _image,
                        fit: BoxFit.cover,
                        height: 75,
                        width: 75,
                      )
                  ),
                  /*Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(37.5),
                      //border: new Border.all(color: Colors.white,width: 1.0,),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _image == null ? AssetImage('images/ic_launcherVI.png') : NetworkImage('https://app.e-dagang.asia' + _image),
                          fit: BoxFit.fill
                      )
                    ),
                  ),*/
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 235,
                        //padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                        child: Text(_title,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: _title.length > 22 ? 2 : 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 3.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Member since:',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(_jdate,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:0.0, top: 3.0,),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('State:',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(_state,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ]
                        ),

                      ),
                    ]
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

}

class ProductsListMerchant extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final int catId;
  final String filte;
  ProductsListMerchant({@required this.catId, this.filte});

  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        //return _buildListView();
        return model.isLoadingMer ? _buildCircularProgressIndicator() : _buildListView();
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

  _buildListView() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: model.getProductsCount() == 0 ? Container(
        //padding: EdgeInsets.only(top: 150),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(CupertinoIcons.clear_circled, color: Colors.red.shade500, size: 50,),
              SizedBox(height: 10,),
              Text(
                'This merchant has no product.',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey.shade900),
                ),
              ),
            ],
          ),
        ),
        color: Colors.transparent,
      ) :

      ListView.builder(
        //primary: false,
        //shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        itemCount: model.getProductsCount() + 2,
        itemBuilder: (context, index) {
          if (index == model.getProductsCount()) {
            if (model.hasMoreProducts) {
              pageIndex++;
              model.parseMerchantProductsFromResponse(catId, pageIndex, filte);
              return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.transparent,
                      child: CupertinoActivityIndicator(
                        radius: 17,
                      ),
                    ),
                  )
              );
            }
            return Container();
          } else if (index == 0) {
            //0th index would contain filter icons
            return Container();
            //return _buildFilterWidgets(screenSize);
          } else if (index % 2 == 0) {
            //2nd, 4th, 6th.. index would contain nothing since this would
            //be handled by the odd indexes where the row contains 2 items
            return Container();
          } else {
            //1st, 3rd, 5th.. index would contain a row containing 2 products

            if (index > model.getProductsCount() - 1) {
              return Container();
            }

            return ProductsListItem(
              product1: model.productsList[index - 1],
              product2: model.productsList[index],
            );
          }
        },
      ),
    );
  }

}
