import 'package:intl/intl.dart';

import '../../utilities/constans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_model.dart';
import 'chat_screen.dart';
import 'user_model.dart';
import '../shimmereffect.dart';

class RecentChats extends StatelessWidget {
  String datefromtimestamp(Timestamp t) {
    DateTime d = t.toDate();
    return DateFormat('EEEE').format(d).toString().substring(0, 3);
  }

  bool isfirstafterlast(Timestamp first, Timestamp last) {
    DateTime f = first.toDate();
    DateTime l = last.toDate();

    return f.isAfter(l);
  }

  Map<int, Timestamp> lastmessage = {};

  Future<void> getlastMessage(
      String currentuserid, String chatpartnerid, int idx) async {
    var lastsnap = await Firestore.instance
        .collection('chats')
        .document(currentuserid)
        .collection(chatpartnerid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .getDocuments();

    lastsnap.documents.forEach((element) {
      lastmessage[idx] = element['createdAt'];
    });
  }

  @override
  Widget build(BuildContext context) {
// Container(
//   child: StreamBuilder(
//     stream: Firestore.instance.collection('users').snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return Center(
//           child: CircularProgressIndicator(
// 			valueColor: AlwaysStoppedAnimation<Color>(themeColor),
//           ),
//         );
//       } else {
//         return ListView.builder(
//           padding: EdgeInsets.all(10.0),
//           itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
//           itemCount: snapshot.data.documents.length,
//         );
//       }
//     },
//   ),
// ),

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (ctx, futuresnapshot) {
                if (futuresnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return StreamBuilder(
                    stream: Firestore.instance
                        .collection('lastseen')
                        .document(futuresnapshot.data.uid)
                        .collection('chatpartners')
                        .orderBy('last', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(maincolor)));
                      } else {
                        var listMessage = snapshot.data.documents;
                        print(listMessage);
                        return ListView.builder(
                          itemCount: listMessage.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Message chat = chats[index];
                            //print(listMessage[index]);
                            print(listMessage[index].documentID);
                            return FutureBuilder(
                              future: getlastMessage(futuresnapshot.data.uid,
                                  listMessage[index].documentID, index),
                              builder: (ctx, ftrsnapshot) => 
                              ftrsnapshot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? ShimmerEffect()
                                  : 
                                  GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            user: User(
                                                id: listMessage[index]
                                                    .documentID,
                                                name: listMessage[index]
                                                    ['username'],
                                                imageUrl: 'mind1',
                                                service: listMessage[index]
                                                    ['service']),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0, right: 20.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.1),
                                          color: isfirstafterlast(
                                            lastmessage[index],
                                            listMessage[index]['last'],
                                          )
                                              ? Color(0xFFFFEFEE)
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 35.0,
                                                  backgroundImage: AssetImage(
                                                      chat.sender.imageUrl),
                                                ),
                                                SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      listMessage[index]
                                                          ['username'],
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.0),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Text(
                                                        listMessage[index]
                                                            ['service'],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  datefromtimestamp(
                                                      lastmessage[index]),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5.0),
                                                isfirstafterlast(
                                                        lastmessage[index],
                                                        listMessage[index]
                                                            ['last'])
                                                    ? Container(
                                                        width: 40.0,
                                                        height: 20.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'NEW',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    : Text(''),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            );
                          },
                        );

                        // ListView.builder(
                        //   padding: EdgeInsets.all(10.0),
                        //   itemBuilder: (context, index) {
                        //     final Message message = Message(
                        //         sender: widget.user,
                        //         time: null,
                        //         text: listMessage[index]['text'],
                        //         unread: false);
                        //     //listMessage[index];                               snapshot.data.documents[index]['time']
                        //     final bool isMe = listMessage[index]
                        //             ['userId'] ==
                        //         futuresnapshot.data.uid;

                        //     return _buildMessage(
                        //         message, isMe, devicesize);
                        //   },
                        //   // buildItem(
                        //   //     index, snapshot.data.documents[index]);},
                        //   itemCount: listMessage.length,
                        //   reverse: true,

                        //   //controller: listScrollController,
                        // );
                      }
                    },
                  );
                }
                ;
              }),

          // ListView.builder(
          //   itemCount: chats.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final Message chat = chats[index];
          //     return GestureDetector(
          //       onTap: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => ChatScreen(
          //             user: chat.sender,
          //           ),
          //         ),
          //       ),
          //       child: Container(
          //         margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
          //         padding:
          //             EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //         decoration: BoxDecoration(
          //           color: chat.unread ? Color(0xFFFFEFEE) : Colors.white,
          //           borderRadius: BorderRadius.only(
          //             topRight: Radius.circular(20.0),
          //             bottomRight: Radius.circular(20.0),
          //           ),
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Row(
          //               children: <Widget>[
          //                 CircleAvatar(
          //                   radius: 35.0,
          //                   backgroundImage: AssetImage(chat.sender.imageUrl),
          //                 ),
          //                 SizedBox(width: 10.0),
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: <Widget>[
          //                     Text(
          //                       chat.sender.name,
          //                       style: TextStyle(
          //                         color: Colors.grey,
          //                         fontSize: 15.0,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //                     SizedBox(height: 5.0),
          //                     Container(
          //                       width: MediaQuery.of(context).size.width * 0.45,
          //                       child: Text(
          //                         chat.text,
          //                         style: TextStyle(
          //                           color: Colors.blueGrey,
          //                           fontSize: 15.0,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //             Column(
          //               children: <Widget>[
          //                 Text(
          //                   chat.time.toString(),
          //                   style: TextStyle(
          //                     color: Colors.grey,
          //                     fontSize: 15.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 SizedBox(height: 5.0),
          //                 chat.unread
          //                     ? Container(
          //                         width: 40.0,
          //                         height: 20.0,
          //                         decoration: BoxDecoration(
          //                           color: Theme.of(context).primaryColor,
          //                           borderRadius: BorderRadius.circular(30.0),
          //                         ),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'NEW',
          //                           style: TextStyle(
          //                             color: Colors.white,
          //                             fontSize: 12.0,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                       )
          //                     : Text(''),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
