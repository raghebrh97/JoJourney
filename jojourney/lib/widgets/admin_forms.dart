import 'package:flutter/material.dart';
import 'package:jojourney/providers/categories_provider.dart';
import 'package:jojourney/providers/hotels_provider.dart';
import 'package:jojourney/providers/places_provider.dart';
import 'package:provider/provider.dart';

class AdminForm extends StatefulWidget {
  int index;
  AdminForm(this.index);

  @override
  _AdminFormState createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  String categoryId;
  String categoryName;
  String categoryUrl;
  String placeCategoryId;
  String placeName;
  String placeDesc;
  List<String> placeUrls;
  String hotelName;
  String hotelId;
  String hotelDesc;
  List<String> hotelUrls;
  double hotelRate;
  var isLoading = false;

  final formKey = GlobalKey<FormState>();

  Future<void> authForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      setState(() {
        isLoading = true;
      });

      if (widget.index == 0)
        await Provider.of<CategoriesProvider>(context, listen: false)
            .postData(categoryId, categoryName, categoryUrl);
      else if (widget.index == 1)
        await Provider.of<PlaceProvider>(context, listen: false)
            .postData(placeCategoryId, placeName, placeDesc, placeUrls);
      else
        await Provider.of<HotelsProvider>(context, listen: false).postData(
            hotelName, hotelId, hotelDesc, hotelRate.toString(), hotelUrls);

      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text('Operation was done successfully!'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Dismiss'))
              ],
            );
          });
      formKey.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProv =
        Provider.of<CategoriesProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Form(
          key: formKey,
          child: Column(
            children: [
              if (widget.index == 0)
                Column(children: [
                  TextFormField(
                    key: ValueKey('catId'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      categoryId = value;
                    },
                    decoration: InputDecoration(labelText: 'Category ID'),
                  ),
                  TextFormField(
                    key: ValueKey('catName'),
                    validator: (value) {
                      if (value.length < 4)
                        return 'Please Enter aa value larger than 4 characters';
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      categoryName = value;
                    },
                    decoration: InputDecoration(labelText: 'Category Name'),
                  ),
                  TextFormField(
                    key: ValueKey('catUrl'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Please enter a valid URl';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      categoryUrl = value;
                    },
                    decoration:
                        InputDecoration(labelText: 'Category Image URL'),
                    keyboardType: TextInputType.url,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: authForm,
                    child: isLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(),
                            height: 15,
                            width: 15,
                          )
                        : Text('Submit'),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(300, 40)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                  )
                ]),
              if (widget.index == 1)
                Column(children: [
                  TextFormField(
                    key: ValueKey('PCategoryId'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      placeCategoryId = value;
                    },
                    decoration: InputDecoration(labelText: 'Category Id'),
                  ),
                  TextFormField(
                    key: ValueKey('placeName'),
                    validator: (value) {
                      if (value.length < 4)
                        return 'Please Enter aa value larger than 4 characters';
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      placeName = value;
                    },
                    decoration: InputDecoration(labelText: 'Place Name'),
                  ),
                  TextFormField(
                    key: ValueKey('placeDesc'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      placeDesc = value;
                    },
                    decoration: InputDecoration(labelText: 'Place Description'),
                    keyboardType: TextInputType.multiline,
                  ),
                  TextFormField(
                    key: ValueKey('placeUrls'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Please enter URLs separated by a comma';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      placeUrls = value.split(' , ');
                    },
                    decoration: InputDecoration(
                      labelText: 'Place Image URLs',
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: authForm,
                    child: isLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(),
                            height: 15,
                            width: 15,
                          )
                        : Text('Submit'),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(300, 40)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                  )
                ]),
              if (widget.index == 2)
                Column(children: [
                  TextFormField(
                    key: ValueKey('hotelId'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      hotelId = value;
                    },
                    decoration: InputDecoration(labelText: 'Hotel ID'),
                  ),
                  TextFormField(
                    key: ValueKey('hotelName'),
                    validator: (value) {
                      if (value.length < 4)
                        return 'Please Enter aa value larger than 4 characters';
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      hotelName = value;
                    },
                    decoration: InputDecoration(labelText: 'Hotel Name'),
                  ),
                  TextFormField(
                    key: ValueKey('hotelDesc'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'This field is mandatory';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      hotelDesc = value;
                    },
                    decoration: InputDecoration(labelText: 'Hotel Description'),
                    keyboardType: TextInputType.multiline,
                  ),
                  TextFormField(
                    key: ValueKey('hotelUrls'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Please enter URLs separated by a comma';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      hotelUrls = value.split(' , ');
                    },
                    decoration: InputDecoration(
                      labelText: 'Hotel Image URLs',
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  TextFormField(
                    key: ValueKey('hotelRate'),
                    validator: (value) {
                      if (double.parse(value) < 0 || double.parse(value) > 5)
                        return 'Please enter a rating between 1 and 5';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      hotelRate = double.parse(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Hotel Rating',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: authForm,
                    child: isLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(),
                            height: 15,
                            width: 15,
                          )
                        : Text('Submit'),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(300, 40)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent)),
                  )
                ]),
            ],
          )),
    );
  }
}
