import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jojourney/screens/hotel_info.dart';
import '../providers/hotels_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class HotelsScreen extends StatefulWidget {
  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  List<Hotel> hotelsList = [];
  var isLoading = true;

  @override
  void didChangeDependencies() {
    //Provider.of<CategoriesProvider>(context);
    Provider.of<HotelsProvider>(context).fetchData().then((value) {
      hotelsList = value;
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.deepPurple,
            ),
          )
        : hotelsList.isEmpty
            ? Center(
                child: Text(
                  'There are no items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: hotelsList.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(
                          HotelInfo.hotelInfoRoute,
                          arguments: {
                            'name':
                            hotelsList[index]
                                .name,
                            'desc':
                            hotelsList[index]
                                .description,
                            'imagesList':
                            hotelsList[index]
                                .images,
                            'rate' : hotelsList[index].rate,
                            'hotelId' : hotelsList[index].hotelId
                          }
                      );
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
                                  image: hotelsList[index].images['i1'],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hotelsList[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5,),
                                        RatingBarIndicator(
                                          unratedColor: Color.fromRGBO(255, 193, 7, 0.5),
                                            rating: double.parse(
                                                hotelsList[index].rate),
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
                                          hotelsList[index].description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton.icon(
                                              onPressed: null,
                                              icon: Icon(Icons.read_more_rounded),
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
                });
  }
}
