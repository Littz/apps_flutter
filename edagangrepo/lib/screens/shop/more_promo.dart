import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/widgets/product_grid_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPromotion extends StatefulWidget {
  final String ctype;
  final String catId;
  final String catName;
  final int total;
  ProductListPromotion({this.ctype, this.catId, this.catName, this.total});

  @override
  KeyValuePairDropdownState3 createState() {
    return new KeyValuePairDropdownState3();
  }
}

class KeyValuePairDropdownState3 extends State<ProductListPromotion> {
  BuildContext context;
  ProductScopedModel model;

  int pageIndex = 1;

  //String dropdownValue = 'Popular';
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
    productModel.parsePromoProductsFromResponse(1, _currentlySelected);

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
          title: Text(
            widget.catName, //+' - '+widget.total.toString(),
            style: TextStyle(
              fontSize: 18, color: Colors.black,
            ),
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
              sliver: ProductsListPromoBody(filte: _currentlySelected),
            ),
          ]
        )
      ),
    );
  }
}

class ProductsListPromoBody extends StatelessWidget {
  BuildContext context;
  ProductScopedModel model;
  final String filte;
  ProductsListPromoBody({@required this.filte,});
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
