import 'package:location/location.dart';

import '../utilities/constans.dart';
import '../models/category.dart';
import 'package:flutter/material.dart';
import '../screens/filter_screen.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  CategoryCard({this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  static double current_loclat, current_loclng;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    // locationRead = await LocationHelper.getPlaceAddress(
    //     locData.latitude, locData.longitude);
    // // setState(() {
    // //   isLoading = false;
    // // });

    current_loclat = locData.latitude;
    current_loclng = locData.longitude;
  }

  // @override
  // void didChangeDependencies() {
  //   setState(() {
  //     isLoading = false;
  //   });

  //   super.didChangeDependencies();
  // }

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current_loclat=null;
    current_loclng=null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        if (current_loclat == null || current_loclng==null) {
          await _getCurrentUserLocation();
        }
        List<String> categoryNames = [];
        categoryNames.add(widget.category.title);
        Navigator.of(context).pushNamed(FilterScreen.routename,
            arguments: SearchParameters(
              categories: categoryNames,
              sortby: 'Sort by Rating',
              distance: 13000, //earth diameter is 12k
              rating: 0,
              loclat: current_loclat,
              loclng: current_loclng,
            ));
        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        width: 65.0,
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLoading
                ? CircularProgressIndicator(
                    backgroundColor: maincolor,
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: widget.category.color,
                    //backgroundImage: AssetImage(category.icon),
                    child: ClipOval(
                      child: Image.asset(
                        widget.category.icon,
                      ),
                    )
                    // radius: 25.0,
                    ),
            FittedBox(child: Text(widget.category.title, style: kTitleItem)),
            Text(
              "${widget.category.subtitle} Places",
              style: kSubtitleItem,
            ),
          ],
        ),
      ),
    );
  }
}
