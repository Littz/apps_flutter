import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductScopedModel extends Model {

  List<Product> _productsList = [];
  Product productDetail = new Product();
  bool _isLoading = true;
  bool _isLoadingCat = false;
  bool _isLoadingTop = false;
  bool _isLoadingPro = false;
  bool _isLoadingMer = false;
  bool _hasModeProducts = true;
  int totCount = 0;
  int currentProductCount;
  List<Product> get productsList => _productsList;
  bool get isLoading => _isLoading;
  bool get isLoadingTop => _isLoadingTop;
  bool get isLoadingCat => _isLoadingCat;
  bool get isLoadingPro => _isLoadingPro;
  bool get isLoadingMer => _isLoadingMer;

  bool get hasMoreProducts => _hasModeProducts;

  void addToProductsList(Product product) {
    _productsList.add(product);
  }

  int getProductsCount() {
    return _productsList.length;
  }


  int mid;
  String user_id, brand_name, company_name, company_no, join_date, state, profile_pic, state_name;

  int getMid() {return mid;}
  String getUserId() {return user_id;}
  String getBrandName() {return brand_name;}
  String getCompanyName() {return company_name;}
  String getCompanyNo() {return company_no;}
  String getJoinDate() {return join_date;}
  String getState() {return state;}
  String getProfilePic() {return profile_pic;}
  String getStateName() {return state_name;}


  Future<dynamic> _getProductsByCategory(categoryId, pageIndex, filte) async {
    String filter = 'Popular';
    if(filte == 'Popular'){filter = 'top';}
    else if (filte == 'Lowest'){filter = 'asc';}
    else if (filte == 'Highest'){filter = 'desc';}
    else {filter = 'top';}

    Map<String, dynamic> postData = {
      'category_id': categoryId,
      'sort': filter,
      'page': pageIndex,
    };

    var response = await http.post(
      Constants.shopProductCategory,
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError(
          (error) {
        print(error.toString());
        return false;
      },
    );

    return json.decode(response.body);
  }

  Future<dynamic> _getProductsByMerchant(merchantId, pageIndex, filte) async {
    String filter = 'Popular';
    if(filte == 'Popular'){filter = 'top';}
    else if (filte == 'Lowest'){filter = 'asc';}
    else if (filte == 'Highest'){filter = 'desc';}
    else {filter = 'top';}

    Map<String, dynamic> postData = {
      'merchant_id': merchantId,
      'sort': filter,
      'page': pageIndex,
    };

    var response = await http.post(
      Constants.shopProductMerchant,
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError(
          (error) {
        print(error.toString());
        return false;
      },
    );
    return json.decode(response.body);
  }

  Future<dynamic> _getProductsPromo(pageIndex, filte) async {
    String filter = 'Popular';
    if(filte == 'Popular'){filter = 'top';}
    else if (filte == 'Lowest'){filter = 'asc';}
    else if (filte == 'Highest'){filter = 'desc';}
    else {filter = 'top';}

    Map<String, dynamic> postData = {
      'sort': filter,
      'page': pageIndex,
    };

    var response = await http.post(
      Constants.shopAPI+'/product/promo',
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError(
          (error) {
        print(error.toString());
        return false;
      },
    );
    return json.decode(response.body);
  }

  Future<dynamic> _getProductsTop(pageIndex, filte) async {
    String filter = 'Popular';
    if(filte == 'Popular'){filter = 'top';}
    else if (filte == 'Lowest'){filter = 'asc';}
    else if (filte == 'Highest'){filter = 'desc';}
    else {filter = 'top';}

    Map<String, dynamic> postData = {
      'sort': filter,
      'page': pageIndex,
    };

    var response = await http.post(
      Constants.shopAPI+'/product/top',
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError(
          (error) {
        print(error.toString());
        return false;
      },
    );
    return json.decode(response.body);
  }

  Future parseCategoryProductsFromResponse(int categoryId, int pageIndex, String filte) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(prefs.getString('email'));
    if (pageIndex == 1) {_isLoadingCat = true;}
    notifyListeners();
    currentProductCount = 0;
    var dataFromResponse = await _getProductsByCategory(categoryId, pageIndex, filte);

    totCount = dataFromResponse["data"]["products"]["total"];
    print(totCount.toString());
    prefs.setString('total_item', totCount.toString());

    dataFromResponse["data"]["products"]["data"].forEach(
          (newProduct) {
        currentProductCount++;

        List<Images> imagesOfProductList = [];
        newProduct["product_image"].forEach(
              (newImage) {
            imagesOfProductList.add(
              new Images(
                id: newImage["id"],
                productId: newImage["product_id"].toString(),  // after migration -> int to string
                imageURL: Constants.urlImage+newImage["image_url"],
              ),
            );
          },
        );

        List<Review> reviewsList = [];
        newProduct["product_review"].forEach(
              (newRview) {
            reviewsList.add(
              new Review(
                  user_id: newRview["user_id"].toString(), // after migration -> int to string
                  product_id: newRview["product_id"].toString(), // after migration -> int to string
                  review_text: newRview["review_text"],
                  rating: newRview["rating"].toString(), // after migration -> int to string
                  userName: newRview["user"]["fullname"]
              ),
            );
          },
        );

        Product product = new Product(
          id: newProduct["id"],
          name: newProduct["name"],
          summary: newProduct["summary"],
          details: newProduct["details"],
          price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
          promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
          delivery: newProduct["delivery_included"].toString() != null ? newProduct["delivery_included"].toString() : 'Exclude delivery', // after migration -> int to string
          ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
          image: Constants.urlImage+newProduct["main_image"],
          merchant_id: newProduct['merchant_id'],
          merchant_name: newProduct['merchant']['company_name'],
          reviews: reviewsList,
          //stockQty: newProduct["stock"] != null ? newProduct["stock"] : 0,
          //ifItemAvailable: newProduct["ispromo"] && newProduct["purchasable"] && newProduct["in_stock"],
          //discount: ((((int.parse(newProduct["price"]) - int.parse(newProduct["promo_price"])) / (int.parse(newProduct["price"]))) * 100)).round(),
          images: imagesOfProductList,
          hasVariants: newProduct['have_variation'],
          stock: newProduct['stock'].toString(), // after migration -> int to string
          minOrder: newProduct['min_order'],
          //categories: categoriesOfProductList,
        );
        addToProductsList(product);
      },
    );

    if (pageIndex == 1) _isLoadingCat = false;
    if (currentProductCount < 10) {
      _hasModeProducts = false;
    }
    notifyListeners();
  }

  Future parseMerchantProductsFromResponse(int merchantId, int pageIndex, String filte) async {
    _isLoadingMer = true;
    notifyListeners();
    currentProductCount = 0;
    var dataFromResponse = await _getProductsByMerchant(merchantId, pageIndex, filte);

    mid = dataFromResponse['data']['merchant']['id'];
    user_id = dataFromResponse['data']['merchant']['user_id'];
    brand_name = dataFromResponse['data']['merchant']['brand_name'];
    company_name = dataFromResponse['data']['merchant']['company_name'];
    company_no = dataFromResponse['data']['merchant']['company_no'];
    join_date = dataFromResponse['data']['merchant']['join_date'];
    state = dataFromResponse['data']['merchant']['state'];
    profile_pic = dataFromResponse['data']['merchant']['logo_url'];
    state_name = dataFromResponse['data']['merchant']['merchant_state']['state_name'];

    dataFromResponse["data"]["products"]["data"].forEach(
          (newProduct) {
        currentProductCount++;

        List<Images> imagesOfProductList = [];
        newProduct["product_image"].forEach(
              (newImage) {
            imagesOfProductList.add(
              new Images(
                id: newImage["id"],
                productId: newImage["product_id"].toString(), // after migration -> int to string
                imageURL: Constants.urlImage+newImage["image_url"],
              ),
            );
          },
        );

        List<Review> reviewsList = [];
        newProduct["product_review"].forEach(
              (newRview) {
            reviewsList.add(
              new Review(
                  user_id: newRview["user_id"].toString(), // after migration -> int to string
                  product_id: newRview["product_id"].toString(), // after migration -> int to string
                  review_text: newRview["review_text"],
                  rating: newRview["rating"].toString(), // after migration -> int to string
                  userName: newRview["user"]["fullname"]
              ),
            );
          },
        );

        Product product = new Product(
          id: newProduct["id"],
          name: newProduct["name"],
          summary: newProduct["summary"],
          details: newProduct["details"],
          price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
          promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
          delivery: newProduct["delivery_included"],
          ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
          image: Constants.urlImage+newProduct["main_image"].toString(),
          merchant_id: newProduct['merchant_id'],
          merchant_name: newProduct['merchant']['company_name'],
          reviews: reviewsList,
          //stockQty: newProduct["stock"] != null ? newProduct["stock"] : 0,
          //ifItemAvailable: newProduct["ispromo"] && newProduct["purchasable"] && newProduct["in_stock"],
          //discount: ((((int.parse(newProduct["price"]) - int.parse(newProduct["promo_price"])) / (int.parse(newProduct["price"]))) * 100)).round(),
          images: imagesOfProductList,
          hasVariants: newProduct['have_variation'],
          stock: newProduct['stock'].toString(), // after migration -> int to string
          minOrder: newProduct.containsKey('min_order') ? newProduct['min_order'] : 1,
          //categories: categoriesOfProductList,
        );
        addToProductsList(product);
      },
    );

    _isLoadingMer = false;
    if (currentProductCount < 10) {
      _hasModeProducts = false;
    }
    notifyListeners();
  }

  Future parsePromoProductsFromResponse(int pageIndex, String filte) async {
    if (pageIndex == 1) {_isLoadingPro = true;}
    notifyListeners();
    currentProductCount = 0;
    var dataFromResponse = await _getProductsPromo(pageIndex, filte);

    dataFromResponse["data"]["products"]["data"].forEach(
          (newProduct) {
        currentProductCount++;

        List<Images> imagesOfProductList = [];
        newProduct["product_image"].forEach(
              (newImage) {
            imagesOfProductList.add(
              new Images(
                id: newImage["id"],
                productId: newImage["product_id"].toString(), // after migration -> int to string
                imageURL: Constants.urlImage+newImage["image_url"],
              ),
            );
          },
        );

        List<Review> reviewsList = [];
        newProduct["product_review"].forEach(
              (newRview) {
            reviewsList.add(
              new Review(
                  user_id: newRview["user_id"].toString(), // after migration -> int to string
                  product_id: newRview["product_id"].toString(), // after migration -> int to string
                  review_text: newRview["review_text"],
                  rating: newRview["rating"].toString(), // after migration -> int to string
                  userName: newRview["user"]["fullname"]
              ),
            );
          },
        );

        Product product = new Product(
          id: newProduct["id"],
          name: newProduct["name"],
          summary: newProduct["summary"],
          details: newProduct["details"],
          price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
          promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
          delivery: newProduct["delivery_included"],
          ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
          image: Constants.urlImage+newProduct["main_image"],
          merchant_id: newProduct['merchant_id'],
          merchant_name: newProduct['merchant']['company_name'],
          reviews: reviewsList,
          //stockQty: newProduct["stock"] != null ? newProduct["stock"] : 0,
          //ifItemAvailable: newProduct["ispromo"] && newProduct["purchasable"] && newProduct["in_stock"],
          //discount: ((((int.parse(newProduct["price"]) - int.parse(newProduct["promo_price"])) / (int.parse(newProduct["price"]))) * 100)).round(),
          images: imagesOfProductList,
          hasVariants: newProduct['have_variation'],
          stock: newProduct['stock'].toString(), // after migration -> int to string
          minOrder: newProduct.containsKey('min_order') ? newProduct['min_order'] : 1,
          //categories: categoriesOfProductList,
        );
        addToProductsList(product);
      },
    );

    if (pageIndex == 1) _isLoadingPro = false;
    if (currentProductCount < 10) {
      _hasModeProducts = false;
    }
    notifyListeners();
  }

  Future parseTopProductsFromResponse(int pageIndex, String filte) async {
    if (pageIndex == 1) {_isLoadingTop = true;}
    notifyListeners();
    currentProductCount = 0;
    var dataFromResponse = await _getProductsTop(pageIndex, filte);

    dataFromResponse["data"]["products"]["data"].forEach(
          (newProduct) {
        currentProductCount++;

        List<Images> imagesOfProductList = [];
        newProduct["product_image"].forEach(
              (newImage) {
            imagesOfProductList.add(
              new Images(
                id: newImage["id"],
                productId: newImage["product_id"].toString(), // after migration -> int to string
                imageURL: Constants.urlImage+newImage["image_url"],
              ),
            );
          },
        );

        List<Review> reviewsList = [];
        newProduct["product_review"].forEach(
              (newRview) {
            reviewsList.add(
              new Review(
                  user_id: newRview["user_id"].toString(), // after migration -> int to string
                  product_id: newRview["product_id"].toString(), // after migration -> int to string
                  review_text: newRview["review_text"],
                  rating: newRview["rating"].toString(), // after migration -> int to string
                  userName: newRview["user"]["fullname"]
              ),
            );
          },
        );

        Product product = new Product(
          id: newProduct["id"],
          name: newProduct["name"],
          summary: newProduct["summary"],
          details: newProduct["details"],
          price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
          promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
          delivery: newProduct["delivery_included"],
          ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
          image: Constants.urlImage+newProduct["main_image"],
          merchant_id: newProduct['merchant_id'],
          merchant_name: newProduct['merchant']['company_name'],
          reviews: reviewsList,
          //stockQty: newProduct["stock"] != null ? newProduct["stock"] : 0,
          //ifItemAvailable: newProduct["ispromo"] && newProduct["purchasable"] && newProduct["in_stock"],
          //discount: ((((int.parse(newProduct["price"]) - int.parse(newProduct["promo_price"])) / (int.parse(newProduct["price"]))) * 100)).round(),
          images: imagesOfProductList,
          hasVariants: newProduct['have_variation'],
          stock: newProduct['stock'].toString(), // after migration -> int to string
          minOrder: newProduct.containsKey('min_order') ? newProduct['min_order'] : 1,
          //categories: categoriesOfProductList,
        );
        addToProductsList(product);
      },
    );

    if (pageIndex == 1) _isLoadingTop = false;
    if (currentProductCount < 10) {
      _hasModeProducts = false;
    }
    notifyListeners();
  }

  Future fetchProductByCategory(catId, sort, offset, limit) async {
    _isLoading = true;
    productsList.clear();
    notifyListeners();
    currentProductCount = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _sort = 'Popular';
    if(sort == 'Popular'){_sort = 'top';}
    else if (sort == 'Lowest'){_sort = 'asc';}
    else if (sort == 'Highest'){_sort = 'desc';}
    else {_sort = 'top';}

    Map<String, dynamic> postData = {
      'category_id': catId,
      'sort': _sort,
      'page': offset,
    };

    http.post(
      Constants.shopProductCategory,
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).then((response) {
      print(response.body);
      var dataFromResponse = json.decode(response.body);
      print(dataFromResponse);

      totCount = dataFromResponse["data"]["products"]["total"];
      print(totCount.toString());
      prefs.setString('total_item', totCount.toString());

      dataFromResponse["data"]["products"]["data"].forEach(
            (newProduct) {
          currentProductCount++;

          List<Images> imagesOfProductList = [];
          newProduct["product_image"].forEach(
                (newImage) {
              imagesOfProductList.add(
                new Images(
                  id: newImage["id"],
                  productId: newImage["product_id"].toString(), // after migration -> int to string
                  imageURL: Constants.urlImage+newImage["image_url"],
                ),
              );
            },
          );

          List<Review> reviewsList = [];
          newProduct["product_review"].forEach(
                (newRview) {
              reviewsList.add(
                new Review(
                    user_id: newRview["user_id"].toString(), // after migration -> int to string
                    product_id: newRview["product_id"].toString(), // after migration -> int to string
                    review_text: newRview["review_text"],
                    rating: newRview["rating"].toString(), // after migration -> int to string
                    userName: newRview["user"]["fullname"]
                ),
              );
            },
          );

          Product product = new Product(
            id: newProduct["id"],
            name: newProduct["name"],
            summary: newProduct["summary"],
            details: newProduct["details"],
            price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
            promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
            delivery: newProduct["delivery_included"],
            ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
            image: Constants.urlImage+newProduct["main_image"],
            merchant_id: newProduct['merchant_id'],
            merchant_name: newProduct['merchant']['company_name'],
            reviews: reviewsList,
            //stockQty: newProduct["stock"] != null ? newProduct["stock"] : 0,
            //ifItemAvailable: newProduct["ispromo"] && newProduct["purchasable"] && newProduct["in_stock"],
            //discount: ((((int.parse(newProduct["price"]) - int.parse(newProduct["promo_price"])) / (int.parse(newProduct["price"]))) * 100)).round(),
            images: imagesOfProductList,
            hasVariants: newProduct['have_variation'],
            stock: newProduct['stock'].toString(), // after migration -> int to string
            minOrder: newProduct['min_order'],
            //categories: categoriesOfProductList,
          );
          addToProductsList(product);
        },
      );

      //if (pageIndex == 1) _isLoading = false;
      if (currentProductCount < 10) {
        _hasModeProducts = false;
      }
      notifyListeners();
    });
  }


  Future<dynamic> _getProductNgo(associateId, pageIndex, filte) async {
    String filter = 'Popular';
    if(filte == 'Popular'){filter = 'top';}
    else if (filte == 'Lowest'){filter = 'asc';}
    else if (filte == 'Highest'){filter = 'desc';}
    else {filter = 'top';}

    Map<String, dynamic> postData = {
      'associate_id': associateId,
      'sort': filter,
      'page': pageIndex,
    };

    var response = await http.post(
      Constants.shopNgoProduct,
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError(
          (error) {
        print(error.toString());
        return false;
      },
    );
    return json.decode(response.body);
  }

  Future parseNgoProductsFromResponse(int associateId, int pageIndex, String filte) async {
    if (pageIndex == 1) {_isLoadingPro = true;}
    notifyListeners();
    currentProductCount = 0;
    var dataFromResponse = await _getProductNgo(associateId, pageIndex, filte);

    dataFromResponse["data"]["products"]["data"].forEach(
          (newProduct) {
        currentProductCount++;

        List<Images> imagesOfProductList = [];
        newProduct["product_image"].forEach((newImage) {
          imagesOfProductList.add(
            new Images(
              id: newImage["id"],
              productId: newImage["product_id"].toString(), // after migration -> int to string
              imageURL: Constants.urlImage+newImage["image_url"],
            ),
          );
        },
        );

        List<Review> reviewsList = [];
        newProduct["product_review"].forEach(
              (newRview) {
            reviewsList.add(
              new Review(
                  user_id: newRview["user_id"].toString(), // after migration -> int to string
                  product_id: newRview["product_id"].toString(), // after migration -> int to string
                  review_text: newRview["review_text"],
                  rating: newRview["rating"].toString(), // after migration -> int to string
                  userName: newRview["user"]["fullname"]
              ),
            );
          },
        );

        Product product = new Product(
          id: newProduct["id"],
          name: newProduct["name"],
          summary: newProduct["summary"],
          details: newProduct["details"],
          price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
          promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
          delivery: newProduct["delivery_included"],
          ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
          image: Constants.urlImage+newProduct["main_image"],
          merchant_id: newProduct['merchant_id'],
          merchant_name: newProduct['merchant']['company_name'],
          reviews: reviewsList,
          images: imagesOfProductList,
          hasVariants: newProduct['have_variation'],
          stock: newProduct['stock'].toString(), // after migration -> int to string
          //minOrder: newProduct.containsKey('min_order') ? newProduct['min_order'] : 1,
        );
        addToProductsList(product);
      },
    );

    if (pageIndex == 1) _isLoadingPro = false;
    if (currentProductCount < 10) {
      _hasModeProducts = false;
    }
    notifyListeners();
  }


  Future<dynamic> _getProductKoop(associateId, pageIndex, filte) async {
    String filter = 'Popular';
    if(filte == 'Popular'){filter = 'top';}
    else if (filte == 'Lowest'){filter = 'asc';}
    else if (filte == 'Highest'){filter = 'desc';}
    else {filter = 'top';}

    Map<String, dynamic> postData = {
      'associate_id': associateId,
      'sort': filter,
      'page': pageIndex,
    };

    var response = await http.post(
      Constants.shopKoopProduct,
      headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError(
          (error) {
        print(error.toString());
        return false;
      },
    );
    return json.decode(response.body);
  }

  Future parseKoopProductsFromResponse(int associateId, int pageIndex, String filte) async {
    if (pageIndex == 1) {_isLoadingPro = true;}
    notifyListeners();
    currentProductCount = 0;
    var dataFromResponse = await _getProductKoop(associateId, pageIndex, filte);

    dataFromResponse["data"]["products"]["data"].forEach(
          (newProduct) {
        currentProductCount++;

        List<Images> imagesOfProductList = [];
        newProduct["product_image"].forEach((newImage) {
          imagesOfProductList.add(
            new Images(
              id: newImage["id"],
              productId: newImage["product_id"].toString(), // after migration -> int to string
              imageURL: Constants.urlImage+newImage["image_url"],
            ),
          );
        },
        );

        List<Review> reviewsList = [];
        newProduct["product_review"].forEach(
              (newRview) {
            reviewsList.add(
              new Review(
                  user_id: newRview["user_id"].toString(), // after migration -> int to string
                  product_id: newRview["product_id"].toString(), // after migration -> int to string
                  review_text: newRview["review_text"],
                  rating: newRview["rating"].toString(), // after migration -> int to string
                  userName: newRview["user"]["fullname"]
              ),
            );
          },
        );

        Product product = new Product(
          id: newProduct["id"],
          name: newProduct["name"],
          summary: newProduct["summary"],
          details: newProduct["details"],
          price: newProduct["price"].toString() != null ? newProduct["price"].toString() : '0.00', // after migration -> int to string
          promoPrice: newProduct["promo_price"].toString() != null ? newProduct["promo_price"].toString() : '0.00', // after migration -> int to string
          delivery: newProduct["delivery_included"],
          ispromo: newProduct['ispromo'].toString(), // after migration -> int to string
          image: Constants.urlImage+newProduct["main_image"],
          merchant_id: newProduct['merchant_id'],
          merchant_name: newProduct['merchant']['company_name'],
          reviews: reviewsList,
          images: imagesOfProductList,
          hasVariants: newProduct['have_variation'],
          stock: newProduct['stock'].toString(), // after migration -> int to string
          //minOrder: newProduct.containsKey('min_order') ? newProduct['min_order'] : 1,
        );
        addToProductsList(product);
      },
    );

    if (pageIndex == 1) _isLoadingPro = false;
    if (currentProductCount < 10) {
      _hasModeProducts = false;
    }
    notifyListeners();
  }

}

