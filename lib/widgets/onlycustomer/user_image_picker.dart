import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../utilities/constans.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickfn, this.currentimage);

  final String currentimage;
  final void Function(File pickedImage) imagePickfn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 200);
    final pickedImageFile = File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickfn(pickedImageFile);
  }

  Widget _showImageDialog() {
    print("Show image dialoG!");
    return AlertDialog(
      title: Text(
        'You like it?',
        textAlign: TextAlign.center,
      ),
      actions: [
        FlatButton(
          child: Text(
            'Yes',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: SizedBox(
        height: 400,
        width: 200,
        child: Hero(
          tag: 'profclick',
          child: Container(
              decoration: BoxDecoration(
            image: DecorationImage(
              image: (_pickedImage != null ? FileImage(_pickedImage) : null),
            ),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Hero(
        tag: 'profclick',
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Theme.of(context).primaryColor,
          child: GestureDetector(
            onTap: () {
              if (_pickedImage != null)
                showDialog(
                    context: context, builder: (_) => _showImageDialog());
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: widget.currentimage != null
                  ? NetworkImage(widget.currentimage)
                  : (_pickedImage != null ? FileImage(_pickedImage) : null),
            ),
          ),
        ),
      ),
      FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.camera_enhance,
            color: Theme.of(context).primaryColor,
          ),
          label: Text('Add image',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          color: Colors.transparent),
    ]);
  }
}
