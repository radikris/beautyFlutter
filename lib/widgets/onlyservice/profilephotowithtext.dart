import 'package:beauty_app/utilities/constans.dart';
import 'package:flutter/material.dart';

class ProfilePhotoWithText extends StatelessWidget {

  String maintitel, subtitel, imagetitel;
  ProfilePhotoWithText(this.maintitel, this.subtitel, this.imagetitel);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,
            backgroundImage: NetworkImage(imagetitel),
          ),
          Text(
            maintitel,
            style: TextStyle(
              //fontFamily: 'Pacifico',
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
          Text(
            subtitel,
            style: TextStyle(
              //fontFamily: 'SourceSansPro',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Divider()
        ]);
  }
}
