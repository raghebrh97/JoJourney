import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:jojourney/widgets/reservation_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_slider/image_slider.dart';
import 'package:provider/provider.dart';

class HotelInfo extends StatefulWidget {
  static const hotelInfoRoute = '/hotel_info';

  @override
  _HotelInfoState createState() => _HotelInfoState();
}

class _HotelInfoState extends State<HotelInfo> with TickerProviderStateMixin {
  Map<String, double> roomTypes = {
    'Single Room': 50,
    'Double Room': 100,
    'Triple Room': 150,
    'Quad Room': 200,
    'Queen Room': 250,
    'Twin Room': 300,
  };

  String selectedRoom;
  double roomPrice;
  DateTime selectedArrDate = DateTime.now();
  DateTime selectedDepDate = DateTime.now().add(Duration(days: 1));

  Future<void> openMap(String name) async {

    var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=$name";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      var tempName = name.toString().replaceAll(' ', '%20');
      urlAppleMaps = 'https://maps.apple.com/?q=$tempName';

      if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      } else {
        throw 'Could not launch $urlAppleMaps';
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    selectedRoom = roomTypes.keys.first;
    roomPrice = roomTypes.values.first;
    final userProv = Provider.of<UserProvider>(context);
    var args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    Map<String, String> imagesMap = args['imagesList'];
    List<String> imagesList =
    imagesMap.values.map((e) => e.toString()).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(args['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(
              showTabIndicator: true,
              tabController:
              TabController(length: imagesList.length, vsync: this),
              tabIndicatorColor: Colors.white,
              tabIndicatorSelectedColor: Colors.black87,
              tabIndicatorHeight: 5,
              tabIndicatorSize: 8,
              curve: Curves.fastOutSlowIn,
              width: MediaQuery.of(context).size.width,
              height: 220,
              allowManualSlide: true,
              children: imagesList.map((String link) {
                return new ClipRRect(
                    child: Image.network(
                      link,
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      fit: BoxFit.fill,
                    ));
              }).toList(),
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About ${args['name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Rating : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        RatingBarIndicator(
                            unratedColor: Color.fromRGBO(255, 193, 7, 0.5),
                            rating: double.parse(args['rate']),
                            itemCount: 5,
                            itemSize: 20,
                            direction: Axis.horizontal,
                            itemBuilder: (ctx, val) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      args['desc'],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton.icon(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all(Colors.indigo)),
                          onPressed: () {
                            openMap(args['name']);
                          },
                          icon: Icon(Icons.location_on_outlined),
                          label: Platform.isAndroid?Text('Show Location in Google Maps') : Text('Show Location in Maps'),
                        ),
                      ),
                    ),
                    if (userProv.isAuth)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton.icon(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all(Colors.indigo)),
                          onPressed: () async{
                            await showModalBottomSheet(context: context, builder: (ctx){
                              return ReservationForm(
                                hotelId: args['hotelId'],
                                selectedRoom: selectedRoom,
                                roomPrice: roomPrice,
                                roomTypes: roomTypes,
                                selectedArrDate: selectedArrDate,
                                selectedDepDate: selectedDepDate,
                                hotelName: args['name'],
                                UID: userProv.userId,
                                email : userProv.email,
                                msContext: context,
                              );
                            });
                          },
                          icon: Icon(Icons.add_rounded),
                          label: Text('Book now!'),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
