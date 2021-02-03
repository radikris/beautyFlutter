import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beauty_app/main.dart';
import 'package:beauty_app/utilities/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'choosephotos.dart';
import '../openclosed.dart';
import '../businessservices.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class SEditProfile extends StatefulWidget {
  DocumentSnapshot userData;
  SEditProfile(this.userData);
  static const routeName = '/s-edit-profile';

  @override
  _SEditProfileState createState() => _SEditProfileState();
}

class _SEditProfileState extends State<SEditProfile> {
  String userName;
  String userWhyus;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _whyusEditingController = TextEditingController();
  bool isInit = true;
  bool isUpload = false;
  bool isLoading = false;
  List getnewphotos;

  void setnewphotos(List listofphotos) {
    getnewphotos = listofphotos;
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      // final DocumentSnapshot tryuserData =
      //     ModalRoute.of(context).settings.arguments as DocumentSnapshot;
      // if (tryuserData != null) {
      //   widget.userData = tryuserData;
      userName = widget.userData['userName'];
      searchAddr = widget.userData['locationread'];
      openstart = widget.userData['opening'];
      closeend = widget.userData['closing'];
      resultCategory = widget.userData['category'];
      loclat = widget.userData['loclat'];
      loclng = widget.userData['loclng'];
      serviceList = widget.userData['services'];

      if (serviceList == null) {
        serviceList = [];
      }

      Completer<GoogleMapController> _controller = Completer();

      if (loclat != null && loclng != null) _showPreview(loclat, loclng);
      if (openstart != null && closeend != null) {
        openingPicked = true;
        isopened = isOpen(openstart, closeend);
        resultOpening = '${openstart} - ${closeend}';
      }

      if (resultCategory != null) {
        categoryPicked = true;
      }
      //}
    }

    isInit = false;
    super.didChangeDependencies();
  }

  List<String> allimageurls;

  Future handleUploadImage() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print('handleimagekezdodik');
    print(getnewphotos);

    try {
      for (int i = 0; i < getnewphotos.length; i++) {
        final StorageReference storageRef = FirebaseStorage.instance
            .ref()
            .child('business_image')
            .child(firebaseUser.uid)
            .child(i.toString());
        if (getnewphotos.elementAt(i) is ImageUploadModel) {
          final StorageUploadTask task =
              storageRef.putFile(getnewphotos.elementAt(i).imageFile);
          await task.onComplete.then((picValue) async {
            await picValue.ref.getDownloadURL().then((downloadUrl) {
              print("URL : " + downloadUrl);
              allimageurls.add(downloadUrl);
            });
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _uploadImages() async {
    final user = await FirebaseAuth.instance.currentUser();
    int i = 0;
    getnewphotos.forEach((f) async {
      if (f is ImageUploadModel) {
        final _ref = FirebaseStorage.instance
            .ref()
            .child('business_image')
            .child(user.uid)
            .child(i.toString() + '.jpg');
        i++;
        final StorageUploadTask uploadTask = _ref.putFile(f.imageFile);
        StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
        // String _url = await downloadUrl.ref.getDownloadURL();
        // print(_url);
        // allimageurls.add(_url);
        await uploadTask.onComplete.then((picValue) async {
          await picValue.ref.getDownloadURL().then((downloadUrl) {
            print("URL : " + downloadUrl);
            allimageurls.add(downloadUrl);
          });
        });
      }
    });
  }

  Future<List> uploadImage(List<Object> _imageFile) async {
    final user = await FirebaseAuth.instance.currentUser();
    List _urllist = [];

    int i = 0;
    await _imageFile.forEach((image) async {
      print('igen: ' + image.toString());
      if (image is ImageUploadModel) {
        // if (ref.getMetadata() != null) {   torolni kellene
        //   await ref.delete();
        // }
        print('na csinaljuk');
        print(image.imageFile);
        final ref = FirebaseStorage.instance
            .ref()
            .child('business_image')
            .child(user.uid)
            .child(i.toString() + '.jpg');
        i++;
        StorageUploadTask uploadTask = ref.putFile(image.imageFile);
        StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
        String _url = await downloadUrl.ref.getDownloadURL();
        _urllist.add(_url);
      }
    });
    print('az i: ' + i.toString());
    print('a lista: ');
    print(_urllist);

    return _urllist;
  }

  Future uploadMultipleImages(List _imageList) async {
    List<String> _imageUrls = List();

    try {
      for (int i = 0; i < _imageList.length; i++) {
        StorageUploadTask uploadTask;
        final StorageReference storageReference =
            FirebaseStorage().ref().child("multiple2/$i");

        if (_imageList.elementAt(i) is ImageUploadModel) {
          uploadTask = storageReference.putFile(_imageList[i]);
        }
        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          // You can use this to notify yourself or your user in any kind of way.
          // For example: you could use the uploadTask.events stream in a StreamBuilder instead
          // to show your user what the current status is. In that case, you would not need to cancel any
          // subscription as StreamBuilder handles this automatically.

          // Here, every StorageTaskEvent concerning the upload is printed to the logs.
          print('EVENT ${event.type}');
        });

        // Cancel your subscription when done.
        await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageReference.getDownloadURL();
        _imageUrls.add(imageUrl); //all all the urls to the list
      }
      //upload the list of imageUrls to firebase as an array
      print(_imageUrls);
      print('felette a kalacs');
      await Firestore.instance
          .collection("business_name")
          .document('images')
          .setData({
        "arrayOfImages": _imageUrls,
      });
      return _imageUrls;
    } catch (e) {
      print(e);
    }
  }

  //uploadFile().whenComplete(() => Navigator.of(context).pop());

  Future uploadFile() async {
    int i = 1;

    CollectionReference imgRef;
    firebase_storage.Reference ref;

    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }

  double calculateAveragePrice() {
    double average = 0;
    serviceList.forEach((element) {
      average += element['price'];
    });
    return average / serviceList.length;
  }

  void updateProfile() async {
    print('updateprofile');
    List imageurllist;
    final user = await FirebaseAuth.instance.currentUser();
    // uploadImage(getnewphotos).then((List urls) {
    //   imageurllist = urls;
    //   print(urls);
    //   Firestore.instance.collection('users').document(user.uid).updateData({
    //     'email': widget.userData['email'],
    //     'username': userName != null ? userName : widget.userData['username'],
    //     'usertype': widget.userData['usertype'],
    //     'loclat': loclat != null ? loclat : widget.userData['loclat'],
    //     'loclng': loclng != null ? loclng : widget.userData['loclng'],
    //     'locationread':
    //         searchAddr != null ? searchAddr : widget.userData['locationread'],
    //     'services': serviceList,
    //     'opening': openstart != null ? openstart : widget.userData['opening'],
    //     'closing': closeend != null ? closeend : widget.userData['closing'],
    //     'userImage': imageurllist,
    //   });
    print(getnewphotos);
    handleUploadImage().then((value) {
      print('uploadfirebassekezdodik');
      Firestore.instance.collection('users').document(user.uid).updateData({
        'email': widget.userData['email'],
        'username': userName != null ? userName : widget.userData['username'],
        'whyus': userWhyus != null ? userWhyus : widget.userData['whyus'],
        'usertype': widget.userData['usertype'],
        'loclat': loclat != null ? loclat : widget.userData['loclat'],
        'loclng': loclng != null ? loclng : widget.userData['loclng'],
        'locationread':
            searchAddr != null ? searchAddr : widget.userData['locationread'],
        'services': serviceList,
        'opening': openstart != null ? openstart : widget.userData['opening'],
        'closing': closeend != null ? closeend : widget.userData['closing'],
        'userImage': allimageurls,
        'category': resultCategory != null
            ? resultCategory
            : widget.userData['category'],
        'averageprice': calculateAveragePrice(),
        'rating':
            widget.userData['rating'] == null ? 0 : widget.userData['rating'],
        'ratingnum': widget.userData['ratingnum'] == null
            ? 0
            : widget.userData['ratingnum'],
      });
      setState(() {
        isUpload = false;
      });
    });

    print('searchaddresS - openinghours');
    print(searchAddr);
    print(openstart);
    print(closeend);
    print(imageurllist);
  }

  void _showDoneDialog() {
    if ((userName == null && widget.userData['username'] == null) ||
        (searchAddr == null && widget.userData['locationread'] == null) ||
        (userWhyus == null && widget.userData['whyus'] == null) ||
        (openstart == null && widget.userData['opening'] == null) ||
        (closeend == null && widget.userData['closing'] == null) ||
        (closeend == null && widget.userData['closing'] == null) ||
        (resultCategory == null && widget.userData['category'] == null) ||
        (loclat == null && widget.userData['loclat'] == null) ||
        (loclng == null && widget.userData['loclng'] == null)) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.WARNING,
          title: 'Incomplete',
          desc: 'Your profile update was\nunsuccessful\nSomething is missing!',
          btnOkOnPress: () {
            debugPrint('OnClick');
          },
          btnOkIcon: Icons.warning,
          onDissmissCallback: () {
            debugPrint('Dialog Dissmiss from callback');
          })
        ..show();
      return;
    }
    updateProfile();
    print('mutasd a succest');
    AwesomeDialog(
        context: context,
        animType: AnimType.TOPSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'Success',
        desc: 'Your profile update was\nsuccessful',
        btnOkOnPress: () {
          debugPrint('OnClick');
        },
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

  Widget _textFieldBuilder(
      String mapKey, String labeltext, String hinttext, IconData typeicon) {
    bool isAlreadyUpdated = false;
    if (widget.userData[mapKey] != null) isAlreadyUpdated = true;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
        //enabled: mapKey=='email' ? false : true,
        initialValue: (isAlreadyUpdated ? widget.userData[mapKey] : null),
        controller: widget.userData[mapKey] == null
            ? (mapKey == 'username'
                ? _nameEditingController
                : _whyusEditingController)
            : null,
        minLines: 1,
        maxLines: 3,
        maxLength: mapKey == 'username' ? 30 : 100,
        onChanged: (value) {
          setState(() {
            if (mapKey == 'username') {
              userName = value;
            } else {
              userWhyus = value;
            }
          });
        },
        key: ValueKey(mapKey),
        decoration: InputDecoration(
          fillColor: maincolor,
          labelText: labeltext,
          border: InputBorder.none,
          hintText: hinttext,
          icon: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color(0xFFEEF8FF),
            ),
            child: Icon(
              typeicon,
              size: 25.0,
              color: Color(
                0xFF309DF1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List<String> namelist = <String>[
    'Hajvágás',
    'Szakállfestés',
    'Full package',
  ];

  var serviceList = [];

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

  void onMapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  String _previewImageUrl;
  double loclat, loclng;

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

  bool categoryPicked = false;
  String resultCategory;
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
                  if (start.isAfter(end)) {
                    DateTime swaptemp = start;
                    start = end;
                    end = swaptemp;
                  }
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

  //List<dynamic> templist;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Edit profile'),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleImageUpload(widget.userData['ispremium'] ? 5 : 3,
                widget.userData['userImage'], setnewphotos),
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.black,
            height: 4,
          ),
          _textFieldBuilder(
              'username', 'Business name', 'Business name', Icons.business),
          Divider(),
          _textFieldBuilder('whyus', 'Why you? Help others find you!',
              'Why should they choose you?', Icons.format_quote),
          Divider(),
          buildOpeningHours(),
          SizedBox(
            height: 10,
          ),
          if (openingPicked) OpenClosed(isopened, openstart, closeend),
          // Container(
          //   decoration: BoxDecoration(
          //     color: (isopened = isOpen(openstart, closeend))
          //         ? Colors.green[300]
          //         : Colors.red[300],
          //   ),
          //   child: Center(
          //     child: FlatButton.icon(
          //       label: Text(
          //         isopened ? 'OPEN' : 'CLOSED',
          //         style: TextStyle(
          //             color: Colors.white, fontWeight: FontWeight.bold),
          //       ),
          //       icon: isopened
          //           ? Icon(
          //               FontAwesomeIcons.doorOpen,
          //               color: Colors.white,
          //             )
          //           : Icon(FontAwesomeIcons.doorClosed, color: Colors.white),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              categoryPicked ? 'Service' : 'Choose service',
              style: kTitleStyle,
            ),
          ),
          SizedBox(height: 1),
          //if(!categoryPicked)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: maincolor, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButton<String>(
              underline: SizedBox.shrink(),
              style: TextStyle(fontWeight: FontWeight.bold),
              dropdownColor: lightmaincolor,
              hint: Text(categoryPicked ? resultCategory : 'Category'),
              items: <String>[
                'Hair',
                'Spa',
                'Nails',
                'Massage',
                'Sport',
                'Other'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  resultCategory = val;
                  categoryPicked = true;
                });
              },
            ),
          ),
          SizedBox(height: 5),
          SearchMapPlaceWidget(
            placeholder: 'Enter your business address',
            apiKey: 'AIzaSyD8jhK6x4Wjw1WAOt1VL9FVaSAfFnBWLZ0',
            // The language of the autocompletion
            language: 'en',
            // The position used to give better recomendations. In this case we are using the user position
            location: LatLng(10, 20),
            radius: 30000,
            onSelected: (Place place) async {
              var addresses = await Geocoder.local
                  .findAddressesFromQuery(place.description);
              var first = addresses.first;
              print("${first.featureName} : ${first.coordinates}");
              _showPreview(
                  first.coordinates.latitude, first.coordinates.longitude);
              loclat = first.coordinates.latitude;
              loclng = first.coordinates.longitude;
              searchAddr = place.description;
            },
          ),
          // RaisedButton(onPressed: () {
          //   Navigator.of(context).pushNamed(SearchMapScreen.routeName);
          // }),
          SizedBox(height: 10),
          Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: _previewImageUrl == null
                ? Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    _previewImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              'Add service to list',
              style: kTitleStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Service',
                        hintText: 'Titel',
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 3),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    controller: durationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Duration',
                      hintText: 'Minutes',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      hintText: 'HUF',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {
              addItemToList();
            },
            color: maincolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          BusinessService(
              serviceList, deleteService, widget.userData.documentID),
          // Center(
          //   child: Text(
          //     'Services',
          //     style: kTitleStyle,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //         side: BorderSide(
          //             color: Theme.of(context).primaryColor, width: 2.0),
          //         borderRadius: BorderRadius.circular(4.0)),
          //     child: (serviceList != null && serviceList.length > 0)
          //         ? ListView.builder(
          //             shrinkWrap: true,
          //             physics: NeverScrollableScrollPhysics(),
          //             padding:
          //                 const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          //             itemCount: serviceList.length,
          //             itemBuilder: (BuildContext context, int index) {
          //               return ServiceTile(
          //                   serviceList[index], index, deleteService);
          //             })
          //         : Center(
          //             child: Text('No services yet...', style: kSubtitleStyle)),
          //   ),
          // ),
          Divider(height: 10, color: maincolor),
          SizedBox(
            height: 15,
          ),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: lightmaincolor,
            child: isUpload
                ? CircularProgressIndicator()
                : Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onPressed: () {
              _showDoneDialog();
            },
          ),
          SizedBox(height: 30.0),
        ],
      ),
    ));
  }
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
