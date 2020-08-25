import 'package:flutter/material.dart';

class RemoveablePhoto extends StatefulWidget {
  final Function removePhoto;
  final Function loadPhoto;
  final int photoidx;
  RemoveablePhoto(this.photoidx, this.removePhoto, this.loadPhoto);

  @override
  _RemoveablePhotoState createState() => _RemoveablePhotoState();
}

class _RemoveablePhotoState extends State<RemoveablePhoto> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 150,
        width: 150,
        child: FadeInImage(
            placeholder: AssetImage('assets/images/simple_background.jpg'),
            //image: AssetImage((wallpapers..shuffle()).first),
            image: NetworkImage(widget.loadPhoto(widget.photoidx)),
            fit: BoxFit.cover),
      ),
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.cancel,
            color: Colors.red[400],
          ),
          onPressed: () {
            widget.removePhoto(widget.photoidx);
          }),
    ]);
  }
}
