import '../utilities/constans.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../widgets/customexpansion.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  CustomListTile(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: CustomExpansionTile(title),
    );
  }
}
