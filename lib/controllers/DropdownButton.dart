import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  String dropdownValue = 'Eliminar';

  String get selectedValue => dropdownValue;

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState(dropdownValue);
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String dropdownValue;

  _DropdownButtonWidgetState(this.dropdownValue);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,

      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.dropdownValue = newValue;
        });
      },
      items: <String>['Eliminar', 'Recogida']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}