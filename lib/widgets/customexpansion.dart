import 'package:beauty_app/utilities/constans.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';

class CustomExpansionTile extends StatefulWidget {
  String titlestring;
  CustomExpansionTile(this.titlestring);
  @override
  State createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ExpansionTile(
      title: Container(
        child: Row(
          children: [
            Text(
              widget.titlestring,
              style: kTitleStyle,
            )
          ],
        ),
        // Change header (which is a Container widget in this case) background colour here.
      ),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        size: 36.0,
        color: Colors.black54,
      ),
      children: <Widget>[
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List<Widget>.generate(showMoreCategory.length, (int index) {
              return CategoryCard(category: showMoreCategory[index]);
          }),
        ),
      ],
      onExpansionChanged: (bool expanding) => setState(() {
        this.isExpanded = expanding;
      }),
      //setState(() => this.isExpanded = expanding),
    );
  }
}
