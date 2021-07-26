import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hotel {
  String hotelId;
  String name;
  String description;
  String rate;
  Map<String, String> images;

  Hotel(
      {@required this.hotelId,
      @required this.name,
      @required this.description,
      @required this.rate,
      @required this.images});
}

class HotelsProvider with ChangeNotifier {
  List<Hotel> fetchedList = [];

  Future<List<Hotel>> fetchData() async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/hotels.json');
    final response = await http.get(url);
    final responseData = jsonDecode(response.body) as Map;
    var responseList = responseData.values.toList();
    responseList.forEach((listItem) {
      if (fetchedList
          .every((element) => element.hotelId != listItem['hotelId'])) {
        fetchedList.add(Hotel(
          hotelId: listItem['hotelId'],
          name: listItem['name'],
          description: listItem['descreption'],
          rate: listItem['rate'].toString(),
          images: Map<String, String>.from(listItem['images']),
        ));
      }
    });

    notifyListeners();
    return fetchedList;
  }

  List<Hotel> get getHotels {
    return [...fetchedList];
  }

  void sortHotelsByRateAsc() {
    fetchedList.sort((a , b) =>
      a.rate.compareTo(b.rate)
    );

    notifyListeners();
  }

  void sortHotelsByRateDesc() {
    fetchedList.sort((a , b) =>
        b.rate.compareTo(a.rate)
    );

    notifyListeners();
  }

  void sortHotelsByNameAsc(){
    fetchedList.sort((a , b) =>
        a.name.compareTo(b.name)
    );

    notifyListeners();
  }
  void sortHotelsByNameDesc(){
    fetchedList.sort((a , b) =>
        b.name.compareTo(a.name)
    );

    notifyListeners();
  }

  Future<void> postData(String hotelName ,String hotelId, String desc, String rate , List<String> imgUrl) async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/hotels.json');

    final imgLinks = Map<String, String>();
    for(int i = 0 ; i< imgUrl.length ; i++){
      imgLinks.putIfAbsent('i$i', () => imgUrl[i]);
    }

    try {
      await http.post(url,
          body: jsonEncode({
            'name' : hotelName,
            'hotelId' : hotelId,
            'descreption' : desc,
            'images' : imgLinks,
            'rate' : rate

          }));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
