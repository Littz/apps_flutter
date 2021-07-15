import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReOrderScopedModel extends Model {
  List<OdrHistory> cartOrder = [];
  List<OdrHistory> get _cartOrder => cartOrder;

  void addToOrderDetail(OdrHistory reoder) {
    _cartOrder.add(reoder);
  }

  bool _isLoadingOd = false;
  bool get isLoadingOd => _isLoadingOd;

  int cid,ctr;
  int getCount() {return ctr;}

  Future<dynamic> _getCartReorder(odrId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> postData = {
      'order_id': odrId,
    };

    var response = await http.post(Uri.parse(Constants.postReorder),
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
      body: json.encode(postData),
    ).catchError((error) {
      print(error.toString());
      return false;
    });

    print('ORDER HISTORY DETAIL ==============================================');
    print('https://shopapp.e-dagang.asia/api/order/details?order_id='+odrId.toString());
    print(response.statusCode.toString());
    print(response.body);
    return json.decode(response.body);

  }

  Future fetchCartReorder (int odrId) async {
    cartOrder.clear();

    _isLoadingOd = true;
    notifyListeners();

    var dataFromResponse = await _getCartReorder(odrId);

    dataFromResponse.forEach((orders) {

      List<OrderGroup> orderGroup = [];
      orders['ordergroup'].forEach((ordergrp) {

        List<OrderItem> orderItems = [];
        ordergrp['orderitems'].forEach((orderitem) {
          orderItems.add(
            new OrderItem(
              id: orderitem['id'],
              group_id: orderitem['group_id'].toString(), // after migration -> int to string
              product_id: orderitem['product_id'].toString(), // after migration -> int to string
              quantity: orderitem['quantity'].toString(), // after migration -> int to string
              price: orderitem['price'].toString(), // after migration -> int to string
              //reviewed: orderitem['reviewed'].toString(), // after migration -> int to string
              product_name: orderitem['product']['name'],
              main_image: orderitem['product']['main_image'],
            )
          );
        });

        orderGroup.add(
          new OrderGroup(
            id: ordergrp['id'],
            order_id: ordergrp['group_id'].toString(), // after migration -> int to string
            merchant_id: ordergrp['merchant_id'].toString(), // after migration -> int to string
            courier_charges: ordergrp['courier_charges'].toString(), // after migration -> int to string
            product_cost: ordergrp['product_cost'].toString(), // after migration -> int to string
            order_status_id: ordergrp['order_status']['id'],
            order_status_name: ordergrp['order_status']['name'],
            //courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            //tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            //courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
            order_items: orderItems,
          ),
        );
      });

      OdrHistory _feat = new OdrHistory(
        id: orders['id'],
        order_no: orders['order_no'].toString(), // after migration -> int to string
        total_price: orders['total_price'].toString(), // after migration -> int to string
        address_id: orders['address_id'],
        order_group: orderGroup,
        name: orders['address']['name'],
        address: orders['address']['address'],
        postcode: orders['address']['postcode'],
        city_id: orders['address']['city_id'],
        state_id: orders['address']['state_id'],
        full_address: orders['address']['full_address'],
        city_name: orders['address']['city']['city_name'],
        state_name: orders['address']['state']['state_name'],
      );
      addToOrderDetail(_feat);
    });

    _isLoadingOd = false;
    notifyListeners();
  }

}