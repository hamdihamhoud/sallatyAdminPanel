import 'dart:convert';

// import 'package:sallaty_delivery/models/user_data.dart';
import 'package:adminpanel/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final Color color;
  final String size;
  final UserData owner;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
    @required this.color,
    this.size = '0',
    @required this.owner,
  });
}

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String address;
  final String buyerId;

  Order({
    this.id,
    @required this.amount,
    @required this.products,
    this.dateTime,
    @required this.address,
    @required this.buyerId,
  });

  int getTotalNum() {
    int sum = 0;
    products.forEach((element) {
      sum += element.quantity;
    });
    return sum;
  }
}

class Orders with ChangeNotifier {
  final mainUrl = 'https://hamdi1234.herokuapp.com';
  String _token;
  String _userId;

  void setToken(String token) {
    _token = token;
  }

  void setUserId(String id) {
    _userId = id;
  }

  Future<UserData> getUserData(String id) async {
    final url = Uri.parse('$mainUrl/users/$id');
    final response = await http.get(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
    );
    UserData user;
    final responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      user = UserData(
        id: responseData['_id'],
        name: responseData['name'],
        number: responseData['number'],
      );
      return user;
    } else {
      throw response.body;
    }
  }

  Future<List<Order>> getOrdersNotConfirmed() async {
    List<Order> ordersNotConfirmed = [];
    final url = Uri.parse('$mainUrl/getOrdersByStatus');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          'isConfirmed': false,
          'isDelivered': false,
          'beingDelivered': false,
        }));
    final responseData = json.decode(response.body) as List;
    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var i = 0; i < responseData.length; i++) {
        final orderItems = responseData[i]['orders'] as List;
        List<CartItem> products = [];
        for (var i = 0; i < orderItems.length; i++) {
          final user = await getUserData(orderItems[i]['product_id']['owner']);
          final product = CartItem(
            id: orderItems[i]['product_id']['_id'] + i.toString(),
            productId: orderItems[i]['product_id']['_id'].toString(),
            imageUrl: orderItems[i]['product_id']['images'][0].toString(),
            price:
                double.parse(orderItems[i]['product_id']['price'].toString()),
            title: orderItems[i]['product_id']['name'].toString(),
            quantity: orderItems[i]['quantity'],
            size: orderItems[i]['size'].toString(),
            owner: user,
            color: Color(orderItems[i]['color']),
          );
          products.add(product);
        }
        final order = Order(
            id: responseData[i]['_id'],
            address: responseData[i]['address'],
            amount: responseData[i]['total'],
            buyerId: responseData[i]['buyer'],
            products: products,
            dateTime: DateTime.parse(
              responseData[i]['date'],
            ));
        ordersNotConfirmed.add(order);
      }
      print(ordersNotConfirmed.length);
      return ordersNotConfirmed;
    } else {
      throw response.body;
    }
  }

  Future<void> checkAsConfirmed(String orderId) async {
    final url = Uri.parse('$mainUrl/update-orders-status/$orderId');
    final response = await http.patch(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
      body: json.encode({
        'isConfirmed': true,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw response.body;
    }
  }

  Future<void> deleteOrderItemFromOrder(String itemId) async {
    final url = Uri.parse('$mainUrl/order/$itemId');
    final response = await http.delete(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> deleteOrder(String orderId) async {
    final url = Uri.parse('$mainUrl/orders/$orderId');
    final response = await http.delete(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> addNoteToOrder(String notes, String orderId) async {
    final url = Uri.parse('$mainUrl/orders/$orderId');
    final response = await http.patch(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          'notes': notes,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }
}
