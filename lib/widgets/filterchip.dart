import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/category.dart';
import '../utilities/constans.dart';

class FilterChipDisplay extends StatefulWidget {
  @override
  _FilterChipDisplayState createState() => _FilterChipDisplayState();
}

class _FilterChipDisplayState extends State<FilterChipDisplay> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: _titleContainer("Choose services"),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
                child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5.0,
                runSpacing: 5.0,
                children: List<Widget>.generate(allofthecategories.length,
                    (int index) {
                  return filterChipWidget(
                    chipName: allofthecategories[index].title,
                    chipColor: allofthecategories[index].color,
                  );
                }),
              ),
            )),
          ),
        ),
        Divider(
          color: Colors.grey[400],
          height: 10.0,
        ),
      ],
    );
  }
}

class filterChipWidget extends StatefulWidget {
  final String chipName;
  final Color chipColor;

  filterChipWidget({Key key, this.chipName, this.chipColor}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: kIndigo, fontSize: 18.0, fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Theme.of(context).primaryColor,
    );
  }
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}
