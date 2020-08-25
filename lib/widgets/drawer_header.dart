import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              'http://www.bbk.ac.uk/mce/wp-content/uploads/2015/03/8327142885_9b447935ff.jpg'),
          radius: 50.0,
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Username',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      Align(
        alignment: Alignment.centerRight + Alignment(0, .3),
        child: Text(
          'Customer/Job name',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight + Alignment(0, .8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Userlocation',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ]);
  }
}
