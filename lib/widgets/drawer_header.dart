import 'package:beauty_app/providers/currentuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    return FutureBuilder(
      future: Provider.of<CurrentUser>(context, listen: false).fetchUserData(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<CurrentUser>(
              builder: (ctx, currUser, child) => Stack(children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        //currUser.userData['userImage']
                        'http://www.bbk.ac.uk/mce/wp-content/uploads/2015/03/8327142885_9b447935ff.jpg'),
                    radius: 50.0,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight - Alignment(0, .5),
                  child: Container(
                    width: deviceSize.width/2.3,
                    child: FittedBox(
                      child: Text(
                        currUser.userData['username'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    currUser.userData['usertype'],
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight + Alignment(0, .6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        currUser.userData['locationread']
                            .toString()
                            .split(',')[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
    );
  }
}
