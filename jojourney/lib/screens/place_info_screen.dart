import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_slider/image_slider.dart';
import 'package:url_launcher/url_launcher.dart';


class PlaceInfo extends StatefulWidget {
  static const placeInfoRoute = '/place_info';

  @override
  _PlaceInfoState createState() => _PlaceInfoState();
}

class _PlaceInfoState extends State<PlaceInfo> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    Map<String, String> imagesMap = args['imagesList'];
    List<String> imagesList =
    imagesMap.values.map((e) => e.toString()).toList();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
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
                      'About ${args['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      args['desc'],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton.icon(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all(Colors.indigo)),
                          onPressed: () {
                            openMap(args['title']);
                          },
                          icon: Icon(Icons.location_on_outlined),
                          label: Platform.isAndroid?Text('Show Location in Google Maps') : Text('Show Location in Maps'),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
