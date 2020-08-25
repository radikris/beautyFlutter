import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentTile extends StatelessWidget {
  String commentdescription, commentname, commentuserimage;
  double commentrating;
  CommentTile(this.commentname, this.commentuserimage, this.commentdescription,
      this.commentrating);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: new BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54, blurRadius: 4.0, offset: Offset(0.0, 0.75))
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(commentuserimage),
            radius: 20,
            backgroundColor: Colors.yellow[100],
          ),
        ),
        title: Row(
          children: <Widget>[
            Text(
              commentname,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            RatingBarIndicator(
              rating: commentrating,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber[600],
              ),
              unratedColor: Colors.amber[100],
              itemCount: 5,
              itemSize: 15.0,
              direction: Axis.horizontal,
            )
          ],
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.reply, color: Colors.yellow[100]),
            Container(
                child: Flexible(
              child: Text(
                " $commentdescription",
                style: TextStyle(color: Colors.white),
                softWrap: true,
              ),
            ))
          ],
        ),
        // trailing: RatingBarIndicator(
        //   rating: commentrating,
        //   itemBuilder: (context, index) => Icon(
        //     Icons.star,
        //     color: Colors.amber[600],
        //   ),
        //   unratedColor: Colors.amber[100],
        //   itemCount: 5,
        //   itemSize: 15.0,
        //   direction: Axis.horizontal,
        // )
      ),
    );
  }
}
