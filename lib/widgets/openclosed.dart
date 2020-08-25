import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OpenClosed extends StatelessWidget {

  OpenClosed(this.isopened, this.openstart, this.closeend);

  bool isopened;
  String openstart, closeend;

   bool isOpen(String opentime, String closetime) {
    DateFormat dateFormat = new DateFormat.Hm();
    DateTime now = DateTime.now();
    DateTime open = dateFormat.parse(opentime);
    open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);
    DateTime close = dateFormat.parse(closetime);
    close =
        new DateTime(now.year, now.month, now.day, close.hour, close.minute);

    if (now.isAfter(open) && now.isBefore(close)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (isopened = isOpen(openstart, closeend))
            ? Colors.green[300]
            : Colors.red[300],
      ),
      child: Center(
        child: FlatButton.icon(
          label: Text(
            isopened ? 'OPEN' : 'CLOSED',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          icon: isopened
              ? Icon(
                  FontAwesomeIcons.doorOpen,
                  color: Colors.white,
                )
              : Icon(FontAwesomeIcons.doorClosed, color: Colors.white),
        ),
      ),
    );
  }
}
