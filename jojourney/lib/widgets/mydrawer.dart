import 'package:flutter/material.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:jojourney/screens/admin_dashboard.dart';
import '../screens/user_auth_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {

    final userProv = Provider.of<UserProvider>(context, listen: false);
    return FutureBuilder(
        future: userProv.fetchUserData(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurpleAccent,
              ),
            );
    return Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  leading: Container(),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/default_prof.png',
                    width: 50,
                  ),
                  title: Text(
                    userProv.userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text(userProv.email),
                ),
                Divider(
                  thickness: 1,
                ),
                if (userProv.userType == 'admin' ||
                    userProv.userType == 'hotelAdmin')
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AdminDashboard.adminRoute);
                    },
                    icon: Icon(Icons.dashboard),
                    label: Text('Admin Dashboard'),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.black54),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              UserAuth.userAuthRoute);
                                      userProv.logOut();
                                    },
                                    child: Text('Yes'))
                              ],
                            ));
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black54),
                  ),
                )
              ],
            ),
          );
    });
  }
}
