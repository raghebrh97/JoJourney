import 'package:flutter/material.dart';
import 'package:jojourney/providers/reservations_provider.dart';
import 'package:jojourney/providers/users_provider.dart';
import 'package:provider/provider.dart';

class ReservationsScreen extends StatefulWidget {
  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final title = 'Reservations';
  List<Reservation> reservations;
  var isLoading = true;

  // @override
  // void didChangeDependencies() {
  //   Provider.of<ReservationsProvider>(context).fetchData().then((value) {
  //     reservations = value;
  //     if(this.mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final resProv = Provider.of<ReservationsProvider>(context);


    return !userProv.isAuth
        ? Center(
            child:
                Text('You are not logged in, login to check your reservations'))
        : FutureBuilder(
            future: Provider.of<ReservationsProvider>(context).fetchData(),
            builder: (ctx, snapShot) {
              return resProv.getList.isEmpty
                  ? Center(
                      child: Text('You have made no reservations yet!'),
                    )
                  : ListView.builder(
                          itemCount: resProv.getList.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(3),
                              height: 140,
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Hotel Name : ${resProv.getList[index].hotelName}'),
                                      SizedBox(height: 3,),
                                      Text(
                                          'Client Email : ${resProv.getList[index].userName}'),
                                      SizedBox(height: 3,),
                                      Text(
                                          'Reservation Date : ${resProv.getList[index].date}'),
                                      SizedBox(height: 3,),
                                      Text(
                                          'Total Price : ${resProv.getList[index].price}\$'),
                                      SizedBox(height: 5,),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            child: Text(
                                                'Status : ${resProv.getList[index].status}' , style: TextStyle(fontWeight: FontWeight.bold)),
                                            alignment: Alignment.centerRight,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
            });
  }
}
