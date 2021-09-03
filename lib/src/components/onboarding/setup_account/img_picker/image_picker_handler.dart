import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/preview_cropped_image_alert.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'image_picker_dialog.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

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
    var image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50);
    cropImage(image);
    //selectedImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    cropImage(image);
    //selectedImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this);
    imagePicker.initState();
  }

  Future cropImage(XFile image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppTheme.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: 'Crop Image',
        )
    );
    //print("croppedFile=${croppedFile}");
    if(croppedFile != null){
      var result = await PreviewCroppedImageAlert.previewCroppedImageDialog(context, "Preview", croppedFile,
          "Cancel", "OK");
      //print("result=${result}");
      if(result){
        XFile xFile = new XFile(croppedFile.path);
        selectedImage(xFile);
      }
    }
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
  closeDialog(){
    imagePicker.dismissDialog();
  }


}


abstract class ImagePickerListener {
  selectedProfileImage(XFile _image,bool profileImage, bool docImage1, bool docImage2,bool docImage3,
      bool docCertificateImage1,bool docCertificateImage2,bool docCertificateImage3,);
}


