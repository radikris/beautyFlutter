import '../utilities/constans.dart';
import '../models/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  CategoryCard({this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
              radius: 20,
              backgroundColor: category.color,
              //backgroundImage: AssetImage(category.icon),
              child: ClipOval(
                child: Image.asset(
                  category.icon,
                ),
              )
              // radius: 25.0,
              ),
          FittedBox(child: Text(category.title, style: kTitleItem)),
          Text(
            "${category.subtitle} Places",
            style: kSubtitleItem,
          ),
        ],
      ),
    );
  }
}
