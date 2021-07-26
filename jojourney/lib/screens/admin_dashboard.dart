import 'package:flutter/material.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:jojourney/widgets/admin_screen.dart';
import '../screens/hotelAdmin_screen.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  static const adminRoute = '/admin_route';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();

}

class _AdminDashboardState extends State<AdminDashboard> {

  @override
  Widget build(BuildContext context) {
    print('build is called');
    final userProv = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Admin DashBoard'),
        ),
        body: userProv.userType == 'admin'
            ? AdminScreen()
            : HotelAdminScreen(userProv.adminHotelId));
  }
}
