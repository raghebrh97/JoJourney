import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jojourney/models/search_delegate.dart';
import 'package:jojourney/providers/hotels_provider.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:jojourney/screens/user_auth_screen.dart';
import 'package:jojourney/widgets/mydrawer.dart';
import 'package:provider/provider.dart';
import '../screens/explore_screen.dart';
import '../screens/hotels_screen.dart';
import '../screens/reservations_screen.dart';
import 'explore_screen.dart';


class TabsScreen extends StatefulWidget {
  static const String tabsRoute = '/tabsScreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var initialTabIndex = 1;
  String email;
  String userName;
  var isRateSorted = false;
  var isNameSorted = false;


  List<Widget> tabs = [ReservationsScreen(), ExploreScreen(), HotelsScreen()];

  var tabsTitlesList = [
    {'title': 'Reservations'},
    {'title': 'Explore'},
    {'title': 'Hotels'}
  ];

  void onTabClick(int index) {
    setState(() {
      initialTabIndex = index;
    });
  }

  Future<bool> onBack() {
    if (initialTabIndex == 1) {
      SystemNavigator.pop();
    } else {
      setState(() {
        initialTabIndex = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final hotelsProv = Provider.of<HotelsProvider>(context, listen: false);

    return WillPopScope(
        onWillPop: onBack,
        child: Scaffold(
            appBar:
            AppBar(
              leading: !userProv.isAuth ? Container() : null,
              title: Text(tabsTitlesList.elementAt(initialTabIndex)['title']),
              actions: [
                if (initialTabIndex == 2)
                  PopupMenuButton(
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              isNameSorted
                                  ? hotelsProv.sortHotelsByNameDesc()
                                  : hotelsProv.sortHotelsByNameAsc();

                              setState(() {
                                isNameSorted = !isNameSorted;
                              });
                            },
                            icon: Icon(Icons.sort_by_alpha),
                            label: isNameSorted
                                ? Text('Sort by name descending')
                                : Text('Sort by name ascending'),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black54)),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              isRateSorted
                                  ? hotelsProv.sortHotelsByRateDesc()
                                  : hotelsProv.sortHotelsByRateAsc();

                              setState(() {
                                isRateSorted = !isRateSorted;
                              });
                            },
                            icon: Icon(Icons.star),
                            label: isRateSorted
                                ? Text('Sort by rating descending')
                                : Text('Sort by rating ascending'),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black54)),
                          ),
                        ),
                      ];
                    },
                    icon: Icon(Icons.sort),
                  ),
                if (initialTabIndex == 2)
                  IconButton(icon: Icon(Icons.search), onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchClass(hotelsProv.getHotels),
                    );
                  })

              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 5,
              type: BottomNavigationBarType.shifting,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.single_bed), label: 'Reservations'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.location_on_outlined), label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.hotel_outlined), label: 'Hotels'),
              ],
              currentIndex: initialTabIndex,
              selectedItemColor: Colors.deepPurpleAccent,
              onTap: onTabClick,
            ),
            body: IndexedStack(
              children: [...tabs],
              index: initialTabIndex,
            ),
            floatingActionButton: userProv.isAuth
                ? null
                : FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserAuth.userAuthRoute);
                    },
                    label: Text('Create a new account!'),
                    icon: Icon(Icons.person_rounded),
                    backgroundColor: Colors.white,
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            drawer: Drawer(child: AppDrawer())));
  }
}
