import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Categories {
  String name;
  String categoryId;
  String imgUrl;

  Categories(
      {@required this.categoryId, @required this.name, @required this.imgUrl});
}

class CategoriesProvider with ChangeNotifier {
  List<dynamic> fetchedList = [];

  Future<List<Categories>> fetchData() async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/categories.json');
    final response = await http.get(url);
    final responseData = jsonDecode(response.body);

    fetchedList = responseData.values
        .map((value) => Categories(
            categoryId: value['id'],
            name: value['name'],
            imgUrl: value['imgUrl']))
        .toList();
    notifyListeners();
    return catList;
  }

  List<Categories> get catList {
    return [...fetchedList];
  }

  Future<void> postData(String id, String name, String imgUrl) async {
    final url = Uri.parse(
        'https://jojourney-6ebd3-default-rtdb.firebaseio.com/categories.json');

    try {
      await http.post(url,
          body: jsonEncode({
            'id': id,
            'name': name,
            'imgUrl': imgUrl,
          }));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
