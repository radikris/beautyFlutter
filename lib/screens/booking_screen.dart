import 'dart:math';

import 'package:beauty_app/utilities/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/onlyservice/servicetile.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/colorexplanation.dart';

class BookingScreen extends StatefulWidget {
  static final routeName = '/booking-screen';

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var _isBooked = false;

  int elsoido, masodikido;
  bool isholiday = false;

  int bookedIdx;
  int currIdx;
  String event;

  DateTime selectedDate;
  DateTime bookedDate;
  DateTime _selectedDay;

  List<dynamic> bookingsList = [];

  CalendarController _calendarController;
  Map<DateTime, List> _events;
  Map<String, dynamic> bookedTimes = {};
  List _selectedEvents;
  Map<DateTime, List> _holidays = {
    DateTime(2020, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2020, 08, 26): ['Easter Monday'],
  };

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  //starttime: datetime.now() kerekitve felfele vagy sima kezdes

  var startTime = TimeOfDay(hour: 7, minute: 0);
  var endTime = TimeOfDay(hour: 19, minute: 0);
  var step = Duration(minutes: 30);
  bool isinit = true;
  BookDetailItem currentItem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isinit) {
      elsoido = 30;
      //isAlreadyLoaded=true;
      masodikido = 20;

      currentItem = ModalRoute.of(context).settings.arguments as BookDetailItem;
      // step = Duration(minutes: currentItem.duration);
      step = Duration(minutes: 15);

      _calendarController = CalendarController();
      _selectedDay = DateTime.now();

      selectedDate = _selectedDay;
      getCurrentDayBookings(selectedDate);

      final times = getTimes(startTime, endTime, step)
          .map((tod) => tod.format(context))
          .toList();

      _events = {
        _selectedDay.add(Duration(days: 0)): [
          for (int i = 0; i < times.toList().length - 1; i++)
            '${times.elementAt(i)}'
        ],
      };

      _selectedEvents = _events[_selectedDay] ?? [];
      _calendarController = CalendarController();
    }
    isinit = false;
  }

  void _book(int idx, DateTime currentd, String eventName) {
    setState(() {
      currIdx = idx;
      currIdx == bookedIdx ? _isBooked = !_isBooked : _isBooked = true;
      bookedIdx = idx;
    });
    bookedDate = currentd;
    event = eventName;
  }

  List setEvents(int day) {
    final times = getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();

    DateTime keyPair = _selectedDay.add(Duration(days: day));
    setState(() {
      _events[keyPair] = [
        for (int i = 0; i < times.toList().length - 1; i++)
          '${times.elementAt(i)}'
      ];
    });

    return _events[keyPair];
  }

  bool isAlreadyLoaded = false;

  Future<void> getCurrentDayBookings(DateTime date) async {
    // bookingsList = [];
    if (!isAlreadyLoaded) {
      await Firestore.instance
          .collection("bookings")
          .document(currentItem.businessid)
          .collection('bookeddates')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          if (result.documentID == date.toString().split(' ')[0].trim()) {
            bookingsList = result.data['booked'];
          }
        });
      });
      setState(() {
        isAlreadyLoaded = true;
      });
    }
  }

  void _onDaySelected(DateTime day, List events) {
    selectedDate = day;
    isAlreadyLoaded = false;
    bookingsList = [];

    List helper = setEvents(day.day - DateTime.now().day);

    setState(() {
      getCurrentDayBookings(day);
      _selectedEvents = helper;

      if (bookedDate.toString().split(' ')[0] ==
          selectedDate.toString().split(' ')[0]) {
        _isBooked = true;
      } else {
        _isBooked = false;
      }
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.pause_circle_filled,
      size: 20.0,
      color: Colors.red[800],
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.black,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Card(
        child: TableCalendar(
          calendarController: _calendarController,
          initialCalendarFormat: CalendarFormat.week,
          events: _events,
          holidays: _holidays,
          startDay: DateTime.now(),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            selectedColor: Colors.deepOrange[400],
            todayColor: Colors.deepOrange[200],
            outsideDaysVisible: false,
            holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
            markersMaxAmount: 0,
          ),
          headerStyle: HeaderStyle(
            formatButtonTextStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration(
              color: Colors.deepOrange[400],
              borderRadius: BorderRadius.circular(16.0),
            ),
            formatButtonShowsNext: false,
          ),
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              isholiday = false;

              _holidays.forEach((key, value) {
                if (key.toString().split(' ')[0] ==
                    selectedDate.toString().split(' ')[0]) {
                  isholiday = true;
                }
              });

              if (DateFormat.E().format(selectedDate) == 'Sun' || isholiday) {

                isholiday = true;
                // print(DateFormat.E().format(selectedDate));
                // children.add(
                //   Positioned(
                //     right: -2,
                //     top: -2,
                //     child: _buildHolidaysMarker(),
                //   ),
                // );
              } else {
                isholiday = false;
              }

              return children;
            },
          ),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onCalendarCreated: _onCalendarCreated,
        ),
      ),
    );
  }

  bool isOverLapping(DateTime startDate, DateTime endDate,
      DateTime timeSlotDate, DateTime timeSlotDateEnd) {
    if (((startDate.isBefore(timeSlotDate) && endDate.isBefore(timeSlotDate)) &&
            (startDate.isBefore(timeSlotDateEnd) &&
                endDate.isBefore(timeSlotDateEnd))) ||
        ((startDate.isAfter(timeSlotDate) && endDate.isAfter(timeSlotDate)) &&
            (startDate.isAfter(timeSlotDateEnd) &&
                endDate.isAfter(timeSlotDateEnd)))) {
      // if ((timeSlotDate == endDate) ||
      //     (timeSlotDate == startDate) ||
      //     (timeSlotDateEnd == endDate) ||
      //     (timeSlotDateEnd == startDate)) {
      //   return false;
      // } else {
      //   return true;
      // }
      return true;
    }
    return false;
  }

  bool isalreadyinBookedMap(String timeslot) {
    bool resultBooked = false;
    DateTime timeSlotDate = DateFormat("HH:mm").parse(timeslot);
    timeSlotDate = timeSlotDate.add(Duration(minutes: 1));

    DateTime timeSlotDateEnd =
        timeSlotDate.add(Duration(minutes: currentItem.duration));
    timeSlotDateEnd = timeSlotDateEnd.subtract(Duration(minutes: 2));

    bookingsList.forEach((element) {
      DateTime temps = DateFormat("HH:mm").parse(element['event']);
      DateTime startDate = temps;
      DateTime endDate =
          temps.add(Duration(minutes: int.parse(element['duration'])));

      // if ((timeSlotDate.isAfter(startDate) &&
      //         timeSlotDateEnd.isBefore(endDate)) ||
      //     timeSlotDate == startDate) {
      //   resultBooked = true;
      //   return;
      // }

      if (((startDate.isBefore(timeSlotDate) &&
                  timeSlotDateEnd.isBefore(endDate)) ||
              (startDate.isAfter(timeSlotDate) &&
                  timeSlotDateEnd.isAfter(endDate)) ||
              (startDate.isAfter(timeSlotDate) &&
                  timeSlotDateEnd.isBefore(endDate)) ||
              (startDate.isBefore(timeSlotDate) &&
                  timeSlotDateEnd.isAfter(endDate))) &&
          !isOverLapping(startDate, endDate, timeSlotDate, timeSlotDateEnd)) {
        // print(timeslot);
        // print('-----------');
        // print(timeSlotDate);
        // print(timeSlotDateEnd);
        // print('TS_TSE');
        // print(startDate);
        // print(endDate);
        // print('-----------ENDDATE');
        resultBooked = true;
        return resultBooked;
        // return resultBooked;
      }

      // if (((startDate.isBefore(timeSlotDate) &&
      //             endDate.isBefore(timeSlotDate)) &&
      //         (startDate.isBefore(timeSlotDateEnd) &&
      //             endDate.isBefore(timeSlotDateEnd))) ||
      //     ((startDate.isAfter(timeSlotDate) && endDate.isAfter(timeSlotDate)) &&
      //         (startDate.isAfter(timeSlotDateEnd) &&
      //             endDate.isAfter(timeSlotDateEnd)))) {
      //   print('-----------');
      //   print(timeSlotDate);
      //   print(timeSlotDateEnd);
      //   print('TS_TSE');
      //   print(startDate);
      //   print(endDate);
      //   resultBooked = false;
      //   return resultBooked;
      // }
    });
    return resultBooked;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget diplaySnackBar(BuildContext ctx) {
    final snackBar = SnackBar(
      content: Text('Oops, Looks like this termin has been already taken!'),
      backgroundColor: Theme.of(ctx).errorColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    setState(() {
      _isBooked = false;
    });
  }

  bool dateanddate(DateTime a, DateTime b) {
    String selectedDateFormat = a.toString().split(' ')[0];
    String comparedkeyFormat = b.toString().split(' ')[0];
    return selectedDateFormat == comparedkeyFormat;
  }

  Future<void> setBooking(BuildContext ctx) async {
    bool cancontinued = true;
    var currentUser = await FirebaseAuth.instance.currentUser();

    if (isalreadyinBookedMap(event)) {
      cancontinued = false;

      diplaySnackBar(ctx);
      return cancontinued;
    }

    // bookingsList.forEach((element) {
    //   // if (isalreadyinBookedMap(event)) {
    //   print(element['event']);
    //   if (element['event'] == event) {
    //     cancontinued = false;
    //     print('Hiba');
    //     print(event);
    //     return 'Hiba';
    //   }
    // });
    // }
    bookingsList.add(BookedHelper(event, '30', currentUser.uid).setMap());

    if (cancontinued) {
      await Firestore.instance
          .collection('bookings')
          .document(currentItem.businessid)
          .collection('bookeddates')
          .document(bookedDate.toString().split(' ')[0])
          .setData({'booked': bookingsList});
    }
  }

  Widget _buildEventList() {
    if (isholiday) {
      return Center(
        child: Text('EZ HOLIDAAAAAY'),
      );
    } else {
      return !isAlreadyLoaded
          ? FutureBuilder(
              future: getCurrentDayBookings(selectedDate),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : Center(child: Text('Loading...')),
            )
          : GridView.count(
              childAspectRatio: 3 / 2,
              crossAxisCount: 3,
              shrinkWrap: true,
              children: _selectedEvents
                  .map((event) => Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: isalreadyinBookedMap(event.toString())
                              ? Colors.red[300]
                              : (_isBooked &&
                                      bookedIdx ==
                                          _selectedEvents.indexOf(event) &&
                                      dateanddate(selectedDate, bookedDate)
                                  ? Colors.orange[300]
                                  : Colors.green[300]),
                          border: Border.all(
                              width: 0.8,
                              color: isalreadyinBookedMap(event.toString())
                                  ? Colors.red[300]
                                  : (_isBooked &&
                                          bookedIdx ==
                                              _selectedEvents.indexOf(event) &&
                                          dateanddate(selectedDate, bookedDate)
                                      ? Colors.orange[300]
                                      : Colors.green[300])),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 4.0),
                        child: Center(
                          child: ListTile(
                              title: Text(
                                event.toString(),
                                textAlign: TextAlign.center,
                              ),
                              onTap: isalreadyinBookedMap(event.toString())
                                  ? null
                                  : (() {
                                      int idx = 0;
                                      _events.forEach((key, value) {
                                        if (value.contains(event)) {
                                          idx = value.indexOf(event);
                                        }
                                      });
                                      _book(
                                          idx, selectedDate, event.toString());
                                    })),
                        ),
                      ))
                  .toList(),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context);
    // final times = getTimes(startTime, endTime, step)
    //     .map((tod) => tod.format(context))
    //     .toList();
    // print(times);

    return Scaffold(
      appBar: AppBar(title: Text('Bookings')),
      backgroundColor: Colors.yellow[50],
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTableCalendar(),
          SizedBox(height: 10),
          if (!isholiday)
            Center(
              child: Text(
                currentItem.titel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          SizedBox(height: 10),
          if (!isholiday)
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    color: lightmaincolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: lightmaincolor)),
                    onPressed: () {
                      setState(() {
                        _isBooked = false;
                        bookedDate = null;
                      });
                    },
                    child: Text('RESET')),
                SizedBox(width: 30),
                FlatButton(
                    color: maincolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: maincolor)),
                    onPressed: () {
                      isAlreadyLoaded = false;
                      getCurrentDayBookings(selectedDate).then((_) {
                        setBooking(context);
                      });
                    },
                    child: Text('BOOK',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
          SizedBox(height: 10),
          if (!isholiday)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ColorExplanation(Colors.green[300], 'Available'),
                ColorExplanation(Colors.red[300], 'Booked'),
                ColorExplanation(Colors.orange[300], 'Your wish'),
              ],
            ),
          SizedBox(height: 15),
          Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: deviceSize.size.width,
                  child: _buildEventList())),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class BookedHelper {
  String event;
  String duration;
  String userid;
  Map<String, String> details;

  BookedHelper(this.event, this.duration, this.userid);

  Map<String, String> setMap() {
    details = {'event': event, 'duration': duration, 'userId': userid};
    return details;
  }
}
