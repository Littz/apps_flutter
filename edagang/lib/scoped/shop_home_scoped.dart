import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';


mixin ShopHomeScopedModel on Model {
List<Banner_> banners = [];
List<Product> promoProducts = [];
List<KoopNgo> kooperasi = [];
List<KoopNgo> ngo = [];
List<Category> categories = [];
List<Product> topProducts = [];
List<Product> featureProducts = [];
List<Video> videos = [];
List<Video> videoList = [];
bool _isLoading = true;
bool _isLoading2 = true;
int totalProducts;

bool get isLoading => _isLoading;
bool get isLoading2 => _isLoading2;

int getTotalProduct() {
  return totalProducts;
}

List<Banner_> get _banners => banners;
void addToBannerList(Banner_ baner) {
  _banners.add(baner);
}

List<Product> get _promoProducts => promoProducts;
void addToPromoList(Product promo) {
  _promoProducts.add(promo);
}

List<KoopNgo> get _koop => kooperasi;
void addToKooperasiList(KoopNgo coop) {
  _koop.add(coop);
}

List<KoopNgo> get _ngo => ngo;
void addToNgoList(KoopNgo ngo2) {
  _ngo.add(ngo2);
}

List<Category> get _category => categories;
void addToCategoryList(Category kategori) {
  _category.add(kategori);
}

List<Product> get _topProducts => topProducts;
void addToTopList(Product top) {
  _topProducts.add(top);
}

List<Product> get _featureProducts => featureProducts;
void addToFeaturedList(Product feat) {
  _featureProducts.add(feat);
}

List<Video> get _videos => videos;
void addToVideoHome(Video vid) {
  _videos.add(vid);
}

List<Video> get _videoLs => videoList;
void addToVideoList(Video vid2) {
  _videoLs.add(vid2);
}

Future<dynamic> _getHomeJson() async {
  var response = await http.get(
    Constants.shopHome,
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  },
  );
  print('CARTSINI HOME #####################################');
  print(Constants.shopHome);
  return json.decode(response.body);
}

Future fetchHomePageResponse() async {
  _banners.clear();
  _promoProducts.clear();
  _category.clear();
  _topProducts.clear();
  _featureProducts.clear();

  notifyListeners();
  totalProducts = 0;
  var dataFromResponse = await _getHomeJson();

  totalProducts = dataFromResponse["data"]["product_count"];

//DATA BANNER =========================================================================================


  dataFromResponse["data"]["banner"].forEach((dataBaner) {
    Banner_ _baner = new Banner_(
      title: dataBaner['title'],
      imageUrl: dataBaner['image_url'],
      type: dataBaner['type'],
      itemId: dataBaner['item_id'],
      remark: dataBaner['remark'],
      link_url: dataBaner['link_url'],
    );
    addToBannerList(_baner);
  });

//DATA CATEGORY =========================================================================================
  dataFromResponse["data"]["category"].forEach((dataCat) {
    Category _cat = new Category(
      catid: dataCat['id'],
      catimage: dataCat['image'],
      catname: dataCat['name'],
    );
    addToCategoryList(_cat);
  });

//DATA PROMO =========================================================================================
  dataFromResponse["data"]["promo"].forEach((dataPromo) {
    List<Images> imagesOfProductList = [];
    dataPromo["product_image"].forEach((newImage) {
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
    dataPromo["product_review"].forEach((newRview) {
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
    Product _promo = new Product(
      id: dataPromo['id'],
      name: dataPromo['name'],
      price: dataPromo["price"].toString() != null ? dataPromo["price"].toString() : '0.00', // after migration -> int to string
      promoPrice: dataPromo["promo_price"].toString() != null ? dataPromo["promo_price"].toString() : '0.00', // after migration -> int to string
      delivery: dataPromo['delivery_included'].toString() != null ? dataPromo["delivery_included"].toString() : 'Exclude delivery',  // after migration -> int to string
      ispromo: dataPromo['ispromo'].toString(), // after migration -> int to string
      summary: dataPromo['summary'],
      details: dataPromo["details"],
      image: Constants.urlImage+dataPromo['main_image'],
      images: imagesOfProductList,
      hasVariants: dataPromo['have_variation'],
      merchant_id: dataPromo['merchant_id'],
      merchant_name: dataPromo['merchant']['company_name'],
      reviews: reviewsList,
    );
    addToPromoList(_promo);
  });

//DATA TOP =========================================================================================
  dataFromResponse["data"]["top"].forEach((dataTop) {
    List<Images> imagesOfProductList = [];
    if(dataTop["product_image"] != ''){
      dataTop["product_image"].forEach((newImage) {
        imagesOfProductList.add(
          new Images(
            id: newImage["id"],
            productId: newImage["product_id"].toString(),// after migration -> int to string
            imageURL: Constants.urlImage+newImage["image_url"],
          ),
        );
      },
      );
    }


    List<Review> reviewsList = [];
    dataTop["product_review"].forEach((newRview) {
      reviewsList.add(
        new Review(
            user_id: newRview["user_id"].toString(), // after migration -> int to string
            product_id: newRview["product_id"].toString(),  // after migration -> int to string
            review_text: newRview["review_text"],
            rating: newRview["rating"].toString(),  // after migration -> int to string
            userName: newRview["user"]["fullname"]
        ),
      );
    },
    );
    Product _top = new Product(
      id: dataTop['id'],
      name: dataTop['name'],
      price: dataTop["price"].toString() != null ? dataTop["price"].toString() : '0.00', // after migration -> int to string
      promoPrice: dataTop["promo_price"].toString() != null ? dataTop["promo_price"].toString() : '0.00', // after migration -> int to string
      delivery: dataTop['delivery_included'].toString() != null ? dataTop["delivery_included"].toString() : 'Exclude delivery',  // after migration -> int to string
      summary: dataTop['summary'],
      details: dataTop["details"],
      image: Constants.urlImage+dataTop['main_image'],
      images: imagesOfProductList,
      hasVariants: dataTop['have_variation'],
      merchant_id: dataTop['merchant_id'],
      merchant_name: dataTop['merchant']['company_name'],
      reviews: reviewsList,
    );
    addToTopList(_top);
  });

//DATA FEATURED =========================================================================================
  dataFromResponse["data"]["feature"].forEach((dataFeat) {
    List<Images> imagesOfProductList = [];
    dataFeat["product_image"].forEach((newImage) {
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
    dataFeat["product_review"].forEach((newRview) {
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
    Product _feat = new Product(
      id: dataFeat['id'],
      name: dataFeat['name'],
      price: dataFeat["price"].toString() != null ? dataFeat["price"].toString() : '0.00', // after migration -> int to string
      promoPrice: dataFeat["promo_price"].toString() != null ? dataFeat["promo_price"].toString() : '0.00', // after migration -> int to string
      delivery: dataFeat['delivery_included'].toString() != null ? dataFeat["delivery_included"].toString() : 'Exclude delivery',  // after migration -> int to string
      ispromo: dataFeat['ispromo'].toString(), // after migration -> int to string
      summary: dataFeat['summary'],
      details: dataFeat["details"],
      image: Constants.urlImage+dataFeat['main_image'],
      images: imagesOfProductList,
      hasVariants: dataFeat['have_variation'],
      merchant_id: dataFeat['merchant_id'].toString(), // after migration -> int to string
      merchant_name: dataFeat['merchant']['company_name'],
      reviews: reviewsList,
    );
    addToFeaturedList(_feat);
  });


//DATA VIDEO =========================================================================================
  dataFromResponse["data"]["video"].forEach((dataV) {
    Video _vid = new Video(
      id: dataV['id'],
      title: dataV['title'],
      link: dataV['link'],
    );
    addToVideoHome(_vid);
  });

  _isLoading2 = false;
  notifyListeners();
}

// https://shopapp.e-dagang.asia/api/video

Future<dynamic> _getVideoJson() async {
  var response = await http.get(
    'https://shopapp.e-dagang.asia/api/video',
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  },
  );
  return json.decode(response.body);
}

Future fetchVideoListResponse() async {
  _videoLs.clear();

  notifyListeners();
  totalProducts = 0;
  var dataFromResponse = await _getVideoJson();

//DATA VIDEO LIST =========================================================================================
  dataFromResponse["data"]["video"].forEach((dataVideo) {
    Video _video = new Video(
      id: dataVideo['id'],
      title: dataVideo['title'],
      link: dataVideo['link'],
    );
    addToVideoList(_video);
  });

  _isLoading2 = false;
  notifyListeners();
}



Future<dynamic> _getKoopJson() async {
  var response = await http.get(
    Constants.shopKoop,
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  },
  );
  return json.decode(response.body);
}

Future fetchKoopListResponse() async {
  _koop.clear();

  notifyListeners();
  totalProducts = 0;
  var dataFromResponse = await _getKoopJson();

//DATA KOOPERASI =========================================================================================
  dataFromResponse["data"]["coop"].forEach((dataCoop) {
    KoopNgo _coop = new KoopNgo(
      id: dataCoop['id'],
      associateName: dataCoop['associate_name'],
      associateLogo: dataCoop['associate_logo'],
    );
    addToKooperasiList(_coop);
  });

  _isLoading2 = false;
  notifyListeners();
}

Future<dynamic> _getNgoJson() async {
  var response = await http.get(
    Constants.shopNgo,
    headers: {'Authorization' : 'Bearer '+Constants.tokenGuest,'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  },
  );
  return json.decode(response.body);
}

Future fetchNgoListResponse() async {
  _ngo.clear();

  notifyListeners();
  totalProducts = 0;
  var dataFromResponse = await _getNgoJson();

//DATA NGO =========================================================================================
  dataFromResponse["data"]["ngo"].forEach((dataNgo) {
    KoopNgo _ngo = new KoopNgo(
      id: dataNgo['id'],
      associateName: dataNgo['associate_name'],
      associateLogo: dataNgo['associate_logo'],
    );
    addToNgoList(_ngo);
  });

  _isLoading2 = false;
  notifyListeners();
}



}