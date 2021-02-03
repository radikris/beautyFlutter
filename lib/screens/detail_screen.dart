import 'package:beauty_app/utilities/constans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import '../utilities/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/businessservices.dart';
import 'booking_screen.dart';
import '../widgets/openclosed.dart';
import '../screens/search_map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../widgets/commenttile.dart';
import '../widgets/temporary/chat_screen.dart';
import '../widgets/temporary/user_model.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detail-screen';
  DocumentSnapshot businessdetail;

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  bool isInit = true;
  bool firstpress = false;
  bool isFavorite = false;
  bool isloaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      widget.businessdetail =
          ModalRoute.of(context).settings.arguments as DocumentSnapshot;
      print(widget.businessdetail.documentID);
    }
    isInit = false;
  }

  @override
  void initState() {
    super.initState();
    _images
      ..add('assets/images/blank_profile.png')
      ..add('assets/images/barber_wallpaper.jpg')
      ..add('assets/images/barbershop-medan-840x450.jpg')
      ..add('assets/images/Instellar.jpg');
    _headers
      ..add('First Image')
      ..add('Second Image')
      ..add('Third Image')
      ..add('Fourth Image');
  }

  List<String> _images = [];
  List<String> _headers = [];

  Widget _buildSocialIcon(IconData icon, String labeltext) {
    return SizedBox(
      height: 100,
      width: 100, // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.white, // button color
          child: InkWell(
            splashColor: lightmaincolor, // splash color
            onTap: () {}, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: maincolor), // icon
                FlatButton(
                  child: Text(labeltext),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            user: User(
                                id: widget.businessdetail.documentID,
                                name: widget.businessdetail['username'],
                                imageUrl: 'mind1',
                                service: widget.businessdetail['category']),
                          ),
                        ));
                  },
                ) // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toggleFavoriteStatus(String userid) async {
    var user = await FirebaseAuth.instance.currentUser();
    final snapShot = await Firestore.instance
        .collection('favorite')
        .document(user.uid)
        .collection('favoritebyuser')
        .document(userid)
        .get();

    if (!isloaded) {
      if (snapShot == null || !snapShot.exists) {
        print('nincs ilyen');
        setState(() {
          isFavorite = false;
        });
      } else {
        print('van ilyen');
        setState(() {
          isFavorite = true;
        });
      }
    }

    if (!firstpress) {
      setState(() {
        isloaded = true;
      });
    }

    //mostantol van a gombnyomasra like

    if (firstpress) {
      if (snapShot == null || !snapShot.exists) {
        await Firestore.instance
            .collection('favorite')
            .document(user.uid)
            .collection('favoritebyuser')
            .document(userid)
            .setData({'bool': 'liked'});
      } else {
        await Firestore.instance
            .collection('favorite')
            .document(user.uid)
            .collection('favoritebyuser')
            .document(userid)
            .delete();
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    }
    firstpress = false;
    return;

    // if (snapShot == null || !snapShot.exists) {
    //   // Docuelse{ment with id == docId doesn't exist.
    //   print('nem letezik ilyen csavo');
    //   setState(() {
    //     isFavorite = false;
    //   });
    //   if (firstpress) {
    //     setState(() {
    //       isFavorite = true;
    //     });
    //     await Firestore.instance
    //         .collection('favorite')
    //         .document(userid)
    //         .collection('favoritebyuser')
    //         .document(user.uid)
    //         .setData({'bool': 'liked'});
    //   }
    // } else {
    //   bool currentstate = isFavorite;
    //   setState(() {
    //     isFavorite = !isFavorite;
    //   });
    //   if (currentstate) {
    //     await Firestore.instance
    //         .collection('favorite')
    //         .document(userid)
    //         .collection('favoritebyuser')
    //         .document(user.uid)
    //         .delete();
    //   } else {
    //     await Firestore.instance
    //         .collection('favorite')
    //         .document(userid)
    //         .collection('favoritebyuser')
    //         .document(user.uid)
    //         .setData({'bool': 'liked'});
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: !isloaded
          ? FutureBuilder(
              future: toggleFavoriteStatus(widget.businessdetail.documentID),
              builder: (ctx, futuresnapshot) =>
                  futuresnapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : Text('szia'))
          : DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red[900],
                          ),
                          onPressed: () async {
                            firstpress = true;
                            toggleFavoriteStatus(
                                widget.businessdetail.documentID);
                          },
                        )
                      ],
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(widget.businessdetail['username'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            )),
                        background: Hero(
                          tag: widget.businessdetail['email'],
                          child: Swiper(
                            itemCount: _images.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Image.asset(
                              _images[index],
                              fit: BoxFit.cover,
                            ),
                            autoplay: true,
                            pagination: new SwiperPagination(
                                margin: new EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 40.0),
                                builder: new DotSwiperPaginationBuilder(
                                    color: Colors.white30,
                                    activeColor: Theme.of(context).primaryColor,
                                    size: 15.0,
                                    activeSize: 20.0)),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [lightmaincolor, Colors.white]),
                              //borderRadius: BorderRadius.circular(50),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Colors.redAccent),
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(icon: Icon(Icons.info), text: "About"),
                            Tab(icon: Icon(Icons.list), text: "Services"),
                            Tab(icon: Icon(Icons.rate_review), text: "Reviews"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    // Container(
                    //     decoration: BoxDecoration(color: Colors.blue),
                    //     child: Icon(Icons.directions_car)),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              'Welcome here\nat ${widget.businessdetail['username']}',
                              style: GoogleFonts.oswald(fontSize: 26),
                              textAlign: TextAlign.center,
                            ),
                          )),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Text(
                            '${widget.businessdetail['opening']} : ${widget.businessdetail['closing']}',
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).primaryColor),
                          )),
                          SizedBox(
                            height: 15,
                          ),
                          OpenClosed(false, widget.businessdetail['opening'],
                              widget.businessdetail['closing']),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildSocialIcon(Icons.explore, 'Website'),
                              _buildSocialIcon(Icons.chat, 'Message'),
                              _buildSocialIcon(Icons.share, 'Share'),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(color: Colors.grey[600]),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Business Rating',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                RatingBarIndicator(
                                  rating: widget.businessdetail['rating'],
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber[600],
                                  ),
                                  unratedColor: Colors.amber[100],
                                  itemCount: 5,
                                  itemSize: 24.0,
                                  direction: Axis.horizontal,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 3),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('(${widget.businessdetail['ratingnum']} reviews)',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey[600]),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Address',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Container(
                                      width: deviceSize.width / 2,
                                      child: Text(
                                          '${widget.businessdetail['locationread']}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    LatLng helper = LatLng(
                                        widget.businessdetail['loclat'],
                                        widget.businessdetail['loclng']);
                                    Navigator.of(context).pushNamed(
                                        SearchMapScreen.routeName,
                                        arguments: helper);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: deviceSize.width / 3.5,
                                    width: deviceSize.width / 2.5,
                                    //alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      LocationHelper
                                          .generateLocationPreviewImage(
                                        widget.businessdetail['loclat'],
                                        widget.businessdetail['loclng'],
                                      ),
                                      fit: BoxFit.fill,
                                      //width: double.infinity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey[600]),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Why us?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21,
                                  color: maincolor),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              '${widget.businessdetail['whyus']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            BusinessService(widget.businessdetail['services'],
                                null, widget.businessdetail.documentID),
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        // set the default style for the children TextSpans
                                        style: Theme.of(context)
                                            .textTheme
                                            .title
                                            .copyWith(fontSize: 25),
                                        children: [
                                          TextSpan(
                                            text:
                                                'Could not find what you were looking for?\n',
                                          ),
                                          TextSpan(
                                            text: 'Send message',
                                            style: TextStyle(color: maincolor),
                                          ),
                                          TextSpan(
                                            text: ' or visit the webstite',
                                          ),
                                        ])),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 300,
                    //   margin: EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(30.0),
                    //       topRight: Radius.circular(30.0),
                    //     ),
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(30.0),
                    //       topRight: Radius.circular(30.0),
                    //     ),
                    //     child: Container(
                    //       color: lightmaincolor,
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: BusinessService(widget.businessdetail['services'],
                    //           () {}, widget.businessdetail.documentID),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 10,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return CommentTile(
                              'Userelso',
                              'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
                              'VALOBAN amerika volt ez a fodrasz teso',
                              4.8);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(40.0),
            bottomRight: const Radius.circular(40.0)),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// class DetailScreen extends StatefulWidget {
//   static const routeName = '/detail-screen';
//   DocumentSnapshot businessdetail;

//   @override
//   _DetailScreenState createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen> {
//   bool isInit = true;
//   TabController controller;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (isInit) {
//       widget.businessdetail =
//           ModalRoute.of(context).settings.arguments as DocumentSnapshot;
//       print(widget.businessdetail.documentID);
//       controller = new TabController(length: 3, vsync: Tik);
//     }
//     isInit = false;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _images
//       ..add('assets/images/blank_profile.png')
//       ..add('assets/images/barber_wallpaper.jpg')
//       ..add('assets/images/barbershop-medan-840x450.jpg')
//       ..add('assets/images/Instellar.jpg');
//     _headers
//       ..add('First Image')
//       ..add('Second Image')
//       ..add('Third Image')
//       ..add('Fourth Image');
//   }

//   List<String> _images = [];
//   List<String> _headers = [];

// // Firestore.instance
// //         .collection('users')
// //         .where("usertype", isEqualTo: "Customer")
// //         .where('ispremium', isEqualTo: true)
// //         .snapshots()
// //         .listen((data) => data.documents.forEach((doc){
// //           print(data);
// //           print(doc['email']);
// //         }));
//   var serviceList = [
//     {'title': 'Men\s Hair Cut', 'duration': 45, 'price': 30},
//     {'title': 'Women\s Hair Cut', 'duration': 60, 'price': 50},
//     {'title': 'Color & Blow Dry', 'duration': 90, 'price': 75},
//     {'title': 'Oil Treatment', 'duration': 30, 'price': 20},
//   ];

//   Widget _customScrollView() {
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverAppBar(
//           expandedHeight: 250.0,
//           floating: false,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             centerTitle: true,
//             title: Text(widget.businessdetail['username'],
//     style: TextStyle(
//       color: Colors.white,
//       fontSize: 15.0,
//     )),
//             background: Hero(
//               tag: widget.businessdetail['email'],
//               child: Swiper(
//     itemCount: _images.length,
//     itemBuilder: (BuildContext context, int index) => Image.asset(
//       _images[index],
//       fit: BoxFit.cover,
//     ),
//     autoplay: true,
//     pagination: new SwiperPagination(
//         margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
//         builder: new DotSwiperPaginationBuilder(
//             color: Colors.white30,
//             activeColor: Theme.of(context).primaryColor,
//             size: 15.0,
//             activeSize: 20.0)),
//               ),
//             ),
//           ),
//           bottom: TabBar(
//             controller: controller,
//             tabs: <Widget>[
//               Tab(
//     text: "About",
//               ),
//               Tab(
//     text: "Services",
//               ),
//               Tab(
//     text: "Reviews",
//               ),
//             ],
//           ),
//         ),
//         SliverToBoxAdapter(
//           // child: Container(
//           //   child: TabBarView(
//           //         children: <Widget>[
//           //           Center(
//           //             child: Text("About Tab"),
//           //           ),
//           //           Center(
//           //             child: Text("Services Tab"),
//           //           ),
//           //           Center(
//           //             child: Text("Reviews Tab"),
//           //           ),
//           //         ],
//           //       ),
//           // ),
//           child: Column(
//             children: <Widget>[
//               OpenClosed(false, widget.businessdetail['opening'],
//       widget.businessdetail['closing']),
//               //SizedBox(height: 15),
//               SizedBox(
//     height: 5,
//               ),
//               Container(
//     margin: EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30.0),
//         topRight: Radius.circular(30.0),
//       ),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30.0),
//         topRight: Radius.circular(30.0),
//       ),
//       child: Container(
//         color: lightmaincolor,
//         padding: const EdgeInsets.all(8.0),
//         child: BusinessService(
//             serviceList, () {}, widget.businessdetail.documentID),
//       ),
//     ),
//               ),
//               // Container(
//               //   color: lightmaincolor,
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: BusinessService(serviceList, () {}),
//               // ),
//             ],
//           ),
//         ),
//         // SliverList(
//         //   delegate: SliverChildBuilderDelegate(
//         //       (context, index) => Padding(
//         //             padding: const EdgeInsets.all(8.0),
//         //             child: Container(
//         //               height: 75,
//         //               color: Colors.black12,
//         //             ),
//         //           ),
//         //       childCount: 10),
//         // ),
//         // Center(
//         //   child: Container(
//         //     decoration: BoxDecoration(color: Theme.of(context).primaryColor),
//         //     child: Text('HELLLLLLLLLLLOOO'),
//         //   ),
//         // )
//       ],
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _customScrollView();
//   }
// }
