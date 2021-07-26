import 'package:flutter/material.dart';
import 'package:jojourney/widgets/admin_forms.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<String> options = [
    'Add a new Category',
    'Add a new Place',
    'Add a new Hotel'
  ];

  String selectedOption = 'Add a new Category';
  int selectedOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Column(
            children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Select an Operation',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 2,
                    child: DropdownButton(
                      hint: Text('Select An Operation from the list'),
                      value: selectedOption,
                      items: options.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedOption = newVal;
                          selectedOptionIndex = options.indexOf(selectedOption);
                        });
                      },
                    )),
              ],
            ),
          ),
          Expanded(flex : 6,child: AdminForm(selectedOptionIndex)),

        ]));
  }
}
