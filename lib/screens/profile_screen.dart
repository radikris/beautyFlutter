import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currentuser.dart';
import '../widgets/onlycustomer/c_profile.dart';
import '../widgets/onlyservice/s_profile.dart';
import '../widgets/onlyservice/s_editprofile.dart';

class ProfileScreen extends StatefulWidget {
  static final routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future:
              Provider.of<CurrentUser>(context, listen: false).fetchUserData(),
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset('assets/gifs/loading.gif'),
              );
            } else {
              if (datasnapshot.error != null) {
                //some rror
                return Center(child: Text('Unfortunetaly error occured!'));
              } else {
                return Consumer<CurrentUser>(
                  builder: (ctx, currUser, child) =>
                      currUser.userData['usertype'] == 'Customer'
                          ? CProfile(currUser.userData)
                          : SEditProfile(currUser.userData),
                );
              }
            }
          }),
    );
  }
}
