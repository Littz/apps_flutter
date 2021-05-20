import 'dart:math';
import 'dart:ui';
import 'package:edagang/main.dart';
import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/utils/shared_prefs.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:edagang/widgets/products_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryDeeplink extends StatefulWidget {
  String catId, catName;
  CategoryDeeplink(this.catId, this.catName);

  @override
  _CategoryDeeplinkState createState() {
    return new _CategoryDeeplinkState();
  }
}

class _CategoryDeeplinkState extends State<CategoryDeeplink> {
  BuildContext context;
  ProductScopedModel model;
  int pageIndex = 1;
  SharedPref sharedPref = SharedPref();

  final Color color2 = Colors.grey;
  final Color color1 = Colors.white;
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
  }

  @override
  Widget build(BuildContext context) {
    ProductScopedModel productModel = ProductScopedModel();
    productModel.parseCategoryProductsFromResponse(int.parse(widget.catId), 1, _currentlySelected);

    return new ScopedModel<ProductScopedModel>(
      model: productModel,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.catName,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,),
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          leading: InkWell(
            onTap: () {Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(1)));},
            splashColor: Colors.deepOrange.shade100,
            highlightColor: Colors.deepOrange.shade100,
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          flexibleSpace: Container(
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
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 10),
              child: dropdownWidget(),
            ),
          ],
        ),
        body: ProductsListCategoryBody(catId: int.parse(widget.catId), filte: _currentlySelected),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

}

class ProductsListCategoryBody extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final int catId;
  final String filte;
  Map<dynamic, dynamic> responseBody;
  ProductsListCategoryBody({@required this.catId, this.filte});
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoadingCat ? _buildCircularProgressIndicator() : _buildListView();
      },
    );
  }

  _buildCircularProgressIndicator() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
        child: CupertinoActivityIndicator(
          radius: 22,
        ),
      ),
    );
  }

  _buildListView() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: model.getProductsCount() == 0 ? Center(child: Text("No products available."))
          : ListView.builder(
        //padding: EdgeInsets.only(top: 5, left: 15, right: 15),
        //physics: NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
        itemCount: model.getProductsCount() + 2,
        itemBuilder: (context, index) {
          if (index == model.getProductsCount()) {
            if (model.hasMoreProducts) {
              pageIndex++;
              model.parseCategoryProductsFromResponse(catId, pageIndex, filte);
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

