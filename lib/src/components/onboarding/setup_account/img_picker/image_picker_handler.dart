import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_dialog.dart';

class ImagePickerHandler {

  final ImagePicker _picker = ImagePicker();
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  bool profileImage = false;
  bool docImage1 = false;
  bool docImage2 = false;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 80);
    selectedImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await await _picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    selectedImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future selectedImage(XFile image) async {
    _listener.selectedProfileImage(image,this.profileImage,this.docImage1,this.docImage2);
  }

  showDialog(BuildContext context,{bool profileImage = false,
    bool docImage1= false,
    bool docImage2= false}) {
    this.profileImage = profileImage;
    this.docImage1 = docImage1;
    this.docImage2 = docImage2;
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  selectedProfileImage(XFile _image,bool profileImage, bool docImage1, bool docImage2);
}
