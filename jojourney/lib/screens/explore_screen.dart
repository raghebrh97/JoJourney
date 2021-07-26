import 'package:flutter/material.dart';
import 'package:jojourney/screens/places_screen.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../providers/categories_provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final title = 'Explore';
  List<Categories> catList = [];
  var isLoading = true;


  @override
  void didChangeDependencies() {
    Provider.of<CategoriesProvider>(context).fetchData().then((value) {
      catList = value;
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
          ))
        : catList.isEmpty
            ? Center(
                child: Text(
                  'There is no Data!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(PlacesScreen.placeRoute,
                          arguments: {'categoryId' : catList[index].categoryId.toString() , 'categoryName' : catList[index].name});
                    },
                    child: Card(
                      shadowColor: Colors.black12,
                      margin: EdgeInsets.all(7),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                                  child: FadeInImage.memoryNetwork(
                                    fit: BoxFit.fill,
                                    width: 600,
                                    height: 200,
                                    image: catList[index].imgUrl,
                                    placeholder: kTransparentImage,
                                    // child: Image.network(
                                    //   catList[index].imgUrl,
                                    //   fit: BoxFit.cover,
                                    //
                                    // ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            catList[index].name,
                            style: TextStyle(
                                fontSize: 15,
//                            fontWeight: FontWeight.bold,
                                fontFamily: 'FredokaOne'),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: catList.length,
              );
  }
}
