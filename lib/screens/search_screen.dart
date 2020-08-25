import 'dart:ui';

import 'package:flutter/material.dart';
import '../utilities/constans.dart';
import '../widgets/filterchip.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../widgets/singlechoice.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = '/search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void _doneSearch() {
    Navigator.of(context).pushNamed(FilterScreen.routename);
  }

  double ratingstars = 3;
  double distance = 2;

  List<String> sortFilter = [
    'Sort by Price',
    'Sort by Rating',
    'Sort by Distance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Set your filters',
            style: kTitleStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            FlatButton(
              child: Text('SEARCH', style: TextStyle(color: maincolor)),
              onPressed: _doneSearch,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(color: Colors.grey[400], height: 10),
                FilterChipDisplay(),
                Divider(color: Colors.grey[400], height: 10),
                Text(
                  'Select rating',
                  style: titelTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RatingBar(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                        setState(() {
                          ratingstars = rating;
                        });
                      },
                    ),
                    Text(
                      'Rating: $ratingstars',
                      style: kSubtitleStyle,
                    ),
                  ],
                ),
                Divider(color: Colors.grey[400], height: 10),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Select distance',
                  style: titelTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '2 km',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: distance,
                        onChanged: (newDistance) {
                          setState(() {
                            distance = newDistance;
                          });
                        },
                        divisions: 24,
                        label: distance.toStringAsFixed(2) + "km",
                        min: 2,
                        max: 50,
                      ),
                    ),
                    Text(
                      '50 km',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Show services, near than: '),
                        TextSpan(
                            text: '$distance km',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey[400], height: 10),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Sort by',
                  style: titelTextStyle,
                ),
                SingleSelectionExample(sortFilter),
                Center(
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: _doneSearch,
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 33),
              ],
            ),
          ),
        ));
  }
}
