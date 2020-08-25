import 'package:flutter/material.dart';

class ColorExplanation extends StatelessWidget {
  String name;
  Color color;
  ColorExplanation(this.color, this.name);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: color),
        ),
        SizedBox(width: 3),
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
