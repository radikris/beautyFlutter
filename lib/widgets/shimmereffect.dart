import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: Colors.grey[300],
          child: ShimmerLayout(),
          period: Duration(milliseconds: 1000),
        ));
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double containerWidth = deviceSize.width / 1.8;
    double containerHeight = 11;

    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.1),
        //color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.grey,
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Long message as name',
                    style: TextStyle(
                      backgroundColor: Colors.grey,
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      'Medium messa',
                      style: TextStyle(
                        backgroundColor: Colors.grey,
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                '333',
                style: TextStyle(
                  backgroundColor: Colors.grey,
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              if (Random().nextInt(100) % 2 == 0)
                Container(
                  width: 40.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '333',
                    style: TextStyle(
                      backgroundColor: Colors.grey,
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
    // Container(
    //   margin: EdgeInsets.symmetric(vertical: 7.5),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: <Widget>[
    //       Container(
    //         decoration: BoxDecoration(
    //           color: Colors.grey,
    //           borderRadius: BorderRadius.circular(100),
    //         ),
    //         height: deviceSize.width/4,
    //         width: deviceSize.width/4,
    //        // color: Colors.grey,
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: <Widget>[
    //           Container(
    //             height: containerHeight,
    //             width: containerWidth*0.3,
    //             color: Colors.grey,
    //           ),
    //           SizedBox(height: 13),
    //           Container(
    //             height: containerHeight,
    //             width: containerWidth,
    //             color: Colors.grey,
    //           ),
    //           SizedBox(height: 13),
    //           Container(
    //             height: containerHeight,
    //             width: containerWidth,
    //             color: Colors.grey,
    //           )
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
