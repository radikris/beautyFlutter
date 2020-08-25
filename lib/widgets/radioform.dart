import 'package:flutter/material.dart';
import '../utilities/constans.dart';

class RadioForm extends StatefulWidget {

  final Function pickedusertype;
  RadioForm(this.pickedusertype);

  @override
  _RadioFormState createState() => _RadioFormState();
}

class _RadioFormState extends State<RadioForm> {

  List gender = ["Customer", "Service provider"];

  String select;

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Color(0xFF527DAA),
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
              widget.pickedusertype(value);
            });
          },
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      decoration: kBoxDecorationStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          addRadioButton(0, 'Customer'),
          addRadioButton(1, 'Service provider'),
        ],
      ),
    );
  }
}
