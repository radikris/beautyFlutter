import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utilities/constans.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../onlycustomer/c_editprofile.dart';

class CProfile extends StatefulWidget {
  DocumentSnapshot userData;
  CProfile(this.userData);

  @override
  _CProfileState createState() => _CProfileState();
}

class _CProfileState extends State<CProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mC,
      //ratings, ratingsbar, ertek, szimpla cardban!
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  //if() check if currentuser vagy nem
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      NMButton(FontAwesomeIcons.userEdit, widget.userData),
                    ],
                  ),
                  AvatarImage(widget.userData['userImage']),
                  SizedBox(height: 15),
                  Text(
                    widget.userData['username'] == null
                        ? 'Username'
                        : widget.userData['username'],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    widget.userData['locationread'] == null
                        ? 'Location'
                        : widget.userData['locationread']
                            .toString()
                            .split(',')[0],
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 35),
                  Center(
                      child: Text(
                    'Reviews',
                    style: kTitleStyle,
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      SocialBox(
                          icon: FontAwesomeIcons.star,
                          count: '4.7',
                          category: 'stars'),
                      SizedBox(width: 15),
                      SocialBox(
                          icon: FontAwesomeIcons.userAlt,
                          count: '1.2k',
                          category: 'ratings'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                      child: Text(
                    'Favorites',
                    style: kTitleStyle,
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 50,),
                      SocialBox(
                        icon: Icons.favorite,
                        count: '5.1k',
                        category: 'favorites'),
                      SizedBox(width: 50),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(child: Center(child:Text('favoirtek'))),
                  SizedBox(height: 35),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SocialBox extends StatelessWidget {
  final IconData icon;
  final String count;
  final String category;

  const SocialBox({this.icon, this.count, this.category});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: nMboxInvert,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.pink.shade800, size: 20),
            SizedBox(width: 8),
            Text(
              count,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 3),
            // Flexible(
            //               child: TextField(
            //     decoration: InputDecoration(
            //         border: InputBorder.none, hintText: category),
            //   ),
            // ),
            Text(
              category,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class NMButton extends StatelessWidget {
  final IconData icon;
  final DocumentSnapshot userData;
  const NMButton(this.icon, this.userData);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: nMbox,
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(CEditProfile.routeName, arguments: userData);
        },
        color: fCL,
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {
  String imageurl;
  AvatarImage(this.imageurl);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: nMbox,
      child: Container(
        decoration: nMbox,
        padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageurl == null
                  ? AssetImage('assets/images/blank_profile.png')
                  : NetworkImage(imageurl),
            ),
          ),
        ),
      ),
    );
  }
}
