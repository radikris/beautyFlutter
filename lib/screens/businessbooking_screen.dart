import 'package:beauty_app/screens/booking_screen.dart';
import 'package:beauty_app/utilities/constans.dart';
import 'package:beauty_app/widgets/onlyservice/modalbottomprofilecard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';
import 'package:dateable/dateable.dart';

// ignore: unused_import

class BusinessBooking extends StatefulWidget {
  static const routeName = '/business-booking';
  @override
  _BusinessBookingState createState() => _BusinessBookingState();
}

class _BusinessBookingState extends State<BusinessBooking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TimetableController<BasicEvent> _controller;

  Map<String, List<dynamic>> bookingsList = {};
  List<BookedHelper> bookingsDetail = [];

  Future<void> getEverydayBookings() async {
    print('na akkor geteveryday');
    var currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection("bookings")
        .document(currentUser.uid)
        .collection("bookeddates")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        bookingsList[result.documentID] = result.data['booked'];
      });
      print(bookingsList);
    });
  }

  List<DateTime> getDatesList() {
    List<DateTime> tempList = [];
    DateTime now = DateTime.now();
    int calculatedDay;
    bookingsList.forEach((key, value) {
      calculatedDay = getDayFromToday(now, key);
      if (calculatedDay > 0) {
        tempList.add(now.subtract(Duration(days: calculatedDay)));
      } else {
        calculatedDay *= -1;
        tempList.add(now.add(Duration(days: calculatedDay)));
      }
    });
    return tempList;
  }

  int getDayFromToday(DateTime now, String dayInString) {
    DateTime timeDate = DateFormat("yyyy-MM-dd").parse(dayInString);
    var difference = now.difference(timeDate).inDays;
    print(difference);
    print(dayInString);
    print('*******');
    if (timeDate.isAfter(now)) {
      difference -= 1;
    }
    return difference;
  }

  List<BasicEvent> getTablesList() {
    List<BasicEvent> tempTables = [];
    int i = 0;
    bookingsList.forEach((key, value) {
      //i++;
      value.forEach((element) {
        i++;
        bookingsDetail.add(new BookedHelper(element['event'],
            element['duration'], element['userId'], element['eventTitel']));

        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        DateTime startdate = dateFormat.parse(key + " " + element['event']);
        DateFormat dateTimeslotFormat = DateFormat('HH:mm');
        DateTime startevent = dateTimeslotFormat.parse(element['event']);
        DateTime endevent =
            startevent.add(Duration(minutes: int.parse(element['duration'])));
        print(startevent);
        print(endevent);

        tempTables.add(
          BasicEvent(
            id: i,
            title: element['eventTitel'],
            color: niceBlue,
            start: LocalDate.dateTime(startdate).at(LocalTime(
                int.parse(element['event'].toString().split(':')[0]),
                int.parse(element['event'].toString().split(':')[1]),
                0)),
            end: LocalDate.dateTime(startdate).at(LocalTime(
                int.parse(endevent.toString().split(' ')[1].split(':')[0]),
                int.parse(endevent.toString().split(' ')[1].split(':')[1]),
                0)),
          ),
        );
      });
      // int i=0;
      // int j=0;

      // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      // DateTime startdate = dateFormat.parse(key + " " + value[i]['event']);
      // DateFormat dateTimeslotFormat = DateFormat('HH:mm');
      // DateTime startevent=dateTimeslotFormat.parse(value[i]['event']);
      // DateTime endevent=startevent.add(Duration(minutes: int.parse(value[i]['duration'])));
      // // String asd = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
      // //  final date = startdate.toDate();
      // //  date.format(['dd', '/', 'mm', '/' ,'yyyy']);
      // //  date.toDateTime();

      // //DateTime dateTime = dateFormat.parse("2019-07-19 8:40:23");
      // // print('>>>>>>>>>>>>>');
      // // print(startdate);
      // // print('***');
      // // print(LocalDate.today().at(LocalTime(13, 0, 0)));
      // // print('<<<<<<<<<<<<');
      // // DateTime enddate =
      // //     startdate.add(Duration(minutes: int.parse(value[i]['duration'])));
      //   print(startevent);
      //   print(endevent);

      // tempTables.add(
      //   BasicEvent(
      //     id: key,
      //     title: 'Halász Gabi',
      //     color: Colors.blue,
      //     // start: LocalDateTime.dateTime(startdate),
      //     // end: LocalDateTime.dateTime(enddate),
      //     // start: LocalDate.today().at(LocalTime(13, 0, 0)),
      //      start :LocalDate.dateTime(startdate).at(LocalTime(int.parse(value[i]['event'].toString().split(':')[0]),int.parse(value[i]['event'].toString().split(':')[1]),0)),
      //     end: LocalDate.dateTime(startdate).at(LocalTime(int.parse(endevent.toString().split(' ')[1].split(':')[0]), int.parse(endevent.toString().split(' ')[1].split(':')[1]), 0)),
      //   ),
      //   // LocalDate.dateTime(startdate).at(Localtime(10,0,0)),
      //   // TableEvent(
      //   //   margin: EdgeInsets.symmetric(horizontal: 50),
      //   //   onTap: () {
      //   //     print(key +
      //   //         " es ezen kivul hogy specko legyen" +
      //   //         value.elementAt(0)['event']);
      //   //   },
      //   //   title: '${value[i]['event']}',
      //   //   start: TableEventTime(
      //   //       hour: int.parse(value[i]['event'].toString().split(':')[0]),
      //   //       minute: int.parse(value[i]['event'].toString().split(':')[1])),
      //   //   end: TableEventTime(
      //   //       hour: int.parse(value[i]['event'].toString().split(':')[0]) + 1,
      //   //       minute: 0),
      //   // ),
      // );
      // i++;
    });
    return tempTables;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Timetable example'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () => _controller.animateToToday(),
            tooltip: 'Jump to today',
          ),
        ],
      ),
      body: FutureBuilder(
        future: getEverydayBookings(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Timetable<BasicEvent>(
                theme: TimetableThemeData(
                  dividerColor: Colors.grey[350],
                ),
                controller: TimetableController(
                  // A basic EventProvider containing a single event:
                  eventProvider: EventProvider.list(
                    //   [
                    //   BasicEvent(
                    //     id: 0,
                    //     title: 'My Event',
                    //     color: Colors.blue,
                    //     start: LocalDate.today().at(LocalTime(13, 0, 0)),
                    //     end: LocalDate.today().at(LocalTime(15, 0, 0)),
                    //   ),
                    // ]
                    getTablesList(),
                  ),

                  initialTimeRange: InitialTimeRange.range(
                    startTime: LocalTime(8, 30, 0),
                    endTime: LocalTime(20, 0, 0),
                  ),
                  initialDate: LocalDate.today(),
                  visibleRange: VisibleRange.days(3),
                  firstDayOfWeek: DayOfWeek.monday,
                ),
                onEventBackgroundTap: (start, isAllDay) {
                  _showSnackBar(
                      'Background tapped $start is all day event $isAllDay');
                },
                eventBuilder: (event) {
                  return BasicEventWidget(
                    event,
                    onTap: () {
                      showModalBottomSheet<void>(
                        //                 context: context,
                        // backgroundColor: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                        // ),
                        // builder: (context) {
                        //   return Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: <Widget>[
                        //       ListTile(
                        //         leading: Icon(Icons.email),
                        //         title: Text('Send email'),
                        //         onTap: () {
                        //           print('Send email');
                        //         },
                        //       ),
                        //       ListTile(
                        //         leading: Icon(Icons.phone),
                        //         title: Text('Call phone'),
                        //          onTap: () {
                        //             print('Call phone');
                        //           },
                        //        ),
                        //     ],
                        //   );
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0)),
                        ),
                        context: context,
                        // backgroundColor: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(20.0),
                        //       topRight: Radius.circular(20.0)),
                        // ),

                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: lightmaincolor, // or some other color
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                            ),
                            height: 450,
                            child: Center(
                              child:

                              ModalBottomProfileCard(getBackDetails(event).userid, getBackDetails(event).eventTitel, getBackDetails(event).event)
                              // ModalBottomProfileCard(
                              //   bookingsDetail[int.parse(event.id) - 1].userid,
                              //   bookingsDetail[int.parse(event.id) - 1]
                              //       .eventTitel,
                              //   bookingsDetail[int.parse(event.id) - 1].event,
                              //   bookingsDetail[int.parse(event.id) - 1]
                              //       .duration,
                              // ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                allDayEventBuilder: (context, event, info) =>
                    BasicAllDayEventWidget(
                  event,
                  info: info,
                  onTap: () => _showSnackBar('All-day event $event tapped'),
                ),
              ),
      ),
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

BookedHelper getBackDetails(BasicEvent event){
  int index = int.parse(event.toString());

  return BookedHelper(bookingsDetail[index-1].event, bookingsDetail[index-1].duration, bookingsDetail[index-1].userid, bookingsDetail[index-1].eventTitel);
}

}

// Consumer<CartModel>(
//       builder: (context, cart, child) {
//         return Text('Total price: ${cart.totalPrice}');
//       },
//     ),

