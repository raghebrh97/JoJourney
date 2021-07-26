import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Place {
  String placeId;
  String categoryId;
  String title;
  String desc;
  String images;
  Map<String, String> imagesUrl;
  String longitude;
  String latitude;

  Place(
      {@required this.placeId,
      @required this.categoryId,
      @required this.title,
      @required this.desc,
      @required this.imagesUrl,
       this.images,
       this.longitude,
       this.latitude});
}

class PlaceProvider with ChangeNotifier {
  List<Place> fetchedList = [];
  List<Place> providedList = [];

  Future<List<Place>> fetchData() async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/places.json');
    final response = await http.get(url);
    final responseData = jsonDecode(response.body) as Map;
    final responseList = responseData.values.toList();

    responseList.forEach((listItem) {
      //!fetchedList
      //           .any((element) => element.placeId == listItem['placeId'])
      if (fetchedList
          .every((element) => element.placeId != listItem['placeId'])) {
        fetchedList.add(Place(
            placeId: listItem['placeId'],
            categoryId: listItem['categoryId'],
            title: listItem['title'],
            desc: listItem['description'],
            imagesUrl: Map<String, String>.from(listItem['images']),
            // images: (listItem['images'] as Map<dynamic , dynamic>).keys.first.toString(),
            // longitude: listItem['location']['longitude'],
            // latitude: listItem['location']['latitude']
        ));
      }
    });

    providedList = fetchedList;

    notifyListeners();
    return placesList;
  }

  List<Place> get placesList {
    return [...providedList];
  }

  Future<void> postData(String categoryId , String name, String desc , List<String> imgUrl) async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/places.json');

    final imgLinks = Map<String, String>();
    for(int i = 0 ; i< imgUrl.length ; i++){
      imgLinks.putIfAbsent('i$i', () => imgUrl[i]);
    }

    try {
      await http.post(url,
          body: jsonEncode({
            'categoryId' : categoryId,
            'placeId': DateTime.now().toIso8601String(),
            'title': name,
            'description' : desc,
            'images': imgLinks
          }));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }


}
