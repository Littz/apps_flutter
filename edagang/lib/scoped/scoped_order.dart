import 'dart:async';
import 'dart:convert';
import 'package:edagang/models/shop_model.dart';
import 'package:edagang/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


mixin OrderScopedModel on Model {
  List<OdrHistory> historyOrders = [];
  List<OrderStatus> toPay = [];
  List<OrderStatus> toShip = [];
  List<OrderStatus> toReceive = [];
  List<OrderStatus> toReview = [];
  List<OrderStatus> toCancel = [];

  bool _isLoadingOrder = false;
  bool _isLoadingOrderStatus = false;

  int totalOrder, totPay, totShip, totReceive, totReview, totCancel;
  String orderSts;

  bool get isLoadingOrder => _isLoadingOrder;
  bool get isLoadingOrderStatus => _isLoadingOrderStatus;


  int getTotalOrder() {
    return totalOrder;
  }
  int getTotalPay() {
    return totPay;
  }
  int getTotalShip() {
    return totShip;
  }
  int getTotalReceive() {
    return totReceive;
  }
  int getTotalReview() {
    return totReview;
  }
  int getTotalCancel() {
    return totCancel;
  }

  String getStatus() {
    return orderSts;
  }

  List<OdrHistory> get _historyOrders => historyOrders;
  void addToOrderList(OdrHistory feat) {
    _historyOrders.add(feat);
  }

  List<OrderStatus> get _toPay => toPay;
  void addToPayList(OrderStatus pay) {
    _toPay.add(pay);
  }

  List<OrderStatus> get _toShip => toShip;
  void addToShipList(OrderStatus ship) {
    _toShip.add(ship);
  }

  List<OrderStatus> get _toReveive => toReceive;
  void addToReceiveList(OrderStatus receive) {
    _toReveive.add(receive);
  }

  List<OrderStatus> get _toReview => toReview;
  void addToReviewList(OrderStatus review) {
    _toReview.add(review);
  }

  List<OrderStatus> get _toCancel => toCancel;
  void addToCancelList(OrderStatus cancel) {
    _toCancel.add(cancel);
  }


  Future<dynamic> _getOrdersJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(Constants.getHistory),
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    ).catchError((error) {
      print(error.toString());
      return false;
    });
    print('CARTSINI ORDER History @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print(Constants.getHistory);
    return json.decode(response.body);
  }

  Future fetchOrderHistoryResponse() async {
    _historyOrders.clear();
    _isLoadingOrder = true;
    notifyListeners();

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
            courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
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



  Future<dynamic> _getMyOrderStatusJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse('http://shopapp.e-dagang.asia/api/order/statuscount'),
      headers: {'Authorization' : 'Bearer '+prefs.getString('token'),'Content-Type': 'application/json',},
    ).catchError((error) {
      print(error.toString());
      return false;
    });
    print('CARTSINI ORDER STATUS RESPONSE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print('http://shopapp.e-dagang.asia/api/order/statuscount');
    return json.decode(response.body);
  }

  Future fetchOrderStatusResponse() async {
    _toPay.clear();
    _toShip.clear();
    _toReveive.clear();
    _toReview.clear();
    _toCancel.clear();

    _isLoadingOrderStatus = true;
    notifyListeners();

    var dataFromResponse = await _getMyOrderStatusJson();

    totPay = dataFromResponse["data"]["topay"]["total"];
    totShip = dataFromResponse["data"]["toship"]["total"];
    totReceive = dataFromResponse["data"]["toreceive"]["total"];
    totReview = dataFromResponse["data"]["toreview"]["total"];
    totCancel = dataFromResponse["data"]["cancel"]["total"];
    totalOrder = totPay + totShip + totReceive + totReview + totCancel;

    print('TO PAY orders @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print(dataFromResponse["data"]["topay"]);

    dataFromResponse["data"]["topay"]["order"].forEach((payOrders) {

      List<OrderGroup> orderGroup = [];
      payOrders['ordergroup'].forEach((ordergrp) {

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
            courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
            order_items: orderItems,
          ),
        );
      });

      OrderStatus _payOrder = new OrderStatus(
        id: payOrders['id'],
        order_no: payOrders['order_no'].toString(), // after migration -> int to string
        total_price: payOrders['total_price'].toString(), // after migration -> int to string
        status: payOrders['status'],
        //payment_status: orders['payment_status'],
        payment_error_code: payOrders['payment_status'] != null ? payOrders['payment_status']['error_code'] : '99',
        payment_error_desc: payOrders['payment_status'] != null ? payOrders['payment_status']['error_desc'] : 'Payment cancel by user.',
        payment_bank: payOrders['payment_bank'],
        transaction_date: payOrders['transaction_date'],
        order_group: orderGroup,
      );
      addToPayList(_payOrder);
    });

    //print('TO SHIP orders @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //print(dataFromResponse["data"]["toship"]);

    dataFromResponse["data"]["toship"]["order"].forEach((shipOrders) {

      List<OrderGroup> orderGroup = [];
      shipOrders['ordergroup'].forEach((ordergrp) {

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
            courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
            order_items: orderItems,
          ),
        );
      });

      OrderStatus _shipOrder = new OrderStatus(
        id: shipOrders['id'],
        order_no: shipOrders['order_no'].toString(), // after migration -> int to string
        total_price: shipOrders['total_price'].toString(), // after migration -> int to string
        status: shipOrders['status'],
        //payment_status: orders['payment_status'],
        payment_error_code: shipOrders['payment_status'] != null ? shipOrders['payment_status']['error_code'] : '99',
        payment_error_desc: shipOrders['payment_status'] != null ? shipOrders['payment_status']['error_desc'] : 'Payment cancel by user.',
        payment_bank: shipOrders['payment_bank'],
        transaction_date: shipOrders['transaction_date'],
        order_group: orderGroup,
      );
      addToShipList(_shipOrder);
    });

    //print('TO RECEIVE orders @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //print(dataFromResponse["data"]["toreceive"]);

    dataFromResponse["data"]["toreceive"]["order"].forEach((receiveOrders) {

      List<OrderGroup> orderGroup = [];
      receiveOrders['ordergroup'].forEach((ordergrp) {

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
            courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
            order_items: orderItems,
          ),
        );
      });

      OrderStatus _receiveOrder = new OrderStatus(
        id: receiveOrders['id'],
        order_no: receiveOrders['order_no'].toString(), // after migration -> int to string
        total_price: receiveOrders['total_price'].toString(), // after migration -> int to string
        status: receiveOrders['status'],
        //payment_status: receiveOrders['payment_status'],
        payment_error_code: receiveOrders['payment_status'] != null ? receiveOrders['payment_status']['error_code'] : '99',
        payment_error_desc: receiveOrders['payment_status'] != null ? receiveOrders['payment_status']['error_desc'] : 'Payment cancel by user.',
        payment_bank: receiveOrders['payment_bank'],
        transaction_date: receiveOrders['transaction_date'],
        order_group: orderGroup,
      );
      addToReceiveList(_receiveOrder);
    });

    //print('TO REVIEW orders @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //print(dataFromResponse["data"]["toreview"]);

    dataFromResponse["data"]["toreview"]["order"].forEach((reviewOrders) {

      List<OrderGroup> orderGroup = [];
      reviewOrders['ordergroup'].forEach((ordergrp) {

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
            courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
            order_items: orderItems,
          ),
        );
      });

      OrderStatus _revieOrder = new OrderStatus(
        id: reviewOrders['id'],
        order_no: reviewOrders['order_no'].toString(), // after migration -> int to string
        total_price: reviewOrders['total_price'].toString(), // after migration -> int to string
        status: reviewOrders['status'],
        //payment_status: orders['payment_status'],
        payment_error_code: reviewOrders['payment_status'] != null ? reviewOrders['payment_status']['error_code'] : '99',
        payment_error_desc: reviewOrders['payment_status'] != null ? reviewOrders['payment_status']['error_desc'] : 'Payment cancel by user.',
        payment_bank: reviewOrders['payment_bank'],
        transaction_date: reviewOrders['transaction_date'],
        order_group: orderGroup,
      );
      addToReviewList(_revieOrder);
    });

    //print('TO CANCEL orders @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //print(dataFromResponse["data"]["cancel"]);

    dataFromResponse["data"]["cancel"]["order"].forEach((cancelOrders) {

      List<OrderGroup> orderGroup = [];
      cancelOrders['ordergroup'].forEach((ordergrp) {

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
            courier_id: ordergrp['courier_id'] != null ? ordergrp['courier_id'] : '', // after migration -> int to string
            tracking_no: ordergrp['tracking_no'] != null ? ordergrp['tracking_no'] : '', // after migration -> int to string
            merchant_name: ordergrp['merchant']['company_name'],
            courier_company: ordergrp['courier_company'] != null ? ordergrp['courier_company']['name'] : '',
            order_items: orderItems,
          ),
        );
      });

      OrderStatus _cancelOrder = new OrderStatus(
        id: cancelOrders['id'],
        order_no: cancelOrders['order_no'].toString(), // after migration -> int to string
        total_price: cancelOrders['total_price'].toString(), // after migration -> int to string
        status: cancelOrders['status'],
        //payment_status: cancelOrders['payment_status'],
        payment_error_code: cancelOrders['payment_status'] != null ? cancelOrders['payment_status']['error_code'] : '99',
        payment_error_desc: cancelOrders['payment_status'] != null ? cancelOrders['payment_status']['error_desc'] : 'Payment cancel by user.',
        payment_bank: cancelOrders['payment_bank'],
        transaction_date: cancelOrders['transaction_date'],
        order_group: orderGroup,
      );
      addToCancelList(_cancelOrder);
    });

    _isLoadingOrderStatus = false;
    notifyListeners();

  }


}