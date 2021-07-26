import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Reservation {
  String hotelName;
  String userName;
  String date;
  String price;
  String reservationId;
  String status;
  DateTime creationTime;

  Reservation(
      {@required this.hotelName,
      @required this.userName,
      @required this.date,
      @required this.price,
      @required this.reservationId,
      @required this.status,
      @required this.creationTime});
}

class ReservationsProvider with ChangeNotifier {
  List<Reservation> resList = [];
  List<Reservation> resAdminList = [];
  Map<dynamic, dynamic> dataMap;
  String UID;
  ReservationsProvider(this.UID);

  Future<void> putData(String hotelId, String hotelName, String userName,
      String date, String price, String status, String UID) async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/reservations.json');

    try {
      final putResponse = await http.post(url,
          body: jsonEncode({
            'hotelId': hotelId,
            'clientName': userName,
            'hotelName': hotelName,
            'date': date,
            'price': price,
            'status': status,
            'UID': UID,
            'createTime': DateTime.now().toIso8601String()
          }));
      notifyListeners();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<Reservation>> fetchData() async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/reservations.json?orderBy="UID"&equalTo="$UID"');
    try {
      final response = await http.get(url);
      final responseData = jsonDecode(response.body) as Map;
      resList = responseData.entries
          .map((e) => Reservation(
              reservationId: e.key,
              hotelName: e.value['hotelName'],
              userName: e.value['clientName'],
              date: e.value['date'],
              price: e.value['price'],
              status: e.value['status'],
              creationTime: DateTime.parse(e.value['createTime'])))
          .toList();
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return getList;
  }

  Future<List<Reservation>> fetchReservationsForAdmin(
      String adminHotelId) async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/reservations.json?orderBy="hotelId"&equalTo="$adminHotelId"');

    try {
      final response = await http.get(url);
      final responseData = jsonDecode(response.body) as Map;

      resAdminList = responseData.entries
          .map((e) => Reservation(
              reservationId: e.key,
              hotelName: e.value['hotelName'],
              userName: e.value['clientName'],
              date: e.value['date'],
              price: e.value['price'],
              status: e.value['status'],
              creationTime: DateTime.parse(e.value['createTime'])))
          .toList();
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return getAdminList;
  }

  List<Reservation> get getList {
    resList.sort((a, b) => a.creationTime.compareTo(b.creationTime));

    return [...resList.reversed];
  }

  List<Reservation> get getAdminList {
    resAdminList.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    return [...resAdminList.reversed];
  }

  Future<void> updateResStatus(String ResId, String newStatus) async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/reservations/$ResId/.json');

    try {
      final response =
          await http.patch(url, body: jsonEncode({'status': newStatus}));
      final responseData = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }
}
