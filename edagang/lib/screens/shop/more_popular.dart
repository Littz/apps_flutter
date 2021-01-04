import 'package:edagang/scoped/scoped_product.dart';
import 'package:edagang/widgets/products_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          title: Text(widget.catName,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,),
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
        body: ProductsListTopBody(filte: _currentlySelected),
        backgroundColor: Colors.grey.shade100,
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
        return model.isLoadingTop ? _buildCircularProgressIndicator() : _buildListView();
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
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: model.getProductsCount() == 0
          ? Center(child: Text("No products available."))
          : /*GridView.builder(
        itemCount: model.getProductsCount(),

        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 0.95),
        ),
        itemBuilder: (BuildContext context, int index) {
          var data = model.productsList[index];

          if (index == model.getProductsCount()) {
            if (model.hasMoreProducts) {
              pageIndex++;
              model.parseCategoryProductsFromResponse(catId, pageIndex);
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
          } else {
            if (model.hasMoreProducts) {
              pageIndex++;
              model.parseCategoryProductsFromResponse(catId, pageIndex);
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

            return new GestureDetector(
              child: new Card(
                elevation: 5.0,
                child: new Container(
                  alignment: Alignment.centerLeft,
                  margin: new EdgeInsets.only(bottom: 10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 240.0,
                          width: MediaQuery.of(context).size.width / 2.2,
                          //margin: EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: 40,
                              height: 40,
                              color: Colors.transparent,
                              child: CupertinoActivityIndicator(
                                radius: 15,
                              ),
                            ),
                            imageUrl: data.image,
                            height: 240.0,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(1),
                                  topRight: Radius.circular(1))
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            data.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: data.ispromo == '1' ?
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${data.price}",
                                        style: TextStyle(fontSize: 12.0, color: Colors.red),
                                      ),
                                      Text(
                                        "${data.promoPrice}",
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ]
                                ) : Text(
                                  "${data.price}",
                                  style: TextStyle(fontSize: 12.0, color: Colors.red),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: data.delivery == '1' ? Image.asset('assets/icons/ic_truck_free.png', height: 15, width: 24,) : Container(),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                        barrierDismissible: false,
                        context: context,
                        child: new CupertinoAlertDialog(
                          title: new Column(
                            children: <Widget>[
                              new Text("GridView"),
                              new Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          content: new Text( spacecrafts[index]),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: new Text("OK")
                            )
                          ],
                        )
                    );
              },
            );
          }

        },
      ),*/

      ListView.builder(
        itemCount: model.getProductsCount() + 2,
        itemBuilder: (context, index) {
          if (index == model.getProductsCount()) {
            if (model.hasMoreProducts) {
              pageIndex++;
              model.parseTopProductsFromResponse(pageIndex, filte);
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
