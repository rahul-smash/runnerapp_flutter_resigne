import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_dialog.dart';

class ImagePickerHandler {

  final ImagePicker _picker = ImagePicker();
  ImagePickerDialog imagePicker;
  ImagePickerListener _listener;
  bool profileImage = false;
  bool docImage1 = false;
  bool docImage2 = false;
  bool docImage3 = false;
  BuildContext context;
  bool docCertificateImage1 = false;
  bool docCertificateImage2 = false;
  bool docCertificateImage3 = false;

  ImagePickerHandler(this._listener);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 80);
    selectedImage(image);
  }

  closeDialog(){
    imagePicker.dismissDialog();
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await await _picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    selectedImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this);
    imagePicker.initState();
  }


  Future selectedImage(XFile image) async {
    _listener.selectedProfileImage(image,this.profileImage,this.docImage1,this.docImage2,this.docImage3,
        this.docCertificateImage1,this.docCertificateImage2,this.docCertificateImage3);
  }

  showDialog(BuildContext context,{bool profileImage = false,
    bool docImage1= false,
    bool docImage2= false,
    bool docImage3= false,
    bool docCertificateImage1 = false,
    bool docCertificateImage2= false,
    bool docCertificateImage3 = false}) {
    this.context = context;
    this.profileImage = profileImage;
    this.docImage1 = docImage1;
    this.docImage2 = docImage2;
    this.docImage3 = docImage3;
    this.docCertificateImage1 = docCertificateImage1;
    this.docCertificateImage2 = docCertificateImage2;
    this.docCertificateImage3 = docCertificateImage3;
    imagePicker.getImage(context);
  }

}

abstract class ImagePickerListener {
  selectedProfileImage(XFile _image,bool profileImage, bool docImage1, bool docImage2,bool docImage3,
      bool docCertificateImage1,bool docCertificateImage2,bool docCertificateImage3,);
}
