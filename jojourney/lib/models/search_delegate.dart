import 'package:flutter/material.dart';
import 'package:jojourney/providers/places_provider.dart';
import 'package:jojourney/screens/hotel_info.dart';
import 'package:jojourney/screens/place_info_screen.dart';
import '../providers/hotels_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomSearchClass extends SearchDelegate {
  List<dynamic> searchResult = [];
  List<dynamic> myList;

  CustomSearchClass(this.myList);

  List<dynamic> searchConditions(List<dynamic> list){
    list = myList.where((element) {
    if (myList is List<Hotel>) {
    return (element.name.toString().startsWith(query) ||
    element.description.contains(query) ||
    element.name.toString().toLowerCase().startsWith(query) ||
    element.description.toString().toLowerCase().contains(query) ||
    element.name.toString().toUpperCase().startsWith(query) ||
    element.description.toString().toUpperCase().contains(query));
    } else if (myList is List<Place>) {
    return (element.title.startsWith(query) ||
    element.desc.contains(query) ||
    element.title.toString().toLowerCase().startsWith(query) ||
    element.desc.toString().toLowerCase().contains(query) ||
    element.title.toString().toUpperCase().startsWith(query) ||
    element.desc.toString().toUpperCase().contains(query));
    } else
    return false;
    }).toList();

    return list;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
// this will show clear query button
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if(query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
// adding a back button to close the search
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResult.clear();

    searchResult = searchConditions(myList);

    if (searchResult.isEmpty)
      return Center(
        child: Text('No results found'),
      );
    else {
      if(searchResult is List<Hotel>)
      return HotelsBuildWidget(searchResult: searchResult);
      else
        return PlacesSearchWidget(searchResult);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchResult = searchConditions(myList);

    if (searchResult.isEmpty)
      return Center(
        child: Text('No results found'),
      );
    else if(query.isNotEmpty && searchResult.isNotEmpty){
      if(searchResult is List<Hotel>)
      return HotelsSuggestionWidget(searchResult: searchResult);
      else
        return PlacesSearchWidget(searchResult);

    } else
      return Container();
  }
}

class PlacesSearchWidget extends StatelessWidget{
  final List searchResult;
  PlacesSearchWidget(this.searchResult);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context)
                  .pushNamed(
                  PlaceInfo
                      .placeInfoRoute,
                  arguments: {
                    'title':
                    searchResult[index]
                        .title,
                    'desc':
                    searchResult[index]
                        .desc,
                    'imagesList':
                    searchResult[index]
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
                          image: searchResult[index]
                              .imagesUrl
                              .values
                              .first,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
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
                                  searchResult[index].title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  searchResult[index].desc,
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
                                      label: Text('Click here to learn more'),
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
        });
  }
}

class HotelsBuildWidget extends StatelessWidget {
  const HotelsBuildWidget({
    Key key,
    @required this.searchResult,
  }) : super(key: key);

  final List searchResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ListView(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResult.length, (index) {
            var item = searchResult[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(HotelInfo.hotelInfoRoute, arguments: {
                  'name': item.name,
                  'desc': item.description,
                  'imagesList': item.images,
                  'rate': item.rate,
                  'hotelId': item.hotelId
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
                            image: item.images['i1'],
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RatingBarIndicator(
                                      unratedColor:
                                          Color.fromRGBO(255, 193, 7, 0.5),
                                      rating: double.parse(item.rate),
                                      itemCount: 5,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                      itemBuilder: (ctx, val) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    item.description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton.icon(
                                        onPressed: null,
                                        icon: Icon(
                                            Icons.read_more_rounded),
                                        label: Text('Click here to learn more'),
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
          })),
    );
  }
}

class HotelsSuggestionWidget extends StatelessWidget {
  const HotelsSuggestionWidget({
    Key key,
    @required this.searchResult,
  }) : super(key: key);

  final List searchResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ListView.builder(
          itemCount: searchResult.length,
          itemBuilder: (ctx , index){
        return GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(HotelInfo.hotelInfoRoute, arguments: {
              'name': searchResult[index].name,
              'desc': searchResult[index].description,
              'imagesList': searchResult[index].images,
              'rate': searchResult[index].rate,
              'hotelId': searchResult[index].hotelId
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
                        image: searchResult[index].images['i1'],
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                searchResult[index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RatingBarIndicator(
                                  unratedColor:
                                  Color.fromRGBO(255, 193, 7, 0.5),
                                  rating: double.parse(searchResult[index].rate),
                                  itemCount: 5,
                                  itemSize: 20,
                                  direction: Axis.horizontal,
                                  itemBuilder: (ctx, val) =>
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                searchResult[index].description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                        Icons.read_more_rounded),
                                    label: Text('Click here to learn more'),
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
      })
    );
  }
}
