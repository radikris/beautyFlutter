import 'package:flutter/material.dart';

import '../widgets/calendar_bb/day_view_example.dart';


/// Screen for picking different examples of this library.
///
/// Examples:
/// * [DayView example](day_view_example.dart)
/// * [DaysPageView example](days_page_view_example.dart)
/// * [MonthPageView example](month_page_view_example.dart)
/// * [MonthView example](month_view_example.dart)
class BusinessBooking extends StatefulWidget {

  static const routeName='/business-booking';
  @override
  _BusinessBookingState createState() => _BusinessBookingState();
}

class _BusinessBookingState extends State<BusinessBooking> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "calendar_views example",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("calendar_views example"),
        ),
        body: new Builder(builder: (BuildContext context) {
          return new ListView(
            children: <Widget>[
              new ListTile(
                title: new Text("Day View"),
                subtitle: new Text("DayView Example"),
                onTap: () {
                  _showWidgetInFullScreenDialog(
                    context,
                    new DayViewExample(),
                  );
                },
              ),
              new Divider(height: 0.0),
              new Divider(height: 0.0),
            ],
          );
        }),
      ),
    );
  }

  void _showWidgetInFullScreenDialog(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }
}

// class BusinessBooking extends StatefulWidget {
//   static const routeName = '/business-booking';
//   @override
//   _BusinessBookingState createState() => _BusinessBookingState();
// }

// class _BusinessBookingState extends State<BusinessBooking> {
//   Map<String, List<dynamic>> bookingsList = {};

//   Future<void> getEverydayBookings() async {
//     await Firestore.instance
//         .collection("bookings")
//         .getDocuments()
//         .then((querySnapshot) {
//       querySnapshot.documents.forEach((result) {
//         bookingsList[result.documentID] = result.data['booked'];
//       });
//       print(bookingsList);
//     });
//   }

//   List<DateTime> getDatesList() {
//     List<DateTime> tempList = [];
//     DateTime now = DateTime.now();
//     int calculatedDay;
//     bookingsList.forEach((key, value) {
//       calculatedDay = getDayFromToday(now, key);
//       if (calculatedDay > 0) {
//         tempList.add(now.subtract(Duration(days: calculatedDay)));
//       } else {
//         calculatedDay *= -1;
//         tempList.add(now.add(Duration(days: calculatedDay)));
//       }
//     });
//     return tempList;
//   }

//   int getDayFromToday(DateTime now, String dayInString) {
//     DateTime timeDate = DateFormat("yyyy-MM-dd").parse(dayInString);
//     var difference = now.difference(timeDate).inDays;
//     print(difference);
//     print(dayInString);
//     print('*******');
//     if (timeDate.isAfter(now)) {
//       difference -= 1;
//     }
//     return difference;
//   }

//   List<TableEvent> getTablesList() {
//     List<TableEvent> tempTables = [];
//     bookingsList.forEach((key, value) {
//       int i = 0;
//       print(value[0]);
//       tempTables.add(
//         TableEvent(
//           margin: EdgeInsets.symmetric(horizontal: 50),
//           onTap: () {
//             print(key +
//                 " es ezen kivul hogy specko legyen" +
//                 value.elementAt(0)['event']);
//           },
//           title: '${value[i]['event']}',
//           start: TableEventTime(
//               hour: int.parse(value[i]['event'].toString().split(':')[0]),
//               minute: int.parse(value[i]['event'].toString().split(':')[1])),
//           end: TableEventTime(
//               hour: int.parse(value[i]['event'].toString().split(':')[0]) + 1,
//               minute: 0),
//         ),
//       );
//       i++;
//     });
//     return tempTables;
//   }

//   List<LaneEvents> getEventsList() {
//     List<LaneEvents> tempEvents = [];
//     DateTime now = DateTime.now();

//     bookingsList.forEach((key, value) {
//       tempEvents.add(
//         LaneEvents(
//           lane: Lane(name: '$key'),
//           events: getTablesList(),
//         ),
//       );
//     });
//     return tempEvents;
//   }

//   List<LaneEvents> _buildLaneEvents() {
//     return getEventsList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Timetable View Demo'),
//       ),
//       body: FutureBuilder(
//         future: getEverydayBookings(),
//         builder: (ctx, snapshot) =>
//             snapshot.connectionState == ConnectionState.waiting
//                 ? CircularProgressIndicator()
//                 : TimetableView(
//                     timetableStyle: TimetableStyle(
                      
//                     ),
//                     laneEventsList: _buildLaneEvents(),
//                   ),
//       ),
//     );
//   }
// }
