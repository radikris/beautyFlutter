import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utilities/constans.dart';
import '../widgets/filterchip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/filterresult.dart';

class FilterScreen extends StatefulWidget {
  static const routename = '/filtered-screen';

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // void _doneSearch() {}

  // List<DocumentSnapshot> businessList = [];

  // buildListItem(String imgPath, String price, Color bgColor) {
  //   final deviceSize = MediaQuery.of(context).size;
  //   return GestureDetector(
  //       onTap: () {
  //         print('nice');
  //         Navigator.of(context).pushNamed(DetailScreen.routeName);
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 16, bottom: 8),
  //         child: Stack(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Expanded(
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).accentColor,
  //                       borderRadius: BorderRadius.circular(15),
  //                       boxShadow: <BoxShadow>[
  //                         BoxShadow(
  //                             color: Colors.black54,
  //                             blurRadius: 5.0,
  //                             offset: Offset(0.0, 0.75))
  //                       ],
  //                     ),
  //                     width: double.infinity,
  //                     height: deviceSize.height / 3,
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 8.0),
  //                           child: RatingBarWithReview(
  //                               deviceSize: deviceSize, review: price),
  //                         ),
  //                         Container(
  //                             width: deviceSize.width -
  //                                 16 -
  //                                 (deviceSize.width / 2 + 16),
  //                             child: FittedBox(
  //                               child: Text(
  //                                 'Kiskunfélegyháza',
  //                                 style: GoogleFonts.patuaOne(fontSize: 18.0),
  //                               ),
  //                             )),
  //                         Text(
  //                           'Wolf Hajstúdió & Fodrászat',
  //                           style: GoogleFonts.oswald(
  //                               color: maincolor, fontSize: 24.0),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Positioned(
  //               top: -15,
  //               left: deviceSize.width / 2.3,
  //               right: null,
  //               child: Column(
  //                 children: <Widget>[
  //                   // CircleAvatar(
  //                   //   radius: 90,
  //                   //   foregroundColor: Colors.transparent,
  //                   //   backgroundColor: Colors.transparent,
  //                   //   backgroundImage: AssetImage(imgPath),
  //                   // ),
  //                   Container(
  //                     width: 50.0,
  //                     height: 50.0,
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(25.0),
  //                       child: FadeInImage(
  //                           placeholder: AssetImage(imgPath),
  //                           image: NetworkImage(
  //                               "https://cdn1.thr.com/sites/default/files/imagecache/scale_crop_768_433/2018/02/gettyimages-862145286_copy_-_h_2018.jpg")),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Card(
  //                       color: Colors.white,
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Text(
  //                           'Open: 10:00-23:00',
  //                           style: GoogleFonts.patuaOne(),
  //                         ),
  //                       ))
  //                 ],
  //               ),
  //             ),
  //           ],
  //           overflow: Overflow.visible,
  //         ),
  //       )
  //       // child: Stack(
  //       //   children: [
  //       //     Container(
  //       //         height: 300.0,
  //       //         width: double.infinity,
  //       //         decoration: BoxDecoration(
  //       //             borderRadius: BorderRadius.circular(25.0),
  //       //             color: Colors.transparent)),
  //       //     Positioned(
  //       //         top: 100.0,
  //       //         child: Container(
  //       //             height: 200.0,
  //       //             width: 250.0,
  //       //             decoration: BoxDecoration(
  //       //                 borderRadius: BorderRadius.circular(25.0),
  //       //                 image: DecorationImage(
  //       //                     image: AssetImage('assets/images/blank_profile.png'),
  //       //                     fit: BoxFit.none)))),
  //       //     Positioned(
  //       //         top: 100.0,
  //       //         child: Container(
  //       //             height: 200.0,
  //       //             width: 250.0,
  //       //             decoration: BoxDecoration(
  //       //               borderRadius: BorderRadius.circular(25.0),
  //       //               color: Colors.white.withOpacity(0.6),
  //       //             ))),
  //       //     Positioned(
  //       //         top: 100.0,
  //       //         child: Container(
  //       //             height: 200.0,
  //       //             width: 250.0,
  //       //             decoration: BoxDecoration(
  //       //               borderRadius: BorderRadius.circular(25.0),
  //       //               color: bgColor.withOpacity(0.9),
  //       //             ))),
  //       //     Positioned(
  //       //         right: 2.0,
  //       //         child: Hero(
  //       //             tag: imgPath,
  //       //             child: Container(
  //       //                 height: 250.0,
  //       //                 width: 150.0,
  //       //                 child: Image(
  //       //                     image: AssetImage(imgPath), fit: BoxFit.scaleDown)))),
  //       //     Positioned(
  //       //         top: 125.0,
  //       //         left: 15.0,
  //       //         child: Column(
  //       //             crossAxisAlignment: CrossAxisAlignment.start,
  //       //             children: [
  //       //               Text(
  //       //                 'Price',
  //       //                 style: GoogleFonts.bigShouldersText(
  //       //                     color: Color(0xFF23163D), fontSize: 20.0),
  //       //               ),
  //       //               Text(
  //       //                 '\$' + price,
  //       //                 style: GoogleFonts.bigShouldersText(
  //       //                     color: Colors.white, fontSize: 40.0),
  //       //               ),
  //       //               SizedBox(height: 20.0),
  //       //               Text(
  //       //                 'Grady\'s COLD BREW',
  //       //                 style: GoogleFonts.bigShouldersText(
  //       //                     color: Color(0xFF23163D), fontSize: 27.0),
  //       //               ),
  //       //               SizedBox(height: 2.0),
  //       //               Container(
  //       //                   width: 200.0,
  //       //                   child: Row(
  //       //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //                       children: [
  //       //                         Column(
  //       //                             crossAxisAlignment: CrossAxisAlignment.start,
  //       //                             children: [
  //       //                               Text(
  //       //                                 '65 reviews',
  //       //                                 style: GoogleFonts.bigShouldersText(
  //       //                                     color: Colors.white, fontSize: 15.0),
  //       //                               ),
  //       //                               RatingBarIndicator(
  //       //                                 rating: 2.75,
  //       //                                 itemBuilder: (context, index) => Icon(
  //       //                                   Icons.star,
  //       //                                   color: Colors.amber,
  //       //                                 ),
  //       //                                 itemCount: 5,
  //       //                                 itemSize: 20.0,
  //       //                                 direction: Axis.horizontal,
  //       //                               )
  //       //                             ]),
  //       //                         GestureDetector(
  //       //                             onTap: () {},
  //       //                             child: Container(
  //       //                                 width: 75.0,
  //       //                                 height: 30.0,
  //       //                                 decoration: BoxDecoration(
  //       //                                   borderRadius:
  //       //                                       BorderRadius.circular(7.0),
  //       //                                   color: Colors.white,
  //       //                                 ),
  //       //                                 child: Row(
  //       //                                     mainAxisAlignment:
  //       //                                         MainAxisAlignment.center,
  //       //                                     children: [
  //       //                                       Icon(Icons.add, size: 17.0),
  //       //                                       SizedBox(width: 5.0),
  //       //                                       Text(
  //       //                                         'Add',
  //       //                                         style:
  //       //                                             GoogleFonts.bigShouldersText(
  //       //                                                 color: Color(0xFF23163D),
  //       //                                                 fontSize: 15.0),
  //       //                                       )
  //       //                                     ])))
  //       //                       ]))
  //       //             ]))
  //       //   ],
  //       // ),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Results'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: deviceSize.height,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 10, right: 10, bottom: 80),
                  child: FilterResult(),
                  //     ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: ScrollPhysics(),
                  //   itemCount: 10,
                  //   itemBuilder: (ctx, index) => buildListItem(
                  //       'assets/images/Instellar.jpg',
                  //       '(254 reviews)',
                  //       Theme.of(context).primaryColor),
                  // ),
                ),
              ),
              //buildListItem('assets/images/Instellar.jpg', '150',
              //Theme.of(context).primaryColor),
            ],
          ),
        ));
  }
}

class RatingBarWithReview extends StatelessWidget {
  const RatingBarWithReview({Key key, @required this.deviceSize, this.review, this.rating})
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
            rating: 1.75,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          )),
          FittedBox(
            child: Text(
              review,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
