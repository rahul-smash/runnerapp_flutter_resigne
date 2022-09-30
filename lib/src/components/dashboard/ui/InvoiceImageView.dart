import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_service_provider/src/model/get_invoice_image_response.dart';
import 'package:marketplace_service_provider/src/model/invoice_image_response.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';

import '../../../../core/dimensions/widget_dimensions.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/base_state.dart';
import '../../../widgets/gradient_elevated_button.dart';
import '../dashboard_pages/home_screen.dart';
import '../model/dashboard_response_summary.dart';
import 'dashboard_screen.dart';
import 'edit_order_screen.dart';

class InvoiceImageView extends StatefulWidget {
  final imageType;
  final BookingRequest booking;

  const InvoiceImageView({Key key, this.booking, this.imageType})
      : super(key: key);

  @override
  State<InvoiceImageView> createState() {
    return _InvoiceImageViewState();
  }
}

class _InvoiceImageViewState extends BaseState<InvoiceImageView> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final remarksController = new TextEditingController();
  String apiImg = '';
  String apiImgType = '';
  Datum invoiceData;

  // File image;
  File _selectedProfileImg;
  bool isEdit = false;
  GetInvoiceImageResponse getInvoiceImageResponse;
  InvoiceImageResponse invoiceImageResponse;

  @override
  void initState() {
    super.initState();
    getInvoiceImageApi();
  }

  @override
  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: AppBar(
        leading: IconButton(
          color: AppTheme.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.imageType == "0"
              ? "Upload Invoice Image"
              : "Upload Doorstep Image",
          style: TextStyle(color: AppTheme.black),
        ),
        backgroundColor: AppTheme.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 25, 20, 20),
          child: SafeArea(
            top: false,
            bottom: false,
            child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Center(
                        child:
                            //   Stack(
                            // children: [
                            Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                          height: Dimensions.getHeight(percentage: 50),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            clipBehavior: Clip.antiAlias,
                            child: GestureDetector(
                                onTap: () async {
                                  print(
                                      "check image${_selectedProfileImg == null}===${getInvoiceImageResponse.data == []}==${getInvoiceImageResponse}===");

                                  !isEdit ? showImgDialog() : Container();

                                  print(
                                      "check response${getInvoiceImageResponse}");
                                },
                                child: Center(
                                    child: getInvoiceImageResponse != null &&
                                            getInvoiceImageResponse
                                                .data.isNotEmpty &&
                                            getInvoiceImageResponse?.data !=
                                                null &&
                                            apiImgType == widget.imageType
                                        // getInvoiceImageResponse.data.last
                                        //         .invoiceImage.imageType ==
                                        //     widget.imageType
                                        ? showImageFromUrl()
                                        : _selectedProfileImg == null
                                            ? showImgPlaceholderView()
                                            : showUserImgView())),
                          ),
                        ),
                        // Positioned(
                        //   top: 10,
                        //   right: 10,
                        //   child: _selectedProfileImg != null &&
                        //           getInvoiceImageResponse != null &&
                        //           getInvoiceImageResponse.data != null
                        //       ? IconButton(
                        //           onPressed: () {
                        //             setState(() {});
                        //           },
                        //           icon: Icon(
                        //             Icons.cancel,
                        //             size: 30,
                        //           ))
                        //       : Container(),
                        // ),
                        //   ],
                        // )
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    isEdit
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                showImgDialog();
                                setState(() {
                                  isEdit = true;
                                  AppUtils.showLoader(context);
                                  getInvoiceImageResponse = null;
                                  AppUtils.hideLoader(context);

                                  print(
                                      "check invoice response___${getInvoiceImageResponse}");
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: AppTheme.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: remarksController,
                        decoration: InputDecoration(
                          hintText: "Remarks",
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF495056),
                              fontWeight: FontWeight.w500),
                        ),
                        // style: TextStyle(
                        //     fontSize: 18,
                        //     color: Color(0xFF495056),
                        //     fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getHeight(percentage: 10),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      child: GradientElevatedButton(
                        onPressed: () async {
                          if (this.network.offline) {
                            AppUtils.showToast(
                                AppConstants.noInternetMsg, false);
                            return;
                          } else {
                            callInvoiceImageApi();
                          }
                        },
                        buttonText: labelSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showImgPlaceholderView() {
    // print("show img from place");

    return Container(
      // margin: EdgeInsets.only(
      //     left: Dimensions.getScaledSize(20),
      //     top: Dimensions.getScaledSize(20),
      //     bottom: Dimensions.getScaledSize(20)),
      // width: Dimensions.getScaledSize(80),
      // height: Dimensions.getScaledSize(80),
      child: Text("Tap here to Upload Image"),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: AppTheme.grayCircle),
    );
  }

  showUserImgView() {
    // print("show img from user view");

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                File(_selectedProfileImg.path),
              ))),
      // child: Image.file(
      //   File(_selectedProfileImg.path),
      //   fit: BoxFit.fill,
      // )
    );
  }

  showImageFromUrl() {
    return Container(
        decoration: BoxDecoration(
      image: DecorationImage(
          fit: BoxFit.cover,
          // onError: ,
          image: NetworkImage(getInvoiceImageResponse != null &&
                  getInvoiceImageResponse.data != null &&
                  getInvoiceImageResponse.data.isNotEmpty
              ? apiImg
              : "")),
    ));
  }

  Widget showImgDialog() {
    AppUtils.chooseImageDialog(context,
        title: "Choose any option",
        cameraButtonEnable: true,
        cameraPressed: () async {
          await imgFromCamera();
        },
        galleryButtonEnable: true,
        galleryPressed: () async {
          await imgFromGallery();
        });
  }

  imgFromCamera() async {
    ImagePicker _picker = ImagePicker();
    XFile img = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    if (img != null) {
      setState(() {
        isEdit = true;
        _selectedProfileImg = File(img.path);
        Navigator.pop(context);
      });
    }
  }

  imgFromGallery() async {
    ImagePicker _picker = ImagePicker();
    XFile img =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (img != null) {
      setState(() {
        isEdit = true;

        _selectedProfileImg = File(img.path);
        Navigator.pop(context);
      });
    }
  }

  void setSavedImageData() {
    remarksController.text =
        getInvoiceImageResponse.data.last.invoiceImage.remarks;

    // remarksController.text =
    //     getInvoiceImageResponse.data.last.invoiceImage.image;
  }

  Future<void> getInvoiceImageApi() async {
    getInvoiceImageResponse = await AppNetwork.getInvoiceImage(
      widget.booking.runnerId,
      widget.booking.id,
    );
    if (getInvoiceImageResponse.success) {
      setState(() {
        print("get apiimgType0${apiImgType}");
        print("get apiimg0${apiImg}");
        if (getInvoiceImageResponse != []) {
          // apiImg = getInvoiceImageResponse.data.last.invoiceImage.image;
          getInvoiceImageResponse.data.forEach((element) {
            print("elementz${element.invoiceImage.imageType}");
            print("element check${widget.imageType}");
            if (element.invoiceImage.imageType.toString() == widget.imageType) {
              isEdit = true;
              apiImgType = element.invoiceImage.imageType;
              apiImg = element.invoiceImage.image;
            }
          });
          print("get apiimgType1${apiImgType}");
          print("get apiimg1${apiImg}");
        }
      });
    }

    // print("check ids${widget.booking.runnerId}");
  }

  Future<void> callInvoiceImageApi() async {
    print("check1");
    print(
        "get invoice response${getInvoiceImageResponse}===${_selectedProfileImg}");
    if (_selectedProfileImg == null) {
      AppUtils.showToast(
          widget.imageType == "0"
              ? "Please upload your invoice image"
              : "Please upload your doorstep image",
          false);
      return;
    } else {
      AppUtils.showLoader(context);
      invoiceImageResponse = await AppNetwork.invoiceImages(
          _selectedProfileImg,
          widget.booking.runnerId,
          widget.booking.id,
          widget.booking.storeId,
          remarksController.text,
          widget.imageType);

      print("check remarks${remarksController.text}");

      AppUtils.hideLoader(context);
      AppUtils.hideKeyboard(context);
      if (invoiceImageResponse != null && invoiceImageResponse.success) {
        AppUtils.showToast(invoiceImageResponse.message, true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DashboardScreen()));
        print("Success===");
      } else {
        AppUtils.showToast(
            invoiceImageResponse != null
                ? invoiceImageResponse.message
                : "Something went wrong",
            true);
      }
    }
  }
}
