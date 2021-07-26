import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jojourney/models/https_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  var token;
  DateTime expiryDate;
  var userId;
  var userName;
  Timer authTimer;
  var email;
  String userType;
  String adminHotelId;

  bool get isAuth {
    return getToken != null;
  }

  String get getToken {
    if (token != null &&
        expiryDate.isAfter(DateTime.now()) &&
        expiryDate != null) return token;

    return null;
  }

  Future<void> authenticate(String userName, String userEmail,
      String userPassword, String authType) async {
    var uri = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$authType?key=AIzaSyADaZs92W1PCBegjznCfZDj0VeonZribYg');

    var response;
    try {
      response = await http.post(uri,
          body: jsonEncode({
            'email': userEmail,
            'password': userPassword,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpsExceptions(responseData['error']['message']);
      }

      token = responseData['idToken'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      userId = responseData['localId'];
      email = responseData['email'];

      if (authType == 'signUp') {
        await postUserData(userEmail, userId, userName);
      }

      notifyListeners();
      autoLogout();

      final userData = jsonEncode({
        'token': token,
        'expiryDate': expiryDate.toIso8601String(),
        'userId': userId,
        'email': email,
        'userName': userName
      });

      final pref = await SharedPreferences.getInstance();
      pref.setString('userData', userData);
    } on PlatformException catch (e) {
      throw e;
    }
  }

  Future<void> postUserData(String email, String UID, String userName) async {
    final dbUrl = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/users.json');
    var response;
    try {
      response = await http.post(dbUrl,
          body: jsonEncode({'email': email, 'UID': UID, 'userName': userName}));
    } catch (e) {
      print(response.body);
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedData =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;

    final extractedExpiryDate = DateTime.parse(extractedData['expiryDate']);
    if (extractedExpiryDate.isBefore(DateTime.now())) return false;

    token = extractedData['token'];
    userId = extractedData['userId'];
    expiryDate = extractedExpiryDate;
    email = extractedData['email'];
    notifyListeners();

    autoLogout();
    return true;
  }

  Future<void> logOut() async {
    userId = null;
    token = null;
    expiryDate = null;
    email = null;
    notifyListeners();

    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }



  Future<void> fetchUserData() async {
    var url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/users.json?orderBy="UID"&equalTo="$userId"');

    try {
      final response = await http.get(url);
      final responseData = jsonDecode(response.body) as Map;
      responseData.values.map((e) {
        email = e['email'];
        userName = e['userName'];
        userType = e['userType'];
        adminHotelId = e['hotelId'];
      }).toList();
    } catch (e) {
      print(e);
    }
  }


  Future<String> getUserType() async{
    var url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/users.json?orderBy="UID"&equalTo="$userId"');

    try {
      final response = await http.get(url);
      final responseData = jsonDecode(response.body) as Map;
      responseData.values.map((e) {
        userType = e['userType'];
      }).toList();
    } catch (e) {
      print(e);
    }
    return userType;
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }

    final timeExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeExpiry), logOut);
  }

}
