import 'package:flutter/material.dart';
import 'package:jojourney/models/search_delegate.dart';
import 'package:jojourney/screens/place_info_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import '../providers/places_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class PlacesScreen extends StatefulWidget {
  static const placeRoute = '/places_screen';
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<Place> placesList = [];
  var isLoading = true;
  int index = 0;
  var isNameSorted = false;

  @override
  void didChangeDependencies() {
    final categoryData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    //Provider.of<CategoriesProvider>(context);
    Provider.of<PlaceProvider>(context, listen: false)
        .fetchData()
        .then((value) {
      // placesList = value;
      value.forEach((provElement) {
        if (provElement.categoryId == categoryData['categoryId']) {
          if (placesList.isEmpty) {
            placesList.add(provElement);
          } else {
            for (int i = 0; i < placesList.length; i++) {
              if (placesList[i].placeId != provElement.placeId)
                placesList.add(provElement);
            }
          }
        }
      });
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });

    super.didChangeDependencies();
  }

  void sortPlacesByNameAsc() {
    placesList.sort((a, b) => a.title.compareTo(b.title));
  }

  void sortPlacesByNameDesc() {
    placesList.sort((a, b) => b.title.compareTo(a.title));
  }

  @override
  Widget build(BuildContext context) {
    final categoryData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryData['categoryName']),
          actions: [
            if (placesList.isNotEmpty)
              IconButton(
                  onPressed: () {
                    isNameSorted
                        ? sortPlacesByNameDesc()
                        : sortPlacesByNameAsc();

                    setState(() {
                      isNameSorted = !isNameSorted;
                    });
                  },
                  icon: isNameSorted
                      ? Image.asset(
                          'assets/descending-alphabet-sort.png',
                          color: Colors.white,
                        )
                      : Image.asset(
                          'assets/sort-alphabet-ascending.png',
                          color: Colors.white,
                        )),
            IconButton(icon: Icon(Icons.search), onPressed: ()=> showSearch(context: context , delegate: CustomSearchClass(placesList)))
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.deepPurple,
                ),
              )
            : placesList.isEmpty
                ? Center(
                    child: Text(
                      'There are no items',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: placesList.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context)
                              .pushNamed(
                              PlaceInfo
                                  .placeInfoRoute,
                              arguments: {
                                'title':
                                placesList[index]
                                    .title,
                                'desc':
                                placesList[index]
                                    .desc,
                                'imagesList':
                                placesList[index]
                                    .imagesUrl
                              });
                        },
                        child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.all(5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: placesList[index]
                                          .imagesUrl
                                          .values
                                          .first,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                    // child: Image.network(
                                    //   placesList[index].images,
                                    //   fit: BoxFit.cover,
                                    //   height: 150,
                                    // ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              placesList[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              placesList[index].desc,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Icon(
                                                      Icons.read_more_rounded),
                                                  label: Text('Read More'),
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty.all(
                                                            Colors.blueGrey),
                                                  )),
                                            )
                                          ]),
                                    ),
                                  ),
                                ])),
                      );
                    }));
  }
}
