import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:edagang/widgets/products_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListTop extends StatefulWidget {
  final String ctype;
  final String catId;
  final String catName;
  final int total;
  ProductListTop({this.ctype, this.catId, this.catName, this.total});

  @override
  KeyValuePairDropdownState4 createState() {
    return new KeyValuePairDropdownState4();
  }
}

class KeyValuePairDropdownState4 extends State<ProductListTop> {
  BuildContext context;
  ProductScopedModel model;

  int pageIndex = 1;
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
  Widget build(BuildContext context) {
    ProductScopedModel productModel = ProductScopedModel();
    productModel.parseTopProductsFromResponse(1, _currentlySelected);

    return ScopedModel<ProductScopedModel>(
      model: productModel,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color(0xff084B8C),
          ),
          title: Text(widget.catName,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 18, color: Colors.black,),
            ),
          ),
          flexibleSpace: Container(
            color: Colors.white,
            /*decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color(0xffF45432),
                  Colors.deepOrangeAccent.shade100,
                ],
              ),
            ),*/
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 10),
              child: dropdownWidget(),
            ),
          ],
        ),
        backgroundColor: Color(0xffEEEEEE),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 10),
              sliver: ProductsListTopBody(filte: _currentlySelected),
            ),
          ]
        )
      ),
    );
  }
}

class ProductsListTopBody extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final String filte;
  ProductsListTopBody({@required this.filte,});

  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return _buildListView();
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
