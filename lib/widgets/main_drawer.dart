import 'package:flutter/material.dart';
import '../utilities/constans.dart';
import '../widgets/drawer_header.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
        leading: Icon(icon, size: 24),
        title: Text(title,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        onTap: tapHandler);
  }

  @override
  Widget build(BuildContext context) {
    var children2 = <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          gradient: kMoreGradientStyle,
        ),
        child: CustomDrawerHeader(),
      ),
      SizedBox(height: 20),
      Switch.adaptive(value: false, onChanged: null),
      SizedBox(height: 5),
      //My Profile, Privacy and Terms, About us, Contact us,Log out
      buildListTile('My profile', Icons.account_box, () {
        Navigator.of(context).pushNamed('/profile-screen');
      }),
      ListDivider(),
      buildListTile('Settings', Icons.settings, () {
        //Navigator.of(context).pushReplacementNamed('/filters');
      }),
      ListDivider(),
      buildListTile('About us', Icons.info, () {
        //Navigator.of(context).pushReplacementNamed('/filters');
      }),
      ListDivider(),
      buildListTile('Contact us', Icons.mail, () {
        Navigator.of(context).pushReplacementNamed('/rating-screen');
      }),
      ListDivider(),
      buildListTile('Privacy and terms', Icons.business_center, () {
        //Navigator.of(context).pushReplacementNamed('/filters');
      }),
      Expanded(child: Container()),
      buildListTile('Log out', Icons.exit_to_app, () {
        FirebaseAuth.instance.signOut();
      }),
      SizedBox(
        height: 5,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: FadeInImage(
                  placeholder: AssetImage("assets/images/icontry.png"),
                  image: AssetImage("assets/images/icontry.png"),
                  fit: BoxFit.cover),
            ),
            SizedBox(width: 2),
            Text(
              "Beauty booking app",
              style: TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            )
          ],
        ),
      ),
    ];
    return Drawer(
        child: Column(
      children: children2,
    ));
  }
}

class ListDivider extends StatelessWidget {
  const ListDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 10,
      thickness: 2,
      color: lightmaincolor,
      indent: 15,
      endIndent: 15,
    );
  }
}
