import 'package:adminpanel/models/feedback.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';

import 'package:adminpanel/models/user_data.dart';
import 'package:http/http.dart' as http;

class AdminFunctioins with ChangeNotifier {
  final mainUrl = 'https://hamdi1234.herokuapp.com';
  String _token;
  String _userId;

  void setToken(String token) {
    _token = token;
  }

  void setUserId(String id) {
    _userId = id;
  }

  Future<void> createAdmin(
      String name, String email, String password, String number) async {
    final url = Uri.parse('$mainUrl/adminUser');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          "name": name,
          "email": email,
          "number": number,
          "password": password,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> createDelivery(
      String name, String email, String password, String number) async {
    final url = Uri.parse('$mainUrl/delivaryUser');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          "name": name,
          "email": email,
          "number": number,
          "password": password,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> deleteDelivery(String deliveryId) async {
    final url = Uri.parse('$mainUrl/deleteDelivery/$deliveryId');
    final response = await http.delete(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> deleteNormal(String normalId) async {
    final url = Uri.parse('$mainUrl/banAccount/$normalId');
    final response = await http.delete(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> extendPremium(String email, int years) async {
    final url = Uri.parse('$mainUrl/extendPremium');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          'email': email,
          'expiringDate':
              DateTime.now().add(Duration(days: years * 365)).toIso8601String(),
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<void> createPremium(String email, int years) async {
    final url = Uri.parse('$mainUrl/premiumUser');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': _token,
        },
        body: json.encode({
          'email': email,
          'expiringDate':
              DateTime.now().add(Duration(days: years * 365)).toIso8601String(),
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
  }

  Future<List<UserData>> getAllDeliveryAccounts() async {
    List<UserData> deliveryUsers = [];
    final url = Uri.parse('$mainUrl/getAllDelivaries');
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var i = 0; i < responseData.length; i++) {
        final user = UserData(
          id: responseData[i]['_id'],
          name: responseData[i]['name'],
          number: responseData[i]['number'],
        );
        deliveryUsers.add(user);
      }
      return deliveryUsers;
    } else
      throw response.body;
  }

  Future<List<UserData>> getAllPremiumAccounts() async {
    List<UserData> premiumUsers = [];
    final url = Uri.parse('$mainUrl/allPremiums');
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var i = 0; i < responseData.length; i++) {
        final user = UserData(
          id: responseData[i]['_id'],
          name: responseData[i]['name'],
          number: responseData[i]['number'],
        );
        premiumUsers.add(user);
      }
      return premiumUsers;
    } else
      throw response.body;
  }

  Future<List<Feedback>> getAllFeedbacks() async {
    List<Feedback> feedbacks = [];
    final url = Uri.parse('$mainUrl/allFeedback');
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var i = 0; i < responseData.length; i++) {
        final feedback = Feedback(
          id: responseData[i]['id'],
          feedback: responseData[i]['feedback'],
          user: UserData(
            id: responseData[i]['user']['_id'],
            name: responseData[i]['user']['name'],
            number: responseData[i]['user']['number'],
          ),
        );
        feedbacks.add(feedback);
      }
      return feedbacks;
    } else
      throw response.body;
  }

  Future<List<Feedback>> getAllFeedbacksNotSeen() async {
    List<Feedback> feedbacks = [];
    final url = Uri.parse('$mainUrl/allNotSeenFeedback');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var i = 0; i < responseData.length; i++) {
        final feedback = Feedback(
          id: responseData[i]['id'],
          feedback: responseData[i]['feedback'],
          user: UserData(
            id: responseData[i]['user']['_id'],
            name: responseData[i]['user']['name'],
            number: responseData[i]['user']['number'],
          ),
        );
        feedbacks.add(feedback);
      }
      return feedbacks;
    } else
      throw response.body;
  }

  Future<void> setFeedbacksToSeen(String feedbackId, String userId) async {
    final url = Uri.parse('$mainUrl/setFeedback/$feedbackId');
    final response = await http.post(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
      body: json.encode({
        'id': userId,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else
      throw response.body;
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

  Future<String> generateCopon(double discountPercentage, String date) async {
    final url = Uri.parse('$mainUrl/cobone');
    final response = await http.post(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
      body: json.encode({
        'discount': discountPercentage,
        'expiringdate': date,
      }),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseData['code'];
    } else
      throw response.body;
  }
}
