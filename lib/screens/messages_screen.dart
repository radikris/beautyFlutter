import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/temporary/category_selector.dart';
import '../widgets/temporary/favorite_contacts.dart';
import '../widgets/temporary/recent_chats.dart';

class MessagesScreen extends StatelessWidget {
  static final routeName = '/messages-screen';

  bool isLoading=false;



  csinald() {
    Firestore.instance
        .collection('users')
        .where("usertype", isEqualTo: "Customer")
        .where('ispremium', isEqualTo: true)
        .snapshots()
        .listen((data) => data.documents.forEach((doc){
          print(data);
          print(doc['email']);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.menu),
      //     iconSize: 30.0,
      //     color: Colors.white,
      //     onPressed: () {},
      //   ),
      //   title: Text(
      //     'Chats',
      //     style: TextStyle(
      //       fontSize: 28.0,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   elevation: 0.0,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       iconSize: 30.0,
      //       color: Colors.white,
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: Column(
        children: <Widget>[
          //CategorySelector(),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(),
                  RecentChats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
