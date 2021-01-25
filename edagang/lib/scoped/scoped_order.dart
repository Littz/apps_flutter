import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


mixin OrderScopedModel on Model {
  List<OdrHistory> historyOrders = [];
  bool _isLoadingOrder = true;
  int totalOrder;

  bool get isLoadingOrder => _isLoadingOrder;

  int getTotalOrder() {
    return totalOrder;
  }

  List<OdrHistory> get _historyOrders => historyOrders;
  void addToOrderList(OdrHistory feat) {
    _historyOrders.add(feat);
  }

  Future<dynamic> _getOrdersJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
      Constants.getHistory,
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    ).catchError((error) {
      print(error.toString());
      return false;
    });
    return json.decode(response.body);
  }

  Future fetchOrderHistoryResponse() async {
    _isLoadingOrder = true;
    _historyOrders.clear();
    notifyListeners();
    totalOrder = 0;
    var dataFromResponse = await _getOrdersJson();

    dataFromResponse["orders"].forEach((orders) {

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
                reviewed: orderitem['reviewed'].toString(), // after migration -> int to string
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
            courier_id: ordergrp['courier_id'].toString(), // after migration -> int to string
            tracking_no: ordergrp['tracking_no'].toString(), // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'],
            order_items: orderItems,
          ),
        );
      });

      OdrHistory _feat = new OdrHistory(
        id: orders['id'],
        order_no: orders['order_no'].toString(), // after migration -> int to string
        total_price: orders['total_price'].toString(), // after migration -> int to string
        status: orders['status'],
        //payment_status: orders['payment_status'],
        payment_err_code: orders['payment_status'] != null ? orders['payment_status']['error_code'] : '99',
        payment_err_desc: orders['payment_status'] != null ? orders['payment_status']['error_desc'] : 'Payment cancel by user.',
        payment_bank: orders['payment_bank'],
        payment_txn_date: orders['transaction_date'],
        order_group: orderGroup,
      );
      addToOrderList(_feat);
    });
    _isLoadingOrder = false;
    notifyListeners();
  }

}