import 'dart:async';
import 'dart:io';

import 'package:edagang/models/shop_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:retry/retry.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin CartScopedModel on Model {
//List<LineItem> _lineItems = [];
//Order order;
Map<dynamic, dynamic> lineItemObject = Map();
//List<LineItem> get lineItems {return List.from(_lineItems);}

List<MyCart> cartList = [];
List<MyCart> cartResume = [];
List<Address> addrList = [];
List<OnlineBanking> bankList = [];
int cartTot = 0;
double totalCost,totalCostR = 0.0;
double totalCourier,totalCourierR = 0.0;
bool _isLoading3 = false;
bool _isLoading4 = false;
int currentCartCount;
List<MyCart> get _kartsList => cartList;
List<MyCart> get _kartReload => cartResume;
List<Address> get addrList_x => addrList;
List<OnlineBanking> get _bankList => bankList;

bool get isLoading3 => _isLoading3;
bool get isLoading4 => _isLoading4;
String cartMsg = "";

void addToCartList(MyCart carts) {
  cartList.add(carts);
}

void addToCartReload(MyCart cart) {
  cartResume.add(cart);
}

void addToAddrList(Address addr) {
  addrList.add(addr);
}

void addToBankList(OnlineBanking bank) {
  bankList.add(bank);
}

int getAddrCount() {
  return addrList.length;
}

int getCartCount() {
  return cartList.length;
}

int getCartotal() {
  return cartTot;
}

double getTotalCost() {
  return totalCost;
}

double getTotalCourier() {
  return totalCourier;
}

double getTotalCostR() {
  return totalCostR;
}

double getTotalCourierR() {
  return totalCourierR;
}

double totalNettR() {
  return totalCostR + totalCourierR;
}

void addProduct({String param}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  _kartsList.clear();
  _isLoading3 = true;
  notifyListeners();
  print('ADD TO CART');
  final String orderToken = prefs.getString('token');

  if (orderToken != null) {
    print('OK');
    createNewLineItem(param);
  }else{
    print('FAILED');
  }
  _isLoading3 = false;
  notifyListeners();
}

void updCartQty({int cartId, int productId, int quantity}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  _kartsList.clear();
  _isLoading4 = true;
  notifyListeners();
  print('UPDATE CART');
  final String orderToken = prefs.getString('token');

  if (orderToken != null) {
    print('OK');
    updateLineItem(cartId, productId, quantity);
  }else{
    print('FAILED');
  }

  _isLoading4 = false;
  notifyListeners();
}

void removeProduct(int cartId, int prodId) async {
  _kartsList.clear();
  notifyListeners();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<dynamic, dynamic> orderParams = Map();
  orderParams = {'_method': 'DELETE', 'product_id': prodId};

  http.post(
    Uri.parse(Constants.shopCart+'/'+cartId.toString()),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    body: json.encode(orderParams)
  ).then((response) {
    print('DELETE CART >>>>');
    print(response.statusCode.toString());
    print(response.body);

    fetchCartTotal();
    fetchCartsFromResponse();
    fetchCartReload();
  });
}

void updateLineItem(int cartId, int productId, int quantity) async {
  Map<dynamic, dynamic> orderParams = Map();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  orderParams = {'cart_id': cartId.toString(), 'product_id': productId.toString(), 'quantity': quantity.toString()};
  print('CARTSINI UPDATE CART >>>>>');
  print(Constants.shopCart+"/updatecart");
  print(orderParams);

  http.post(Uri.parse(Constants.shopCart+"/updatecart?cart_id="+cartId.toString()+"&product_id="+productId.toString()+"&quantity="+quantity.toString()),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    //body: json.encode(orderParams)
  ).then((response) {
    print(response.statusCode.toString());
    print(response.body);

    fetchCartTotal();
    fetchCartsFromResponse();
    fetchCartReload();
  });
}

void createNewLineItem(String params) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  http.post(
    Uri.parse(Constants.shopCart+'?'+params),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    //body: json.encode(lineItemObject)
  ).then((response) {
    print('CARTSINI ADD TO CART >>>>>');
    print(Constants.shopCart+'?'+params);
    print(response.statusCode.toString());
    print(response.body);

    fetchCartTotal();
    fetchCartsFromResponse();
    //var responseBody = json.decode(response.body);
    //print(responseBody);
    //if(response.statusCode == 200 || response.statusCode == 302){
    //  //fetchCartReload();
    //}

  });
}

Future<void> addToCart(String params) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var response = await http.post(Constants.shopCart+'?'+params, headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',});
  print('CARTSINI ADD TO CART >>>>>');
  print(Constants.shopCart+'?'+params);
  print(response.statusCode.toString());

  if (response.statusCode == 200) {
    print(response.body);
    print('Successful added to cart.');
    //print(await _getCartCount());
    //print(await _getCartList());

    fetchCartTotal();
    fetchCartsFromResponse();
    //var jsonResponse = json.decode(response.body);
    //var itemCount = jsonResponse['totalItems'];

  } else {
    print(response.body);
    print('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> addToCartRetry(String params) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final client = HttpClient();

  try {
// Get statusCode by retrying a function
    final statusCode = await retry(() async {
// Make a HTTP request and return the status code.
      final request = await client.postUrl(Uri.parse(Constants.shopCart+'?'+params)).timeout(Duration(seconds: 5));
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer "+prefs.getString('token'));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      final response = await request.close().timeout(Duration(seconds: 5));
      await response.drain();
      return response.statusCode;
    },
// Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
// Print result from status code
    print('CARTSINI ADD TO CART >>>>>');
    print(statusCode.toString());
    if (statusCode == 200) {
      print('Successful added to cart.');
      fetchCartTotal();
      fetchCartsFromResponse();
    } else {
      print('Failed to add cart.');
    }
  } finally {
// Always close an HttpClient from dart:io, to close TCP connections in the
// connection pool. Many servers has keep-alive to reduce round-trip time
// for additional requests and avoid that clients run out of port and
// end up in WAIT_TIME unpleasantries...
    client.close();
  }
}

void updShipping({int addr_id}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  _kartReload.clear();

  notifyListeners();
  print('UPDATE SHIPPING');
  final String orderToken = prefs.getString('token');

  if (orderToken != null) {
    print('OK');
    setShippingAddress(addr_id);
  }else{
    print('FAILED');
  }
  notifyListeners();
}

void setShippingAddress(int addr_id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<dynamic, dynamic> addrData = Map();
  addrData = {
    'address_id': addr_id,
    'default_shipping': 'Y',
    'default_billing': 'Y',
  };

  http.post(Uri.parse(Constants.addressAPI + '/setdefault'),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    body: json.encode(addrData)
  ).then((response) {
    print('CARTSINI UPDATE SHIPPING >>>>>');
    print(Constants.addressAPI + '/setdefault?address_id='+addr_id.toString());
    print(response.statusCode.toString());
    print(response.body);

    if(response.statusCode == 200){
      fetchCartReload();
    }

  });
}


Future<dynamic> _getCartCount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(
    Uri.parse(Constants.shopAPI+'/cart/product/count'),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('CARTSINI CART TOTAL ##########################################');
  print(Constants.shopAPI+'/cart/product/count');
  print(response.statusCode.toString());
  print(response.body);
  return json.decode(response.body);
}

Future fetchCartTotal() async {
  notifyListeners();
  var dataFromResponse = await _getCartCount();
  cartTot = dataFromResponse['data']['cart_total'];

  notifyListeners();
}


Future<dynamic> _getCartList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(
    Uri.parse(Constants.shopCart),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('CARTSINI CART LIST ##########################################');
  print(Constants.shopCart);
  print(response.statusCode.toString());
  print(response.body);

  return json.decode(response.body);
}

Future fetchCartsFromResponse() async {
  _isLoading3 = true;
  _kartsList.clear();
  notifyListeners();

  var dataFromResponse = await _getCartList();
  //print(dataFromResponse.toString());

  dataFromResponse['data']['cart'].forEach((newCart) {

    List<CartProduct> cartProducts = [];
    newCart['merchant']['cart_products'].forEach((cartProd) {

      List<CartVariation> cartVariation = [];
      cartProd['product_details']['cart_variation'].forEach((cartVari) {
        cartVariation.add(
          new CartVariation(
            id: cartVari['id'],
            product_id: cartVari['product_id'].toString(), // after migration -> int to string
            variation_id: cartVari['variation_id'].toString(), // after migration -> int to string
            option_id: cartVari['option_id'].toString(), // after migration -> int to string
            variation_name: cartVari['variation_details']['variation_name'],
            option_name: cartVari['option_details']['option_name'],
            unit_price: cartVari['option_details']['unit_price'].toString(), // after migration -> int to string
            stock: cartVari['option_details']['stock'].toString(), // after migration -> int to string
            //image_url: Constants.getProductImages + cartVari['option_details']['image_url'],
          ),
        );
      });

      cartProducts.add(
          new CartProduct(
            id: cartProd['id'],
            cart_id: cartProd['cart_id'].toString(), // after migration -> int to string
            merchant_id: cartProd['merchant_id'].toString(), // after migration -> int to string
            product_id: cartProd['product_id'].toString(), // after migration -> int to string
            quantity: cartProd['quantity'].toString(), // after migration -> int to string
            have_variation: cartProd['have_variation'].toString(), // after migration -> int to string
            name: cartProd['product_details']['name'],
            price: cartProd['product_details']['price'].toString(), // after migration -> int to string
            ispromo: cartProd['product_details']['ispromo'].toString(), // after migration -> int to string
            promo_price: cartProd['product_details']['promo_price'].toString(), // after migration -> int to string
            promo_startdate: cartProd['product_details']['promo_startdate'],
            promo_enddate: cartProd['product_details']['promo_enddate'],
            main_image: Constants.urlImage+cartProd['product_details']['main_image'],
            stock: cartProd['product_details']['stock'].toString(), // after migration -> int to string
            min_order: cartProd['product_details']['min_order'],
            cart_variation: cartVariation,
          )
      );
    });

    MyCart kart = new MyCart(
      id: newCart['id'],
      merchant_id: newCart['merchant_id'].toString(), // after migration -> int to string
      company_name: newCart['merchant']['company_name'],
      courier_charges: newCart['merchant']['courier_charges'].toString(), // after migration -> int to string
      //subtotal: newCart['merchant']['subtotal'],
      cart_products: cartProducts,
    );
    addToCartList(kart);
  },
  );

  totalCost = double.parse(dataFromResponse['data']['total_cost'].toString());
  totalCourier = double.parse(dataFromResponse['data']['total_courier'].toString());

  _isLoading3 = false;
  notifyListeners();
}


Future<dynamic> _getCartReload() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(
    Uri.parse(Constants.shopCart+'/reload'),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
  ).catchError((error) {
    print(error.toString());
    return false;
  });
  print('CARTSINI CART RELOAD ##########################################');
  print(Constants.shopCart+'/reload');
  print(response.statusCode.toString());
  print(response.body);

  return json.decode(response.body);
}

Future fetchCartReload() async {
  _kartReload.clear();
  notifyListeners();

  var dataFromResponse = await _getCartReload();
  //print(dataFromResponse.toString());

  dataFromResponse['data']['cart'].forEach((newCart) {

    List<CartProduct> cartProducts = [];
    newCart['merchant']['cart_products'].forEach((cartProd) {

      List<CartVariation> cartVariation = [];
      cartProd['product_details']['cart_variation'].forEach((cartVari) {
        cartVariation.add(
          new CartVariation(
            id: cartVari['id'],
            product_id: cartVari['product_id'].toString(), // after migration -> int to string
            variation_id: cartVari['variation_id'].toString(), // after migration -> int to string
            option_id: cartVari['option_id'].toString(), // after migration -> int to string
            variation_name: cartVari['variation_details']['variation_name'],
            option_name: cartVari['option_details']['option_name'],
            unit_price: cartVari['option_details']['unit_price'].toString(), // after migration -> int to string
            stock: cartVari['option_details']['stock'].toString(), // after migration -> int to string
            //image_url: Constants.getProductImages + cartVari['option_details']['image_url'],
          ),
        );
      });

      cartProducts.add(
          new CartProduct(
            id: cartProd['id'],
            cart_id: cartProd['cart_id'].toString(), // after migration -> int to string
            merchant_id: cartProd['merchant_id'].toString(), // after migration -> int to string
            product_id: cartProd['product_id'].toString(), // after migration -> int to string
            quantity: cartProd['quantity'].toString(), // after migration -> int to string
            have_variation: cartProd['have_variation'].toString(), // after migration -> int to string
            name: cartProd['product_details']['name'],
            price: cartProd['product_details']['price'].toString(), // after migration -> int to string
            ispromo: cartProd['product_details']['ispromo'].toString(), // after migration -> int to string
            promo_price: cartProd['product_details']['promo_price'].toString(), // after migration -> int to string
            promo_startdate: cartProd['product_details']['promo_startdate'],
            promo_enddate: cartProd['product_details']['promo_enddate'],
            main_image: Constants.urlImage+cartProd['product_details']['main_image'],
            stock: cartProd['product_details']['stock'].toString(), // after migration -> int to string
            min_order: cartProd['product_details']['min_order'],
            cart_variation: cartVariation,
          )
      );
    });

    MyCart kart = new MyCart(
      id: newCart['id'],
      merchant_id: newCart['merchant_id'].toString(),
      company_name: newCart['merchant']['company_name'],
      courier_charges: newCart['merchant']['courier_charges'].toString(),
      cart_products: cartProducts,
    );
    addToCartReload(kart);
  });

  totalCostR = double.parse(dataFromResponse['data']['total_cost'].toString());
  totalCourierR = double.parse(dataFromResponse['data']['total_courier'].toString());

  notifyListeners();
}


Future fetchAddressList() async {
  addrList_x.clear();
  notifyListeners();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  http.get(
    Uri.parse(Constants.addressAPI),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
  ).then((response) {
    //print(response.body);
    var responseBody = json.decode(response.body);
    print('CARTSINI ADDRESS >>>>');
    print(Constants.addressAPI);
    print(response.statusCode.toString());
    print(response.body);
    responseBody['data']['addresses'].forEach((addr) {

      Address adres = new Address(
        id: addr['id'],
        name: addr['name'],
        address: addr['address'],
        full_address: addr['full_address'],
        state_id: addr['state_id'].toString(), // after migration -> int to string
        city_id: addr['city_id'].toString(), // after migration -> int to string
        postcode: addr['postcode'].toString(), // after migration -> int to string
        mobile_no: addr['mobile_no'].toString(), // after migration -> int to string
        email: addr['email'],
        default_shipping: addr['default_shipping'],
        default_billing: addr['default_billing'].toString(), // after migration -> int to string
        location_tag: addr['location_tag'],
      );
      addToAddrList(adres);
    });

    notifyListeners();
  });
}

Future fetchBankList() async {
  _bankList.clear();
  notifyListeners();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  http.get(Uri.parse(Constants.getFpxbank),
    headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
  ).then((response) {
    print('CARTSINI BANKING >>>>');
    print(Constants.getFpxbank);
    print(response.statusCode.toString());
    print(response.body);

    var responseBody = json.decode(response.body);
    responseBody['data'].forEach((fpxbnk) {

      OnlineBanking bank = new OnlineBanking(
        id: fpxbnk['id'],
        bank_code: fpxbnk['bank_code'],
        bank_display_name: fpxbnk['bank_display_name'],
        bank_logo: fpxbnk['bank_logo'],
      );
      addToBankList(bank);
    });

    notifyListeners();
  });
}

}
