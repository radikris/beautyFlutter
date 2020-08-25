import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_map_place/search_map_place.dart';

class SearchMapScreen extends StatefulWidget {
  static const routeName = '/search-map';

  @override
  _SearchMapScreenState createState() => _SearchMapScreenState();
}

class _SearchMapScreenState extends State<SearchMapScreen> {
  GoogleMapController mapController;

  String searchAddr;
  double markerlat, markerlng;

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 17.0)));

      setState(() {
        markerlat = result[0].position.latitude;
        markerlng = result[0].position.longitude;
      });
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      LatLng helper = ModalRoute.of(context).settings.arguments as LatLng;
      markerlat = helper.latitude;
      markerlng = helper.longitude;
      isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Where is it actually?'),
          centerTitle: true,
          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(Icons.cancel),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       }),
          // ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: {
                Marker(
                    markerId: MarkerId('m1'),
                    infoWindow:
                        InfoWindow(title: 'Ez mi?', snippet: 'Ez amerika'),
                    onTap: () {
                      print('clicked on the marker');
                    },
                    position: LatLng(markerlat, markerlng))
              },
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(markerlat, markerlng),
                zoom: 17.0,
              ),
            ),
            // Positioned(
            //   top: 30.0,
            //   right: 15.0,
            //   left: 15.0,
            //   child: Container(
            //     height: 50.0,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10.0), color: Colors.white),
            //     child: TextField(
            //       decoration: InputDecoration(
            //           hintText: 'Enter Address',
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            //           suffixIcon: IconButton(
            //               icon: Icon(Icons.search),
            //               onPressed: searchandNavigate,
            //               iconSize: 30.0)),
            //       onChanged: (val) {
            //         setState(() {
            //           searchAddr = val;
            //         });
            //       },
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
