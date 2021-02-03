import 'dart:io';

import 'package:beauty_app/utilities/constans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'message_model.dart';
import 'user_model.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  static const routeName = '/chatuser-screen';

  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  static bool firstmessagejustsentnow=false;
  bool firstenter=true;

  Future<void> enteredChat() async {
    final user = await FirebaseAuth.instance.currentUser();
    var userData=await Firestore.instance.collection('users').document(user.uid).get();
    if(firstenter==true){
      firstenter=false;
    }

    var alreadycurrent = await Firestore.instance
        .collection('chats')
        .document(user.uid)
        .collection(widget.user.id)
        .getDocuments();
    
    if(alreadycurrent.documents.length==0){
      firstmessagejustsentnow=true;
    }

    if (alreadycurrent.documents.length == 1) {
      Firestore.instance
          .collection('lastseen')
          .document(user.uid)
          .collection('chatpartners')
          .document(widget.user.id)
          .setData({
        'last': Timestamp.now(),
        'username': widget.user.name,
        'userimage': widget.user.imageUrl,
        'service': widget.user.service,
      });

      Firestore.instance
          .collection('lastseen')
          .document(widget.user.id)
          .collection('chatpartners')
          .document(user.uid)
          .setData({
        'last': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
        'username': userData['username'],
        'userimage': userData['userImage'],
        'service': userData['category'] != null ? userData['category'] : 'Customer',
      });
    } else if (alreadycurrent.documents.length > 1) {
      Firestore.instance
          .collection('lastseen')
          .document(user.uid)
          .collection('chatpartners')
          .document(widget.user.id)
          .setData({
        'last': Timestamp.now(),
        'username': widget.user.name,
        'userimage': widget.user.imageUrl,
        'service': widget.user.service,
      });
    }
  }

  Future<bool> _onWillPop() async {
    enteredChat();
    Navigator.of(context).pop(true);
    //return true;
  }

  void _sendMessage({String type = 'txt'}) async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    var userData=await Firestore.instance.collection('users').document(user.uid).get();

    Firestore.instance
        .collection('chats')
        .document(widget.user.id)
        .collection(user.uid)
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userimage': userData['userImage'],
      'type': type,
      // 'userImage': widget.user.imageUrl,
    });

    Firestore.instance
        .collection('chats')
        .document(user.uid)
        .collection(widget.user.id)
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userimage': userData['userImage'],
      'type': type,
      // 'userImage': widget.user.imageUrl,
    });

    _controller.clear();
  }

  File imageFile;
  String imageUrl;
  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      sendImage();
    }
  }

  bool isLoading = true;
  Future sendImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        _enteredMessage = downloadUrl;
        _sendMessage(type: 'image');
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _buildMessage(Message message, bool isMe, Size devicesize) {
    final devSize = devicesize;
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: devicesize.width / 3,
            )
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: devicesize.width / 3),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: devicesize.width / 3 * 0.5,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time.toString(),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    //if (isMe) {
    return msg;
    //}
    // return Row(
    //   children: <Widget>[
    //     msg,
    //     IconButton(
    //       icon: message.isLiked
    //           ? Icon(Icons.favorite)
    //           : Icon(Icons.favorite_border),
    //       iconSize: 30.0,
    //       color: message.isLiked
    //           ? Theme.of(context).primaryColor
    //           : Colors.blueGrey,
    //       onPressed: () {},
    //     )
    //   ],
    // );
  }

  _buildMessageComposer() {
    print('megint ujra');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              onChanged: (value) {
                _enteredMessage = value;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
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
                        future: Future.wait([
                          FirebaseAuth.instance.currentUser(),
                          enteredChat()
                        ]),
                        //FirebaseAuth.instance.currentUser(),
                        builder: (ctx, futuresnapshot) {
                          if (futuresnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              futuresnapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                            );
                          } else {
                            return StreamBuilder(
                              stream: Firestore.instance
                                  .collection('chats')
                                  .document(futuresnapshot.data[0].uid)
                                  .collection(widget.user.id)
                                  .orderBy('createdAt', descending: true)
                                  .limit(20)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  maincolor)));
                                } else {
                                  var listMessage = snapshot.data.documents;
                                  return ListView.builder(
                                    padding: EdgeInsets.all(10.0),
                                    itemBuilder: (context, index) {
                                      final Message message = Message(
                                          sender: widget.user,
                                          time: null,
                                          text: listMessage[index]['text'],
                                          unread: false);
                                      //listMessage[index];                               snapshot.data.documents[index]['time']
                                      final bool isMe = listMessage[index]
                                              ['userId'] ==
                                          futuresnapshot.data[0].uid;

                                      return _buildMessage(
                                          message, isMe, devicesize);
                                    },
                                    // buildItem(
                                    //     index, snapshot.data.documents[index]);},
                                    itemCount: listMessage.length,
                                    reverse: true,

                                    //controller: listScrollController,
                                  );
                                }
                              },
                            );
                          }
                          ;
                        }),
                    // ListView.builder(
                    //   reverse: true,
                    //   padding: EdgeInsets.only(top: 15.0),
                    //   itemCount: messages.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     final Message message = messages[index];
                    //     final bool isMe = message.sender.id == currentUser.id;
                    //     return _buildMessage(message, isMe);
                    //   },
                    // ),
                  ),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ),
    );
  }
}
