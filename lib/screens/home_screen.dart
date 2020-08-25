import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import '../utilities/constans.dart';
import '../models/barbershop.dart';
import '../models/category.dart';
import '../widgets/barbershop.dart';
import '../widgets/category_card.dart';
import '../widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = '/home-screen';
  final wallpapers = [
    'assets/images/barber_wallpaper.jpg',
    'assets/images/makeup_wallpaper.jpg',
    'assets/images/nails_wallpaper.jpg',
    'assets/images/other_wallpaper.jpg',
    'assets/images/massage_wallpaper.jpg',
    'assets/images/spa_wallpaper.jpg',
    'assets/images/sport_wallpaper.jpg'
  ];
  static int wallpaperidx = 0;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        placeholder:
                            AssetImage('assets/images/simple_background.jpg'),
                        //image: AssetImage((wallpapers..shuffle()).first),
                        image: AssetImage(wallpapers[
                            wallpaperidx < wallpapers.length
                                ? wallpaperidx++
                                : wallpaperidx = 0]),
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
                            style: kTitleStyle.copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          margin: EdgeInsets.symmetric(horizontal: 18.0),
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white.withOpacity(.9),
                          ),
                          child: TextField(
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
                      return FittedBox(child: CategoryCard(category: category));
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
    );
  }
}
