import 'package:flutter/material.dart';
import '../../utilities/constans.dart';
import '../../screens/booking_screen.dart';

class ServiceTile extends StatelessWidget {
  final service;
  int id;
  ServiceTile(this.businessid, this.service, this.id, this.removeService,
      {this.buttonpressed});
  Function removeService;
  Function buttonpressed;
  String businessid;

  @override
  Widget build(BuildContext context) {
    return removeService != null
        ? Dismissible(
            key: UniqueKey(),
            direction:
                removeService == null ? null : DismissDirection.endToStart,
            onDismissed: (direction) {
              removeService(id);
            },
            background: Container(
              color: removeService == null
                  ? Colors.orange[200]
                  : Theme.of(context).errorColor,
              child: Icon(
                removeService == null ? Icons.visibility_off : Icons.delete,
                color: removeService == null ? Colors.black : Colors.white,
                size: 40,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.symmetric(horizontal: 15),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      //                    <--- top side
                      color: Colors.grey[350],
                      width: 3.0,
                    ),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        service['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${service['duration']} Minutes',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${service['price']} Ft',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  MaterialButton(
                    onPressed:
                        //buttonpressed == null ? null : (){
                        () {
                      // print(service['duration']);
                      // print(service['duration'] is int);
                      Navigator.of(context).pushNamed(BookingScreen.routeName,
                          arguments: BookDetailItem(service['title'],
                              (service['duration']), businessid));
                    },
                    color: maincolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Book',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ))
        : Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    //                    <--- top side
                    color: Colors.grey[350],
                    width: 3.0,
                  ),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      service['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${service['duration']} Minutes',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '${service['price']} Ft',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5,),
                    MaterialButton(
                      onPressed:
                          //buttonpressed == null ? null : (){
                          () {
                        // print(service['duration']);
                        // print(service['duration'] is int);
                        Navigator.of(context).pushNamed(BookingScreen.routeName,
                            arguments: BookDetailItem(service['title'],
                                int.parse((service['duration'])), businessid));
                      },
                      color: maincolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Book',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
                // Text(
                //   '${service['price']} Ft',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                // MaterialButton(
                //   onPressed:
                //       //buttonpressed == null ? null : (){
                //       () {
                //     // print(service['duration']);
                //     // print(service['duration'] is int);
                //     Navigator.of(context).pushNamed(BookingScreen.routeName,
                //         arguments: BookDetailItem(service['title'],
                //             (service['duration']), businessid));
                //   },
                //   color: maincolor,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Text(
                //     'Book',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          );
  }
}

class BookDetailItem {
  String titel;
  int duration;
  String businessid;

  BookDetailItem(this.titel, this.duration, this.businessid);
}
