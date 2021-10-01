import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/img_picker/image_picker_handler.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class AddImageBottomSheet with ImagePickerListener {
  dynamic booking;
  BuildContext context;
  ImagePickerHandler imagePicker;
  List<File> imagePath = List.empty(growable: true);
  Function setstate;

  String paymentMethod = 'cod';

  AddImageBottomSheet(this.context, this.booking, this.paymentMethod) {
    imagePicker = new ImagePickerHandler(this);
    imagePicker.init();
    openAddImageBottomSheet(context);
  }

  openAddImageBottomSheet(
    context,
  ) async {
    final ScrollController _newBookingScrollController =
        ScrollController(initialScrollOffset: 0);

    await showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              setstate = setState;
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    width: AppUtils.getDeviceWidth(context),
                    child: Wrap(children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  AppImages.icon_popupcancelicon,
                                  height: 20,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text(
                              "Add Task Images",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                color: AppTheme.black,
                                borderRadius: BorderRadius.circular(30)),
                            width: 30,
                            height: 3,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "Work Images",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.subHeadingTextColor,
                                      fontFamily: AppConstants.fontName,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Max file size: 15mb",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.mainTextColor,
                                      fontFamily: AppConstants.fontName,
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: imagePath.length != 4,
                            child: Row(
                              children: [
                                InkWell(
                                  child: DottedBorder(
                                    dashPattern: [3, 3, 3, 3],
                                    strokeWidth: 1,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    //padding: EdgeInsets.all(6),
                                    color: AppTheme.subHeadingTextColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height:
                                            Dimensions.getWidth(percentage: 22),
                                        width:
                                            Dimensions.getWidth(percentage: 30),
                                        color: Color(0xffF9F9F9),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.upload_rounded,
                                                color: AppTheme.primaryColor,
                                              ),
                                              Text(
                                                "Upload\nImage",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.mainTextColor,
                                                  fontFamily:
                                                      AppConstants.fontName,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    imagePicker.showDialog(context,
                                        docImage1: true,
                                        profileImage: false,
                                        docImage2: false,
                                        docImage3: false,
                                        docCertificateImage1: false,
                                        docCertificateImage2: false,
                                        docCertificateImage3: false);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: imagePath.isNotEmpty,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: imagePath.length > 2
                                  ? Dimensions.getHeight(percentage: 30)
                                  : null,
                              child: Scrollbar(
                                thickness: 2.0,
                                isAlwaysShown: true,
                                controller: _newBookingScrollController,
                                child: ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                                  controller: _newBookingScrollController,
                                  itemCount: imagePath.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        margin: EdgeInsets.only(
                                            top: Dimensions.getScaledSize(10)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: shadow,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                              height: double.infinity,
                                              child: Icon(
                                                Icons.description_outlined,
                                                color: AppTheme.primaryColor,
                                              )),
                                          title: Text(
                                              getImageName(imagePath[index]),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          subtitle: Text("N/A"),
                                          trailing: Visibility(
                                            visible: true,
                                            child: InkWell(
                                              onTap: () {
                                                imagePath.removeAt(index);
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.clear,
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              left: 10, right: 10),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: imagePath.isNotEmpty,
                            child: Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.only(
                                    top: 30, left: 30, right: 30),
                                child: GradientElevatedButton(
                                  buttonText: 'Submit',
                                  onPressed: () {
                                    _addWorkImagesApi(
                                        context, booking, imagePath);
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ));
            },
          );
        });
  }

  @override
  selectedProfileImage(
      XFile _image,
      bool profileImage,
      bool docImage1,
      bool docImage2,
      bool docImage3,
      bool docCertificateImage1,
      bool docCertificateImage2,
      bool docCertificateImage3) {
    if (imagePath.length != 4) imagePath.add(File(_image.path));
    setstate(() {});
  }

  String getImageName(File file) {
    if (file != null) {
      return file.path.split('/').last;
    }
    return "";
  }

  void _addWorkImagesApi(
      BuildContext context, dynamic booking, List<File> imageList) async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      AppUtils.showLoader(context);
      BaseResponse baseResponse = await getIt
          .get<DashboardRepository>()
          .addBookingWorkImages(
              userId: AppSharedPref.instance.getUserId(),
              orderId: booking.id,
              paymentMethod: paymentMethod,
              total: booking.total,
              imageList: imageList);
      AppUtils.hideLoader(context);
      if (baseResponse != null) {
        if (baseResponse.success) {
          Navigator.pop(context);
          uploadedSuccessfully(context);
        } else {
          AppUtils.showToast(baseResponse.message, false);
        }
      }
    } else {
      AppUtils.noNetWorkDialog(context);
    }
  }

  uploadedSuccessfully(
    context,
  ) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: AppUtils.getDeviceWidth(context),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.icon_thankyou_popup_bg),
                            fit: BoxFit.cover),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0))),
                    child: Wrap(children: <Widget>[
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  AppImages.icon_popupcancelicon,
                                  height: 20,
                                )),
                          ),
                          Image.asset(
                            AppImages.icon_small_tick,
                            height: 100,
                          ),
                          Text(
                            'Uploaded',
                            style: TextStyle(
                                color: AppTheme.mainTextColor,
                                fontSize: AppConstants.extraLargeSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Your Images was successfully uploaded.',
                            style: TextStyle(
                                color: AppTheme.subHeadingTextColor,
                                fontSize: AppConstants.smallSize,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ));
            },
          );
        });
  }
}
