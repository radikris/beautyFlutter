import 'package:beauty_app/utilities/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'user_image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import '../../utilities/location_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CEditProfile extends StatefulWidget {
  DocumentSnapshot userData;
  //CEditProfile(this.userData);

  static const routeName = '/c-edit-profile';

  @override
  _CEditProfileState createState() => _CEditProfileState();
}

class _CEditProfileState extends State<CEditProfile> {
  // 0 = Hotels, 1 = Flights
  int _searchType = 0;
  final _formKey = GlobalKey<FormState>();
  bool isInit = true;
  bool isUpload = false;
  bool isLoading = false;
  File _userImageFile;
  double loclat, loclng;
  String locationRead;
  String userName;
  String currentImage;
  TextEditingController _locationEditingController = TextEditingController();
  TextEditingController _dataEditingController = TextEditingController();

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void updateProfile() async {
    // if ((userName == null && widget.userData['username'] != null) || (locationRead == null && widget.userData['locationread']!=null) || _userImageFile==null) && ((widget.userData['username'] != null) || (widget.userData['locationread']!=null) || widget.userData['userImage']!=null)){
    //   return;
    // }
    if (userName != null || locationRead != null || _userImageFile != null) {
      print('updateprofile');
      final user = await FirebaseAuth.instance.currentUser();
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(user.uid + '.jpg');
      // if (ref.getMetadata() != null) {   torolni kellene
      //   await ref.delete();
      // }
      var imageurl = '';
      if (_userImageFile != null) {
        await ref.putFile(_userImageFile).onComplete;
        imageurl = await ref.getDownloadURL();
      }

      Firestore.instance.collection('users').document(user.uid).updateData({
        'email': widget.userData['email'],
        'username': userName != null ? userName : widget.userData['username'],
        'usertype': widget.userData['usertype'],
        'loclat': loclat != null ? loclat : widget.userData['loclat'],
        'loclng': loclng != null ? loclng : widget.userData['loclng'],
        'locationread': locationRead != null
            ? locationRead
            : widget.userData['locationread'],
        'userImage': widget.userData['userImage'] != null
            ? widget.userData['userImage']
            : (imageurl == '' ? null : imageurl),
      });

      setState(() {
        isUpload = false;
      });
    }
  }

  void _showDoneDialog() {
    if ((userName == null && widget.userData['username'] == null) ||
        (locationRead == null && widget.userData['locationread'] == null)) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.WARNING,
          title: 'Incomplete',
          desc: 'Your profile update was\nunsuccessful',
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

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    setState(() async {
      locationRead = await LocationHelper.getPlaceAddress(
          locData.latitude, locData.longitude);
      setState(() {
        isLoading = false;
      });

      loclat = locData.latitude;
      loclng = locData.longitude;
      _locationEditingController.text = locationRead;
    });
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final DocumentSnapshot tryuserData =
          ModalRoute.of(context).settings.arguments as DocumentSnapshot;
      if (tryuserData != null) {
        widget.userData = tryuserData;
      }
    }

    isInit = false;
    super.didChangeDependencies();
  }

  Widget _textFieldBuilder(
      String mapKey, String labeltext, String hinttext, IconData typeicon,
      {bool isenabled = true}) {
    bool isAlreadyUpdated = false;
    if (widget.userData[mapKey] != null) isAlreadyUpdated = true;
    return TextFormField(
      //enabled: mapKey=='email' ? false : true,
      enableInteractiveSelection: isenabled,
      onTap: () {
        if (isenabled == false)
          FocusScope.of(context).requestFocus(new FocusNode());
      },
      initialValue: (isAlreadyUpdated ? widget.userData[mapKey] : null),
      controller: !isenabled && widget.userData[mapKey] == null
          ? _locationEditingController
          : null,
      maxLines: !isenabled ? 3 : 1,
      onChanged: (value) {
        setState(() {
          if (mapKey == 'username') {
            userName = value;
          }
        });
      },
      key: ValueKey(mapKey),
      decoration: InputDecoration(
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
        suffixIcon: !isenabled
            ? (!isLoading
                ? IconButton(
                    icon: Icon(FontAwesomeIcons.searchLocation),
                    onPressed: () {
                      _getCurrentUserLocation();
                      setState(() {
                        isLoading = false;
                      });
                    })
                : CircularProgressIndicator())
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        children: <Widget>[
          SizedBox(height: 30.0),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      'Keep your profile uptoday!',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  UserImagePicker(_pickedImage, widget.userData['userImage']),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.0),
          _textFieldBuilder('username', 'Full name', 'Full name', Icons.person),
          Divider(
            height: 25,
          ),
          _textFieldBuilder('email', 'Email address', 'Email', Icons.email),
          Divider(height: 25.0),
          _textFieldBuilder('locationread', 'Current Location',
              'Set currentlocation', Icons.location_on,
              isenabled: false),
          Divider(
            height: 25,
          ),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Color(0xFF309DF1),
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
              updateProfile();
              _showDoneDialog();
            },
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
