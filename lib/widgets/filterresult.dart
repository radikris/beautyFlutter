import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/constans.dart';
import '../screens/detail_screen.dart';
import 'dart:math' as Math;

class FilterResult extends StatefulWidget {
  @override
  _FilterResultState createState() => _FilterResultState();
}

class _FilterResultState extends State<FilterResult> {
  bool isinit = true;
  SearchParameters parameters;

  Future<void> deleteIfMoreThan5(
      QuerySnapshot alreadysearch, FirebaseUser user) async {
    if (alreadysearch.documents.length > 4) {
      String deletename = alreadysearch
          .documents[alreadysearch.documents.length - 1].documentID;

      await Firestore.instance
          .collection('presearch')
          .document(user.uid)
          .collection('lastfive')
          .document(deletename)
          .delete();
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isinit) {
      parameters =
          ModalRoute.of(context).settings.arguments as SearchParameters;

      final user = await FirebaseAuth.instance.currentUser();
      var userData =
          await Firestore.instance.collection('users').document(user.uid).get();

      var alreadysearch = await Firestore.instance
          .collection('presearch')
          .document(user.uid)
          .collection('lastfive')
          .orderBy('time', descending: true)
          .getDocuments();
      //date szerint, last limit(1) es azt deletelni kell
      // String deletename;
      // if (alreadysearch != null) {
      //   deletename = alreadysearch.documents[0].documentID;
      // }
      //print('deletename');

      // if (alreadysearch.documents.length > 4) {
      //   String deletename = alreadysearch
      //       .documents[alreadysearch.documents.length - 1].documentID;

      //   await Firestore.instance
      //       .collection('presearch')
      //       .document(user.uid)
      //       .collection('lastfive')
      //       .document(deletename)
      //       .delete();
      // }
      deleteIfMoreThan5(alreadysearch, user).then((value) async {
        if (alreadysearch.documents.length < 6) {
          await Firestore.instance
              .collection('presearch')
              .document(user.uid)
              .collection('lastfive')
              .document((DateTime.now().millisecondsSinceEpoch).toString())
              .setData({
            'direct': parameters.directsearch == null
                ? parameters.categories[0]
                : parameters.directsearch,
            'categories': parameters.categories,
            'time': DateTime.now().millisecondsSinceEpoch
          });
        }
      });

      // print(parameters.categories);
      // print(parameters.distance);
      // print(parameters.sortby);
      // print(parameters.rating);
      // step = Duration(minutes: currentItem.duration);
    }
    isinit = false;
  }

  buildListItem(DocumentSnapshot businessDetails, BuildContext ctx) {
    final deviceSize = MediaQuery.of(ctx).size;
    return GestureDetector(
        onTap: () {
          //print('nice');
          Navigator.of(ctx)
              .pushNamed(DetailScreen.routeName, arguments: businessDetails);
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
                                  review:
                                      '(${businessDetails['ratingnum']} Reviews)',
                                  rating: businessDetails['rating'].toDouble()),
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
                                  color: businessDetails['ispremium']
                                      ? Colors.amber[600]
                                      : maincolor,
                                  fontSize: 24.0),
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

  double distanceinkm(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = Math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var result = 12742 * Math.asin(Math.sqrt(a));
    //print(result.toString() + " in km a tavolsag");
    return result; // 2 * R; R = 6371 km
  }

  List<DocumentSnapshot> premiumFirst(List<DocumentSnapshot> list) {
    List<DocumentSnapshot> reversed = list.reversed.toList();
    int listlength = list.length;
    for (int i = 0; i < reversed.length; i++) {
      if (reversed.elementAt(i)['ispremium']) {
        int placeofelement = list.indexOf(reversed.elementAt(i));
        list.removeAt(
            placeofelement); //the length of the list added +1, but so the index is valid, there is element at the original length
        list.insert(0, reversed.elementAt(i));
      }
    }
    return list;
  }

  int sortby(DocumentSnapshot a, DocumentSnapshot b, String sortby) {
    if (a[sortby] < b[sortby]) {
      return 1;
    } else if (a[sortby] > b[sortby]) {
      return -1;
    } else {
      return 0;
    }
  }

  int sortbydistance(DocumentSnapshot a, DocumentSnapshot b) {
    double a_distance = distanceinkm(
        a['loclat'], a['loclng'], parameters.loclat, parameters.loclng);
    double b_distance = distanceinkm(
        b['loclat'], b['loclng'], parameters.loclat, parameters.loclng);

    if (a_distance < b_distance) {
      return 1;
    } else if (a_distance > b_distance) {
      return -1;
    } else {
      return 0;
    }
  }

  bool noresult = false;
  bool notemptyBuilder = false;

  bool containsany(String searchwhere, String searchwhat) {
    //print('containsany meghivva');
    bool result = false;
    List<String> listsearchwhat = searchwhat.split(' ');
    listsearchwhat.forEach((element) {
      if (searchwhere.contains(element)) {
        print('benne van teso');
        //notemptyBuilder=true;
        result = true;
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (parameters.categories.isEmpty) {
      noresult = true;
      parameters.categories.addAll(<String>[
        'Hairdresser',
        'Wellness',
        'Nails',
        'Massage',
        'Sport',
        'Other',
        'Hair',
        'Spa',
      ]);
    }
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            //.where('rating', isGreaterThanOrEqualTo: parameters.rating)
            //.orderBy('rating', descending: true)
            .orderBy('ispremium', descending: true)
            //.where('category', arrayContainsAny: parameters.categories)
            .where('category', whereIn: parameters.categories)
            //isLessThanOrEqualTo: parameters.distance)
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
          var businessDocs = businessSnapshot.data.documents;
          businessDocs.sort((DocumentSnapshot a, DocumentSnapshot b) {
            //a['rating'].compareTo(b['rating']);
            // if (a['rating'] < b['rating']) {
            //   return 1;
            // } else if (a['rating'] > b['rating']) {
            //   return -1;
            // } else {
            //   return 0;
            // }
            if (parameters.sortby.contains('Rating')) {
              return sortby(a, b, 'rating');
            } else if (parameters.sortby.contains('Price')) {
              return sortby(b, a, 'averageprice');
            } else {
              return sortbydistance(b, a);
            }
          });
          businessDocs = premiumFirst(businessDocs);
          for (int index = 0;
              index < businessDocs.length && !notemptyBuilder;
              index++) {
            if ((businessDocs[index]['loclat'] != null &&
                    distanceinkm(
                            businessDocs[index]['loclat'],
                            businessDocs[index]['loclng'],
                            parameters.loclat,
                            parameters.loclng) <=
                        parameters.distance) &&
                (businessDocs[index]['rating'] != null &&
                    businessDocs[index]['rating'] > parameters.rating)) {
              if (parameters.directsearch != null) {
                // if ((businessDocs[index]['whyus']
                //         .toString()
                //         .toLowerCase()

                //         //RegExp(r'your-substring', caseSensitive: false)

                //         .contains(parameters.directsearch.toLowerCase()) ||
                //     businessDocs[index]['username']
                //         .toString()
                //         .toLowerCase()
                //         .contains(parameters.directsearch.toLowerCase())))
                print(containsany(
                    businessDocs[index]['whyus'].toString().toLowerCase(),
                    parameters.directsearch.toLowerCase()));
                if (containsany(
                        businessDocs[index]['whyus'].toString().toLowerCase(),
                        parameters.directsearch.toLowerCase()) ||
                    containsany(
                        businessDocs[index]['username']
                            .toString()
                            .toLowerCase(),
                        parameters.directsearch.toLowerCase())) {
                  notemptyBuilder = true;
                } else {
                  print('nem containseli');
                }
              } else {
                notemptyBuilder = true;
              }
            }
          }

          return notemptyBuilder
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: businessDocs.length,
                  itemBuilder: (ctx, index) {
                    if ((businessDocs[index]['loclat'] != null &&
                            distanceinkm(
                                    businessDocs[index]['loclat'],
                                    businessDocs[index]['loclng'],
                                    parameters.loclat,
                                    parameters.loclng) <=
                                parameters.distance) &&
                        (businessDocs[index]['rating'] != null &&
                            businessDocs[index]['rating'] >
                                parameters.rating)) {
                      if (parameters.directsearch != null) {
                        // if ((businessDocs[index]['whyus']
                        //         .toString()
                        //         .toLowerCase()
                        //         //RegExp(r'your-substring', caseSensitive: false)
                        //         .contains(parameters.directsearch) ||
                        //     businessDocs[index]['username']
                        //         .toString()
                        //         .toLowerCase()
                        //         .contains(parameters.directsearch)))
                        if (containsany(
                                businessDocs[index]['whyus']
                                    .toString()
                                    .toLowerCase(),
                                parameters.directsearch.toLowerCase()) ||
                            containsany(
                                businessDocs[index]['username']
                                    .toString()
                                    .toLowerCase(),
                                parameters.directsearch.toLowerCase())) {
                          return buildListItem(businessDocs[index], context);
                        } else {
                          return const SizedBox(height: 0, width: 0);
                        }
                      } else {
                        return buildListItem(businessDocs[index], context);
                      }
                    } else {
                      return const SizedBox(
                          height: 0,
                          width:
                              0); // you can't return null, because itembuilder return type is Widget
                    }
                  })
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.sadTear,
                        size: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              // set the default style for the children TextSpans
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 25),
                              children: [
                                TextSpan(
                                  text: 'Sorry, we could not find anything:/\n',
                                ),
                                TextSpan(
                                  text: 'Check your filters',
                                  style: TextStyle(color: maincolor),
                                ),
                                TextSpan(
                                  text: ' again please!',
                                ),
                              ])),
                    ],
                  ),
                );
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
  const RatingBarWithReview(
      {Key key, @required this.deviceSize, this.review, this.rating})
      : super(key: key);

  final String review;
  final double rating;
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
            rating: rating,
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
