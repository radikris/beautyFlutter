import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Widget showProgress() {
  return Center(
    child: SpinKitFoldingCube(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    ),
  );
}

final titelTextStyle =
    TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold);

final niceBlue = Color(0xFF527DAA);
final lightBlue = Color(0xFF309DF1);
final fade1 = Color(0xFFF8B195);
final fade2 = Color(0xFFF0B195);
final fade3 = Color(0xFFE6B195);
final fade4 = Color(0xFFDCB195);
final lightmaincolor = Color(0xFFFFD5AC);
final maincolor = Color(0xFFF8B195);

final kGradientStyle = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFF8B195),
    Color(0xFFF0B195),
    Color(0xFFE6B195),
    Color(0xFFDCB195),
  ],
  stops: [0.1, 0.4, 0.7, 0.9],
);

final kMoreGradientStyle = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFF8B195),
    Color(0xFFf8b19b),
    Color(0xFFE6A987),
    Color(0xFFf8b19f),
  ],
  stops: [0.1, 0.4, 0.7, 0.9],
);

const kPurple = Color(0xFF6F51FF);
const kYellow = Color(0xFFFFAD03);
const kGreen = Color(0xFF22B274);
const kPink = Color(0xFFEB1E79);
const kIndigo = Color(0xFF000A45);
const kBlack = Color(0xFF4C4C4C);
const kGrey = Color(0xFFACACAC);

var kTitleStyle = GoogleFonts.roboto(
  color: kBlack,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);
var kSubtitleStyle = GoogleFonts.roboto(
  color: kGrey,
  fontSize: 14.0,
);
var kTitleItem = GoogleFonts.roboto(
  color: kBlack,
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
);
var kSubtitleItem = GoogleFonts.roboto(
  color: kGrey,
  fontSize: 12.0,
);
var kHintStyle = GoogleFonts.roboto(
  color: kGrey,
  fontSize: 12.0,
);

Color mC = Colors.grey.shade100;
Color mCL = Colors.white;
Color mCD = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;

BoxDecoration nMbox =
    BoxDecoration(shape: BoxShape.circle, color: mC, boxShadow: [
  BoxShadow(
    color: mCD,
    offset: Offset(10, 10),
    blurRadius: 10,
  ),
  BoxShadow(
    color: mCL,
    offset: Offset(-10, -10),
    blurRadius: 10,
  ),
]);

BoxDecoration nMboxInvert = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: mCD,
    boxShadow: [
      BoxShadow(
          color: mCL, offset: Offset(3, 3), blurRadius: 3, spreadRadius: -3),
    ]);

class SearchParameters {
  List<String> categories = [];
  double rating;
  double distance;
  String sortby;
  double loclat, loclng;
  String directsearch;
  SearchParameters({this.categories, this.rating, this.distance, this.sortby, this.loclat, this.loclng, this.directsearch});
}