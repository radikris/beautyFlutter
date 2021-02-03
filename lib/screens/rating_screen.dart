import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utilities/constans.dart';
import 'dart:math' as Math;

class RatingScreen extends StatefulWidget {
  static const routeName = '/rating-screen';

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;
  IconData myFeedback = FontAwesomeIcons.sadTear;
  Color myFeedbackColor = maincolor;

  Future<void> sendReview(String comment, double rating) async {
    final user = await FirebaseAuth.instance.currentUser();
    var userData=await Firestore.instance.collection('users').document(user.uid).get();

    var alreadycurrent = await Firestore.instance
        .collection('ratings')
        .document('Rcsb4F3CFrP7DeXdkdXFtqQLN9M2')
        .collection('allrating')
        .getDocuments();
    rating=rating- rating%1 + 1;
    print('rating');

    int ratingnumber=alreadycurrent.documents.length;
    double sumrating=0;
    double sumrating_divided=0;
    print('adjukoszse');
    /*alreadycurrent.documents.forEach((element) {
      print(element['rating']);
      print(element['time']);
      sumrating+= element['rating'];
    });
    sumrating_divided=sumrating/ratingnumber;
    */

      await Firestore.instance
          .collection('ratings')
          .document('Rcsb4F3CFrP7DeXdkdXFtqQLN9M2')
          .collection('allrating')
          .document(ratingnumber.toString())
          .setData({
        'time': Timestamp.now(),
        'username': userData['username'],
        'userimage': userData['userImage'],
        'rating': rating,
        'ratingnum': ratingnumber+1,
        'comment': comment,
        //'ratingimage': imageurl
      });

    double finalrating=(ratingnumber * userData['rating'] + rating)/(ratingnumber+1);

    await Firestore.instance.collection('users').document('Rcsb4F3CFrP7DeXdkdXFtqQLN9M2').updateData({
      'rating': finalrating,
    });

  }

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //
            }),
        title: Text("Feedback"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.solidStar),
              onPressed: () {
                //
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Color(0xffE5E5E5),
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: Text(
                    "How happy are you with this service?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              Container(
                  child: Align(
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                          width: deviceSize.width*0.75,
                          //height: deviceSize.height*0.5,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Text(
                                  myFeedbackText,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22.0),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Icon(
                                  myFeedback,
                                  color: myFeedbackColor,
                                  size: 100.0,
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Slider(
                                    min: 0.0,
                                    max: 5.0,
                                    
                                    divisions: 4,
                                    value: sliderValue,
                                    activeColor: Color(0xffe05f2c),
                                    inactiveColor: Colors.blueGrey,
                                    onChanged: (newValue) {
                                      setState(() {
                                        sliderValue = newValue;
                                        print(sliderValue-sliderValue%1 + 1);
                                        if (sliderValue >= 0.0 &&
                                            sliderValue <= 1.0) {
                                          myFeedback = FontAwesomeIcons.sadTear;
                                          myFeedbackColor = Colors.red;
                                          myFeedbackText = "COULD BE BETTER";
                                        }
                                        if (sliderValue > 1.0 &&
                                            sliderValue <=2.0) {
                                          myFeedback = FontAwesomeIcons.frown;
                                          myFeedbackColor = Colors.yellow;
                                          myFeedbackText = "BELOW AVERAGE";
                                        }
                                        if (sliderValue > 2.0 &&
                                            sliderValue <= 3.0) {
                                          myFeedback = FontAwesomeIcons.meh;
                                          myFeedbackColor = Colors.amber;
                                          myFeedbackText = "NORMAL";
                                        }
                                        if (sliderValue > 3.0 &&
                                            sliderValue <= 4.0) {
                                          myFeedback = FontAwesomeIcons.smile;
                                          myFeedbackColor = Colors.green;
                                          myFeedbackText = "GOOD";
                                        }
                                        if (sliderValue > 4.0 &&
                                            sliderValue <= 5.0) {
                                          myFeedback = FontAwesomeIcons.laugh;
                                          myFeedbackColor = Colors.pink;
                                          myFeedbackText = "EXCELLENT";
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  child: TextField(
                                    controller: myController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey)),
                                      hintText: 'Add Comment',
                                    ),
                                    style: TextStyle(height: 3.0),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                           BorderRadius.circular(30.0)),
                                    color: Color(0xffe05f2c),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(color: Color(0xffffffff)),
                                    ),
                                    onPressed: () async {
                                      await sendReview(myController.text, sliderValue);
                                    },
                                  ),
                                )),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
            
            ],
          ),
        ),
      ),
    );
  }
}
