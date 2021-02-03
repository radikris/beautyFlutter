import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'dart:math';

import '../utilities/constans.dart';
import '../models/barbershop.dart';
import '../models/category.dart';
import '../widgets/barbershop.dart';
import '../widgets/category_card.dart';
import '../widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import '../screens/filter_screen.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../widgets/searchdelegate.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = '/home-screen';
  static int wallpaperidx = 0;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final wallpapers = [
    'assets/images/barber_wallpaper.jpg',
    'assets/images/makeup_wallpaper.jpg',
    'assets/images/nails_wallpaper.jpg',
    'assets/images/other_wallpaper.jpg',
    'assets/images/massage_wallpaper.jpg',
    'assets/images/spa_wallpaper.jpg',
    'assets/images/sport_wallpaper.jpg'
  ];

  bool isExpanded = false;

  static double current_loclat = null, current_loclng = null;
  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    current_loclat = locData.latitude;
    current_loclng = locData.longitude;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current_loclat = null;
    current_loclng = null;
  }

  final TextEditingController controller = TextEditingController();

  List<String> historysearches=[];

  Future<void> getHistory() async {
    final user = await FirebaseAuth.instance.currentUser();

    var alreadysearch = await Firestore.instance
        .collection('presearch')
        .document(user.uid)
        .collection('lastfive')
        .orderBy('time', descending: true)
        .getDocuments();

    List<String> searchs = [];
    alreadysearch.documents.forEach((element) {
      searchs.add(element['direct']);
    });
    
    historysearches=searchs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getHistory(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator(
              backgroundColor: maincolor,
            ))
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: OvalBottomBorderClipper(),
                        child: Stack(children: <Widget>[
                          SizedBox(
                            height: 250.0,
                            width: double.infinity,
                            child: FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/simple_background.jpg'),
                                //image: AssetImage((wallpapers..shuffle()).first),
                                image: AssetImage(wallpapers[
                                    HomeScreen.wallpaperidx < wallpapers.length
                                        ? HomeScreen.wallpaperidx++
                                        : HomeScreen.wallpaperidx = 0]),
                                fit: BoxFit.cover),
                          ),
                          Container(
                            width: double.infinity,
                            height: 250.0,
                            padding: EdgeInsets.only(bottom: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(
                                    "Find and book best services",
                                    style: kTitleStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 18.0),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white.withOpacity(.9),
                                  ),
                                  child: TextFormField(
                                    //initialValue: controller.text,
                                    //https://stackoverflow.com/questions/61048477/flutter-return-search-delegate-result-string-to-a-textfield

                                    controller: controller,
                                    autocorrect: true,
                                    cursorColor: kBlack,
                                    decoration: InputDecoration(
                                      hintText: "Search Saloon, Spa and Barber",
                                      hintStyle: kHintStyle,
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.search,
                                        color: kGrey,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.search,
                                    enableSuggestions: true,
                                    onTap: () {
                                      // List<String> historysearches =
                                      //     await getHistory();
                                      showSearch(
                                          context: context,
                                          delegate: DataSearch(
                                              historysearches, controller));
                                    },
                                    onFieldSubmitted: (term) async {
                                      print('object');
                                      print('ranyomtunk a donera');

                                      //await uploaddirectSearch(term);
                                      if (current_loclat == null ||
                                          current_loclng == null) {
                                        await _getCurrentUserLocation();
                                      }
                                      List<String> categoryNames = [];
                                      categoryNames.addAll(<String>[
                                        'Hairdresser',
                                        'Wellness',
                                        'Nails',
                                        'Massage',
                                        'Sport',
                                        'Other',
                                        'Hair',
                                        'Spa',
                                      ]);
                                      Navigator.of(context).pushNamed(
                                          FilterScreen.routename,
                                          arguments: SearchParameters(
                                              categories: categoryNames,
                                              sortby: 'Sort by Rating',
                                              distance:
                                                  13000, //earth diameter is 12k
                                              rating: 0,
                                              loclat: current_loclat,
                                              loclng: current_loclng,
                                              directsearch: term));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 25.0),
                      CustomListTile("Show more Categories"),
                      SizedBox(height: 25.0),
                      Container(
                        width: double.infinity,
                        height: 100.0,
                        child: ListView.builder(
                          itemCount: categoryList.length,
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var category = categoryList[index];
                            return FittedBox(
                                child: CategoryCard(category: category));
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      //CustomListTile(title: "Recommended for You"),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Recommended for You',
                              style: kTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Container(
                          width: double.infinity,
                          height: 150.0,
                          child: ListView.builder(
                            itemCount: bestList.length,
                            scrollDirection: Axis.horizontal,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var barbershop = bestList[index];
                              return BarbershopCard(barbershop: barbershop);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
