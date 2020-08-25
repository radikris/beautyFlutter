import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/constans.dart';
import '../screens/detail_screen.dart';

class FilterResult extends StatelessWidget {
  buildListItem(DocumentSnapshot businessDetails, BuildContext ctx) {
    final deviceSize = MediaQuery.of(ctx).size;
    return GestureDetector(
        onTap: () {
          //print('nice');
          Navigator.of(ctx).pushNamed(DetailScreen.routeName, arguments: businessDetails);
          //arguments businessDetails
        },
        child: Hero(
          tag: businessDetails['email'],
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(ctx).accentColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 5.0,
                                offset: Offset(0.0, 0.75))
                          ],
                        ),
                        width: double.infinity,
                        height: deviceSize.height / 3,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RatingBarWithReview(
                                  deviceSize: deviceSize,
                                  review: '(254 Reviews)'),
                            ),
                            Container(
                                width: deviceSize.width -
                                    16 -
                                    (deviceSize.width / 2 + 16),
                                child: Text(
                                  businessDetails['locationread']
                                      .toString()
                                      .split(',')[0],
                                  style: GoogleFonts.patuaOne(fontSize: 18.0),
                                )),
                            Text(
                              businessDetails['username'],
                              style: GoogleFonts.oswald(
                                  color: maincolor, fontSize: 24.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: -15,
                  left: deviceSize.width / 2.3,
                  right: 5,
                  child: Column(
                    children: <Widget>[
                      // CircleAvatar(
                      //   radius: 90,
                      //   backgroundImage:
                      //       AssetImage('assets/images/Instellar.jpg'),
                      // ),
                      // Container(
                      //   width: 90.0,
                      //   height: 90.0,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(90.0),
                      //     child: FadeInImage(
                      //         placeholder:
                      //             AssetImage('assets/images/Instellar.jpg'),
                      //         image: NetworkImage(
                      //             "https://cdn1.thr.com/sites/default/files/imagecache/scale_crop_768_433/2018/02/gettyimages-862145286_copy_-_h_2018.jpg")),
                      //   ),
                      // ),
                      ClipOval(
                        // borderRadius: BorderRadius.circular(180.0),
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            width: 180,
                            height: 180,
                            placeholder: AssetImage("assets/gifs/loading.gif"),
                            image: NetworkImage(
                                "https://cdn1.thr.com/sites/default/files/imagecache/scale_crop_768_433/2018/02/gettyimages-862145286_copy_-_h_2018.jpg")),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Card(
                          color: Colors.white,
                          child: FittedBox(
                            child: FlatButton.icon(
                              label: Text(
                                  '${businessDetails['opening']} - ${businessDetails['closing']}',
                                  style: GoogleFonts.patuaOne()),
                              icon: Icon(Icons.access_time),
                              onPressed: null,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
              overflow: Overflow.visible,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .orderBy('category')
            //.orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, businessSnapshot) {
          if (businessSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: maincolor,
              ),
            );
          }
          final businessDocs = businessSnapshot.data.documents;
          return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: businessDocs.length,
              itemBuilder: (ctx, index) => buildListItem(
                  businessDocs[index],
                  // 'assets/images/Instellar.jpg',
                  // '(254 reviews)',
                  // businessDocs[index]['username'],
                  // businessDocs[index]['locationread'].toString().split(',')[0],
                  context));
          // ListView.builder(
          //           reverse: true,
          //           itemCount: chatDocs.length,
          //           itemBuilder: (ctx, index) => MessageBubble(
          //             chatDocs[index]['text'],
          //             chatDocs[index]['username'],
          //             chatDocs[index]['userImage'],
          //             chatDocs[index]['userId'] == futureSnapshot.data.uid,
          //             key: ValueKey(chatDocs[index].documentID),
          //           ),
          //         );
        });
  }
}

class RatingBarWithReview extends StatelessWidget {
  const RatingBarWithReview({Key key, @required this.deviceSize, this.review})
      : super(key: key);

  final String review;
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceSize.width - 16 - (deviceSize.width / 2 + 16 + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FittedBox(
              child: RatingBarIndicator(
            rating: 2.75,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          )),
          Text(
            review,
            style: GoogleFonts.patuaOne(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
