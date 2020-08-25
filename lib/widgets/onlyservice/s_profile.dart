import 'dart:async';

import 'package:beauty_app/utilities/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import '../../utilities/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../screens/search_map_screen.dart';
import 'package:geocoder/geocoder.dart';
import 'servicetile.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:intl/intl.dart';
import 'removeablephoto.dart';
import 'package:google_fonts/google_fonts.dart';
import 's_editprofile.dart';

class SProfile extends StatefulWidget {
  DocumentSnapshot userData;
  SProfile(this.userData);

  @override
  _SProfileState createState() => _SProfileState();
}

class _SProfileState extends State<SProfile> {
  final List<String> namelist = <String>[
    'Hajvágás',
    'Szakállfestés',
    'Full package',
  ];

  var serviceList = [
    {'title': 'Men\s Hair Cut', 'duration': 45, 'price': 3000},
    {'title': 'Women\s Hair Cut', 'duration': 60, 'price': 5000},
    {'title': 'Color & Blow Dry', 'duration': 90, 'price': 7500},
    {'title': 'Oil Treatment', 'duration': 30, 'price': 2000},
  ];

  void deleteService(int index) {
    setState(() {
      serviceList.removeAt(index);
    });
  }

  final List<int> durationlist = <int>[30, 15, 45];
  final List<int> pricelist = <int>[2500, 1500, 3800];

  CarouselSlider carouselSlider;
  GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  String searchAddr;

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  result[0].position.latitude, result[0].position.longitude),
              zoom: 10.0)));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    print('showprievew meghivva');
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      lat,
      lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  int _current = 0;
  List imgList = [
    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];

  void removeImgFromList(int idx) {
    setState(() {
      imgList.removeAt(idx);
    });
  }

  String loadImgFromList(int idx) {
    return imgList.elementAt(idx);
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  void addItemToList() {
    setState(() {
      namelist.insert(0, nameController.text);
      durationlist.insert(0, int.parse(durationController.text));
      pricelist.insert(0, int.parse(priceController.text));
      serviceList.add({
        'title': nameController.text,
        'duration': durationController.text,
        'price': priceController.text
      });
    });
    nameController.text = '';
    durationController.text = '';
    priceController.text = '';
  }

  String openstart;
  String closeend;

  bool isopened;
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

  DateTime _dateTime = DateTime.now();
  String resultOpening;
  bool openingPicked = false;
  Widget buildOpeningHours() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FlatButton(
          child: Text(
              openingPicked ? "Opening hours" : "Choose your opening hours",
              style: kTitleStyle),
          onPressed: () {
            DateTimeRangePicker(
                startText: "From",
                endText: "To",
                doneText: "Yes",
                cancelText: "Cancel",
                interval: 30,
                initialStartTime: DateTime.now(),
                mode: DateTimeRangePickerMode.time,
                use24hFormat: true,
                onConfirm: (start, end) {
                  print(start);
                  print(end);
                  setState(() {
                    openstart = DateFormat('kk:mm').format(start);
                    closeend = DateFormat('kk:mm').format(end);
                    openingPicked = true;
                    resultOpening = '${openstart} - ${closeend}';
                  });
                }).showPicker(context);
          },
        ),
        if (openingPicked)
          Center(
              child: Text(
            resultOpening,
            style:
                TextStyle(fontSize: 17, color: Theme.of(context).primaryColor),
          )),
      ]),
    );
  }

  openScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(SEditProfile.routeName, arguments: widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              width: 55,
              height: 55,
              decoration: nMbox,
              child: RaisedButton(
                onPressed: openScreen(context),
                color: fCL,
              ),
            )));
    // child: Column(
    //   children: <Widget>[
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Wrap(
    //         alignment: WrapAlignment.center,
    //         spacing: 5.0,
    //         runSpacing: 5.0,
    //         children: imgList.length > 0
    //             ? List<Widget>.generate(imgList.length, (int index) {
    //                 return RemoveablePhoto(
    //                   index,
    //                   removeImgFromList,
    //                   loadImgFromList,
    //                 );
    //               })
    //             : Center(
    //                 child: Text(
    //                 'No Photos yet',
    //                 textAlign: TextAlign.center,
    //               )),
    //       ),
    //     ),
    //     SizedBox(height: 10),
    //     Center(
    //       child: _textFieldBuilder('username', 'Full name', 'Full name', Icons.person),
    //     ),
    //     Divider(),
    //     buildOpeningHours(),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     if (openingPicked)
    //       Container(
    //         decoration: BoxDecoration(
    //           color: (isopened = isOpen(openstart, closeend))
    //               ? Colors.green[300]
    //               : Colors.red[300],
    //         ),
    //         child: Center(
    //           child: FlatButton.icon(
    //             label: Text(
    //               isopened ? 'OPEN' : 'CLOSE',
    //               style: TextStyle(
    //                   color: Colors.white, fontWeight: FontWeight.bold),
    //             ),
    //             icon: isopened
    //                 ? Icon(
    //                     FontAwesomeIcons.doorOpen,
    //                     color: Colors.white,
    //                   )
    //                 : Icon(FontAwesomeIcons.doorClosed, color: Colors.white),
    //           ),
    //         ),
    //       ),
    //     SizedBox(height: 10),
    //     SearchMapPlaceWidget(
    //       apiKey: 'AIzaSyD8jhK6x4Wjw1WAOt1VL9FVaSAfFnBWLZ0',
    //       // The language of the autocompletion
    //       language: 'en',
    //       // The position used to give better recomendations. In this case we are using the user position
    //       location: LatLng(10, 20),
    //       radius: 30000,
    //       onSelected: (Place place) async {
    //         var addresses = await Geocoder.local
    //             .findAddressesFromQuery(place.description);
    //         var first = addresses.first;
    //         print("${first.featureName} : ${first.coordinates}");
    //         _showPreview(
    //             first.coordinates.latitude, first.coordinates.longitude);
    //       },
    //     ),
    //     // RaisedButton(onPressed: () {
    //     //   Navigator.of(context).pushNamed(SearchMapScreen.routeName);
    //     // }),
    //     SizedBox(height: 10),
    //     Container(
    //       height: 170,
    //       width: double.infinity,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         border: Border.all(width: 1, color: Colors.grey),
    //       ),
    //       child: _previewImageUrl == null
    //           ? Text(
    //               'No Location Chosen',
    //               textAlign: TextAlign.center,
    //             )
    //           : Image.network(
    //               _previewImageUrl,
    //               fit: BoxFit.cover,
    //               width: double.infinity,
    //             ),
    //     ),
    //     SizedBox(
    //       height: 20.0,
    //     ),
    //     Center(
    //       child: Text(
    //         'Add service to list',
    //         style: kTitleStyle,
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.only(left: 10, right: 10, top: 10),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           Flexible(
    //             child: TextFormField(
    //                 controller: nameController,
    //                 decoration: InputDecoration(
    //                   border: OutlineInputBorder(),
    //                   labelText: 'Service',
    //                   hintText: 'Titel',
    //                 ),
    //                 keyboardType: TextInputType.multiline,
    //                 minLines: 1,
    //                 maxLines: 3),
    //           ),
    //           SizedBox(
    //             width: 10,
    //           ),
    //           Flexible(
    //             child: TextFormField(
    //               controller: durationController,
    //               decoration: InputDecoration(
    //                 border: OutlineInputBorder(),
    //                 labelText: 'Duration',
    //                 hintText: 'Minutes',
    //               ),
    //               keyboardType: TextInputType.number,
    //             ),
    //           ),
    //           SizedBox(
    //             width: 10,
    //           ),
    //           Flexible(
    //             child: TextFormField(
    //               controller: priceController,
    //               decoration: InputDecoration(
    //                 border: OutlineInputBorder(),
    //                 labelText: 'Price',
    //                 hintText: 'HUF',
    //               ),
    //               keyboardType: TextInputType.number,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     MaterialButton(
    //       onPressed: () {
    //         addItemToList();
    //       },
    //       color: maincolor,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //       child: Text(
    //         'Add',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 15,
    //     ),
    //     Center(
    //       child: Text(
    //         'Services',
    //         style: kTitleStyle,
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Card(
    //         shape: RoundedRectangleBorder(
    //             side: BorderSide(
    //                 color: Theme.of(context).primaryColor, width: 2.0),
    //             borderRadius: BorderRadius.circular(4.0)),
    //         child: ListView.builder(
    //             shrinkWrap: true,
    //             physics: NeverScrollableScrollPhysics(),
    //             padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
    //             itemCount: serviceList.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               return ServiceTile(
    //                   serviceList[index], index, deleteService);
    //             }),
    //       ),
    //     ),
    //     Divider(height: 10, color: maincolor),
    //     SizedBox(
    //       height: 35,
    //     ),
    //   ],
    // ),
  }
}

//IMAGE CAROUSEL
// Padding(
//             padding: EdgeInsets.all(15),
//             child: Stack(children: <Widget>[
//               CarouselSlider(
//                 height: 300.0,
//                 initialPage: 0,
//                 enlargeCenterPage: true,
//                 autoPlay: true,
//                 reverse: false,
//                 enableInfiniteScroll: true,
//                 autoPlayInterval: Duration(seconds: 4),
//                 autoPlayAnimationDuration: Duration(milliseconds: 3000),
//                 pauseAutoPlayOnTouch: Duration(seconds: 7),
//                 scrollDirection: Axis.horizontal,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _current = index;
//                   });
//                 },
//                 items: imgList.map((imgUrl) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                         ),
//                         child: Image.network(
//                           imgUrl,
//                           fit: BoxFit.fill,
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//               Center(
//                   child: Container(
//                 margin: EdgeInsets.only(top: 3),
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Color(0xE6FFFFFF),
//                 ),
//                 child: Text(
//                   'Username',
//                   style: kTitleStyle,
//                 ),
//               )),
//             ]),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: map<Widget>(imgList, (index, url) {
//               return Container(
//                 width: 10.0,
//                 height: 10.0,
//                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _current == index
//                       ? Colors.black87
//                       : Theme.of(context).primaryColor,
//                 ),
//               );
//             }),
//           ),

//NICE GOOGLEFONT NAME
// Center(
//             child: Text(
//               'Service name',
//               style: GoogleFonts.bigShouldersText(
//                                       color: maincolor, fontSize: 22.0),
//             ),
//           ),
