import 'package:flutter/material.dart';
import 'package:jojourney/providers/reservations_provider.dart';
import 'package:provider/provider.dart';

class HotelAdminScreen extends StatefulWidget {
  final String adminHotelId;


  HotelAdminScreen(this.adminHotelId);

  @override
  _HotelAdminScreenState createState() => _HotelAdminScreenState();
}

class _HotelAdminScreenState extends State<HotelAdminScreen> {


  @override
  Widget build(BuildContext context) {
    final resProv = Provider.of<ReservationsProvider>(context);
    return FutureBuilder(
        future: resProv.fetchReservationsForAdmin(widget.adminHotelId),
        builder: (ctx, snapShot) =>
          resProv.getAdminList.isEmpty
            ? Center(child: Text('There are no pending requests')):
        ListView.builder(
                itemCount: resProv.getAdminList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    height: 200,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Hotel Name : ${resProv.getAdminList[index].hotelName}'),
                            SizedBox(height: 5,),
                            Text(
                                'Client Email : ${resProv.getAdminList[index].userName}'),
                            SizedBox(height: 5,),
                            Text(
                                'Reservation Date : ${resProv.getAdminList[index].date}'),
                            SizedBox(height: 5,),
                            Text(
                                'Total Price : ${resProv.getAdminList[index].price}\$'),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  child: Text(
                                      'Status : ${resProv.getAdminList[index].status}' , style: TextStyle(fontWeight: FontWeight.bold),),
                                  alignment: Alignment.centerRight,
                                )),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: OutlinedButton(
                                        style:resProv.getAdminList[index].status == 'Rejected'? ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black12)) : ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        child: Text('Reject'),
                                        onPressed: resProv.getAdminList[index].status == 'Rejected'? null :() {
                                          resProv.updateResStatus(
                                              resProv.getAdminList[index]
                                                  .reservationId,
                                              'Rejected');
                                        })),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: resProv.getAdminList[index].status == 'Accepted'?ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black12)) : ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blueAccent)),
                                      child: Text('Accept'),
                                      onPressed:resProv.getAdminList[index].status == 'Accepted'? null : () {
                                        resProv.updateResStatus(
                                            resProv.getAdminList[index]
                                                .reservationId,
                                            'Accepted');
                                      },
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })

       );
      }
  }

