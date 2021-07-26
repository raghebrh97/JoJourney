import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jojourney/providers/hotels_provider.dart';
import 'package:jojourney/providers/places_provider.dart';
import 'package:jojourney/providers/reservations_provider.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:jojourney/screens/admin_dashboard.dart';
import 'package:jojourney/screens/hotel_info.dart';
import 'package:jojourney/screens/place_info_screen.dart';
import 'package:jojourney/screens/places_screen.dart';
import 'package:jojourney/widgets/splash_screen.dart';
import './screens/tabs_screen.dart';
import './screens/user_auth_screen.dart';
import 'package:provider/provider.dart';
import './providers/places_provider.dart';
import 'providers/categories_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => HotelsProvider()),
        ChangeNotifierProxyProvider<UserProvider, ReservationsProvider>(
          update: (ctx, userProv, reservationProv) =>
              ReservationsProvider(userProv.userId),
          create: null,
        ),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProv, child) => MaterialApp(
          title: 'JoJourney',
          theme: ThemeData(
              primaryColor: Colors.deepPurpleAccent,
              accentColor: Colors.white,
              textSelectionTheme: TextSelectionThemeData(
                  selectionColor: Colors.black,
                  cursorColor: Colors.deepPurpleAccent)),
          home: userProv.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: userProv.autoLogin(),
                  builder: (ctx, userSnapShot) =>
                      userSnapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : UserAuth()),
          routes: {
            TabsScreen.tabsRoute: (ctx) => TabsScreen(),
            UserAuth.userAuthRoute: (ctx) => UserAuth(),
            PlacesScreen.placeRoute: (_) => PlacesScreen(),
            PlaceInfo.placeInfoRoute: (_) => PlaceInfo(),
            HotelInfo.hotelInfoRoute: (_) => HotelInfo(),
            AdminDashboard.adminRoute: (_) => AdminDashboard(),
          },
        ),
      ),
    );
  }
}
