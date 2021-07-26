import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jojourney/providers/reservations_provider.dart';
import 'package:provider/provider.dart';

class ReservationForm extends StatefulWidget {
  String selectedRoom;
  double roomPrice;
  Map<String, double> roomTypes;
  DateTime selectedArrDate;
  DateTime selectedDepDate;
  String hotelName;
  String hotelId;
  String UID;
  String email;
  BuildContext msContext;

  ReservationForm(
      {@required this.selectedRoom,
      @required this.roomPrice,
      @required this.roomTypes,
      @required this.selectedArrDate,
      @required this.selectedDepDate,
      @required this.hotelName,
      @required this.hotelId,
      @required this.UID,
      @required this.email,
      this.msContext});

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  @override
  Widget build(BuildContext context) {
    final resProv = Provider.of<ReservationsProvider>(context, listen: false);
    var finalPrice = widget.roomPrice;

    return StatefulBuilder(builder: (context, StateSetter setModalState) {
      return Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Reservation Form',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Select Room Type :',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton(
                        hint: Text('Select Room Type'),
                        value: widget.selectedRoom,
                        onChanged: (val) {
                          setModalState(() {
                            widget.selectedRoom = val;
                            widget.roomPrice =
                                widget.roomTypes[widget.selectedRoom];
                            finalPrice = widget.roomPrice *
                                widget.selectedDepDate
                                    .difference(widget.selectedArrDate)
                                    .inDays;
                          });
                        },
                        items: widget.roomTypes.keys.map((roomType) {
                          return DropdownMenuItem<String>(
                              value: roomType, child: Text(roomType));
                        }).toList()),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Select Arrival Date :',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueGrey),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2023));

                          if (pickedDate != null) {
                            setModalState(() {
                              widget.selectedArrDate = pickedDate;
                              finalPrice = widget.roomPrice *
                                  widget.selectedDepDate
                                      .difference(widget.selectedArrDate)
                                      .inDays;
                            });
                          }
                        },
                        child: Text(DateFormat('dd/MM/yyyy')
                            .format(widget.selectedArrDate))),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Select Departure Date :',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueGrey),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2023));

                          if (pickedDate != null) {
                            setModalState(() {
                              widget.selectedDepDate = pickedDate;
                              finalPrice = widget.roomPrice *
                                  (widget.selectedDepDate
                                          .difference(widget.selectedArrDate)
                                          .inDays +
                                      2);
                            });
                          }
                        },
                        child: Text(DateFormat('dd/MM/yyyy')
                            .format(widget.selectedDepDate))),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Selected Room Price :',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(flex: 1, child: Text('$finalPrice \$'))
                ],
              ),
              Divider(),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blueGrey),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  if (widget.selectedArrDate
                                      .isAfter(widget.selectedDepDate)) {
                                    return AlertDialog(
                                      title: Text('Error!'),
                                      content: Text(
                                          'Departure Date must be greater than Arrival Date!'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Dismiss')),
                                      ],
                                    );
                                  } else {
                                    return AlertDialog(
                                      title: Text('Confirmation!'),
                                      content: Text(
                                          'Are you sure you want to submit this request?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              resProv.putData(
                                                  widget.hotelId,
                                                  widget.hotelName,
                                                  widget.email,
                                                  'From ${DateFormat('dd/MM/yyyy').format(widget.selectedArrDate)} To ${DateFormat('dd/MM/yyyy').format(widget.selectedDepDate)}',
                                                  finalPrice.toString(),
                                                  'Submitted',
                                                  widget.UID);

                                              Navigator.pop(context);
                                              Navigator.of(widget.msContext)
                                                  .pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  'Your request has been submitted, please check the reservations tab for the status',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ));
                                            },
                                            child: Text('Yes')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel')),
                                      ],
                                    );
                                  }
                                });
                          },
                          child: Text('Submit Request!')))),
            ],
          ),
        ),
      );
    });
  }
}
