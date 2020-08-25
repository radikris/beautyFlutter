import 'package:flutter/material.dart';

class SingleSelectionExample extends StatefulWidget {
  List<String> sortFilter;

  SingleSelectionExample(this.sortFilter);

  @override
  _SingleSelectionExampleState createState() => _SingleSelectionExampleState();
}

class _SingleSelectionExampleState extends State<SingleSelectionExample> {
  String selectedValue;
  double singleheight;

  @override
  void initState() {
    super.initState();

    selectedValue = widget.sortFilter.first;
    singleheight = widget.sortFilter.length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: singleheight * 50.0,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              selectedValue = widget.sortFilter[index];
              setState(() {});
            },
            child: Container(
              // color: selectedValue == widget.sortFilter[index]
              //     ? Colors.green[100]
              //     : null,
              child: Row(
                children: <Widget>[
                  Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: widget.sortFilter[index],
                      groupValue: selectedValue,
                      onChanged: (s) {
                        selectedValue = s;
                        setState(() {});
                      }),
                  Text(widget.sortFilter[index])
                ],
              ),
            ),
          );
        },
        itemCount: widget.sortFilter.length,
      ),
    );
  }
}
