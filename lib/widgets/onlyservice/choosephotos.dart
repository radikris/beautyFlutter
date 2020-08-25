import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SingleImageUpload extends StatefulWidget {
  int howmanyphoto;
  List<dynamic> currentphotos;
  final Function setphotohandler;
  SingleImageUpload(
      this.howmanyphoto, this.currentphotos, this.setphotohandler);

  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.currentphotos != null) {
        for (int i = 0; i < widget.currentphotos.length; i++) {
          images.add(widget.currentphotos.elementAt(i));
        }
        for (int i = 0; i <= widget.howmanyphoto - images.length; i++) {
          images.add("Add Image");
        }
      }else{
        for(int i=0; i<widget.howmanyphoto; i++){
          images.add('Add Image');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.howmanyphoto == 3 ? 120 : 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: buildGridView(),
          ),
        ],
      ),
    );
  }

  bool isAlreadyNetImage(Object whatisit) {
    if (whatisit is ImageUploadModel) return false;
    if (whatisit is String && whatisit == 'Add Image') return false;
    print(whatisit.toString());
    return true;
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if ((images[index] is ImageUploadModel) ||
            isAlreadyNetImage(images[index])) {
          ImageUploadModel uploadModel;
          String imageurl;
          if (images[index] is ImageUploadModel)
            uploadModel = images[index];
          else if (images[index].toString() != ('Add Image'))
            imageurl = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                if (isAlreadyNetImage(images[index]))
                  Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                  ),
                if (images[index] is ImageUploadModel &&
                    uploadModel.imageFile != null)
                  Image.file(
                    uploadModel.imageFile,
                    width: 300,
                    height: 300,
                  ),
                if (isAlreadyNetImage(images[index]) ||
                    images[index] is ImageUploadModel)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red[400],
                      ),
                      onTap: () {
                        setState(() {
                          images.replaceRange(index, index + 1, ['Add Image']);
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      File val;
      _imageFile.then((file) async {
        val = file;
        if (val != null) {
          getFileImage(index);
        }
      });
    });
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;

        
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
        widget.setphotohandler(images);
      });
    });
  }
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
